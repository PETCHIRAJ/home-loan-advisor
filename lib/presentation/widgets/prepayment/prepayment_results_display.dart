import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/prepayment_result.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';

class PrepaymentResultsDisplay extends StatefulWidget {
  final PrepaymentResult result;
  final LoanParameters loanParameters;

  const PrepaymentResultsDisplay({
    super.key,
    required this.result,
    required this.loanParameters,
  });

  @override
  State<PrepaymentResultsDisplay> createState() => _PrepaymentResultsDisplayState();
}

class _PrepaymentResultsDisplayState extends State<PrepaymentResultsDisplay>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabLabels = [
    'Summary',
    'Timeline',
    'Comparison',
  ];

  final List<IconData> _tabIcons = [
    Icons.summarize,
    Icons.timeline,
    Icons.compare_arrows,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: FinancialColors.savings.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: FinancialColors.savings,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prepayment Impact Analysis',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: FinancialColors.savings,
                          ),
                        ),
                        Text(
                          'See how your prepayment strategy will save money and time',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
            tabs: List.generate(
              _tabLabels.length,
              (index) => Tab(
                icon: Icon(_tabIcons[index], size: 18),
                text: _tabLabels[index],
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
            ),
          ),

          // Tab Content
          Container(
            constraints: const BoxConstraints(minHeight: 400),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IndexedStack(
                key: ValueKey(_selectedIndex),
                index: _selectedIndex,
                children: [
                  _buildSummaryTab(),
                  _buildTimelineTab(),
                  _buildComparisonTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final benefits = widget.result.benefits;
    final comparison = widget.result.comparison;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Key Benefits Grid
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _buildBenefitCard(
                      'Interest Saved',
                      benefits.totalInterestSaved.toIndianFormat(),
                      Icons.savings,
                      FinancialColors.savings,
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitCard(
                      'Time Saved',
                      benefits.formattedTenureReduction,
                      Icons.schedule,
                      FinancialColors.prepayment,
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitCard(
                      'ROI',
                      '${benefits.roiPercentage.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      FinancialColors.taxBenefit,
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _buildBenefitCard(
                        'Interest Saved',
                        benefits.totalInterestSaved.toIndianFormat(),
                        Icons.savings,
                        FinancialColors.savings,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBenefitCard(
                        'Time Saved',
                        benefits.formattedTenureReduction,
                        Icons.schedule,
                        FinancialColors.prepayment,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBenefitCard(
                        'ROI',
                        '${benefits.roiPercentage.toStringAsFixed(1)}%',
                        Icons.trending_up,
                        FinancialColors.taxBenefit,
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 20),

          // Detailed Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detailed Breakdown',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDetailRow('Prepayment Amount', benefits.totalPrepaymentAmount.toIndianFormat()),
                _buildDetailRow('Original Tenure', '${comparison.originalTenureMonths ~/ 12} years ${comparison.originalTenureMonths % 12} months'),
                _buildDetailRow('New Tenure', '${comparison.newTenureMonths ~/ 12} years ${comparison.newTenureMonths % 12} months'),
                _buildDetailRow('Original Total Interest', comparison.originalTotalInterest.toIndianFormat()),
                _buildDetailRow('New Total Interest', comparison.newTotalInterest.toIndianFormat()),
                const Divider(),
                _buildDetailRow(
                  'Net Benefit (After Tax Impact)',
                  benefits.netBenefit.toIndianFormat(),
                  isHighlight: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Break-even Analysis
          if (benefits.breakEvenMonths > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Break-even: ${benefits.breakEvenMonths.toInt()} months. Your prepayment will pay for itself through interest savings.',
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
    );
  }

  Widget _buildTimelineTab() {
    final progression = widget.result.breakdown.balanceProgression;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Outstanding Balance Over Time',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 70,
                      interval: widget.loanParameters.loanAmount / 4,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            value.toCompactIndianFormat(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: (widget.loanParameters.tenureYears * 3).toDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value % 12 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Y${(value / 12).toInt()}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Original loan line
                  LineChartBarData(
                    spots: progression
                        .map((point) => FlSpot(
                              point.month.toDouble(),
                              point.originalBalance,
                            ))
                        .toList(),
                    isCurved: true,
                    color: FinancialColors.cost,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  // New loan line (with prepayment)
                  LineChartBarData(
                    spots: progression
                        .map((point) => FlSpot(
                              point.month.toDouble(),
                              point.newBalance,
                            ))
                        .toList(),
                    isCurved: true,
                    color: FinancialColors.savings,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Original Loan', FinancialColors.cost),
              const SizedBox(width: 24),
              _buildLegendItem('With Prepayment', FinancialColors.savings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTab() {
    final comparison = widget.result.comparison;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Before vs After Comparison',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildComparisonRow('EMI Amount', comparison.originalEMI, comparison.newEMI, isEMI: true),
                _buildComparisonRow('Tenure (Months)', comparison.originalTenureMonths, comparison.newTenureMonths, isMonths: true),
                _buildComparisonRow('Total Interest', comparison.originalTotalInterest, comparison.newTotalInterest),
                _buildComparisonRow('Total Amount', comparison.originalTotalAmount, comparison.newTotalAmount),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Savings Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FinancialColors.savings.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FinancialColors.savings.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.savings,
                      color: FinancialColors.savings,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Savings',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FinancialColors.savings,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interest Saved',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            comparison.interestSaved.toIndianFormat(),
                            style: FinancialTypography.moneyLarge.copyWith(
                              color: FinancialColors.savings,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Time Saved',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${comparison.tenureReducedMonths ~/ 12}y ${comparison.tenureReducedMonths % 12}m',
                            style: FinancialTypography.moneyLarge.copyWith(
                              color: FinancialColors.prepayment,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: FinancialTypography.moneyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: FinancialTypography.moneyMedium.copyWith(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? FinancialColors.savings : null,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    dynamic originalValue,
    dynamic newValue, {
    bool isEMI = false,
    bool isMonths = false,
  }) {
    String formatValue(dynamic value) {
      if (value is double) {
        return isEMI ? value.toEMIFormat() : value.toIndianFormat();
      } else if (value is int && isMonths) {
        return '$value months';
      }
      return value.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              formatValue(originalValue),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(Icons.arrow_forward, size: 16),
          Expanded(
            child: Text(
              formatValue(newValue),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FinancialColors.savings,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}