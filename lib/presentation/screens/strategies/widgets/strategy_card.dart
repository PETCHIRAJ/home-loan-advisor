import 'package:flutter/material.dart';
import '../../../../domain/entities/money_saving_strategy.dart';
import '../../../../core/extensions/number_extensions.dart';

class StrategyCard extends StatelessWidget {
  final PersonalizedStrategyResult strategy;
  final VoidCallback onTap;

  const StrategyCard({
    super.key,
    required this.strategy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get strategy metadata based on strategyId
    final strategyMeta = _getStrategyMetadata(strategy.strategyId);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with savings and feasibility
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Savings amount
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '💰',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'SAVE ${strategy.personalizedSavings.toCompactFormat()}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Feasibility badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getFeasibilityColor(strategy.feasibility, theme),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          strategy.feasibility.emoji,
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          strategy.feasibility.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getFeasibilityTextColor(strategy.feasibility, theme),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Strategy title and description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Strategy emoji
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        strategyMeta['emoji'] ?? '💡',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strategyMeta['title'] ?? 'Strategy',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strategyMeta['description'] ?? 'Save money on your home loan',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick stats
              Row(
                children: [
                  // EMI impact
                  if (strategy.newEMI != strategy.currentEMI)
                    _buildStatChip(
                      context,
                      icon: Icons.trending_down,
                      label: 'EMI Impact',
                      value: strategy.newEMI > strategy.currentEMI 
                        ? '+${(strategy.newEMI - strategy.currentEMI).toCompactFormat()}'
                        : '-${(strategy.currentEMI - strategy.newEMI).toCompactFormat()}',
                      color: strategy.newEMI > strategy.currentEMI 
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    ),
                  
                  if (strategy.newEMI != strategy.currentEMI)
                    const SizedBox(width: 8),
                  
                  // Tenure reduction
                  if (strategy.tenureReductionMonths > 0)
                    _buildStatChip(
                      context,
                      icon: Icons.schedule,
                      label: 'Time Saved',
                      value: '${(strategy.tenureReductionMonths / 12).toStringAsFixed(1)}Y',
                      color: theme.colorScheme.tertiary,
                    ),
                  
                  const Spacer(),
                  
                  // Quick win label
                  if (strategyMeta['quickWin'] != null && strategyMeta['quickWin'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        strategyMeta['quickWin'],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Action button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Calculate My Savings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getFeasibilityColor(StrategyFeasibility feasibility, ThemeData theme) {
    switch (feasibility) {
      case StrategyFeasibility.highlyRecommended:
        return theme.colorScheme.primary.withOpacity(0.15);
      case StrategyFeasibility.recommended:
        return theme.colorScheme.tertiary.withOpacity(0.15);
      case StrategyFeasibility.conditional:
        return theme.colorScheme.secondary.withOpacity(0.15);
      case StrategyFeasibility.notRecommended:
        return theme.colorScheme.error.withOpacity(0.15);
    }
  }

  Color _getFeasibilityTextColor(StrategyFeasibility feasibility, ThemeData theme) {
    switch (feasibility) {
      case StrategyFeasibility.highlyRecommended:
        return theme.colorScheme.primary;
      case StrategyFeasibility.recommended:
        return theme.colorScheme.tertiary;
      case StrategyFeasibility.conditional:
        return theme.colorScheme.secondary;
      case StrategyFeasibility.notRecommended:
        return theme.colorScheme.error;
    }
  }

  Map<String, dynamic> _getStrategyMetadata(String strategyId) {
    switch (strategyId) {
      case 'extra_emi_yearly':
        return {
          'emoji': '💰',
          'title': 'Extra EMI Strategy',
          'description': 'Pay one additional EMI every year to save massive interest',
          'quickWin': 'Quick Win',
        };
      case 'emi_step_up_5percent':
        return {
          'emoji': '📈',
          'title': '5% EMI Increase Yearly',
          'description': 'Increase your EMI by 5% every year as your income grows',
          'quickWin': 'High Impact',
        };
      case 'lump_sum_prepayment':
        return {
          'emoji': '💸',
          'title': 'Lump Sum Prepayment',
          'description': 'Use bonus, inheritance, or savings for one-time prepayment',
          'quickWin': 'Instant Impact',
        };
      case 'refinance_lower_rate':
        return {
          'emoji': '🏦',
          'title': 'Refinance at Lower Rate',
          'description': 'Switch to a bank offering lower interest rates',
          'quickWin': 'Long-term Win',
        };
      case 'emi_round_up':
        return {
          'emoji': '🎯',
          'title': 'Round-up EMI Strategy',
          'description': 'Round your EMI to the nearest ₹1,000 for effortless saving',
          'quickWin': 'Effortless',
        };
      default:
        return {
          'emoji': '💡',
          'title': 'Money-Saving Strategy',
          'description': 'Save money on your home loan',
          'quickWin': '',
        };
    }
  }
}