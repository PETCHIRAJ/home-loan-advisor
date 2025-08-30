import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/loan_scenario.dart';
import '../../../providers/scenario_comparison_providers.dart';
import 'scenario_presets_sheet.dart';
import 'add_custom_scenario_dialog.dart';
import '../../../widgets/common/responsive_scenario_cards.dart';
import '../../../widgets/common/responsive_layout.dart';

class ScenarioCardsView extends ConsumerWidget {
  const ScenarioCardsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredScenarios = ref.watch(filteredScenariosProvider);
    final bestScenario = ref.watch(bestScenarioProvider);

    if (filteredScenarios.isEmpty) {
      return const Center(child: Text('No scenarios available'));
    }

    return CustomScrollView(
      slivers: [
        // Action buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showPresetsSheet(context, ref),
                    icon: const Icon(Icons.tune),
                    label: const Text('Apply Presets'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddCustomScenarioDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Custom'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Responsive scenario cards with adaptive layout
        SliverFillRemaining(
          child: ResponsiveScenarioCards(
            scenarios: filteredScenarios,
            bestScenario: bestScenario,
            onToggleScenario: (scenarioId) => ref
                .read(scenarioComparisonProvider.notifier)
                .toggleScenario(scenarioId),
            onEditScenario: (scenario) => _editScenario(context, ref, scenario),
            onRemoveScenario: (scenarioId) => ref
                .read(scenarioComparisonProvider.notifier)
                .removeScenario(scenarioId),
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  void _showPresetsSheet(BuildContext context, WidgetRef ref) {
    ResponsiveBottomSheet.show(
      context: context,
      maxHeightFactor: 0.85,
      builder: (context) => const ScenarioPresetsSheet(),
    );
  }

  void _showAddCustomScenarioDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddCustomScenarioDialog(),
    );
  }

  void _editScenario(
    BuildContext context,
    WidgetRef ref,
    LoanScenario scenario,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditScenarioDialog(scenario: scenario),
    );
  }
}

/// Dialog for editing scenario parameters
class EditScenarioDialog extends ConsumerStatefulWidget {
  final LoanScenario scenario;

  const EditScenarioDialog({super.key, required this.scenario});

  @override
  ConsumerState<EditScenarioDialog> createState() => _EditScenarioDialogState();
}

class _EditScenarioDialogState extends ConsumerState<EditScenarioDialog> {
  late final TextEditingController _loanAmountController;
  late final TextEditingController _interestRateController;
  late final TextEditingController _tenureController;

  @override
  void initState() {
    super.initState();
    _loanAmountController = TextEditingController(
      text: widget.scenario.parameters.loanAmount.toStringAsFixed(0),
    );
    _interestRateController = TextEditingController(
      text: widget.scenario.parameters.interestRate.toStringAsFixed(2),
    );
    _tenureController = TextEditingController(
      text: widget.scenario.parameters.tenureYears.toString(),
    );
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.scenario.name}'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _loanAmountController,
              decoration: const InputDecoration(
                labelText: 'Loan Amount',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _interestRateController,
              decoration: const InputDecoration(
                labelText: 'Interest Rate',
                suffixText: '% p.a.',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tenureController,
              decoration: const InputDecoration(
                labelText: 'Tenure',
                suffixText: 'years',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _updateScenario, child: const Text('Update')),
      ],
    );
  }

  void _updateScenario() {
    final loanAmount = double.tryParse(_loanAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final tenure = int.tryParse(_tenureController.text);

    if (loanAmount == null || interestRate == null || tenure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    final newParameters = widget.scenario.parameters.copyWith(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenure,
    );

    ref
        .read(scenarioComparisonProvider.notifier)
        .updateScenarioParameters(widget.scenario.id, newParameters);

    Navigator.of(context).pop();
  }
}
