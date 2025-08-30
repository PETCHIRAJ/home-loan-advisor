import 'package:flutter/material.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/loan_scenario.dart';
import 'responsive_layout.dart';

/// Responsive container for scenario comparison cards with adaptive layouts
class ResponsiveScenarioCards extends StatelessWidget {
  final List<LoanScenario> scenarios;
  final LoanScenario? bestScenario;
  final Function(String)? onToggleScenario;
  final Function(LoanScenario)? onEditScenario;
  final Function(String)? onRemoveScenario;
  final ScrollPhysics? physics;

  const ResponsiveScenarioCards({
    super.key,
    required this.scenarios,
    this.bestScenario,
    this.onToggleScenario,
    this.onEditScenario,
    this.onRemoveScenario,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (scenarios.isEmpty) {
      return const Center(
        child: Text('No scenarios available'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger = constraints.maxWidth >= AppBreakpoints.tablet;
        
        if (isTabletOrLarger) {
          return _buildGridLayout(context, constraints);
        } else {
          return _buildStackedLayout(context);
        }
      },
    );
  }

  Widget _buildStackedLayout(BuildContext context) {
    return ListView.separated(
      padding: ResponsivePadding.screen(context),
      physics: physics,
      itemCount: scenarios.length,
      separatorBuilder: (context, index) => 
        const SizedBox(height: ResponsiveSpacing.md),
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return MobileScenarioCard(
          scenario: scenario,
          isBest: bestScenario?.id == scenario.id,
          onToggle: scenario.isBaseScenario 
            ? null 
            : () => onToggleScenario?.call(scenario.id),
          onEdit: () => onEditScenario?.call(scenario),
          onRemove: scenario.isBaseScenario || 
                   !scenario.id.startsWith('custom_')
            ? null
            : () => onRemoveScenario?.call(scenario.id),
        );
      },
    );
  }

  Widget _buildGridLayout(BuildContext context, BoxConstraints constraints) {
    final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
    final childAspectRatio = constraints.maxWidth > 1200 ? 0.85 : 0.75;

    return GridView.builder(
      padding: ResponsivePadding.screen(context),
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: ResponsiveSpacing.md,
        mainAxisSpacing: ResponsiveSpacing.md,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: scenarios.length,
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return TabletScenarioCard(
          scenario: scenario,
          isBest: bestScenario?.id == scenario.id,
          onToggle: scenario.isBaseScenario 
            ? null 
            : () => onToggleScenario?.call(scenario.id),
          onEdit: () => onEditScenario?.call(scenario),
          onRemove: scenario.isBaseScenario || 
                   !scenario.id.startsWith('custom_')
            ? null
            : () => onRemoveScenario?.call(scenario.id),
        );
      },
    );
  }
}

/// Mobile-optimized scenario card with stacked layout
class MobileScenarioCard extends StatelessWidget {
  final LoanScenario scenario;
  final bool isBest;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const MobileScenarioCard({
    super.key,
    required this.scenario,
    this.isBest = false,
    this.onToggle,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasResult = scenario.result != null;
    final isEnabled = scenario.isEnabled;
    
    return Card(
      elevation: isBest ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isBest 
            ? FinancialColors.savings
            : colorScheme.outline.withValues(alpha: 0.2),
          width: isBest ? 2 : 1,
        ),
      ),
      color: _getCardColor(context),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: ResponsivePadding.card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with badges and toggle
              _buildHeader(context, isEnabled),
              
              const SizedBox(height: ResponsiveSpacing.lg),
              
              // Key metrics prominently displayed
              if (hasResult && isEnabled)
                _buildMobileMetrics(context)
              else if (!hasResult && isEnabled)
                const Center(child: CircularProgressIndicator())
              else
                _buildDisabledState(context),
              
              const SizedBox(height: ResponsiveSpacing.md),
              
              // Parameters in compact format
              _buildCompactParameters(context, isEnabled),
              
              // Action buttons
              if (onEdit != null || onRemove != null) ...[
                const SizedBox(height: ResponsiveSpacing.lg),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEnabled) {
    return Row(
      children: [
        // Icon and title
        Expanded(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getScenarioIcon(),
                  color: _getIconColor(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: ResponsiveSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scenario.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isEnabled ? null : 
                                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isBest) _buildBestBadge(context),
                        if (scenario.isBaseScenario) _buildBaseBadge(context),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scenario.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isEnabled 
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Toggle switch
        if (onToggle != null) ...[
          const SizedBox(width: ResponsiveSpacing.sm),
          Switch.adaptive(
            value: isEnabled,
            onChanged: (_) => onToggle?.call(),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileMetrics(BuildContext context) {
    final result = scenario.result!;
    
    return Container(
      padding: const EdgeInsets.all(ResponsiveSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Primary metric (EMI)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly EMI',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                result.monthlyEMI.toEMIFormat(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ResponsiveSpacing.sm),
          
          // Secondary metrics row
          Row(
            children: [
              Expanded(
                child: _buildMiniMetric(
                  context, 
                  'Total Interest', 
                  '₹${(result.totalInterest / 100000).toStringAsFixed(1)}L',
                  FinancialColors.cost,
                ),
              ),
              const SizedBox(width: ResponsiveSpacing.md),
              Expanded(
                child: _buildMiniMetric(
                  context, 
                  'Total Amount', 
                  '₹${(result.totalAmount / 100000).toStringAsFixed(1)}L',
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          
          // Additional benefits if available
          if (result.taxBenefits.totalAnnualSavings > 0 || 
              result.pmayBenefit?.isEligible == true) ...[
            const SizedBox(height: ResponsiveSpacing.sm),
            Row(
              children: [
                if (result.taxBenefits.totalAnnualSavings > 0)
                  Expanded(
                    child: _buildMiniMetric(
                      context, 
                      'Tax Savings/Year', 
                      result.taxBenefits.totalAnnualSavings.toEMIFormat(),
                      FinancialColors.taxBenefit,
                    ),
                  ),
                if (result.taxBenefits.totalAnnualSavings > 0 && 
                    result.pmayBenefit?.isEligible == true)
                  const SizedBox(width: ResponsiveSpacing.md),
                if (result.pmayBenefit?.isEligible == true)
                  Expanded(
                    child: _buildMiniMetric(
                      context, 
                      'PMAY Subsidy', 
                      result.pmayBenefit!.subsidyAmount.toEMIFormat(),
                      FinancialColors.pmayBenefit,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniMetric(BuildContext context, String label, String value, Color? color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCompactParameters(BuildContext context, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(ResponsiveSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildParameterChip(
              context,
              Icons.account_balance_wallet,
              scenario.parameters.loanAmount.toIndianFormat(),
              isEnabled,
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildParameterChip(
              context,
              Icons.percent,
              '${scenario.parameters.interestRate}%',
              isEnabled,
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildParameterChip(
              context,
              Icons.schedule,
              '${scenario.parameters.tenureYears}Y',
              isEnabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterChip(BuildContext context, IconData icon, String value, bool isEnabled) {
    return Column(
      children: [
        Icon(
          icon,
          size: 14,
          color: isEnabled 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isEnabled 
              ? null
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ResponsiveSpacing.lg),
      child: Center(
        child: Text(
          'Scenario disabled',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
        if (onEdit != null && onRemove != null) 
          const SizedBox(width: ResponsiveSpacing.sm),
        if (onRemove != null) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Remove'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBestBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: FinancialColors.savings,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 10, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            'BEST',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'BASE',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  Color? _getCardColor(BuildContext context) {
    if (isBest) {
      return FinancialColors.savings.withValues(alpha: 0.03);
    }
    if (scenario.isBaseScenario) {
      return Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.05);
    }
    if (!scenario.isEnabled) {
      return Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }
    return null;
  }

  Color _getIconBackgroundColor(BuildContext context) {
    if (isBest) {
      return FinancialColors.savings.withValues(alpha: 0.2);
    }
    if (scenario.isBaseScenario) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  Color _getIconColor(BuildContext context) {
    if (isBest) {
      return FinancialColors.savings;
    }
    if (scenario.isBaseScenario) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  IconData _getScenarioIcon() {
    if (scenario.isBaseScenario) return Icons.home;
    if (scenario.name.toLowerCase().contains('sbi')) return Icons.account_balance;
    if (scenario.name.toLowerCase().contains('hdfc')) return Icons.business;
    if (scenario.name.toLowerCase().contains('icici')) return Icons.corporate_fare;
    if (scenario.name.toLowerCase().contains('prepay')) return Icons.payment;
    if (scenario.name.toLowerCase().contains('step')) return Icons.trending_up;
    return Icons.compare_arrows;
  }
}

/// Tablet-optimized scenario card with more compact grid layout
class TabletScenarioCard extends StatelessWidget {
  final LoanScenario scenario;
  final bool isBest;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const TabletScenarioCard({
    super.key,
    required this.scenario,
    this.isBest = false,
    this.onToggle,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasResult = scenario.result != null;
    final isEnabled = scenario.isEnabled;
    
    return Card(
      elevation: isBest ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isBest 
            ? FinancialColors.savings
            : colorScheme.outline.withValues(alpha: 0.2),
          width: isBest ? 2 : 1,
        ),
      ),
      color: _getCardColor(context),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(ResponsiveSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact header
              _buildCompactHeader(context, isEnabled),
              
              const SizedBox(height: ResponsiveSpacing.sm),
              
              // Key metrics
              Expanded(
                child: hasResult && isEnabled
                  ? _buildTabletMetrics(context)
                  : !hasResult && isEnabled
                    ? const Center(child: CircularProgressIndicator())
                    : _buildDisabledState(context),
              ),
              
              // Compact action bar
              if (onToggle != null || onEdit != null || onRemove != null)
                _buildCompactActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context, bool isEnabled) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scenario.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? null : 
                          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isBest || scenario.isBaseScenario) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isBest ? FinancialColors.savings : 
                               Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                scenario.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletMetrics(BuildContext context) {
    final result = scenario.result!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // EMI prominently
        Text(
          result.monthlyEMI.toEMIFormat(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          'Monthly EMI',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        
        const SizedBox(height: ResponsiveSpacing.sm),
        
        // Other metrics
        _buildMetricRow(context, 'Interest', '₹${(result.totalInterest / 100000).toStringAsFixed(1)}L'),
        if (result.taxBenefits.totalAnnualSavings > 0)
          _buildMetricRow(context, 'Tax Savings', result.taxBenefits.totalAnnualSavings.toEMIFormat()),
      ],
    );
  }

  Widget _buildMetricRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    return Center(
      child: Text(
        'Disabled',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildCompactActions(BuildContext context) {
    return Row(
      children: [
        if (onToggle != null) ...[
          Expanded(
            child: Switch.adaptive(
              value: scenario.isEnabled,
              onChanged: (_) => onToggle?.call(),
            ),
          ),
        ],
        if (onEdit != null) ...[
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 16),
            visualDensity: VisualDensity.compact,
          ),
        ],
        if (onRemove != null) ...[
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete, 
              size: 16,
              color: Theme.of(context).colorScheme.error,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ],
    );
  }

  Color? _getCardColor(BuildContext context) {
    if (isBest) {
      return FinancialColors.savings.withValues(alpha: 0.03);
    }
    if (scenario.isBaseScenario) {
      return Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.05);
    }
    if (!scenario.isEnabled) {
      return Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }
    return null;
  }
}