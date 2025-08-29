import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';
import '../../providers/loan_provider.dart';
import '../../widgets/charts/loan_composition_chart.dart';
import '../../widgets/common/unified_header.dart';

/// Dashboard screen with daily interest burn counter and loan overview
/// 
/// Features:
/// - Daily Interest Burn Counter (hero feature)
/// - Current loan health summary
/// - Quick insights and key metrics
/// - Progress indicators and visual feedback
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _burnController;
  late Animation<double> _burnAnimation;
  
  // Chart toggle state
  bool _showCompositionChart = true;
  
  // Sample progress data - in real app this would come from payment history
  final int _monthsCompleted = 24; // 2 years completed

  @override
  void initState() {
    super.initState();
    _burnController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _burnAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _burnController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation when screen loads
    _burnController.forward();
  }

  @override
  void dispose() {
    _burnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loanAsync = ref.watch(loanNotifierProvider);
    
    return loanAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: const UnifiedHeader(
          title: 'Dashboard',
          showLoanSummary: false,
          showBackButton: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading loan data',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (loan) => _buildDashboardContent(context, theme, loan),
    );
  }
  
  Widget _buildDashboardContent(BuildContext context, ThemeData theme, loan) {
    final emi = LoanCalculations.calculateEMI(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
    );
    
    final currentBalance = LoanCalculations.calculateOutstandingBalance(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      paymentsMade: _monthsCompleted,
    );
    
    final dailyInterest = (currentBalance * loan.annualInterestRate / 100) / 365;
    final totalInterest = LoanCalculations.calculateTotalInterest(
      loanAmount: loan.loanAmount,
      monthlyEMI: emi,
      tenureYears: loan.tenureYears,
    );
    
    final progressPercentage = ((loan.loanAmount - currentBalance) / loan.loanAmount);

    return Scaffold(
      appBar: const UnifiedHeader(
        title: 'Dashboard',
        showLoanSummary: true,
        showBackButton: false,
        currentTabIndex: 0, // Dashboard is at index 0
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate data refresh
          await Future.delayed(const Duration(seconds: 1));
          _burnController.reset();
          _burnController.forward();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // Remove padding since cards have their own margins
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Interest Burn Counter (Hero Feature)
              _buildDailyBurnCounter(
                theme,
                dailyInterest,
                _burnAnimation,
              ),
              
              const SizedBox(height: 24),
              
              // Loan Composition Chart or Progress Summary
              _buildChartSection(theme, loan),
              
              const SizedBox(height: 24),
              
              // Loan Health Summary
              _buildLoanHealthSummaryOriginal(
                theme,
                currentBalance,
                loan.loanAmount,
                progressPercentage,
                _monthsCompleted,
                loan.tenureYears,
              ),
              
              const SizedBox(height: 24),
              
              // Quick Insights
              _buildQuickInsightsOriginal(
                theme,
                emi,
                totalInterest,
                dailyInterest,
              ),
              
              const SizedBox(height: 24),
              
              // Action Cards
              _buildActionCards(theme),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Remove FAB to match mockup exactly
    );
  }

  // LIVE MONEY BURN COUNTER - Exact HTML mockup match
  Widget _buildLiveBurnCounter(
    ThemeData theme,
    double dailyInterest,
    Animation<double> animation,
  ) {
    final monthlyBurn = dailyInterest * 30;
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD32F2F), // --error-red
              Color(0xFFFF5722), // Complementary red
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Header with lightning emoji
              Text(
                '⚡ LIVE MONEY BURN COUNTER ⚡',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Animated burn amount - EXACT ₹696 from mockup
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Text(
                    '₹696', // Exact amount from mockup
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'LOST TODAY',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '₹20,880 this month',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action button
              ElevatedButton(
                onPressed: () {
                  // Show breakdown
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'View Breakdown',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Loan Health Score - Exact HTML mockup match
  Widget _buildLoanHealthScore(
    ThemeData theme,
    double currentBalance,
    double originalAmount,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with home icon
            Row(
              children: [
                const Text('🏠', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  'YOUR LOAN HEALTH SCORE',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Health score display - EXACT 5.0/10 from mockup
            Row(
              children: [
                Text(
                  '5.0/10',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: const Color(0xFFFF8F00), // --warning-orange
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(width: 24),
                
                // Dot progress indicators
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 10 dots showing 5 filled
                      Row(
                        children: List.generate(10, (index) => Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < 5 
                              ? const Color(0xFFFF8F00) // --warning-orange
                              : const Color(0xFFE0E0E0), // --divider
                            boxShadow: index < 5 ? [
                              BoxShadow(
                                color: const Color(0xFFFF8F00).withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ] : null,
                          ),
                        )),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Poor - Significant room for improvement',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF757575), // --text-secondary
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action button
            ElevatedButton(
              onPressed: () {
                // Navigate to improvement suggestions
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8F00), // --warning-orange
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text(
                'See How to Improve',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Today's Money-Saving Tip - Exact HTML mockup match
  Widget _buildMoneySavingTip(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with lightbulb
            Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  'TODAY\'S MONEY-SAVING TIP',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tip content with gradient background
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF388E3C), // --success-green
                    Color(0xFF66BB6A), // Lighter green
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Round up your EMI to ₹26,000',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Save ₹2,47,000 over loan life • Works offline',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Calculate impact
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: const Color(0xFF388E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Calculate Impact',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Dismiss tip
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Dismiss',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Quick Insights - Exact HTML mockup match
  Widget _buildQuickInsightsExact(
    ThemeData theme,
    double emi,
    double totalInterest,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with chart icon
            Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  'QUICK INSIGHTS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Three exact insights from mockup
            Column(
              children: [
                _buildInsightItemExact(
                  theme,
                  '💳', // Credit card icon
                  'Your Monthly EMI',
                  '₹26,085',
                ),
                
                const SizedBox(height: 16),
                
                _buildInsightItemExact(
                  theme,
                  '💰', // Money bag icon
                  'Total Interest You\'ll Pay',
                  '₹32.6L',
                ),
                
                const SizedBox(height: 16),
                
                _buildInsightItemExact(
                  theme,
                  '🎯', // Target icon
                  'Break-even Point',
                  'Year 12',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // CTA Button - Exact from mockup
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to strategies
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0), // --primary-blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: 2,
                ),
                child: Text(
                  'Explore Money-Saving Strategies →',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper for insight items
  Widget _buildInsightItemExact(
    ThemeData theme,
    String emoji,
    String label,
    String value,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // --surface-variant
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF1565C0), // --primary-blue
            width: 3,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Label
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF757575), // --text-secondary
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
              // Value
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF212121), // --text-primary
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyBurnCounter(
    ThemeData theme,
    double dailyInterest,
    Animation<double> animation,
  ) {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.errorContainer,
              theme.colorScheme.errorContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: theme.colorScheme.error,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Daily Interest Burn',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Text(
                    CurrencyFormatter.formatCurrency(
                      dailyInterest * animation.value,
                    ),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'burns away every day',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Visual burn animation
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: animation.value,
                    backgroundColor: theme.colorScheme.onErrorContainer.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.error,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'That\'s ${CurrencyFormatter.formatCurrencyCompact(dailyInterest * 365)}/year in interest!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Keep original methods for backward compatibility but rename
  Widget _buildLoanHealthSummaryOriginal(
    ThemeData theme,
    double currentBalance,
    double originalAmount,
    double progressPercentage,
    int monthsCompleted,
    int tenureYears,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Health Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress indicator
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Progress',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '${(progressPercentage * 100).toStringAsFixed(1)}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Key metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    theme,
                    'Outstanding',
                    CurrencyFormatter.formatCurrencyCompact(currentBalance),
                    Icons.account_balance,
                    theme.colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    theme,
                    'Paid',
                    CurrencyFormatter.formatCurrencyCompact(originalAmount - currentBalance),
                    Icons.check_circle,
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    theme,
                    'Time Completed',
                    '${(monthsCompleted / 12).toStringAsFixed(1)} years',
                    Icons.schedule,
                    theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    theme,
                    'Remaining',
                    CurrencyFormatter.formatTenure(tenureYears - (monthsCompleted / 12)),
                    Icons.timer,
                    theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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

  Widget _buildQuickInsightsOriginal(
    ThemeData theme,
    double emi,
    double totalInterest,
    double dailyInterest,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Insights',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildInsightRow(
              theme,
              'Monthly EMI',
              CurrencyFormatter.formatEMI(emi),
              Icons.payment,
            ),
            
            const SizedBox(height: 12),
            
            _buildInsightRow(
              theme,
              'Total Interest',
              CurrencyFormatter.formatCurrencyCompact(totalInterest),
              Icons.trending_up,
            ),
            
            const SizedBox(height: 12),
            
            _buildInsightRow(
              theme,
              'Weekly Interest',
              CurrencyFormatter.formatCurrencyCompact(dailyInterest * 7),
              Icons.calendar_view_week,
            ),
            
            const SizedBox(height: 12),
            
            _buildInsightRow(
              theme,
              'Monthly Interest',
              CurrencyFormatter.formatCurrencyCompact(dailyInterest * 30),
              Icons.calendar_month,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(ThemeData theme, loan) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Chart toggle header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showCompositionChart ? 'Loan Breakdown' : 'Progress Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showCompositionChart = !_showCompositionChart;
                        });
                      },
                      icon: Icon(
                        _showCompositionChart 
                            ? Icons.bar_chart 
                            : Icons.pie_chart,
                      ),
                      tooltip: _showCompositionChart 
                          ? 'Switch to Progress View' 
                          : 'Switch to Composition View',
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Chart content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showCompositionChart
                  ? const LoanCompositionChart(
                      key: ValueKey('composition'),
                      height: 180, // Further reduced for better fit
                      showLegend: true,
                      showEducationalLabels: false, // Hide labels in dashboard
                    )
                  : _buildProgressVisualization(theme, loan),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressVisualization(ThemeData theme, loan) {
    // Calculate progress data
    final emi = LoanCalculations.calculateEMI(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
    );
    final totalAmount = emi * loan.tenureYears * 12;
    final paidSoFar = (emi * _monthsCompleted);
    final progressPercentage = (paidSoFar / totalAmount).clamp(0.0, 1.0);
    
    return SizedBox(
      key: const ValueKey('progress'),
      height: 280,
      child: Column(
        children: [
          // Circular progress indicator
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  children: [
                    // Background circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 12,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: progressPercentage,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Center content
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
                            'Completed',
                            style: theme.textTheme.bodySmall?.copyWith(
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
          ),
          
          const SizedBox(height: 20),
          
          // Progress details
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Paid',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        CurrencyFormatter.formatCurrencyCompact(paidSoFar),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remaining',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        CurrencyFormatter.formatCurrencyCompact(totalAmount - paidSoFar),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to calculator using the same method as header
                      try {
                        final mainNavState = context.findAncestorStateOfType<State<StatefulWidget>>();
                        if (mainNavState != null) {
                          final dynamic state = mainNavState;
                          if (state.navigateToTab != null) {
                            state.navigateToTab(3); // Navigate to Calculator tab
                          }
                        }
                      } catch (e) {
                        // Fallback
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please go to the Calculator tab')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.calculate_outlined,
                              size: 32,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Calculator',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recalculate EMI',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to strategies
                      try {
                        final mainNavState = context.findAncestorStateOfType<State<StatefulWidget>>();
                        if (mainNavState != null) {
                          final dynamic state = mainNavState;
                          if (state.navigateToTab != null) {
                            state.navigateToTab(1); // Navigate to Strategies tab
                          }
                        }
                      } catch (e) {
                        // Fallback
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please go to the Strategies tab')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline,
                              size: 32,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Strategies',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Save money',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}