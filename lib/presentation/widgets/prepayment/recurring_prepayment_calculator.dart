import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../domain/entities/prepayment_result.dart';
import '../../../core/utils/prepayment_calculation_utils.dart';
import '../../../core/extensions/number_extensions.dart';
import 'prepayment_results_display.dart';

class RecurringPrepaymentCalculator extends ConsumerStatefulWidget {
  final LoanParameters loanParameters;
  final EMIResult emiResult;
  final bool isVisible;

  const RecurringPrepaymentCalculator({
    super.key,
    required this.loanParameters,
    required this.emiResult,
    required this.isVisible,
  });

  @override
  ConsumerState<RecurringPrepaymentCalculator> createState() => _RecurringPrepaymentCalculatorState();
}

class _RecurringPrepaymentCalculatorState extends ConsumerState<RecurringPrepaymentCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _prepaymentAmountController = TextEditingController();
  
  double _prepaymentAmount = 5000;
  PrepaymentFrequency _frequency = PrepaymentFrequency.monthly;
  int _startYear = 1;
  int _startMonth = 1;
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
        type: PrepaymentType.recurring,
        amount: _prepaymentAmount,
        frequency: _frequency,
        startMonth: _startMonth,
        startYear: _startYear,
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

  String _getFrequencyDescription() {
    switch (_frequency) {
      case PrepaymentFrequency.monthly:
        return 'Every month';
      case PrepaymentFrequency.quarterly:
        return 'Every 3 months';
      case PrepaymentFrequency.yearly:
        return 'Once a year';
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
              color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recurring Prepayment',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Make regular additional payments towards your loan principal. This systematic approach can significantly reduce your loan tenure and interest burden over time.',
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
                                helperText: 'Minimum: ₹1,000 | Suggested: 5-20% of EMI',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter prepayment amount';
                                }
                                final amount = double.tryParse(value.replaceAll(',', ''));
                                if (amount == null) {
                                  return 'Please enter a valid amount';
                                }
                                if (amount < 1000) {
                                  return 'Minimum prepayment amount is ₹1,000';
                                }
                                if (amount > widget.emiResult.monthlyEMI) {
                                  return 'Amount should be less than your EMI';
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
                                  value: _prepaymentAmount.clamp(1000, widget.emiResult.monthlyEMI),
                                  min: 1000,
                                  max: widget.emiResult.monthlyEMI,
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
                                      '₹1K',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      widget.emiResult.monthlyEMI.toCompactIndianFormat(),
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
                                _buildQuickAmountChip('₹2K', 2000),
                                _buildQuickAmountChip('₹5K', 5000),
                                _buildQuickAmountChip('₹10K', 10000),
                                _buildQuickAmountChip('5% of EMI', widget.emiResult.monthlyEMI * 0.05),
                                _buildQuickAmountChip('10% of EMI', widget.emiResult.monthlyEMI * 0.10),
                                _buildQuickAmountChip('20% of EMI', widget.emiResult.monthlyEMI * 0.20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Frequency Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Frequency',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Frequency Selection
                            Column(
                              children: PrepaymentFrequency.values.map((frequency) {
                                final isSelected = _frequency == frequency;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _frequency = frequency;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.secondaryContainer
                                            : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.secondary
                                              : Theme.of(context).dividerColor,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<PrepaymentFrequency>(
                                            value: frequency,
                                            groupValue: _frequency,
                                            onChanged: (value) {
                                              setState(() {
                                                _frequency = value!;
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _getFrequencyDisplayName(frequency),
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  '${_getAnnualPrepaymentsForFrequency(frequency)} payments per year',
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            (_prepaymentAmount * _getAnnualPrepaymentsForFrequency(frequency)).toCompactIndianFormat(),
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '/year',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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
                              'When to Start',
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
                                        initialValue: _startYear,
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
                                            _startYear = value!;
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
                                        initialValue: _startMonth,
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
                                            _startMonth = value!;
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
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Prepayments will start from ${_months[_startMonth - 1]} of Year $_startYear, ${_getFrequencyDescription().toLowerCase()}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
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
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      ),
                      child: _isCalculating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Calculate Recurring Prepayment Impact'),
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
    final isSelected = (_prepaymentAmount - amount).abs() < 0.01;
    final canAfford = amount <= widget.emiResult.monthlyEMI;

    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onSecondary
              : canAfford
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.secondary
          : canAfford
              ? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3)
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

  String _getFrequencyDisplayName(PrepaymentFrequency frequency) {
    switch (frequency) {
      case PrepaymentFrequency.monthly:
        return 'Monthly';
      case PrepaymentFrequency.quarterly:
        return 'Quarterly';
      case PrepaymentFrequency.yearly:
        return 'Yearly';
    }
  }

  int _getAnnualPrepaymentsForFrequency(PrepaymentFrequency frequency) {
    switch (frequency) {
      case PrepaymentFrequency.monthly:
        return 12;
      case PrepaymentFrequency.quarterly:
        return 4;
      case PrepaymentFrequency.yearly:
        return 1;
    }
  }
}