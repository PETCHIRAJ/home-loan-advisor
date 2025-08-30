import 'package:flutter/material.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';
import 'visualizations/overview_tab.dart';
import 'visualizations/balance_trend_tab.dart';
import 'visualizations/yearly_breakdown_tab.dart';
import 'visualizations/payment_schedule_tab.dart';
import '../../screens/prepayment/prepayment_calculator_screen.dart';

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

  String _getShortLabel(String label) {
    switch (label) {
      case 'Overview':
        return 'Overview';
      case 'Balance Trend':
        return 'Trend';
      case 'Yearly Breakdown':
        return 'Yearly';
      case 'Payment Schedule':
        return 'Schedule';
      default:
        return label;
    }
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Stack vertically on small screens
                      return Column(
                        children: [
                          _SummaryItem(
                            label: 'Total Interest',
                            value: widget.result.totalInterest.toIndianFormat(),
                            color: FinancialColors.cost,
                          ),
                          const SizedBox(height: 12),
                          _SummaryItem(
                            label: 'Total Amount',
                            value: widget.result.totalAmount.toIndianFormat(),
                            color: FinancialColors.neutral,
                          ),
                        ],
                      );
                    } else {
                      // Keep side by side on larger screens
                      return Row(
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
                      );
                    }
                  },
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return TabBar(
                      controller: _tabController,
                      isScrollable: constraints.maxWidth < 600,
                      tabAlignment: constraints.maxWidth < 600 
                          ? TabAlignment.start 
                          : TabAlignment.fill,
                      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth < 600 ? 8 : 0,
                      ),
                      tabs: List.generate(
                        _tabLabels.length,
                        (index) => Tab(
                          icon: Icon(_tabIcons[index], size: 18),
                          text: constraints.maxWidth < 400 
                              ? _getShortLabel(_tabLabels[index])
                              : _tabLabels[index],
                          iconMargin: const EdgeInsets.only(bottom: 4),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Tab Content
              Container(
                constraints: const BoxConstraints(minHeight: 300),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
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

        // Prepayment Calculator Button
        Card(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrepaymentCalculatorScreen(
                    loanParameters: widget.parameters,
                    emiResult: widget.result,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calculate,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prepayment Calculator',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Calculate how prepayments can save you money and reduce loan tenure',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
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

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 350) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
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
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          ],
                        );
                      } else {
                        return Row(
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
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
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
        Text(
          label, 
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: FinancialTypography.moneyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          // Stack vertically on very small screens
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section, 
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description, 
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                amount.toEMIFormat(),
                style: FinancialTypography.moneyMedium.copyWith(
                  color: FinancialColors.taxBenefit,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section, 
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      description, 
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  amount.toEMIFormat(),
                  style: FinancialTypography.moneyMedium.copyWith(
                    color: FinancialColors.taxBenefit,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
