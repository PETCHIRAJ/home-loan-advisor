import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/loan_data.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/daily_burn_counter.dart';
import '../widgets/loan_health_score.dart';
import '../widgets/quick_action_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample data - in real app, this would come from state management
  final LoanData sampleLoan = LoanData(
    loanAmount: 5000000, // 50 lakhs
    interestRate: 8.5,
    tenureYears: 20,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning! 🌅',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppTheme.outline,
                      ),
                    ),
                    const Text(
                      'Your Loan Dashboard',
                      style: AppTextStyles.titleLarge,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => _showNotifications(),
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  IconButton(
                    onPressed: () => _showSettings(),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),

              // Main Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Daily Interest Burn Counter - Hero Element
                    DailyBurnCounter(
                      dailyBurn: sampleLoan.dailyInterestBurn,
                      onTap: () => _showInterestBreakdown(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Loan Health Score
                    LoanHealthScore(
                      score: _calculateHealthScore(),
                      onTap: () => _showHealthDetails(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions Row
                    _buildQuickActions(),
                    
                    const SizedBox(height: 24),
                    
                    // Key Metrics Grid
                    _buildMetricsGrid(),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Achievements
                    _buildRecentAchievements(),
                    
                    const SizedBox(height: 24),
                    
                    // Strategy Recommendations
                    _buildStrategyRecommendations(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openQuickCalculator(),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calculate),
        label: const Text('Quick Calc'),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              QuickActionButton(
                icon: Icons.payment,
                label: 'Bi-Weekly',
                subtitle: 'Save ${sampleLoan.biWeeklySavings.toIndianCurrencyCompact}',
                color: AppTheme.successGreen,
                onTap: () => _navigateToStrategy('bi-weekly'),
              ),
              const SizedBox(width: 12),
              QuickActionButton(
                icon: Icons.add_circle,
                label: 'Extra EMI',
                subtitle: 'Save ${sampleLoan.extraEMISavings.toIndianCurrencyCompact}',
                color: AppTheme.secondaryTeal,
                onTap: () => _navigateToStrategy('extra-emi'),
              ),
              const SizedBox(width: 12),
              QuickActionButton(
                icon: Icons.trending_up,
                label: 'Round Up',
                subtitle: 'Save ${sampleLoan.roundUpSavings.toIndianCurrencyCompact}',
                color: AppTheme.warningOrange,
                onTap: () => _navigateToStrategy('round-up'),
              ),
              const SizedBox(width: 12),
              QuickActionButton(
                icon: Icons.insights,
                label: '78% Rule',
                subtitle: 'Eye Opener',
                color: AppTheme.errorRed,
                onTap: () => _navigateToInsight('78-rule'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Loan at a Glance',
              style: AppTextStyles.titleLarge,
            ),
            TextButton(
              onPressed: () => _showAllMetrics(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            DashboardCard(
              title: 'Monthly EMI',
              value: sampleLoan.monthlyEMI.toIndianCurrency,
              subtitle: 'Current payment',
              icon: Icons.payment,
              color: AppTheme.primaryBlue,
              onTap: () => _showEMIBreakdown(),
            ),
            DashboardCard(
              title: 'Total Interest',
              value: sampleLoan.totalInterest.toIndianCurrencyCompact,
              subtitle: 'Over ${sampleLoan.tenureYears} years',
              icon: Icons.trending_up,
              color: AppTheme.errorRed,
              onTap: () => _showInterestBreakdown(),
            ),
            DashboardCard(
              title: 'Break-Even',
              value: '${sampleLoan.breakEvenMonth} months',
              subtitle: 'When you own more',
              icon: Icons.balance,
              color: AppTheme.secondaryTeal,
              onTap: () => _showBreakEvenDetails(),
            ),
            DashboardCard(
              title: 'Potential Savings',
              value: sampleLoan.biWeeklySavings.toIndianCurrencyCompact,
              subtitle: 'With optimization',
              icon: Icons.savings,
              color: AppTheme.successGreen,
              onTap: () => _showSavingsBreakdown(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Achievements 🏆',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.goldAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: AppTheme.goldAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'First Calculation Complete!',
                      style: AppTextStyles.labelLarge,
                    ),
                    Text(
                      'You discovered ₹2.1L in potential savings',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrategyRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended for You',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.successGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Smart Tip: Coffee Money Challenge',
                      style: AppTextStyles.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Skip that ₹50 coffee daily and add it to EMI. You\'ll save ₹4.2L over your loan tenure!',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppTheme.outline,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToStrategy('coffee-converter'),
                    child: const Text('Try This Strategy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateHealthScore() {
    // Simplified health score calculation
    double score = 70; // Base score
    
    // Adjust based on interest rate
    if (sampleLoan.interestRate < 8.0) score += 15;
    else if (sampleLoan.interestRate > 9.0) score -= 10;
    
    // Adjust based on tenure
    if (sampleLoan.tenureYears < 15) score += 10;
    else if (sampleLoan.tenureYears > 25) score -= 10;
    
    return score.clamp(0, 100);
  }

  // Navigation methods
  void _showNotifications() {
    // Show notifications bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_outlined, size: 48),
            SizedBox(height: 16),
            Text('No new notifications'),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    // Navigate to settings
  }

  void _showInterestBreakdown() {
    // Show detailed interest breakdown
  }

  void _showHealthDetails() {
    // Show loan health score details
  }

  void _openQuickCalculator() {
    // Open quick calculator modal/screen
    HapticFeedback.mediumImpact();
  }

  void _navigateToStrategy(String strategy) {
    // Navigate to specific strategy screen
    HapticFeedback.lightImpact();
  }

  void _navigateToInsight(String insight) {
    // Navigate to specific insight screen
    HapticFeedback.lightImpact();
  }

  void _showAllMetrics() {
    // Show all metrics screen
  }

  void _showEMIBreakdown() {
    // Show EMI breakdown
  }

  void _showBreakEvenDetails() {
    // Show break-even details
  }

  void _showSavingsBreakdown() {
    // Show savings breakdown
  }
}