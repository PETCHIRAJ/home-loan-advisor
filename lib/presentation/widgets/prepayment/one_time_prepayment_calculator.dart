import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../domain/entities/prepayment_result.dart';
import '../../../core/utils/prepayment_calculation_utils.dart';
import '../../../core/extensions/number_extensions.dart';
import 'prepayment_results_display.dart';

class OneTimePrepaymentCalculator extends ConsumerStatefulWidget {
  final LoanParameters loanParameters;
  final EMIResult emiResult;
  final bool isVisible;

  const OneTimePrepaymentCalculator({
    super.key,
    required this.loanParameters,
    required this.emiResult,
    required this.isVisible,
  });

  @override
  ConsumerState<OneTimePrepaymentCalculator> createState() => _OneTimePrepaymentCalculatorState();
}

class _OneTimePrepaymentCalculatorState extends ConsumerState<OneTimePrepaymentCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _prepaymentAmountController = TextEditingController();
  
  double _prepaymentAmount = 100000;
  int _selectedYear = 1;
  int _selectedMonth = 1;
  PrepaymentResult? _calculationResult;
  bool _isCalculating = false;

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    _prepaymentAmountController.text = _prepaymentAmount.toInt().toString();
  }

  @override
  void dispose() {
    _prepaymentAmountController.dispose();
    super.dispose();
  }

  void _calculatePrepayment() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCalculating = true;
    });

    try {
      final scenario = PrepaymentScenario(
        type: PrepaymentType.oneTime,
        amount: _prepaymentAmount,
        startMonth: _selectedMonth,
        startYear: _selectedYear,
      );

      final result = PrepaymentCalculationUtils.calculatePrepaymentResult(
        scenario: scenario,
        loanParams: widget.loanParameters,
        originalEMI: widget.emiResult,
      );

      setState(() {
        _calculationResult = result;
        _isCalculating = false;
      });
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calculating prepayment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'One-time Prepayment',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Make a single lump sum payment towards your loan principal at any time during the loan tenure. This reduces your outstanding balance and can significantly cut down interest costs.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Prepayment Amount Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prepayment Amount',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Amount Input
                            TextFormField(
                              controller: _prepaymentAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount (₹)',
                                hintText: 'Enter prepayment amount',
                                prefixIcon: const Icon(Icons.currency_rupee),
                                border: const OutlineInputBorder(),
                                helperText: 'Minimum: ₹10,000 | Maximum: Outstanding Balance',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter prepayment amount';
                                }
                                final amount = double.tryParse(value.replaceAll(',', ''));
                                if (amount == null) {
                                  return 'Please enter a valid amount';
                                }
                                if (amount < 10000) {
                                  return 'Minimum prepayment amount is ₹10,000';
                                }
                                if (amount > widget.loanParameters.loanAmount) {
                                  return 'Amount cannot exceed loan amount';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                final amount = double.tryParse(value.replaceAll(',', ''));
                                if (amount != null) {
                                  setState(() {
                                    _prepaymentAmount = amount;
                                  });
                                }
                              },
                            ),

                            const SizedBox(height: 16),

                            // Amount Slider
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Amount Selection',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Slider(
                                  value: _prepaymentAmount.clamp(10000, widget.loanParameters.loanAmount),
                                  min: 10000,
                                  max: widget.loanParameters.loanAmount,
                                  divisions: 20,
                                  label: _prepaymentAmount.toIndianFormat(),
                                  onChanged: (value) {
                                    setState(() {
                                      _prepaymentAmount = value;
                                      _prepaymentAmountController.text = value.toInt().toString();
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹10K',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      widget.loanParameters.loanAmount.toCompactIndianFormat(),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Quick Amount Buttons
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildQuickAmountChip('1L', 100000),
                                _buildQuickAmountChip('2L', 200000),
                                _buildQuickAmountChip('5L', 500000),
                                _buildQuickAmountChip('10L', 1000000),
                                _buildQuickAmountChip('25% of Loan', widget.loanParameters.loanAmount * 0.25),
                                _buildQuickAmountChip('50% of Loan', widget.loanParameters.loanAmount * 0.50),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Timing Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'When to Make Prepayment',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Year',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        initialValue: _selectedYear,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        items: List.generate(
                                          widget.loanParameters.tenureYears,
                                          (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text('Year ${index + 1}'),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedYear = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        initialValue: _selectedMonth,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        items: List.generate(
                                          12,
                                          (index) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text(_months[index]),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedMonth = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Prepayment will be made in ${_months[_selectedMonth - 1]} of Year $_selectedYear',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Calculate Button
                    FilledButton(
                      onPressed: _isCalculating ? null : _calculatePrepayment,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isCalculating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Calculate Prepayment Impact'),
                    ),

                    const SizedBox(height: 24),

                    // Results Section
                    if (_calculationResult != null)
                      PrepaymentResultsDisplay(
                        result: _calculationResult!,
                        loanParameters: widget.loanParameters,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountChip(String label, double amount) {
    final isSelected = _prepaymentAmount == amount;
    final canAfford = amount <= widget.loanParameters.loanAmount;

    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : canAfford
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : canAfford
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
      onPressed: canAfford
          ? () {
              setState(() {
                _prepaymentAmount = amount;
                _prepaymentAmountController.text = amount.toInt().toString();
              });
            }
          : null,
    );
  }
}