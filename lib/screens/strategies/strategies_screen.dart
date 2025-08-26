import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';

/// Strategies screen for loan optimization recommendations
/// 
/// Features:
/// - Popular loan optimization strategies
/// - Savings calculations for each strategy
/// - Recommendations based on user profile
/// - Strategy comparison and benefits
class StrategiesScreen extends StatelessWidget {
  const StrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Sample calculations for demonstration
    const loanAmount = 5000000.0; // ₹50 lakhs
    const interestRate = 8.5;
    const tenureYears = 20;
    const extraEMI = 5000.0; // ₹5K extra EMI
    
    final regularEMI = LoanCalculations.calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
    );
    
    final extraPaymentSavings = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      extraPrincipal: extraEMI,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Strategies'),
        actions: [
          IconButton(
            onPressed: () {
              _showStrategyInfo(context);
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'Strategy Information',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(theme),
            
            const SizedBox(height: 24),
            
            // Featured Strategy
            _buildFeaturedStrategy(
              theme,
              regularEMI,
              extraEMI,
              extraPaymentSavings,
            ),
            
            const SizedBox(height: 24),
            
            // Strategy List
            _buildStrategyList(theme),
            
            const SizedBox(height: 24),
            
            // Tips Section
            _buildTipsSection(theme),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Smart Loan Strategies',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Discover proven strategies to save lakhs on your home loan interest and become debt-free faster.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedStrategy(
    ThemeData theme,
    double regularEMI,
    double extraEMI,
    Map<String, dynamic> savings,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.secondaryContainer,
              theme.colorScheme.secondaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'RECOMMENDED',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Extra EMI Payment',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Pay just ₹${extraEMI.toStringAsFixed(0)} extra every month and save significantly on interest.',
                style: theme.textTheme.bodyLarge,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildSavingMetric(
                      theme,
                      'Interest Saved',
                      CurrencyFormatter.formatCurrencyCompact(
                        savings['interestSaved'] ?? 0.0,
                      ),
                      Icons.savings,
                      theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSavingMetric(
                      theme,
                      'Time Saved',
                      CurrencyFormatter.formatTenure(
                        savings['timeSaved'] ?? 0.0,
                      ),
                      Icons.schedule,
                      theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Navigate to strategy details
                  },
                  child: const Text('Learn More'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingMetric(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyList(ThemeData theme) {
    final strategies = [
      {
        'title': 'Prepayment Strategy',
        'subtitle': 'Make lump sum payments when you have extra funds',
        'icon': Icons.payment,
        'benefit': 'Save ₹3-5L in interest',
        'difficulty': 'Medium',
      },
      {
        'title': 'Step-up EMI',
        'subtitle': 'Increase EMI by 10% annually with salary hikes',
        'icon': Icons.trending_up,
        'benefit': 'Save ₹6-8L in interest',
        'difficulty': 'Easy',
      },
      {
        'title': 'Loan Switching',
        'subtitle': 'Switch to lower interest rate when available',
        'icon': Icons.swap_horiz,
        'benefit': 'Save ₹2-4L in interest',
        'difficulty': 'Medium',
      },
      {
        'title': 'Bi-weekly Payments',
        'subtitle': 'Pay half EMI every 2 weeks instead of monthly',
        'icon': Icons.calendar_view_week,
        'benefit': 'Save ₹4-6L in interest',
        'difficulty': 'Hard',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Strategies',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        ...strategies.map((strategy) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                strategy['icon'] as IconData,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              strategy['title'] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(strategy['subtitle'] as String),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(
                          strategy['difficulty'] as String,
                          theme,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        strategy['difficulty'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getDifficultyColor(
                            strategy['difficulty'] as String,
                            theme,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      strategy['benefit'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to strategy detail
            },
          ),
        )).toList(),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty, ThemeData theme) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return theme.colorScheme.primary;
      case 'medium':
        return theme.colorScheme.secondary;
      case 'hard':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  Widget _buildTipsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pro Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            _buildTip(
              theme,
              'Start with small extra payments and increase gradually',
              Icons.trending_up,
            ),
            
            const SizedBox(height: 8),
            
            _buildTip(
              theme,
              'Use annual bonuses and tax refunds for prepayments',
              Icons.card_giftcard,
            ),
            
            const SizedBox(height: 8),
            
            _buildTip(
              theme,
              'Review and compare interest rates annually',
              Icons.rate_review,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(ThemeData theme, String tip, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  static void _showStrategyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Loan Strategies'),
        content: const Text(
          'These strategies are based on mathematical calculations and general financial principles. '
          'Always consult with a financial advisor before making major financial decisions. '
          'Actual savings may vary based on your specific loan terms and financial situation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}