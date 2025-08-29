import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/loan_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/unified_header.dart';

/// Progress screen with dual-mode display
///
/// Features:
/// - Planning Phase mode: Down payment savings tracker
/// - Loan Active mode: Progress tracking with achievements
/// - Matches progress.html mockup exactly
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _countUpController;
  late Animation<double> _countUpAnimation;

  @override
  void initState() {
    super.initState();

    // Progress bar animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    // Count up animation for amounts
    _countUpController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _countUpAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOut,
    ));

    // Start animations
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressController.forward();
      _countUpController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _countUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final loanAsync = ref.watch(loanNotifierProvider);
        final settingsAsync = ref.watch(settingsNotifierProvider);

        return loanAsync.when(
          data: (loan) => settingsAsync.when(
            data: (settings) => _buildContent(context, ref, loan, settings),
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Scaffold(
              body: Center(child: Text('Error loading settings: $error')),
            ),
          ),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error loading loan: $error')),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, dynamic loan,
      dynamic settings) {
    // Determine if loan is in planning phase or active
    final isLoanActive = settings.isLoanTaken;
    final monthsPaid = settings.monthsAlreadyPaid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const UnifiedHeader(
        title: 'Progress',
        showLoanSummary: true,
        showBackButton: false,
        currentTabIndex: 2, // Progress is at index 2
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status indicator
              _buildStatusIndicator(isLoanActive, monthsPaid),

              const SizedBox(height: 16),

              // Content based on mode
              if (isLoanActive)
                ..._buildLoanActiveContent(ref)
              else
                ..._buildPlanningContent(ref),

              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }


  // Status Indicator
  Widget _buildStatusIndicator(bool isLoanActive, int monthsPaid) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📊',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Text(
            isLoanActive
                ? 'Showing: Loan Active ($monthsPaid months paid)'
                : 'Showing: Planning Phase',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(Change in Calculator)',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Planning Phase Content
  List<Widget> _buildPlanningContent(WidgetRef ref) {
    return [
      // Preparation Progress
      _buildPreparationProgress(),
      const SizedBox(height: 24),
      // Loan Readiness Checklist
      _buildReadinessChecklist(),
    ];
  }

  // Loan Active Content
  List<Widget> _buildLoanActiveContent(WidgetRef ref) {
    return [
      // Current Progress
      _buildCurrentProgress(ref),
      const SizedBox(height: 24),
      // Achievements
      _buildAchievementsSection(),
      const SizedBox(height: 24),
      // Strategy Adoption
      _buildStrategyAdoption(ref),
      const SizedBox(height: 24),
      // Personalized Insights
      _buildPersonalizedInsights(),
    ];
  }

  Widget _buildPreparationProgress() {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '🎯',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'PREPARATION PROGRESS',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Hero amount
            AnimatedBuilder(
              animation: _countUpAnimation,
              builder: (context, child) {
                const targetAmount = 375000;
                final currentAmount =
                    (targetAmount * _countUpAnimation.value).toInt();

                return Column(
                  children: [
                    Text(
                      CurrencyFormatter.formatCurrency(
                          currentAmount.toDouble()),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.financialColors.savingsGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Down Payment Saved',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Progress bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final progress = 0.75 * _progressAnimation.value;

                return Column(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.financialColors.savingsGreen,
                                      theme.financialColors.loanHealthGood,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(75 * _progressAnimation.value).toInt()}% to goal',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.financialColors.savingsGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Metrics
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '₹1,25,000',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.financialColors.warningAmber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Still to Save',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '8 months',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.financialColors.savingsGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time to Goal',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadinessChecklist() {
    final theme = Theme.of(context);
    final checklistItems = [
      {
        'title': 'Credit Score Check',
        'status': 'Excellent (780+)',
        'state': 'completed',
        'icon': '✅',
      },
      {
        'title': 'Income Documentation',
        'status': 'Ready',
        'state': 'completed',
        'icon': '✅',
      },
      {
        'title': 'Property Shortlisting',
        'status': '3 properties identified',
        'state': 'in-progress',
        'icon': '⏳',
      },
      {
        'title': 'Rate Comparison',
        'status': 'Not started',
        'state': 'pending',
        'icon': '⭕',
      },
    ];

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '📋',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'LOAN READINESS CHECKLIST',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Checklist items
            ...checklistItems.map((item) => _buildChecklistItem(
                  item['icon'] as String,
                  item['title'] as String,
                  item['status'] as String,
                  item['state'] as String,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(
      String icon, String title, String status, String state) {
    final theme = Theme.of(context);
    Color bgColor;
    Color borderColor;

    switch (state) {
      case 'completed':
        bgColor = theme.financialColors.savingsGreen.withOpacity(0.1);
        borderColor = theme.financialColors.savingsGreen;
        break;
      case 'in-progress':
        bgColor = theme.financialColors.warningAmber.withOpacity(0.1);
        borderColor = theme.financialColors.warningAmber;
        break;
      default:
        bgColor = theme.colorScheme.outline.withOpacity(0.1);
        borderColor = theme.colorScheme.outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
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
      {
        'percentage': 0.25,
        'label': '25% Complete',
        'achieved': progressPercentage >= 0.25
      },
      {
        'percentage': 0.50,
        'label': '50% Complete',
        'achieved': progressPercentage >= 0.50
      },
      {
        'percentage': 0.75,
        'label': '75% Complete',
        'achieved': progressPercentage >= 0.75
      },
      {
        'percentage': 1.0,
        'label': 'Loan Free!',
        'achieved': progressPercentage >= 1.0
      },
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
                      achieved
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
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
                          fontWeight:
                              achieved ? FontWeight.w600 : FontWeight.normal,
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPayments(ThemeData theme, double emi) {
    // Mock recent payments data
    final recentPayments = List.generate(
        5,
        (index) => {
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(
      ThemeData theme, int monthsCompleted, double progressPercentage) {
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentProgress(WidgetRef ref) {
    // This method will be called from _buildContent which has access to loan
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '🎯',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'CURRENT PROGRESS',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Hero amount with animation
            AnimatedBuilder(
              animation: _countUpAnimation,
              builder: (context, child) {
                const targetAmount = 247350;
                final currentAmount =
                    (targetAmount * _countUpAnimation.value).toInt();

                return Column(
                  children: [
                    Text(
                      CurrencyFormatter.formatCurrency(
                          currentAmount.toDouble()),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.financialColors.savingsGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Money Saved So Far',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Progress bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final progress = 0.45 * _progressAnimation.value;

                return Column(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.financialColors.savingsGreen,
                                      theme.financialColors.loanHealthGood,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(45 * _progressAnimation.value).toInt()}% to first goal',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.financialColors.savingsGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Metrics
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '1.2 years',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.financialColors.warningAmber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time Reduced',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '₹1,89,420',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.financialColors.savingsGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Interest Saved',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '🏆',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'ACHIEVEMENTS UNLOCKED',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Achievement badges grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAchievementBadge('🥉', 'First Round-Up', true),
                _buildAchievementBadge('🥈', 'Bi-Weekly', true),
                _buildAchievementBadge('🏅', 'Smart Saver', true),
                _buildAchievementBadge('🎖️', '6mo Saver', true),
              ],
            ),

            const SizedBox(height: 16),

            // Next achievement
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.financialColors.loanHealthGood,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Next: 🏆 Prepayment Pro',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Make one prepayment to unlock',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String icon, String name, bool unlocked) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: unlocked
            ? LinearGradient(
                colors: [
                  theme.financialColors.achievementGold,
                  const Color(0xFFFFA726),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: unlocked ? null : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: theme.financialColors.achievementGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: unlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyAdoption(WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '📊',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'STRATEGY ADOPTION',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Strategy items
            _buildStrategyItem('✅', 'Bi-Weekly Payments', 'Active', 'active'),
            _buildStrategyItem('✅', 'Round-Up to ₹45K', 'Active', 'active'),
            _buildStrategyItem('⏸️', 'Extra EMI', 'Paused', 'paused'),
            _buildStrategyItem('❌', 'Prepayment', 'Not Started', 'not-started'),

            const SizedBox(height: 16),

            // Activate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to strategies
                  DefaultTabController.of(context).animateTo(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Activate New Strategy',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyItem(
      String icon, String name, String status, String state) {
    final theme = Theme.of(context);
    Color bgColor;
    Color borderColor;

    switch (state) {
      case 'active':
        bgColor = theme.financialColors.savingsGreen.withOpacity(0.1);
        borderColor = theme.financialColors.savingsGreen;
        break;
      case 'paused':
        bgColor = theme.financialColors.warningAmber.withOpacity(0.1);
        borderColor = theme.financialColors.warningAmber;
        break;
      default:
        bgColor = theme.colorScheme.outline.withOpacity(0.1);
        borderColor = theme.colorScheme.outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  status,
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
  }

  Widget _buildPersonalizedInsights() {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Text(
                  '💡',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  'PERSONALIZED INSIGHTS',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Insights content with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.financialColors.loanHealthGood,
                    const Color(0xFF4DB6AC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'This month you\'re on track to save ₹18,450 more than before!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Metrics
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '8.2/10',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Consistency Score',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '78%',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Goal Achievement',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Share achievement
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.9),
                            foregroundColor: theme.financialColors.loanHealthGood,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Share Achievement'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Set goals
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onPrimary,
                            side: BorderSide(
                              color: theme.colorScheme.onPrimary.withOpacity(0.3),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Set Goals'),
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
}
