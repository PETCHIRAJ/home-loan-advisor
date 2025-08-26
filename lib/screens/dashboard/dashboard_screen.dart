import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';

/// Dashboard screen with daily interest burn counter and loan overview
/// 
/// Features:
/// - Daily Interest Burn Counter (hero feature)
/// - Current loan health summary
/// - Quick insights and key metrics
/// - Progress indicators and visual feedback
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _burnController;
  late Animation<double> _burnAnimation;
  
  // Sample loan data - will be replaced with actual data management
  final double _loanAmount = 5000000; // ₹50 lakhs
  final double _interestRate = 8.5;
  final int _tenureYears = 20;
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
    final emi = LoanCalculations.calculateEMI(
      loanAmount: _loanAmount,
      annualInterestRate: _interestRate,
      tenureYears: _tenureYears,
    );
    
    final currentBalance = LoanCalculations.calculateOutstandingBalance(
      loanAmount: _loanAmount,
      annualInterestRate: _interestRate,
      tenureYears: _tenureYears,
      paymentsMade: _monthsCompleted,
    );
    
    final dailyInterest = (currentBalance * _interestRate / 100) / 365;
    final totalInterest = LoanCalculations.calculateTotalInterest(
      loanAmount: _loanAmount,
      monthlyEMI: emi,
      tenureYears: _tenureYears,
    );
    
    final progressPercentage = ((_loanAmount - currentBalance) / _loanAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              // Reset and replay animation
              _burnController.reset();
              _burnController.forward();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
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
          padding: const EdgeInsets.all(16),
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
              
              // Loan Health Summary
              _buildLoanHealthSummary(
                theme,
                currentBalance,
                _loanAmount,
                progressPercentage,
                _monthsCompleted,
                _tenureYears,
              ),
              
              const SizedBox(height: 24),
              
              // Quick Insights
              _buildQuickInsights(
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

  Widget _buildLoanHealthSummary(
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
                        backgroundColor: theme.colorScheme.surfaceVariant,
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

  Widget _buildQuickInsights(
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

  Widget _buildActionCards(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () {
                    // Navigate to calculator
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calculate,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Calculate\nNew EMI',
                          style: theme.textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () {
                    // Navigate to strategies
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: 32,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'View\nStrategies',
                          style: theme.textTheme.labelLarge,
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
    );
  }
}