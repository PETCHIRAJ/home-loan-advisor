import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';

/// Progress screen for tracking loan payment progress and milestones
/// 
/// Features:
/// - Loan progress visualization
/// - Payment history overview
/// - Upcoming milestones
/// - Progress analytics and trends
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Sample data - will be replaced with actual user data
    const loanAmount = 5000000.0; // ₹50 lakhs
    const interestRate = 8.5;
    const tenureYears = 20;
    const monthsCompleted = 24; // 2 years completed
    
    final emi = LoanCalculations.calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
    );
    
    final currentBalance = LoanCalculations.calculateOutstandingBalance(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      paymentsMade: monthsCompleted,
    );
    
    final totalPaid = (loanAmount - currentBalance);
    final progressPercentage = totalPaid / loanAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Progress'),
        actions: [
          IconButton(
            onPressed: () {
              _showProgressInfo(context);
            },
            icon: const Icon(Icons.help_outline),
            tooltip: 'Progress Help',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Overview
            _buildProgressOverview(
              theme,
              progressPercentage,
              totalPaid,
              currentBalance,
              monthsCompleted,
              tenureYears,
            ),
            
            const SizedBox(height: 24),
            
            // Monthly Stats
            _buildMonthlyStats(theme, emi, monthsCompleted),
            
            const SizedBox(height: 24),
            
            // Milestones
            _buildMilestones(theme, progressPercentage),
            
            const SizedBox(height: 24),
            
            // Recent Payments
            _buildRecentPayments(theme, emi),
            
            const SizedBox(height: 24),
            
            // Achievement Section
            _buildAchievements(theme, monthsCompleted, progressPercentage),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(
    ThemeData theme,
    double progressPercentage,
    double totalPaid,
    double currentBalance,
    int monthsCompleted,
    int tenureYears,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Progress Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Circular progress indicator
            Center(
              child: SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: CircularProgressIndicator(
                        value: progressPercentage,
                        strokeWidth: 12,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(progressPercentage * 100).toStringAsFixed(1)}%',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Complete',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Paid',
                    CurrencyFormatter.formatCurrencyCompact(totalPaid),
                    Icons.check_circle,
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Remaining',
                    CurrencyFormatter.formatCurrencyCompact(currentBalance),
                    Icons.pending,
                    theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Time Elapsed',
                    '${(monthsCompleted / 12).toStringAsFixed(1)} years',
                    Icons.schedule,
                    theme.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    'Time Left',
                    CurrencyFormatter.formatTenure(tenureYears - (monthsCompleted / 12)),
                    Icons.timer,
                    theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats(ThemeData theme, double emi, int monthsCompleted) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Monthly EMI',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatCurrency(emi),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Payments Made',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$monthsCompleted',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(ThemeData theme, double progressPercentage) {
    final milestones = [
      {'percentage': 0.25, 'label': '25% Complete', 'achieved': progressPercentage >= 0.25},
      {'percentage': 0.50, 'label': '50% Complete', 'achieved': progressPercentage >= 0.50},
      {'percentage': 0.75, 'label': '75% Complete', 'achieved': progressPercentage >= 0.75},
      {'percentage': 1.0, 'label': 'Loan Free!', 'achieved': progressPercentage >= 1.0},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milestones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ...milestones.map((milestone) {
              final achieved = milestone['achieved'] as bool;
              final label = milestone['label'] as String;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      achieved ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: achieved 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.outline,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: achieved ? FontWeight.w600 : FontWeight.normal,
                          color: achieved 
                            ? theme.colorScheme.onSurface 
                            : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (achieved)
                      Icon(
                        Icons.celebration,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPayments(ThemeData theme, double emi) {
    // Mock recent payments data
    final recentPayments = List.generate(5, (index) => {
      'month': 'Month ${24 - index}',
      'amount': emi,
      'date': DateTime.now().subtract(Duration(days: 30 * index)),
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Payments',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full payment history
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            ...recentPayments.map((payment) {
              final amount = payment['amount'] as double;
              final month = payment['month'] as String;
              final date = payment['date'] as DateTime;
              
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.payment,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                ),
                title: Text(
                  month,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: theme.textTheme.labelMedium,
                ),
                trailing: Text(
                  CurrencyFormatter.formatCurrency(amount),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(ThemeData theme, int monthsCompleted, double progressPercentage) {
    final achievements = <Map<String, dynamic>>[];
    
    if (monthsCompleted >= 12) {
      achievements.add({
        'title': 'First Year Complete',
        'description': 'You\'ve successfully made 12 payments!',
        'icon': Icons.celebration,
        'color': theme.colorScheme.primary,
      });
    }
    
    if (progressPercentage >= 0.25) {
      achievements.add({
        'title': 'Quarter Way There',
        'description': '25% of your loan is now paid off',
        'icon': Icons.trending_up,
        'color': theme.colorScheme.secondary,
      });
    }
    
    if (monthsCompleted >= 24) {
      achievements.add({
        'title': 'Two Years Strong',
        'description': 'Consistent payments for 2 years',
        'icon': Icons.star,
        'color': theme.colorScheme.tertiary,
      });
    }

    if (achievements.isEmpty) {
      achievements.add({
        'title': 'Getting Started',
        'description': 'Your loan journey has begun!',
        'icon': Icons.flag,
        'color': theme.colorScheme.primary,
      });
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            ...achievements.map((achievement) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (achievement['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (achievement['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      achievement['icon'] as IconData,
                      color: achievement['color'] as Color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            achievement['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  static void _showProgressInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Progress Tracking'),
        content: const Text(
          'This screen shows your loan payment progress based on your current payment history. '
          'All calculations are estimates based on standard amortization schedules. '
          'For exact figures, please refer to your official loan statements.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}