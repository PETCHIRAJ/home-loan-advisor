import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/calculation_history.dart';

class HistoryStatsCard extends StatelessWidget {
  final HistoryStats stats;

  const HistoryStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (stats.totalCalculations == 0) {
      return _buildEmptyStats(context);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview card
          Card(
            elevation: 0,
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your EMI Journey',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You have calculated ${stats.totalCalculations} EMI scenarios and saved potential ₹${_formatCurrency(stats.totalPotentialSavings)} in tax benefits annually.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Statistics grid
          _buildStatsGrid(context),

          const SizedBox(height: 20),

          // Timeline card
          if (stats.firstCalculationDate != null && stats.lastCalculationDate != null)
            _buildTimelineCard(context),
        ],
      ),
    );
  }

  Widget _buildEmptyStats(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No Statistics Available',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start calculating EMIs to see your statistics and insights.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          context,
          'Total Calculations',
          stats.totalCalculations.toString(),
          Icons.calculate,
          Theme.of(context).colorScheme.primaryContainer,
        ),
        _buildStatCard(
          context,
          'Bookmarked',
          stats.bookmarkedCount.toString(),
          Icons.bookmark,
          Theme.of(context).colorScheme.secondaryContainer,
        ),
        _buildStatCard(
          context,
          'Avg Loan Amount',
          '₹${_formatCurrency(stats.averageLoanAmount)}',
          Icons.account_balance,
          Theme.of(context).colorScheme.tertiaryContainer,
        ),
        _buildStatCard(
          context,
          'Avg Interest Rate',
          '${stats.averageInterestRate.toStringAsFixed(2)}%',
          Icons.percent,
          Theme.of(context).colorScheme.errorContainer,
        ),
        _buildStatCard(
          context,
          'Common Tenure',
          '${stats.mostCommonTenure} years',
          Icons.schedule,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        _buildStatCard(
          context,
          'Tax Savings/Year',
          '₹${_formatCurrency(stats.totalPotentialSavings)}',
          Icons.savings,
          Colors.green.withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color backgroundColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final firstDate = stats.firstCalculationDate!;
    final lastDate = stats.lastCalculationDate!;
    final daysBetween = lastDate.difference(firstDate).inDays;
    final monthsBetween = (daysBetween / 30).round();

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.timeline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Journey Timeline',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Timeline items
            _buildTimelineItem(
              context,
              'First Calculation',
              DateFormat('MMM dd, yyyy').format(firstDate),
              Icons.start,
              true,
            ),
            
            if (daysBetween > 0) ...[
              const SizedBox(height: 12),
              _buildTimelineItem(
                context,
                'Latest Calculation',
                DateFormat('MMM dd, yyyy').format(lastDate),
                Icons.event,
                false,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.insights,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        monthsBetween > 0
                            ? 'Active for $monthsBetween months'
                            : daysBetween > 0
                                ? 'Active for $daysBetween days'
                                : 'Started today',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String date,
    IconData icon,
    bool isFirst,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isFirst 
                ? colorScheme.primaryContainer 
                : colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isFirst 
                ? colorScheme.onPrimaryContainer 
                : colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) { // 1 crore
      return '${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) { // 1 lakh
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) { // 1 thousand
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}