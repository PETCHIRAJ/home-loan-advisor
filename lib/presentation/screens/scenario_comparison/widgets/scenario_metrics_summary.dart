import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/loan_scenario.dart';
import '../../../providers/scenario_comparison_providers.dart';

class ScenarioMetricsSummary extends ConsumerWidget {
  const ScenarioMetricsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosWithResults = ref.watch(scenariosWithResultsProvider);
    final bestScenario = ref.watch(bestScenarioProvider);
    final metrics = ref.watch(comparisonMetricsProvider);

    if (scenariosWithResults.isEmpty || metrics == null) {
      return const Center(child: Text('No metrics available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Cards
          _buildSummaryCards(context, metrics, bestScenario),

          const SizedBox(height: 24),

          // Detailed comparison table
          _buildComparisonTable(context, scenariosWithResults, bestScenario),

          const SizedBox(height: 24),

          // Differences analysis
          if (scenariosWithResults.length > 1)
            _buildDifferencesAnalysis(context, scenariosWithResults, metrics),

          const SizedBox(height: 24),

          // Recommendations
          _buildRecommendations(context, scenariosWithResults, bestScenario),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    ScenarioComparisonMetrics metrics,
    LoanScenario? bestScenario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Summary',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - single column
              return Column(
                children: [
                  _MetricCard(
                    title: 'EMI Range',
                    value:
                        '${metrics.minEMI.toEMIFormat()} - ${metrics.maxEMI.toEMIFormat()}',
                    subtitle: 'Difference: ${metrics.emiRange.toEMIFormat()}',
                    icon: Icons.payments,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    title: 'Interest Range',
                    value:
                        '₹${metrics.minTotalInterest.toIndianFormat()} - ₹${metrics.maxTotalInterest.toIndianFormat()}',
                    subtitle:
                        'Max savings: ₹${metrics.totalInterestRange.toIndianFormat()}',
                    icon: Icons.trending_down,
                    color: FinancialColors.cost,
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    title: 'Best Option',
                    value: bestScenario?.name ?? 'None',
                    subtitle: bestScenario != null
                        ? 'Total cost: ₹${bestScenario.totalCostAfterBenefits.toIndianFormat()}'
                        : 'No best option identified',
                    icon: Icons.star,
                    color: FinancialColors.savings,
                  ),
                ],
              );
            } else {
              // Desktop layout - row
              return Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'EMI Range',
                      value:
                          '${metrics.minEMI.toEMIFormat()} - ${metrics.maxEMI.toEMIFormat()}',
                      subtitle: 'Difference: ${metrics.emiRange.toEMIFormat()}',
                      icon: Icons.payments,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'Interest Range',
                      value:
                          '₹${metrics.minTotalInterest.toIndianFormat()} - ₹${metrics.maxTotalInterest.toIndianFormat()}',
                      subtitle:
                          'Max savings: ₹${metrics.totalInterestRange.toIndianFormat()}',
                      icon: Icons.trending_down,
                      color: FinancialColors.cost,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'Best Option',
                      value: bestScenario?.name ?? 'None',
                      subtitle: bestScenario != null
                          ? 'Total cost: ₹${bestScenario.totalCostAfterBenefits.toIndianFormat()}'
                          : 'No best option identified',
                      icon: Icons.star,
                      color: FinancialColors.savings,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildComparisonTable(
    BuildContext context,
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Comparison',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 16,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Scenario')),
                DataColumn(label: Text('EMI')),
                DataColumn(label: Text('Total Interest')),
                DataColumn(label: Text('Total Amount')),
                DataColumn(label: Text('Tax Benefits')),
                DataColumn(label: Text('Effective Rate')),
                DataColumn(label: Text('Total Cost')),
              ],
              rows: scenarios.map((scenario) {
                final isBest = bestScenario?.id == scenario.id;
                final result = scenario.result!;

                return DataRow(
                  color: isBest
                      ? WidgetStateProperty.all(
                          FinancialColors.savings.withValues(alpha: 0.1),
                        )
                      : null,
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            scenario.name,
                            style: TextStyle(
                              fontWeight: isBest
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isBest) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: FinancialColors.savings,
                            ),
                          ],
                        ],
                      ),
                    ),
                    DataCell(Text(result.monthlyEMI.toEMIFormat())),
                    DataCell(Text('₹${result.totalInterest.toIndianFormat()}')),
                    DataCell(Text('₹${result.totalAmount.toIndianFormat()}')),
                    DataCell(
                      Text(
                        '₹${result.taxBenefits.totalAnnualSavings.toEMIFormat()}/year',
                      ),
                    ),
                    DataCell(
                      Text(
                        '${scenario.effectiveInterestRate.toStringAsFixed(2)}%',
                      ),
                    ),
                    DataCell(
                      Text(
                        '₹${scenario.totalCostAfterBenefits.toIndianFormat()}',
                        style: TextStyle(
                          fontWeight: isBest
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isBest ? FinancialColors.savings : null,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifferencesAnalysis(
    BuildContext context,
    List<LoanScenario> scenarios,
    ScenarioComparisonMetrics metrics,
  ) {
    // Compare each scenario with base scenario
    final baseScenario = scenarios.where((s) => s.isBaseScenario).firstOrNull;
    if (baseScenario == null) return const SizedBox.shrink();

    final otherScenarios = scenarios.where((s) => !s.isBaseScenario).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comparison with Base Scenario',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...otherScenarios.map((scenario) {
          final emiDiff =
              scenario.result!.monthlyEMI - baseScenario.result!.monthlyEMI;
          final interestDiff =
              scenario.result!.totalInterest -
              baseScenario.result!.totalInterest;
          final totalCostDiff =
              scenario.totalCostAfterBenefits -
              baseScenario.totalCostAfterBenefits;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: totalCostDiff < 0
                ? FinancialColors.savings.withValues(alpha: 0.05)
                : totalCostDiff > 0
                ? FinancialColors.cost.withValues(alpha: 0.05)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        scenario.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: totalCostDiff < 0
                              ? FinancialColors.savings
                              : totalCostDiff > 0
                              ? FinancialColors.cost
                              : FinancialColors.neutral,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          totalCostDiff < 0
                              ? 'SAVES MONEY'
                              : totalCostDiff > 0
                              ? 'COSTS MORE'
                              : 'SAME',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DifferenceItem(
                          label: 'EMI Difference',
                          value: emiDiff.toEMIFormat(),
                          isPositive: emiDiff < 0,
                        ),
                      ),
                      Expanded(
                        child: _DifferenceItem(
                          label: 'Interest Difference',
                          value: '₹${interestDiff.abs().toIndianFormat()}',
                          isPositive: interestDiff < 0,
                        ),
                      ),
                      Expanded(
                        child: _DifferenceItem(
                          label: 'Total Cost Difference',
                          value: '₹${totalCostDiff.abs().toIndianFormat()}',
                          isPositive: totalCostDiff < 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    List<LoanScenario> scenarios,
    LoanScenario? bestScenario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bestScenario != null) ...[
                  Row(
                    children: [
                      Icon(Icons.star, color: FinancialColors.savings),
                      const SizedBox(width: 8),
                      Text(
                        'Best Option: ${bestScenario.name}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FinancialColors.savings,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This scenario offers the lowest total cost after considering all benefits and subsidies.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],

                // General recommendations
                _RecommendationItem(
                  icon: Icons.timeline,
                  title: 'Consider shorter tenure',
                  description:
                      'Shorter loan tenure typically results in lower total interest, despite higher EMI.',
                ),
                const SizedBox(height: 12),
                _RecommendationItem(
                  icon: Icons.trending_down,
                  title: 'Shop for lower rates',
                  description:
                      'Even a 0.5% reduction in interest rate can save significant money over the loan tenure.',
                ),
                const SizedBox(height: 12),
                _RecommendationItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Maximize tax benefits',
                  description:
                      'Ensure you\'re claiming all eligible tax deductions to reduce effective interest rate.',
                ),
                const SizedBox(height: 12),
                _RecommendationItem(
                  icon: Icons.home_work,
                  title: 'Check PMAY eligibility',
                  description:
                      'PMAY subsidy can significantly reduce your effective loan amount and total cost.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifferenceItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _DifferenceItem({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isPositive
                  ? FinancialColors.savings
                  : FinancialColors.cost,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isPositive
                    ? FinancialColors.savings
                    : FinancialColors.cost,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
