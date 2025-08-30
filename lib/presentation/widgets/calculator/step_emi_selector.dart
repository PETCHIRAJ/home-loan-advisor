import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/step_emi.dart';
import '../../../core/utils/step_emi_calculation_utils.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EMI Structure',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how your EMI changes over time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // EMI Type Selector
            _buildEMITypeSelector(context),

            if (parameters.type != StepEMIType.none) ...[
              const SizedBox(height: 24),
              _buildStepConfigurationSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEMITypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMI Type',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        
        // EMI Type Cards
        ...StepEMIType.values.map((type) => _buildEMITypeCard(context, type)),
      ],
    );
  }

  Widget _buildEMITypeCard(BuildContext context, StepEMIType type) {
    final isSelected = parameters.type == type;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected 
          ? colorScheme.primaryContainer
          : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected 
              ? colorScheme.primary
              : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => _handleEMITypeChange(type),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon based on type
                Icon(
                  _getIconForEMIType(type),
                  color: isSelected 
                    ? colorScheme.primary
                    : colorScheme.onSurface,
                  size: 24,
                ),
                const SizedBox(width: 16),
                
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected 
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected 
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepConfigurationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Configuration',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),

        // Step Percentage
        _buildStepPercentageSelector(context),
        
        const SizedBox(height: 20),

        // Step Frequency
        _buildStepFrequencySelector(context),

        const SizedBox(height: 16),

        // Configuration Summary
        _buildConfigurationSummary(context),
      ],
    );
  }

  Widget _buildStepPercentageSelector(BuildContext context) {
    final suggestedPercentages = StepEMICalculationUtils.getSuggestedStepPercentages();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Percentage',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'How much should your EMI ${parameters.type == StepEMIType.stepUp ? 'increase' : 'decrease'}?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        // Percentage chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestedPercentages.map((percentage) {
            final isSelected = parameters.stepPercentage == percentage;
            return FilterChip(
              label: Text('${percentage.toStringAsFixed(percentage % 1 == 0 ? 0 : 1)}%'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onParametersChanged(parameters.copyWith(stepPercentage: percentage));
                }
              },
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepFrequencySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Frequency',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'How often should the EMI change?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        SegmentedButton<StepFrequency>(
          segments: StepFrequency.values.map((frequency) {
            return ButtonSegment<StepFrequency>(
              value: frequency,
              label: Text(frequency.displayName),
            );
          }).toList(),
          selected: {parameters.frequency},
          onSelectionChanged: (Set<StepFrequency> selection) {
            onParametersChanged(parameters.copyWith(frequency: selection.first));
          },
        ),
      ],
    );
  }

  Widget _buildConfigurationSummary(BuildContext context) {
    if (parameters.type == StepEMIType.none) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final changeVerb = parameters.type == StepEMIType.stepUp ? 'increases' : 'decreases';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your EMI $changeVerb by ${parameters.stepPercentage}% ${parameters.frequency.displayName.toLowerCase()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getConfigurationBenefit(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForEMIType(StepEMIType type) {
    switch (type) {
      case StepEMIType.none:
        return Icons.straighten;
      case StepEMIType.stepUp:
        return Icons.trending_up;
      case StepEMIType.stepDown:
        return Icons.trending_down;
    }
  }

  String _getConfigurationBenefit() {
    switch (parameters.type) {
      case StepEMIType.stepUp:
        return 'Perfect for growing income - start with lower EMIs and increase as your salary grows';
      case StepEMIType.stepDown:
        return 'Ideal for retirement planning - higher EMIs initially, then reduce as you approach retirement';
      default:
        return '';
    }
  }

  void _handleEMITypeChange(StepEMIType newType) {
    if (newType == parameters.type) return;

    StepEMIParameters newParameters;
    
    switch (newType) {
      case StepEMIType.none:
        newParameters = StepEMIParameters.none();
        break;
      case StepEMIType.stepUp:
        newParameters = StepEMIParameters.stepUp(
          stepPercentage: parameters.type == StepEMIType.stepDown 
            ? parameters.stepPercentage 
            : 10.0,
          frequency: parameters.frequency,
        );
        break;
      case StepEMIType.stepDown:
        newParameters = StepEMIParameters.stepDown(
          stepPercentage: parameters.type == StepEMIType.stepUp 
            ? parameters.stepPercentage 
            : 10.0,
          frequency: parameters.frequency,
        );
        break;
    }

    onParametersChanged(newParameters);
  }
}

/// Preview widget showing EMI progression
class StepEMIPreview extends StatelessWidget {
  final StepEMIResult result;

  const StepEMIPreview({
    super.key,
    required this.result,
  });

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
    final yearlyBreakdown = result.yearlyBreakdown.take(5).toList(); // Show first 5 years

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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
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
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}