import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/loan_provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/loan_model.dart';

/// Interactive pie chart showing loan composition breakdown
///
/// Displays principal amount vs total interest with:
/// - Material 3 colors for clear distinction
/// - Interactive touch responses
/// - Educational labels and percentages
/// - Legend with exact amounts
class LoanCompositionChart extends ConsumerWidget {
  const LoanCompositionChart({
    super.key,
    this.height = 300,
    this.showLegend = true,
    this.showEducationalLabels = true,
  });

  final double height;
  final bool showLegend;
  final bool showEducationalLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanAsync = ref.watch(loanNotifierProvider);
    final theme = Theme.of(context);

    return loanAsync.when(
      loading: () => SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: height,
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
        height: height,
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

    final principal = loan.loanAmount;
    final totalInterest = loan.totalInterest;
    final totalAmount = loan.totalAmount;

    // Calculate percentages
    final principalPercentage = (principal / totalAmount) * 100;
    final interestPercentage = (totalInterest / totalAmount) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title and subtitle
        if (showEducationalLabels) ...[
          Text(
            'Loan Composition Breakdown',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'See how much of your total payment goes to principal vs interest',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Chart container
        SizedBox(
          height: height,
          child: Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Add haptic feedback on touch
                        // HapticFeedback.lightImpact(); // Uncomment if needed
                      },
                      enabled: true,
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: _buildPieChartSections(
                      theme,
                      principal,
                      totalInterest,
                      principalPercentage,
                      interestPercentage,
                    ),
                    startDegreeOffset: -90,
                  ),
                ),
              ),

              // Legend
              if (showLegend) ...[
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildLegend(
                    theme,
                    principal,
                    totalInterest,
                    principalPercentage,
                    interestPercentage,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Educational insights
        if (showEducationalLabels) ...[
          const SizedBox(height: 16),
          _buildEducationalInsights(theme, loan),
        ],
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    ThemeData theme,
    double principal,
    double totalInterest,
    double principalPercentage,
    double interestPercentage,
  ) {
    return [
      // Principal section
      PieChartSectionData(
        color: theme.colorScheme.primary,
        value: principal,
        title: '${principalPercentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.6,
      ),
      // Interest section
      PieChartSectionData(
        color: theme.colorScheme.error,
        value: totalInterest,
        title: '${interestPercentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onError,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.6,
      ),
    ];
  }

  Widget _buildLegend(
    ThemeData theme,
    double principal,
    double totalInterest,
    double principalPercentage,
    double interestPercentage,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          theme,
          'Principal Amount',
          CurrencyFormatter.formatCurrencyCompact(principal),
          '${principalPercentage.toStringAsFixed(1)}%',
          theme.colorScheme.primary,
          'The actual loan amount you borrowed',
        ),
        const SizedBox(height: 16),
        _buildLegendItem(
          theme,
          'Total Interest',
          CurrencyFormatter.formatCurrencyCompact(totalInterest),
          '${interestPercentage.toStringAsFixed(1)}%',
          theme.colorScheme.error,
          'Interest paid over the loan tenure',
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    ThemeData theme,
    String label,
    String amount,
    String percentage,
    Color color,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            percentage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationalInsights(ThemeData theme, LoanModel loan) {
    final interestRatio = (loan.totalInterest / loan.totalAmount) * 100;
    
    String insightText;
    Color insightColor;
    IconData insightIcon;

    if (interestRatio > 60) {
      insightText = 'High interest burden! Consider prepayment strategies to reduce total interest.';
      insightColor = theme.colorScheme.error;
      insightIcon = Icons.warning;
    } else if (interestRatio > 40) {
      insightText = 'Moderate interest burden. Explore prepayment options for savings.';
      insightColor = theme.colorScheme.tertiary;
      insightIcon = Icons.info;
    } else {
      insightText = 'Good loan structure with reasonable interest burden.';
      insightColor = theme.colorScheme.primary;
      insightIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: insightColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: insightColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            insightIcon,
            color: insightColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Insight',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: insightColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  insightText,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}