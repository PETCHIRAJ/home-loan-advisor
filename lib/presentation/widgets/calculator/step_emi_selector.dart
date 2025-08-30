import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/step_emi.dart';
import '../common/responsive_step_emi_selector.dart';

/// Legacy StepEMISelector that now uses the new responsive implementation
class StepEMISelector extends ConsumerWidget {
  final StepEMIParameters parameters;
  final Function(StepEMIParameters) onParametersChanged;

  const StepEMISelector({
    super.key,
    required this.parameters,
    required this.onParametersChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the new responsive step EMI selector with improved UX
    return ResponsiveStepEMISelector(
      parameters: parameters,
      onParametersChanged: onParametersChanged,
    );
  }
}

/// Preview widget showing EMI progression - kept for backward compatibility
class StepEMIPreview extends StatelessWidget {
  final StepEMIResult result;

  const StepEMIPreview({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.parameters.type == StepEMIType.none) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EMI Progression',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // EMI progression chart (simplified)
            _buildProgressionChart(context),

            const SizedBox(height: 16),

            // Key metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'First EMI',
                    '₹${result.firstEMI.toStringAsFixed(0)}',
                    Icons.play_arrow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    'Last EMI',
                    '₹${result.lastEMI.toStringAsFixed(0)}',
                    Icons.stop,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Interest comparison
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: result.isMoreExpensive
                    ? colorScheme.errorContainer.withValues(alpha: 0.3)
                    : colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    result.isMoreExpensive
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 20,
                    color: result.isMoreExpensive
                        ? colorScheme.error
                        : colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.isMoreExpensive
                          ? 'Costs ₹${result.interestSavedVsRegular.abs().toStringAsFixed(0)} more than regular EMI'
                          : 'Saves ₹${result.interestSavedVsRegular.toStringAsFixed(0)} vs regular EMI',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: result.isMoreExpensive
                            ? colorScheme.onErrorContainer
                            : colorScheme.onPrimaryContainer,
                      ),
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

  Widget _buildProgressionChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final yearlyBreakdown = result.yearlyBreakdown
        .take(5)
        .toList(); // Show first 5 years

    return SizedBox(
      height: 60,
      child: Row(
        children: yearlyBreakdown.asMap().entries.map((entry) {
          final index = entry.key;
          final yearly = entry.value;
          final maxEMI = yearlyBreakdown.fold<double>(
            0,
            (max, item) => item.emiAmount > max ? item.emiAmount : max,
          );
          final heightRatio = yearly.emiAmount / maxEMI;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < yearlyBreakdown.length - 1 ? 4 : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bar
                  Container(
                    height: 40 * heightRatio,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Year label
                  Text(
                    'Y${yearly.year}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
