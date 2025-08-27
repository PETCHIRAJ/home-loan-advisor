import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';
import '../../providers/loan_provider.dart';
import '../../widgets/charts/loan_composition_chart.dart';
import '../../widgets/charts/test_chart.dart';

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
        appBar: AppBar(title: const Text('Dashboard')),
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
              
              // Loan Composition Chart or Progress Summary
              _buildChartSection(theme, loan),
              
              const SizedBox(height: 24),
              
              // Loan Health Summary
              _buildLoanHealthSummary(
                theme,
                currentBalance,
                loan.loanAmount,
                progressPercentage,
                _monthsCompleted,
                loan.tenureYears,
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
                      height: 280,
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
    
    return Container(
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
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.surfaceVariant,
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