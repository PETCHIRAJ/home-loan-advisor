import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/calculation_providers.dart';
import '../../widgets/calculator/loan_input_form.dart';
import '../../widgets/calculator/emi_results_card.dart';
import '../../widgets/common/app_scaffold.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorScreenStateProvider);
    final emiCalculation = ref.watch(emiCalculationProvider);

    return AppScaffold(
      title: 'EMI Calculator',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.read(loanParametersProvider.notifier).resetToDefaults();
            ref.read(emiCalculationProvider.notifier).clearResult();
          },
          tooltip: 'Reset to defaults',
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

            // Calculate button
            FilledButton(
              onPressed: calculatorState.isLoading
                  ? null
                  : () {
                      ref
                          .read(calculatorScreenStateProvider.notifier)
                          .setLoading(true);
                      ref
                          .read(emiCalculationProvider.notifier)
                          .calculateEMI()
                          .then((_) {
                            ref
                                .read(calculatorScreenStateProvider.notifier)
                                .setLoading(false);
                            ref
                                .read(calculatorScreenStateProvider.notifier)
                                .showResults();
                          });
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
                    return EMIResultsCard(result: result);
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
                                .read(emiCalculationProvider.notifier)
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
}
