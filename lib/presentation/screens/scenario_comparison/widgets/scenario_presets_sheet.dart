import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/loan_scenario.dart';
import '../../../providers/scenario_comparison_providers.dart';

class ScenarioPresetsSheet extends ConsumerWidget {
  const ScenarioPresetsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scenarioComparisonProvider);
    final scenarios = state.comparison?.scenarios ?? [];
    
    // Find non-base scenarios that can be modified
    final modifiableScenarios = scenarios
        .where((s) => !s.isBaseScenario && !s.id.startsWith('custom_'))
        .toList();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.tune),
              const SizedBox(width: 8),
              Text(
                'Apply Quick Presets',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Presets grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ScenarioPreset.values.length,
            itemBuilder: (context, index) {
              final preset = ScenarioPreset.values[index];
              return _buildPresetButton(context, ref, preset, modifiableScenarios);
            },
          ),

          const SizedBox(height: 24),

          // Help text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Presets will be applied to existing scenario slots. Enable/disable scenarios to compare different options.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    WidgetRef ref,
    ScenarioPreset preset,
    List<LoanScenario> modifiableScenarios,
  ) {
    return OutlinedButton(
      onPressed: () => _applyPreset(context, ref, preset, modifiableScenarios),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            preset.displayName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _getPresetValue(preset),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getPresetValue(ScenarioPreset preset) {
    switch (preset) {
      case ScenarioPreset.lowerRate:
        return '-0.5%';
      case ScenarioPreset.higherRate:
        return '+0.5%';
      case ScenarioPreset.shorterTenure:
        return '-5 years';
      case ScenarioPreset.longerTenure:
        return '+5 years';
      case ScenarioPreset.lowerAmount:
        return '-20%';
      case ScenarioPreset.higherAmount:
        return '+20%';
    }
  }

  void _applyPreset(
    BuildContext context,
    WidgetRef ref,
    ScenarioPreset preset,
    List<LoanScenario> modifiableScenarios,
  ) {
    // Find the scenario that matches this preset
    final targetScenarioId = _getPresetScenarioId(preset);
    final targetScenario = modifiableScenarios
        .where((s) => s.id == targetScenarioId)
        .firstOrNull;

    if (targetScenario != null) {
      ref
          .read(scenarioComparisonProvider.notifier)
          .applyScenarioPreset(targetScenario.id, preset);
      
      // Enable the scenario if it's not already enabled
      if (!targetScenario.isEnabled) {
        ref
            .read(scenarioComparisonProvider.notifier)
            .toggleScenario(targetScenario.id);
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied ${preset.displayName} preset'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not apply ${preset.displayName} preset'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _getPresetScenarioId(ScenarioPreset preset) {
    switch (preset) {
      case ScenarioPreset.lowerRate:
        return 'lower_rate';
      case ScenarioPreset.higherRate:
        return 'higher_rate';
      case ScenarioPreset.shorterTenure:
        return 'shorter_tenure';
      case ScenarioPreset.longerTenure:
        return 'longer_tenure';
      case ScenarioPreset.lowerAmount:
        return 'lower_amount';
      case ScenarioPreset.higherAmount:
        return 'higher_amount';
    }
  }
}