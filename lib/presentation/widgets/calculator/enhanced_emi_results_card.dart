import 'package:flutter/material.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';
import 'visualizations/overview_tab.dart';
import 'visualizations/balance_trend_tab.dart';
import 'visualizations/yearly_breakdown_tab.dart';
import 'visualizations/payment_schedule_tab.dart';

class EnhancedEMIResultsCard extends StatefulWidget {
  final EMIResult result;
  final LoanParameters parameters;

  const EnhancedEMIResultsCard({
    super.key,
    required this.result,
    required this.parameters,
  });

  @override
  State<EnhancedEMIResultsCard> createState() => _EnhancedEMIResultsCardState();
}

class _EnhancedEMIResultsCardState extends State<EnhancedEMIResultsCard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabLabels = [
    'Overview',
    'Balance Trend',
    'Yearly Breakdown',
    'Payment Schedule',
  ];

  final List<IconData> _tabIcons = [
    Icons.pie_chart,
    Icons.show_chart,
    Icons.bar_chart,
    Icons.table_chart,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main EMI Summary Card (always visible)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Monthly EMI',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.result.monthlyEMI.toEMIFormat(),
                  style: FinancialTypography.emiAmount.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Summary Row
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Interest',
                        value: widget.result.totalInterest.toIndianFormat(),
                        color: FinancialColors.cost,
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Amount',
                        value: widget.result.totalAmount.toIndianFormat(),
                        color: FinancialColors.neutral,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Visualization Tabs Card
        Card(
          child: Column(
            children: [
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                  tabs: List.generate(
                    _tabLabels.length,
                    (index) => Tab(
                      icon: Icon(_tabIcons[index], size: 20),
                      text: _tabLabels[index],
                    ),
                  ),
                ),
              ),

              // Tab Content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: IndexedStack(
                  key: ValueKey(_selectedIndex),
                  index: _selectedIndex,
                  children: [
                    // Overview Tab
                    OverviewTab(
                      result: widget.result,
                      isVisible: _selectedIndex == 0,
                    ),

                    // Balance Trend Tab
                    BalanceTrendTab(
                      result: widget.result,
                      parameters: widget.parameters,
                      isVisible: _selectedIndex == 1,
                    ),

                    // Yearly Breakdown Tab
                    YearlyBreakdownTab(
                      result: widget.result,
                      isVisible: _selectedIndex == 2,
                    ),

                    // Payment Schedule Tab
                    PaymentScheduleTab(
                      result: widget.result,
                      parameters: widget.parameters,
                      isVisible: _selectedIndex == 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tax Benefits Card (if applicable)
        if (widget.result.taxBenefits.totalAnnualSavings > 0)
          Card(
            color: FinancialColors.taxBenefit.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: FinancialColors.taxBenefit,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Annual Tax Benefits',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: FinancialColors.taxBenefit),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (widget.result.taxBenefits.section80C > 0)
                    _TaxBenefitRow(
                      section: 'Section 80C',
                      description: 'Principal repayment',
                      amount: widget.result.taxBenefits.section80C,
                    ),

                  if (widget.result.taxBenefits.section24B > 0) ...[
                    const SizedBox(height: 8),
                    _TaxBenefitRow(
                      section: 'Section 24B',
                      description: 'Interest payment',
                      amount: widget.result.taxBenefits.section24B,
                    ),
                  ],

                  if (widget.result.taxBenefits.section80EEA > 0) ...[
                    const SizedBox(height: 8),
                    _TaxBenefitRow(
                      section: 'Section 80EEA',
                      description: 'Additional interest (First-time buyer)',
                      amount: widget.result.taxBenefits.section80EEA,
                    ),
                  ],

                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Annual Tax Savings',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.result.taxBenefits.totalAnnualSavings
                            .toEMIFormat(),
                        style: FinancialTypography.moneyLarge.copyWith(
                          color: FinancialColors.taxBenefit,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 16),

        // PMAY Benefit Card (if applicable)
        if (widget.result.pmayBenefit != null &&
            widget.result.pmayBenefit!.isEligible)
          Card(
            color: FinancialColors.pmayBenefit.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home_work, color: FinancialColors.pmayBenefit),
                      const SizedBox(width: 8),
                      Text(
                        'PMAY Subsidy Benefit',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: FinancialColors.pmayBenefit),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              widget.result.pmayBenefit!.category,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Subsidy Amount',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              widget.result.pmayBenefit!.subsidyAmount
                                  .toEMIFormat(),
                              style: FinancialTypography.moneyMedium.copyWith(
                                color: FinancialColors.pmayBenefit,
                                fontWeight: FontWeight.bold,
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
          ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: FinancialTypography.moneyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TaxBenefitRow extends StatelessWidget {
  final String section;
  final String description;
  final double amount;

  const _TaxBenefitRow({
    required this.section,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section, style: Theme.of(context).textTheme.titleSmall),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text(
          amount.toEMIFormat(),
          style: FinancialTypography.moneyMedium.copyWith(
            color: FinancialColors.taxBenefit,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
