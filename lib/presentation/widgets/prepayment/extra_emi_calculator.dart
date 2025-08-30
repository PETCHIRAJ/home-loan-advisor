import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../domain/entities/prepayment_result.dart';
import '../../../core/utils/prepayment_calculation_utils.dart';
import '../../../core/extensions/number_extensions.dart';
import 'prepayment_results_display.dart';

class ExtraEMICalculator extends ConsumerStatefulWidget {
  final LoanParameters loanParameters;
  final EMIResult emiResult;
  final bool isVisible;

  const ExtraEMICalculator({
    super.key,
    required this.loanParameters,
    required this.emiResult,
    required this.isVisible,
  });

  @override
  ConsumerState<ExtraEMICalculator> createState() => _ExtraEMICalculatorState();
}

class _ExtraEMICalculatorState extends ConsumerState<ExtraEMICalculator> {
  final _formKey = GlobalKey<FormState>();
  
  int _extraEMIsPerYear = 1;
  int _startYear = 1;
  PrepaymentResult? _calculationResult;
  bool _isCalculating = false;

  final Map<int, String> _strategyNames = {
    1: 'Annual Bonus',
    2: 'Semi-Annual',
    3: 'Quarterly',
    4: 'Quarterly Plus',
  };

  final Map<int, String> _strategyDescriptions = {
    1: 'Pay one extra EMI every year (ideal for annual bonus)',
    2: 'Pay one extra EMI every 6 months',
    3: 'Pay one extra EMI every 3 months',
    4: 'Pay one extra EMI every 3 months (maximum impact)',
  };

  @override
  void initState() {
    super.initState();
  }

  void _calculatePrepayment() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCalculating = true;
    });

    try {
      final scenario = PrepaymentScenario(
        type: PrepaymentType.extraEMI,
        amount: widget.emiResult.monthlyEMI, // Extra EMI amount equals regular EMI
        startMonth: 1,
        startYear: _startYear,
        extraEMIsPerYear: _extraEMIsPerYear,
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
              color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Extra EMI Strategy',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pay one additional EMI multiple times per year. This is perfect for utilizing bonuses, increments, or other lump sum receipts to reduce your loan tenure.',
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
                    // Strategy Selection Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Extra EMI Strategy',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Current EMI: ${widget.emiResult.monthlyEMI.toEMIFormat()}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Strategy Options
                            Column(
                              children: [1, 2, 3, 4].map((extraEMIs) {
                                final isSelected = _extraEMIsPerYear == extraEMIs;
                                final annualExtraAmount = widget.emiResult.monthlyEMI * extraEMIs;
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _extraEMIsPerYear = extraEMIs;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context).colorScheme.tertiaryContainer
                                            : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.tertiary
                                              : Theme.of(context).dividerColor,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Radio<int>(
                                                value: extraEMIs,
                                                groupValue: _extraEMIsPerYear,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _extraEMIsPerYear = value!;
                                                  });
                                                },
                                                activeColor: Theme.of(context).colorScheme.tertiary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _strategyNames[extraEMIs]!,
                                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                                        color: isSelected ? Theme.of(context).colorScheme.tertiary : null,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _strategyDescriptions[extraEMIs]!,
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '$extraEMIs Extra EMI${extraEMIs > 1 ? 's' : ''}',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    annualExtraAmount.toCompactIndianFormat(),
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).colorScheme.tertiary,
                                                    ),
                                                  ),
                                                  Text(
                                                    'per year',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
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

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Starting Year',
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

                            const SizedBox(height: 16),

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
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Extra EMIs will start from Year $_startYear, $_extraEMIsPerYear time${_extraEMIsPerYear > 1 ? 's' : ''} per year',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.tertiary,
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

                    const SizedBox(height: 16),

                    // Benefits Preview Card
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
                                  Icons.lightbulb_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Why Extra EMI Works',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            _buildBenefitPoint(
                              'Principal Reduction',
                              'Each extra EMI directly reduces your outstanding principal',
                              Icons.trending_down,
                            ),
                            const SizedBox(height: 8),
                            _buildBenefitPoint(
                              'Interest Savings',
                              'Lower principal means less interest on remaining balance',
                              Icons.savings,
                            ),
                            const SizedBox(height: 8),
                            _buildBenefitPoint(
                              'Tenure Reduction',
                              'Significantly reduces your loan tenure by years',
                              Icons.schedule,
                            ),
                            const SizedBox(height: 8),
                            _buildBenefitPoint(
                              'Flexible Timing',
                              'Perfect for utilizing bonuses and increments',
                              Icons.event_available,
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
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(context).colorScheme.onTertiary,
                      ),
                      child: _isCalculating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Calculate Extra EMI Impact'),
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

  Widget _buildBenefitPoint(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}