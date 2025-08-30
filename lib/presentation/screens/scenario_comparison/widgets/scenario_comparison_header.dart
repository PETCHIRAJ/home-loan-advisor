import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/loan_scenario.dart';
import '../../../providers/scenario_comparison_providers.dart';

class ScenarioComparisonHeader extends ConsumerWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback? onClearError;

  const ScenarioComparisonHeader({
    super.key,
    required this.isLoading,
    this.error,
    this.onClearError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledScenarios = ref.watch(enabledScenariosProvider);
    final bestScenario = ref.watch(bestScenarioProvider);
    final metrics = ref.watch(comparisonMetricsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and scenario count
          Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Compare Loan Scenarios',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (enabledScenarios.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${enabledScenarios.length} scenarios',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Error message
          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  if (onClearError != null)
                    IconButton(
                      onPressed: onClearError,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.error,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Loading indicator
          if (isLoading) ...[
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
          ],

          // Quick summary
          if (!isLoading && metrics != null && enabledScenarios.isNotEmpty) ...[
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return _buildCompactSummary(context, metrics, bestScenario);
                } else {
                  return _buildExpandedSummary(context, metrics, bestScenario);
                }
              },
            ),
          ],

          // Tips for empty state
          if (!isLoading && error == null && enabledScenarios.isEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enable scenarios from the list below to compare different loan options',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactSummary(
    BuildContext context,
    ScenarioComparisonMetrics metrics,
    var bestScenario,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SummaryChip(
              label: 'EMI Range',
              value: '${metrics.minEMI.toEMIFormat()} - ${metrics.maxEMI.toEMIFormat()}',
              icon: Icons.payments,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _SummaryChip(
              label: 'Best Option',
              value: bestScenario?.name ?? 'N/A',
              icon: Icons.star,
              color: FinancialColors.savings,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedSummary(
    BuildContext context,
    ScenarioComparisonMetrics metrics,
    var bestScenario,
  ) {
    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'EMI Range',
            value: '${metrics.minEMI.toEMIFormat()} - ${metrics.maxEMI.toEMIFormat()}',
            icon: Icons.payments,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryChip(
            label: 'Interest Savings',
            value: '₹${(metrics.maxTotalInterest - metrics.minTotalInterest).toIndianFormat()}',
            icon: Icons.savings,
            color: FinancialColors.savings,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryChip(
            label: 'Best Option',
            value: bestScenario?.name ?? 'N/A',
            icon: Icons.star,
            color: FinancialColors.savings,
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: chipColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: chipColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}