import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/calculation_providers.dart';
import '../../providers/history_provider.dart';
import '../../widgets/calculator/loan_input_form.dart';
import '../../widgets/calculator/enhanced_emi_results_card.dart';
import '../../widgets/calculator/step_emi_selector.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../../domain/entities/step_emi.dart';
import '../../../domain/entities/calculation_history.dart';
import '../history/calculation_history_screen.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorScreenStateProvider);
    final emiCalculation = ref.watch(enhancedEMICalculationProvider);
    final stepEMIParameters = ref.watch(stepEMIParametersProvider);
    final autoStepResult = ref.watch(autoStepEMICalculationProvider);

    return AppScaffold(
      title: 'EMI Calculator',
      actions: [
        // History button
        IconButton(
          onPressed: () => _navigateToHistory(context, ref),
          icon: const Icon(Icons.history),
          tooltip: 'Calculation History',
        ),
        TextButton.icon(
          icon: const Icon(Icons.clear_all),
          label: const Text('Clear'),
          onPressed: () {
            ref.read(loanParametersProvider.notifier).resetToDefaults();
            ref.read(enhancedEMICalculationProvider.notifier).clearResult();
            ref.read(stepEMIParametersProvider.notifier).reset();
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section with app description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'India\'s Tax-Aware EMI Calculator',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calculate your home loan EMI with complete tax benefits analysis including Section 80C, 24B, and PMAY subsidies.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Loan input form
            const LoanInputForm(),

            const SizedBox(height: 16),

            // Step EMI selector
            StepEMISelector(
              parameters: stepEMIParameters,
              onParametersChanged: (parameters) {
                ref
                    .read(stepEMIParametersProvider.notifier)
                    .updateParameters(parameters);
              },
            ),

            const SizedBox(height: 16),

            // Step EMI preview (if enabled)
            if (stepEMIParameters.type != StepEMIType.none &&
                autoStepResult.hasValue &&
                autoStepResult.value != null)
              StepEMIPreview(result: autoStepResult.value!),

            const SizedBox(height: 16),

            // Calculate button
            FilledButton(
              onPressed: calculatorState.isLoading
                  ? null
                  : () async {
                      ref
                          .read(calculatorScreenStateProvider.notifier)
                          .setLoading(true);

                      await ref
                          .read(enhancedEMICalculationProvider.notifier)
                          .calculateEMI();

                      ref
                          .read(calculatorScreenStateProvider.notifier)
                          .setLoading(false);

                      // Check if calculation was successful and show results
                      final calculationResult = ref.read(
                        enhancedEMICalculationProvider,
                      );
                      if (calculationResult.hasValue &&
                          calculationResult.value != null) {
                        ref
                            .read(calculatorScreenStateProvider.notifier)
                            .showResults();

                        // Save calculation to history
                        try {
                          final loanParams = ref.read(loanParametersProvider);
                          await ref
                              .read(historyActionsProvider.notifier)
                              .saveCalculation(
                                parameters: loanParams,
                                result: calculationResult.value!,
                              );
                        } catch (e) {
                          // Silently handle history save errors - don't disrupt main flow
                          debugPrint(
                            'Failed to save calculation to history: $e',
                          );
                        }
                      }
                    },
              child: calculatorState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Calculate EMI'),
            ),

            const SizedBox(height: 16),

            // Results section
            if (calculatorState.showResults && emiCalculation.hasValue)
              emiCalculation.when(
                data: (result) {
                  if (result != null) {
                    final loanParams = ref.read(loanParametersProvider);
                    return EnhancedEMIResultsCard(
                      result: result,
                      parameters: loanParams,
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, stackTrace) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error calculating EMI',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            ref
                                .read(enhancedEMICalculationProvider.notifier)
                                .calculateEMI();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Tips section
            if (!calculatorState.showResults) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.tips_and_updates),
                          const SizedBox(width: 8),
                          Text(
                            'Quick Tips',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip(
                        context,
                        'Higher down payment reduces EMI and total interest',
                      ),
                      _buildTip(
                        context,
                        'Shorter tenure saves more on total interest',
                      ),
                      _buildTip(
                        context,
                        'Consider tax benefits in your loan planning',
                      ),
                      _buildTip(
                        context,
                        'PMAY subsidy can reduce your effective interest rate',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  /// Navigate to calculation history screen
  Future<void> _navigateToHistory(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (context) => const CalculationHistoryScreen()),
    );

    // If user selected a history item to load, restore the parameters
    if (result != null && result is CalculationHistory) {
      ref
          .read(loanParametersProvider.notifier)
          .loadFromHistory(result.parameters);

      // Show snackbar to indicate parameters loaded
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.name != null
                  ? 'Loaded "${result.name}"'
                  : 'Loaded calculation from history',
            ),
            action: SnackBarAction(
              label: 'Calculate',
              onPressed: () {
                // Trigger calculation
                ref
                    .read(enhancedEMICalculationProvider.notifier)
                    .calculateEMI();
              },
            ),
          ),
        );
      }
    }
  }
}
