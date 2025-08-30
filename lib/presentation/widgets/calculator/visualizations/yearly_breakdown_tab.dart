import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/emi_result.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class YearlyBreakdownTab extends StatefulWidget {
  final EMIResult result;
  final bool isVisible;

  const YearlyBreakdownTab({
    super.key,
    required this.result,
    required this.isVisible,
  });

  @override
  State<YearlyBreakdownTab> createState() => _YearlyBreakdownTabState();
}

class _YearlyBreakdownTabState extends State<YearlyBreakdownTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(YearlyBreakdownTab oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      _animationController.forward();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Year-wise Payment Breakdown',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Stacked bars show Principal (blue) and Interest (red) components',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 16),

          // Bar Chart
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: 350,
                child: BarChart(
                  BarChartData(
                    maxY: _getMaxY(),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final yearData = widget
                              .result
                              .breakdown
                              .yearlyBreakdown[groupIndex];
                          final isPrincipal = rodIndex == 0;

                          return BarTooltipItem(
                            'Year ${yearData.year}\n'
                            '${isPrincipal ? 'Principal' : 'Interest'}: '
                            '${(isPrincipal ? yearData.principalPaid : yearData.interestPaid).toCompactFormat()}\n'
                            'Tax Savings: ${yearData.taxSavings.toCompactFormat()}',
                            TextStyle(
                              color: isPrincipal
                                  ? Theme.of(context).colorScheme.primary
                                  : FinancialColors.cost,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            _touchedGroupIndex = -1;
                            return;
                          }
                          _touchedGroupIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: _getMaxY() / 4,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toCompactFormat(),
                              style: Theme.of(context).textTheme.labelSmall,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 &&
                                index <
                                    widget
                                        .result
                                        .breakdown
                                        .yearlyBreakdown
                                        .length) {
                              final year = widget
                                  .result
                                  .breakdown
                                  .yearlyBreakdown[index]
                                  .year;
                              return Text(
                                'Y$year',
                                style: Theme.of(context).textTheme.labelSmall,
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: _getMaxY() / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor,
                          strokeWidth: 0.5,
                          dashArray: [3, 3],
                        );
                      },
                    ),
                    barGroups: _buildBarGroups(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LegendItem(
                color: Theme.of(context).colorScheme.primary,
                label: 'Principal Payment',
                icon: Icons.account_balance,
              ),
              _LegendItem(
                color: FinancialColors.cost,
                label: 'Interest Payment',
                icon: Icons.trending_up,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Summary Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Payment Analysis',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        title: 'Peak Interest Year',
                        value: 'Year ${_getPeakInterestYear()}',
                        subtitle: _getPeakInterestAmount().toCompactFormat(),
                        color: FinancialColors.cost,
                        icon: Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryMetric(
                        title: 'Peak Principal Year',
                        value: 'Year ${_getPeakPrincipalYear()}',
                        subtitle: _getPeakPrincipalAmount().toCompactFormat(),
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icons.trending_down,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        title: 'Total Tax Savings',
                        value: _getTotalTaxSavings().toCompactFormat(),
                        subtitle: 'Over loan tenure',
                        color: FinancialColors.taxBenefit,
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryMetric(
                        title: 'Interest Crossover',
                        value: 'Year ${_getInterestCrossoverYear()}',
                        subtitle: 'Principal > Interest',
                        color: FinancialColors.savings,
                        icon: Icons.swap_horiz,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.result.breakdown.yearlyBreakdown.asMap().entries.map((entry) {
      final index = entry.key;
      final yearData = entry.value;
      final isTouched = _touchedGroupIndex == index;

      return BarChartGroupData(
        x: index,
        barRods: [
          // Principal bar
          BarChartRodData(
            toY: yearData.principalPaid * _animation.value,
            color: Theme.of(context).colorScheme.primary,
            width: isTouched ? 20 : 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          // Interest bar (stacked)
          BarChartRodData(
            toY:
                (yearData.principalPaid + yearData.interestPaid) *
                _animation.value,
            color: FinancialColors.cost,
            width: isTouched ? 20 : 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY() {
    double maxPayment = 0;
    for (final year in widget.result.breakdown.yearlyBreakdown) {
      final totalPayment = year.principalPaid + year.interestPaid;
      if (totalPayment > maxPayment) {
        maxPayment = totalPayment;
      }
    }
    return maxPayment * 1.1; // Add 10% padding
  }

  int _getPeakInterestYear() {
    double maxInterest = 0;
    int year = 1;
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      if (yearData.interestPaid > maxInterest) {
        maxInterest = yearData.interestPaid;
        year = yearData.year;
      }
    }
    return year;
  }

  double _getPeakInterestAmount() {
    double maxInterest = 0;
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      if (yearData.interestPaid > maxInterest) {
        maxInterest = yearData.interestPaid;
      }
    }
    return maxInterest;
  }

  int _getPeakPrincipalYear() {
    double maxPrincipal = 0;
    int year = 1;
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      if (yearData.principalPaid > maxPrincipal) {
        maxPrincipal = yearData.principalPaid;
        year = yearData.year;
      }
    }
    return year;
  }

  double _getPeakPrincipalAmount() {
    double maxPrincipal = 0;
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      if (yearData.principalPaid > maxPrincipal) {
        maxPrincipal = yearData.principalPaid;
      }
    }
    return maxPrincipal;
  }

  double _getTotalTaxSavings() {
    double totalSavings = 0;
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      totalSavings += yearData.taxSavings;
    }
    return totalSavings;
  }

  int _getInterestCrossoverYear() {
    for (final yearData in widget.result.breakdown.yearlyBreakdown) {
      if (yearData.principalPaid > yearData.interestPaid) {
        return yearData.year;
      }
    }
    return widget.result.breakdown.yearlyBreakdown.last.year;
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SummaryMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
