import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/loan_provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/loan_model.dart';
import 'dart:math' as math;

/// Interactive bar chart showing EMI breakdown over time
///
/// Displays how monthly EMI splits between:
/// - Principal payment (decreasing over time)
/// - Interest payment (increasing over time)
/// - Visual representation of loan amortization
class EMIBreakdownChart extends ConsumerStatefulWidget {
  const EMIBreakdownChart({
    super.key,
    this.height = 300,
    this.showMonths = 24, // Show first 2 years by default
    this.showLegend = true,
  });

  final double height;
  final int showMonths;
  final bool showLegend;

  @override
  ConsumerState<EMIBreakdownChart> createState() => _EMIBreakdownChartState();
}

class _EMIBreakdownChartState extends ConsumerState<EMIBreakdownChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final loanAsync = ref.watch(loanNotifierProvider);
    final theme = Theme.of(context);

    return loanAsync.when(
      loading: () => SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'Error loading chart data',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ),
      data: (loan) => _buildChart(context, loan, theme),
    );
  }

  Widget _buildChart(BuildContext context, LoanModel loan, ThemeData theme) {
    if (!loan.isValid) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'Invalid loan parameters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      );
    }

    final emiData = _calculateEMIBreakdown(loan);
    final maxValue = emiData.isNotEmpty 
        ? emiData.map((e) => e.totalEMI).reduce(math.max) 
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Text(
          'EMI Breakdown Over Time',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'See how your monthly payment splits between principal and interest',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: widget.height,
          child: BarChart(
            BarChartData(
              maxY: maxValue * 1.1, // Add 10% padding
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => theme.colorScheme.inverseSurface,
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = emiData[group.x.toInt()];
                    final isInterest = rodIndex == 0;
                    
                    return BarTooltipItem(
                      'Month ${data.month}\n',
                      TextStyle(
                        color: theme.colorScheme.onInverseSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: isInterest 
                              ? 'Interest: ${CurrencyFormatter.formatCurrency(data.interestAmount)}'
                              : 'Principal: ${CurrencyFormatter.formatCurrency(data.principalAmount)}',
                          style: TextStyle(
                            color: isInterest 
                                ? theme.colorScheme.error 
                                : theme.colorScheme.primary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < emiData.length) {
                        // Show every 6th month for readability
                        if (index % 6 == 0 || index == emiData.length - 1) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${emiData[index].month}',
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 32,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        CurrencyFormatter.formatCurrencyCompact(value),
                        style: theme.textTheme.labelSmall,
                      );
                    },
                    reservedSize: 50,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(theme, emiData),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) {
                  return value % (maxValue / 5) == 0;
                },
                horizontalInterval: maxValue / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),

        // Legend
        if (widget.showLegend) ...[
          const SizedBox(height: 16),
          _buildLegend(theme),
        ],

        // Key insights
        const SizedBox(height: 16),
        _buildKeyInsights(theme, loan, emiData),
      ],
    );
  }

  List<EMIBreakdownData> _calculateEMIBreakdown(LoanModel loan) {
    final monthlyRate = loan.annualInterestRate / 12 / 100;
    final totalMonths = math.min(loan.totalMonths, widget.showMonths);
    final monthlyEMI = loan.monthlyEMI;
    
    List<EMIBreakdownData> data = [];
    double outstandingBalance = loan.loanAmount;

    for (int month = 1; month <= totalMonths; month++) {
      final interestAmount = outstandingBalance * monthlyRate;
      final principalAmount = monthlyEMI - interestAmount;
      
      data.add(EMIBreakdownData(
        month: month,
        principalAmount: principalAmount,
        interestAmount: interestAmount,
        totalEMI: monthlyEMI,
        outstandingBalance: outstandingBalance - principalAmount,
      ));

      outstandingBalance -= principalAmount;
      
      // Stop if balance becomes negative
      if (outstandingBalance <= 0) break;
    }

    return data;
  }

  List<BarChartGroupData> _buildBarGroups(
    ThemeData theme,
    List<EMIBreakdownData> emiData,
  ) {
    return emiData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          // Interest bar (bottom)
          BarChartRodData(
            toY: data.interestAmount,
            color: theme.colorScheme.error,
            width: isTouched ? 8 : 6,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
          ),
          // Principal bar (stacked on top)
          BarChartRodData(
            fromY: data.interestAmount,
            toY: data.totalEMI,
            color: theme.colorScheme.primary,
            width: isTouched ? 8 : 6,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          theme,
          'Interest Payment',
          theme.colorScheme.error,
        ),
        const SizedBox(width: 24),
        _buildLegendItem(
          theme,
          'Principal Payment',
          theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _buildKeyInsights(
    ThemeData theme,
    LoanModel loan,
    List<EMIBreakdownData> emiData,
  ) {
    if (emiData.isEmpty) return const SizedBox.shrink();

    final firstMonth = emiData.first;
    final lastMonth = emiData.last;
    
    final firstInterestRatio = (firstMonth.interestAmount / firstMonth.totalEMI) * 100;
    final lastInterestRatio = (lastMonth.interestAmount / lastMonth.totalEMI) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  theme,
                  'Month 1 Split',
                  '${firstInterestRatio.toStringAsFixed(1)}% Interest',
                  '${(100 - firstInterestRatio).toStringAsFixed(1)}% Principal',
                  Icons.timeline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  theme,
                  'Month ${lastMonth.month} Split',
                  '${lastInterestRatio.toStringAsFixed(1)}% Interest',
                  '${(100 - lastInterestRatio).toStringAsFixed(1)}% Principal',
                  Icons.trending_down,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Early payments save more! Interest portion decreases over time, making early prepayments more effective.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    ThemeData theme,
    String title,
    String value1,
    String value2,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value1,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value2,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for EMI breakdown
class EMIBreakdownData {
  final int month;
  final double principalAmount;
  final double interestAmount;
  final double totalEMI;
  final double outstandingBalance;

  const EMIBreakdownData({
    required this.month,
    required this.principalAmount,
    required this.interestAmount,
    required this.totalEMI,
    required this.outstandingBalance,
  });
}