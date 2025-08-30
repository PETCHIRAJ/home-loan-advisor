import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/step_emi.dart';
import '../../../../core/extensions/number_extensions.dart';

class StepEMIChartTab extends StatefulWidget {
  final StepEMIResult stepResult;
  final double regularEMI; // For comparison

  const StepEMIChartTab({
    super.key,
    required this.stepResult,
    required this.regularEMI,
  });

  @override
  State<StepEMIChartTab> createState() => _StepEMIChartTabState();
}

class _StepEMIChartTabState extends State<StepEMIChartTab> {
  int _selectedChartType = 0; // 0: EMI Progression, 1: Interest vs Principal

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart type selector
          _buildChartTypeSelector(),
          const SizedBox(height: 20),

          // Chart
          Expanded(
            child: _selectedChartType == 0 
              ? _buildEMIProgressionChart()
              : _buildInterestPrincipalChart(),
          ),

          const SizedBox(height: 20),

          // Summary metrics
          _buildSummaryMetrics(),
        ],
      ),
    );
  }

  Widget _buildChartTypeSelector() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('EMI Progression'),
          icon: Icon(Icons.trending_up),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Interest vs Principal'),
          icon: Icon(Icons.pie_chart),
        ),
      ],
      selected: {_selectedChartType},
      onSelectionChanged: (Set<int> selection) {
        setState(() {
          _selectedChartType = selection.first;
        });
      },
    );
  }

  Widget _buildEMIProgressionChart() {
    final colorScheme = Theme.of(context).colorScheme;
    final yearlyData = widget.stepResult.yearlyBreakdown;

    if (yearlyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Create chart data
    final stepEMISpots = yearlyData.asMap().entries.map((entry) {
      return FlSpot(entry.value.year.toDouble(), entry.value.emiAmount);
    }).toList();

    final regularEMISpots = yearlyData.asMap().entries.map((entry) {
      return FlSpot(entry.value.year.toDouble(), widget.regularEMI);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EMI Progression Over Time',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10000,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toStringAsFixed(0)}K',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Y${value.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall,
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    // Step EMI line
                    LineChartBarData(
                      spots: stepEMISpots,
                      color: colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: colorScheme.primary,
                            strokeColor: colorScheme.surface,
                            strokeWidth: 2,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    
                    // Regular EMI line (for comparison)
                    LineChartBarData(
                      spots: regularEMISpots,
                      color: colorScheme.secondary,
                      barWidth: 2,
                      dashArray: [5, 5],
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => colorScheme.inverseSurface,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final isStepEMI = spot.barIndex == 0;
                          return LineTooltipItem(
                            '${isStepEMI ? 'Step EMI' : 'Regular EMI'}\nYear ${spot.x.toInt()}\n₹${spot.y.toIndianFormat()}',
                            TextStyle(
                              color: colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              children: [
                _buildLegendItem(
                  context,
                  colorScheme.primary,
                  widget.stepResult.parameters.type.displayName,
                  false,
                ),
                const SizedBox(width: 20),
                _buildLegendItem(
                  context,
                  colorScheme.secondary,
                  'Regular EMI',
                  true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestPrincipalChart() {
    final colorScheme = Theme.of(context).colorScheme;
    final yearlyData = widget.stepResult.yearlyBreakdown;

    if (yearlyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Chart uses BarChart with stacked bars instead of line chart data

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Principal vs Interest by Year',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: yearlyData.fold<double>(0, (max, item) => 
                    (item.principalPaid + item.interestPaid) > max 
                      ? (item.principalPaid + item.interestPaid) 
                      : max,
                  ) * 1.1,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toStringAsFixed(0)}K',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Y${value.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall,
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  barGroups: yearlyData.map((yearly) {
                    
                    return BarChartGroupData(
                      x: yearly.year,
                      barRods: [
                        BarChartRodData(
                          toY: yearly.principalPaid + yearly.interestPaid,
                          color: colorScheme.primary,
                          width: 20,
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              yearly.principalPaid,
                              colorScheme.primary,
                            ),
                            BarChartRodStackItem(
                              yearly.principalPaid,
                              yearly.principalPaid + yearly.interestPaid,
                              colorScheme.secondary,
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => colorScheme.inverseSurface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final yearly = yearlyData[groupIndex];
                        return BarTooltipItem(
                          'Year ${yearly.year}\nPrincipal: ₹${yearly.principalPaid.toIndianFormat()}\nInterest: ₹${yearly.interestPaid.toIndianFormat()}',
                          TextStyle(
                            color: colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              children: [
                _buildLegendItem(
                  context,
                  colorScheme.primary,
                  'Principal',
                  false,
                ),
                const SizedBox(width: 20),
                _buildLegendItem(
                  context,
                  colorScheme.secondary,
                  'Interest',
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    Color color,
    String label,
    bool isDashed,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5),
          ),
          child: isDashed
            ? CustomPaint(
                painter: DashedLinePainter(color: color),
              )
            : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSummaryMetrics() {
    final stepResult = widget.stepResult;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step EMI Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'First EMI',
                    '₹${stepResult.firstEMI.toIndianFormat()}',
                    Icons.play_arrow,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'Last EMI',
                    '₹${stepResult.lastEMI.toIndianFormat()}',
                    Icons.stop,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'Average EMI',
                    '₹${stepResult.averageEMI.toIndianFormat()}',
                    Icons.timeline,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    context,
                    'Total Steps',
                    '${stepResult.totalSteps}',
                    Icons.stairs,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Interest comparison
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: stepResult.isMoreExpensive
                  ? colorScheme.errorContainer.withValues(alpha: 0.3)
                  : colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: stepResult.isMoreExpensive
                    ? colorScheme.error.withValues(alpha: 0.3)
                    : colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    stepResult.isMoreExpensive
                      ? Icons.trending_up
                      : Icons.trending_down,
                    color: stepResult.isMoreExpensive
                      ? colorScheme.error
                      : colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stepResult.isMoreExpensive
                            ? 'Additional Cost'
                            : 'Interest Saved',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: stepResult.isMoreExpensive
                              ? colorScheme.onErrorContainer
                              : colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '₹${stepResult.interestSavedVsRegular.abs().toIndianFormat()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: stepResult.isMoreExpensive
                              ? colorScheme.onErrorContainer
                              : colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stepResult.isMoreExpensive
                            ? 'vs regular EMI'
                            : 'compared to regular EMI',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: stepResult.isMoreExpensive
                              ? colorScheme.onErrorContainer.withValues(alpha: 0.7)
                              : colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed lines in legend
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 2.0;
    const dashSpace = 2.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}