import 'package:flutter/material.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/loan_scenario.dart';

class ScenarioCard extends StatelessWidget {
  final LoanScenario scenario;
  final bool isBest;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const ScenarioCard({
    super.key,
    required this.scenario,
    this.isBest = false,
    this.onToggle,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasResult = scenario.result != null;
    final isEnabled = scenario.isEnabled;

    return Card(
      color: _getCardColor(context),
      elevation: isBest ? 4 : 1,
      child: Stack(
        children: [
          // Best scenario badge
          if (isBest)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: FinancialColors.savings,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'BEST',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Base scenario badge
          if (scenario.isBaseScenario)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BASE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with toggle
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isEnabled
                                      ? null
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scenario.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isEnabled
                                      ? Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.8)
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (onToggle != null) ...[
                      const SizedBox(width: 8),
                      Switch(
                        value: isEnabled,
                        onChanged: (_) => onToggle?.call(),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Parameters
                _buildParameterRow(
                  context,
                  'Loan Amount',
                  scenario.parameters.loanAmount.toIndianFormat(),
                  Icons.account_balance_wallet,
                  isEnabled,
                ),
                const SizedBox(height: 8),
                _buildParameterRow(
                  context,
                  'Interest Rate',
                  '${scenario.parameters.interestRate}% p.a.',
                  Icons.percent,
                  isEnabled,
                ),
                const SizedBox(height: 8),
                _buildParameterRow(
                  context,
                  'Tenure',
                  '${scenario.parameters.tenureYears} years',
                  Icons.schedule,
                  isEnabled,
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Results
                if (hasResult && isEnabled) ...[
                  _buildResultRow(
                    context,
                    'Monthly EMI',
                    scenario.result!.monthlyEMI.toEMIFormat(),
                    FinancialColors.neutral,
                    isBold: true,
                  ),
                  const SizedBox(height: 8),
                  _buildResultRow(
                    context,
                    'Total Interest',
                    scenario.result!.totalInterest.toIndianFormat(),
                    FinancialColors.cost,
                  ),
                  const SizedBox(height: 8),
                  _buildResultRow(
                    context,
                    'Total Amount',
                    scenario.result!.totalAmount.toIndianFormat(),
                    FinancialColors.neutral,
                  ),
                  if (scenario.result!.taxBenefits.totalAnnualSavings > 0) ...[
                    const SizedBox(height: 8),
                    _buildResultRow(
                      context,
                      'Tax Savings/Year',
                      scenario.result!.taxBenefits.totalAnnualSavings
                          .toEMIFormat(),
                      FinancialColors.taxBenefit,
                    ),
                  ],
                  if (scenario.result!.pmayBenefit?.isEligible == true) ...[
                    const SizedBox(height: 8),
                    _buildResultRow(
                      context,
                      'PMAY Subsidy',
                      scenario.result!.pmayBenefit!.subsidyAmount.toEMIFormat(),
                      FinancialColors.pmayBenefit,
                    ),
                  ],
                ] else if (!hasResult && isEnabled) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (!isEnabled) ...[
                  Center(
                    child: Text(
                      'Scenario disabled',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                // Action buttons
                if (onEdit != null || onRemove != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (onEdit != null) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                      if (onEdit != null && onRemove != null)
                        const SizedBox(width: 8),
                      if (onRemove != null) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onRemove,
                            icon: const Icon(Icons.delete, size: 16),
                            label: const Text('Remove'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? _getCardColor(BuildContext context) {
    if (isBest) {
      return FinancialColors.savings.withValues(alpha: 0.05);
    }
    if (scenario.isBaseScenario) {
      return Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.1);
    }
    if (!scenario.isEnabled) {
      return Theme.of(context).colorScheme.surface.withValues(alpha: 0.5);
    }
    return null;
  }

  Widget _buildParameterRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isEnabled,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isEnabled
                  ? Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isEnabled
                ? null
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: FinancialTypography.moneySmall.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
