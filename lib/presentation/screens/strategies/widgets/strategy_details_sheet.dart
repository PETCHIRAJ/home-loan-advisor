import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/money_saving_strategy.dart';
import '../../../../core/extensions/number_extensions.dart';

class StrategyDetailsSheet extends StatefulWidget {
  final PersonalizedStrategyResult strategy;

  const StrategyDetailsSheet({
    super.key,
    required this.strategy,
  });

  @override
  State<StrategyDetailsSheet> createState() => _StrategyDetailsSheetState();
}

class _StrategyDetailsSheetState extends State<StrategyDetailsSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _tabController = TabController(length: 3, vsync: this);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strategyMeta = _getStrategyMetadata(widget.strategy.strategyId);

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, MediaQuery.of(context).size.height * _slideAnimation.value),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Strategy icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            strategyMeta['emoji'] ?? '💡',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Title and feasibility
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strategyMeta['title'] ?? 'Strategy',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  widget.strategy.feasibility.emoji,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.strategy.feasibility.displayName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _getFeasibilityColor(widget.strategy.feasibility, theme),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Close button
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Savings highlight
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                        theme.colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSavingsStat(
                        context,
                        title: 'Total Savings',
                        value: widget.strategy.personalizedSavings.toIndianFormat(),
                        color: theme.colorScheme.primary,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      _buildSavingsStat(
                        context,
                        title: 'Time Saved',
                        value: '${(widget.strategy.tenureReductionMonths / 12).toStringAsFixed(1)} Years',
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: theme.colorScheme.onPrimary,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Steps'),
                      Tab(text: 'Details'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(context, strategyMeta),
                      _buildStepsTab(context, strategyMeta),
                      _buildDetailsTab(context),
                    ],
                  ),
                ),

                // Action button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        // TODO: Implement strategy activation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${strategyMeta['title']} will be activated!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.rocket_launch),
                      label: const Text('Activate This Strategy'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(BuildContext context, Map<String, dynamic> strategyMeta) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            strategyMeta['description'] ?? 'This strategy can help you save money on your home loan.',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Before vs After comparison chart
          Text(
            'Impact Comparison',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildComparisonChart(),
          ),

          const SizedBox(height: 24),

          // Key benefits
          Text(
            'Key Benefits',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._getBenefits(strategyMeta).map((benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    benefit,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 24),

          // Feasibility explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getFeasibilityColor(widget.strategy.feasibility, theme).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getFeasibilityColor(widget.strategy.feasibility, theme).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.strategy.feasibility.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Feasibility Assessment',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.strategy.feasibilityReason,
                  style: theme.textTheme.bodyMedium?.copyWith(
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

  Widget _buildStepsTab(BuildContext context, Map<String, dynamic> strategyMeta) {
    final theme = Theme.of(context);
    final steps = _getImplementationSteps(strategyMeta);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Implementation Steps',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Step content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      step,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          // Requirements section
          Text(
            'Requirements',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._getRequirements(strategyMeta).map((requirement) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.assignment_turned_in,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    requirement,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculation Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Current vs New EMI
          _buildDetailRow(context, 'Current EMI', widget.strategy.currentEMI.toEMIFormat()),
          _buildDetailRow(context, 'New EMI', widget.strategy.newEMI.toEMIFormat()),
          _buildDetailRow(
            context, 
            'EMI Difference', 
            '${widget.strategy.newEMI > widget.strategy.currentEMI ? '+' : '-'}${(widget.strategy.newEMI - widget.strategy.currentEMI).abs().toEMIFormat()}'
          ),

          const Divider(height: 32),

          // Tenure details
          _buildDetailRow(context, 'Current Tenure', '${widget.strategy.currentTenureMonths} months'),
          _buildDetailRow(context, 'New Tenure', '${widget.strategy.newTenureMonths} months'),
          _buildDetailRow(
            context, 
            'Time Saved', 
            '${widget.strategy.tenureReductionMonths} months (${(widget.strategy.tenureReductionMonths / 12).toStringAsFixed(1)} years)'
          ),

          const Divider(height: 32),

          // Savings details
          _buildDetailRow(context, 'Interest Saved', widget.strategy.totalInterestSaved.toIndianFormat()),
          _buildDetailRow(context, 'ROI on Investment', '${widget.strategy.roiOnInvestment.toStringAsFixed(2)}%'),

          const SizedBox(height: 24),

          // Additional calculation details
          if (widget.strategy.calculationDetails.isNotEmpty) ...[
            Text(
              'Additional Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.strategy.calculationDetails.entries
                    .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsStat(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: widget.strategy.currentEMI * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Current');
                  case 1:
                    return const Text('With Strategy');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: widget.strategy.currentEMI,
                color: Colors.red.shade300,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: widget.strategy.newEMI,
                color: Colors.green.shade300,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getFeasibilityColor(StrategyFeasibility feasibility, ThemeData theme) {
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
          'description': 'Pay one additional EMI every year to save massive interest. This is one of the most effective ways to reduce your loan burden without significantly impacting your monthly budget.',
        };
      case 'emi_step_up_5percent':
        return {
          'emoji': '📈',
          'title': '5% EMI Increase Yearly',
          'description': 'Increase your EMI by 5% every year as your income grows. This strategy aligns with your income growth and can dramatically reduce your loan tenure.',
        };
      case 'lump_sum_prepayment':
        return {
          'emoji': '💸',
          'title': 'Lump Sum Prepayment',
          'description': 'Use bonus, inheritance, or savings for one-time prepayment. Even a single large prepayment can save you lakhs in interest over the loan tenure.',
        };
      case 'refinance_lower_rate':
        return {
          'emoji': '🏦',
          'title': 'Refinance at Lower Rate',
          'description': 'Switch to a bank offering lower interest rates. Though it requires effort, refinancing can save you significant money over the long term.',
        };
      case 'emi_round_up':
        return {
          'emoji': '🎯',
          'title': 'Round-up EMI Strategy',
          'description': 'Round your EMI to the nearest ₹1,000 for effortless saving. This small change can make a big difference over time without straining your budget.',
        };
      default:
        return {
          'emoji': '💡',
          'title': 'Money-Saving Strategy',
          'description': 'Save money on your home loan with this effective strategy.',
        };
    }
  }

  List<String> _getBenefits(Map<String, dynamic> strategyMeta) {
    switch (widget.strategy.strategyId) {
      case 'extra_emi_yearly':
        return [
          'Save ${widget.strategy.personalizedSavings.toCompactFormat()} in total interest',
          'Reduce loan tenure by ${(widget.strategy.tenureReductionMonths / 12).toStringAsFixed(1)} years',
          'No paperwork or bank visits required',
          'Can be automated with standing instruction',
        ];
      case 'emi_step_up_5percent':
        return [
          'Save ${widget.strategy.personalizedSavings.toCompactFormat()} in total interest',
          'Reduce tenure by ${(widget.strategy.tenureReductionMonths / 12).toStringAsFixed(1)} years',
          'Matches typical salary growth pattern',
          'Builds wealth through forced saving',
        ];
      case 'lump_sum_prepayment':
        return [
          'Immediate interest savings of ${widget.strategy.personalizedSavings.toCompactFormat()}',
          'Reduce loan tenure significantly',
          'Lower monthly financial burden',
          'Psychological relief of reduced debt',
        ];
      case 'refinance_lower_rate':
        return [
          'Save ${widget.strategy.personalizedSavings.toCompactFormat()} over loan tenure',
          'Lower monthly EMI payments',
          'Better bank services and facilities',
          'Potential for additional credit facilities',
        ];
      case 'emi_round_up':
        return [
          'Save ${widget.strategy.personalizedSavings.toCompactFormat()} in total interest',
          'Reduce tenure by ${(widget.strategy.tenureReductionMonths / 12).toStringAsFixed(1)} years',
          'Effortless and automatic savings',
          'Builds disciplined saving habit',
        ];
      default:
        return [
          'Significant interest savings',
          'Reduced loan tenure',
          'Better financial management',
        ];
    }
  }

  List<String> _getImplementationSteps(Map<String, dynamic> strategyMeta) {
    switch (widget.strategy.strategyId) {
      case 'extra_emi_yearly':
        return [
          'Calculate your annual EMI amount (current EMI × 12)',
          'Set up automatic transfer for December or bonus month',
          'Instruct bank to apply extra payment towards principal reduction',
          'Track your savings annually and adjust if needed',
        ];
      case 'emi_step_up_5percent':
        return [
          'Calculate 5% increase of current EMI amount',
          'Set up annual EMI revision schedule with your bank',
          'Plan your budget to accommodate the increased EMI',
          'Monitor your income growth and adjust percentage if needed',
        ];
      case 'lump_sum_prepayment':
        return [
          'Identify the available lump sum amount for prepayment',
          'Visit bank branch or use net banking for prepayment',
          'Choose "Principal Reduction" option during payment',
          'Get updated loan schedule and savings report from bank',
        ];
      case 'refinance_lower_rate':
        return [
          'Research banks offering lower interest rates',
          'Check your eligibility and calculate processing charges',
          'Apply for loan takeover or balance transfer',
          'Complete documentation and legal formalities',
          'Close existing loan after new loan approval',
        ];
      case 'emi_round_up':
        return [
          'Round your current EMI to the nearest ₹1,000',
          'Update your EMI amount with the bank',
          'Set up auto-debit for the new rounded amount',
          'Track your additional savings annually',
        ];
      default:
        return [
          'Contact your bank for more information',
          'Review your financial situation',
          'Implement the strategy gradually',
        ];
    }
  }

  List<String> _getRequirements(Map<String, dynamic> strategyMeta) {
    switch (widget.strategy.strategyId) {
      case 'extra_emi_yearly':
        return [
          'Annual bonus or savings equivalent to 1 EMI',
          'Bank account with sufficient balance',
          'Standing instruction facility with your bank',
        ];
      case 'emi_step_up_5percent':
        return [
          'Annual income growth of 8-10% consistently',
          'Stable employment with regular increments',
          'Emergency fund equivalent to 6 months expenses',
        ];
      case 'lump_sum_prepayment':
        return [
          'Available lump sum (bonus, savings, inheritance)',
          'Maintain 6-month emergency fund after prepayment',
          'Clear any high-interest debt (credit cards) first',
        ];
      case 'refinance_lower_rate':
        return [
          'Good credit score (750+) for better rates',
          'Stable income documentation for 2+ years',
          'Existing loan with 10+ years remaining tenure',
          'Property papers and legal documents in order',
        ];
      case 'emi_round_up':
        return [
          'Monthly surplus of ₹500-2,000 in budget',
          'Auto-debit facility with your bank',
          'Stable monthly income flow',
        ];
      default:
        return [
          'Stable financial situation',
          'Understanding of loan terms',
          'Regular income source',
        ];
    }
  }
}