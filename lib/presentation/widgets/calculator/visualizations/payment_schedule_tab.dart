import 'package:flutter/material.dart';
import '../../../../domain/entities/emi_result.dart';
import '../../../../domain/entities/loan_parameters.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentScheduleTab extends StatefulWidget {
  final EMIResult result;
  final LoanParameters parameters;
  final bool isVisible;

  const PaymentScheduleTab({
    super.key,
    required this.result,
    required this.parameters,
    required this.isVisible,
  });

  @override
  State<PaymentScheduleTab> createState() => _PaymentScheduleTabState();
}

class _PaymentScheduleTabState extends State<PaymentScheduleTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isYearlyView = false;
  final List<PaymentScheduleItem> _monthlySchedule = [];
  final List<PaymentScheduleItem> _yearlySchedule = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _generateSchedule();
  }

  @override
  void didUpdateWidget(PaymentScheduleTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateSchedule() {
    _monthlySchedule.clear();
    _yearlySchedule.clear();

    final totalMonths = widget.parameters.tenureYears * 12;
    final monthlyInterestRate = widget.parameters.interestRate / (12 * 100);
    double outstandingBalance = widget.parameters.loanAmount;

    // Generate monthly schedule
    for (int month = 1; month <= totalMonths; month++) {
      final interestForMonth = outstandingBalance * monthlyInterestRate;
      final principalForMonth = widget.result.monthlyEMI - interestForMonth;

      outstandingBalance -= principalForMonth;

      _monthlySchedule.add(
        PaymentScheduleItem(
          period: month,
          emiAmount: widget.result.monthlyEMI,
          principalAmount: principalForMonth,
          interestAmount: interestForMonth,
          outstandingBalance: outstandingBalance.clamp(0, double.infinity),
        ),
      );
    }

    // Generate yearly schedule from existing yearly breakdown
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      _yearlySchedule.add(
        PaymentScheduleItem(
          period: yearData.year,
          emiAmount: widget.result.monthlyEMI * 12,
          principalAmount: yearData.principalPaid,
          interestAmount: yearData.interestPaid,
          outstandingBalance: yearData.outstandingBalance,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      _animationController.forward();
    }

    final currentSchedule = _isYearlyView ? _yearlySchedule : _monthlySchedule;

    return Column(
      children: [
        // Header with toggle
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Schedule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isYearlyView
                        ? '${_yearlySchedule.length} yearly payments'
                        : '${_monthlySchedule.length} monthly payments',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),

              // Toggle switch
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ViewToggleButton(
                      label: 'Monthly',
                      isSelected: !_isYearlyView,
                      onTap: () {
                        setState(() {
                          _isYearlyView = false;
                        });
                      },
                    ),
                    _ViewToggleButton(
                      label: 'Yearly',
                      isSelected: _isYearlyView,
                      onTap: () {
                        setState(() {
                          _isYearlyView = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  _isYearlyView ? 'Year' : 'Month',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _isYearlyView ? 'Annual EMI' : 'Monthly EMI',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Principal',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Interest',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Outstanding',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        // Scrollable Table Content
        Expanded(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ListView.builder(
                itemCount: currentSchedule.length,
                itemBuilder: (context, index) {
                  final item = currentSchedule[index];
                  final isEvenRow = index % 2 == 0;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeInOut,
                    transform: Matrix4.translationValues(
                      100 * (1 - _animation.value),
                      0,
                      0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isEvenRow
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.1),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              item.period.toString(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.emiAmount.toCompactFormat(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.principalAmount.toCompactFormat(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: FinancialColors.savings,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.interestAmount.toCompactFormat(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: FinancialColors.cost,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.outstandingBalance.toCompactFormat(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Summary Footer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Schedule Summary',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: 'Total Payments',
                      value: currentSchedule.length.toString(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: 'Total Principal',
                      value: widget.result.principalAmount.toCompactFormat(),
                      color: FinancialColors.savings,
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: 'Total Interest',
                      value: widget.result.totalInterest.toCompactFormat(),
                      color: FinancialColors.cost,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentScheduleItem {
  final int period;
  final double emiAmount;
  final double principalAmount;
  final double interestAmount;
  final double outstandingBalance;

  PaymentScheduleItem({
    required this.period,
    required this.emiAmount,
    required this.principalAmount,
    required this.interestAmount,
    required this.outstandingBalance,
  });
}

class _ViewToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
