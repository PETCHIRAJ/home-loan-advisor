import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/loan_scenario.dart';
import '../../../providers/scenario_comparison_providers.dart';

class ComparisonCharts extends ConsumerStatefulWidget {
  const ComparisonCharts({super.key});

  @override
  ConsumerState<ComparisonCharts> createState() => _ComparisonChartsState();
}

class _ComparisonChartsState extends ConsumerState<ComparisonCharts>
    with SingleTickerProviderStateMixin {
  late TabController _chartTabController;

  final List<String> _chartTabs = ['EMI', 'Interest', 'Total Cost', 'Timeline'];

  @override
  void initState() {
    super.initState();
    _chartTabController = TabController(length: _chartTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _chartTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scenariosWithResults = ref.watch(scenariosWithResultsProvider);
    final bestScenario = ref.watch(bestScenarioProvider);

    if (scenariosWithResults.isEmpty) {
      return const Center(child: Text('No scenarios to display'));
    }

    return Column(
      children: [
        // Chart tabs
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _chartTabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            labelStyle: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            tabs: _chartTabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),

        // Chart content
        Expanded(
          child: TabBarView(
            controller: _chartTabController,
            children: [
              _buildEMIChart(scenariosWithResults, bestScenario),
              _buildInterestChart(scenariosWithResults, bestScenario),
              _buildTotalCostChart(scenariosWithResults, bestScenario),
              _buildTimelineChart(scenariosWithResults, bestScenario),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEMIChart(
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly EMI Comparison',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Compare monthly payment amounts across scenarios',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY:
                      scenarios
                          .map((s) => s.result!.monthlyEMI)
                          .reduce((a, b) => a > b ? a : b) *
                      1.1,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final scenario = scenarios[groupIndex];
                        return BarTooltipItem(
                          '${scenario.name}\n${scenario.result!.monthlyEMI.toEMIFormat()}',
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toInt()}K',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < scenarios.length) {
                            final name = scenarios[index].name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  name.length > 10
                                      ? '${name.substring(0, 10)}...'
                                      : name,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: scenarios.asMap().entries.map((entry) {
                    final index = entry.key;
                    final scenario = entry.value;
                    final isBest = bestScenario?.id == scenario.id;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: scenario.result!.monthlyEMI,
                          color: _getScenarioColor(context, scenario, isBest),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestChart(
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Interest Comparison',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total interest paid over the loan tenure',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY:
                      scenarios
                          .map((s) => s.result!.totalInterest)
                          .reduce((a, b) => a > b ? a : b) *
                      1.1,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final scenario = scenarios[groupIndex];
                        return BarTooltipItem(
                          '${scenario.name}\n₹${scenario.result!.totalInterest.toIndianFormat()}',
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 70,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '₹${(value / 100000).toInt()}L',
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
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < scenarios.length) {
                            final name = scenarios[index].name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  name.length > 10
                                      ? '${name.substring(0, 10)}...'
                                      : name,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: scenarios.asMap().entries.map((entry) {
                    final index = entry.key;
                    final scenario = entry.value;
                    final isBest = bestScenario?.id == scenario.id;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: scenario.result!.totalInterest,
                          color: _getScenarioColor(context, scenario, isBest),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCostChart(
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Cost After Benefits',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total cost including tax benefits and subsidies',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY:
                      scenarios
                          .map((s) => s.totalCostAfterBenefits)
                          .reduce((a, b) => a > b ? a : b) *
                      1.1,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final scenario = scenarios[groupIndex];
                        return BarTooltipItem(
                          '${scenario.name}\n₹${scenario.totalCostAfterBenefits.toIndianFormat()}',
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ) ??
                              const TextStyle(),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 70,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '₹${(value / 100000).toInt()}L',
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
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < scenarios.length) {
                            final name = scenarios[index].name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  name.length > 10
                                      ? '${name.substring(0, 10)}...'
                                      : name,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: scenarios.asMap().entries.map((entry) {
                    final index = entry.key;
                    final scenario = entry.value;
                    final isBest = bestScenario?.id == scenario.id;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: scenario.totalCostAfterBenefits,
                          color: _getScenarioColor(context, scenario, isBest),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineChart(
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    // Create timeline data showing cumulative interest over time
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interest Accumulation Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'How interest accumulates over time for each scenario',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final scenarioIndex = spot.barIndex;
                          final scenario = scenarios[scenarioIndex];
                          final year = spot.x.toInt();
                          final cumulativeInterest = spot.y;

                          return LineTooltipItem(
                            '${scenario.name}\nYear $year: ₹${cumulativeInterest.toIndianFormat()}',
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ) ??
                                const TextStyle(),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Year ${value.toInt()}',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 70,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '₹${(value / 100000).toInt()}L',
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                  lineBarsData: scenarios.map((scenario) {
                    final isBest = bestScenario?.id == scenario.id;

                    // Generate cumulative interest data points
                    final spots = <FlSpot>[];
                    double cumulativeInterest = 0;

                    for (final yearData
                        in scenario.result!.breakdown.yearlyBreakdown) {
                      cumulativeInterest += yearData.interestPaid;
                      spots.add(
                        FlSpot(yearData.year.toDouble(), cumulativeInterest),
                      );
                    }

                    return LineChartBarData(
                      spots: spots,
                      color: _getScenarioColor(context, scenario, isBest),
                      barWidth: isBest ? 3 : 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: spots.length <= 10),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Legend
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: scenarios.map((scenario) {
                final isBest = bestScenario?.id == scenario.id;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 3,
                      decoration: BoxDecoration(
                        color: _getScenarioColor(context, scenario, isBest),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scenario.name,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (isBest) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        size: 12,
                        color: FinancialColors.savings,
                      ),
                    ],
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScenarioColor(
    BuildContext context,
    LoanScenario scenario,
    bool isBest,
  ) {
    if (isBest) {
      return FinancialColors.savings;
    }
    if (scenario.isBaseScenario) {
      return Theme.of(context).colorScheme.primary;
    }

    // Generate color based on scenario ID hash
    final hash = scenario.id.hashCode;
    final colors = [
      FinancialColors.cost,
      FinancialColors.prepayment,
      FinancialColors.pmayBenefit,
      FinancialColors.privateBank,
      FinancialColors.nbfc,
    ];

    return colors[hash.abs() % colors.length];
  }
}
