import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/emi_result.dart';
import '../../../../domain/entities/loan_parameters.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class BalanceTrendTab extends StatefulWidget {
  final EMIResult result;
  final LoanParameters parameters;
  final bool isVisible;

  const BalanceTrendTab({
    super.key,
    required this.result,
    required this.parameters,
    required this.isVisible,
  });

  @override
  State<BalanceTrendTab> createState() => _BalanceTrendTabState();
}

class _BalanceTrendTabState extends State<BalanceTrendTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<FlSpot>? _balanceSpots;
  List<FlSpot>? _principalSpots;
  bool _showPrincipal = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _generateDataPoints();
  }

  @override
  void didUpdateWidget(BalanceTrendTab oldWidget) {
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

  void _generateDataPoints() {
    _balanceSpots = [];
    _principalSpots = [];

    final totalMonths = widget.parameters.tenureYears * 12;
    final monthlyInterestRate = widget.parameters.interestRate / (12 * 100);
    double outstandingBalance = widget.parameters.loanAmount;
    double principalPaid = 0;

    // Add initial point
    _balanceSpots!.add(FlSpot(0, outstandingBalance));
    _principalSpots!.add(FlSpot(0, principalPaid));

    for (int month = 1; month <= totalMonths; month++) {
      final interestForMonth = outstandingBalance * monthlyInterestRate;
      final principalForMonth = widget.result.monthlyEMI - interestForMonth;

      outstandingBalance -= principalForMonth;
      principalPaid += principalForMonth;

      // Add point every 6 months for better performance
      if (month % 6 == 0 || month == totalMonths) {
        _balanceSpots!.add(
          FlSpot(
            month.toDouble(),
            outstandingBalance.clamp(0, double.infinity),
          ),
        );
        _principalSpots!.add(FlSpot(month.toDouble(), principalPaid));
      }
    }
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with toggle - responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                // Stack vertically on small screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance Trend Over Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Show Principal',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: _showPrincipal,
                          onChanged: (value) {
                            setState(() {
                              _showPrincipal = value;
                            });
                          },
                          activeTrackColor: FinancialColors.savings,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Keep side by side on larger screens
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Balance Trend Over Time',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Show Principal',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: _showPrincipal,
                          onChanged: (value) {
                            setState(() {
                              _showPrincipal = value;
                            });
                          },
                          activeTrackColor: FinancialColors.savings,
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 16),

          // Line Chart
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 300,
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: widget.parameters.loanAmount / 5,
                      verticalInterval:
                          (widget.parameters.tenureYears * 12) / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor,
                          strokeWidth: 0.5,
                          dashArray: [3, 3],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor,
                          strokeWidth: 0.5,
                          dashArray: [3, 3],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 70,
                          interval: widget.parameters.loanAmount / 4,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                value.toCompactFormat(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: (widget.parameters.tenureYears * 12) / 4,
                          getTitlesWidget: (value, meta) {
                            final years = (value / 12).round();
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${years}Y',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 10),
                              ),
                            );
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
                    lineBarsData: [
                      // Outstanding Balance Line
                      LineChartBarData(
                        spots: _balanceSpots!
                            .map(
                              (spot) =>
                                  FlSpot(spot.x, spot.y * _animation.value),
                            )
                            .toList(),
                        isCurved: true,
                        color: FinancialColors.cost,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: FinancialColors.cost.withValues(alpha: 0.1),
                        ),
                      ),

                      // Principal Paid Line (if enabled)
                      if (_showPrincipal)
                        LineChartBarData(
                          spots: _principalSpots!
                              .map(
                                (spot) =>
                                    FlSpot(spot.x, spot.y * _animation.value),
                              )
                              .toList(),
                          isCurved: true,
                          color: FinancialColors.savings,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: FinancialColors.savings.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final month = touchedSpot.x.toInt();
                            final year = (month / 12).ceil();
                            final monthInYear = month % 12 == 0
                                ? 12
                                : month % 12;

                            final color = touchedSpot.barIndex == 0
                                ? FinancialColors.cost
                                : FinancialColors.savings;

                            final label = touchedSpot.barIndex == 0
                                ? 'Outstanding'
                                : 'Principal Paid';

                            return LineTooltipItem(
                              '$label\nYear $year, Month $monthInYear\n${touchedSpot.y.toCompactFormat()}',
                              TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                    maxY: widget.parameters.loanAmount * 1.1,
                    minY: 0,
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
                color: FinancialColors.cost,
                label: 'Outstanding Balance',
                icon: Icons.trending_down,
              ),
              if (_showPrincipal)
                _LegendItem(
                  color: FinancialColors.savings,
                  label: 'Principal Paid',
                  icon: Icons.trending_up,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Key Metrics
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
                      Icons.insights,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Balance Milestones',
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
                      child: _MilestoneItem(
                        label: '50% Paid Off',
                        value:
                            '${(widget.parameters.tenureYears * 0.7).toInt()} years',
                        description: 'Approximately',
                      ),
                    ),
                    Expanded(
                      child: _MilestoneItem(
                        label: 'Interest Dominance',
                        value:
                            'First ${(widget.parameters.tenureYears * 0.6).toInt()} years',
                        description: 'Interest > Principal',
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
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
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

class _MilestoneItem extends StatelessWidget {
  final String label;
  final String value;
  final String description;

  const _MilestoneItem({
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
