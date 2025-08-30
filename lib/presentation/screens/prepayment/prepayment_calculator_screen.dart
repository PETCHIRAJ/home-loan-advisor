import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import '../../widgets/prepayment/prepayment_tabs.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';

class PrepaymentCalculatorScreen extends ConsumerStatefulWidget {
  final LoanParameters loanParameters;
  final EMIResult emiResult;

  const PrepaymentCalculatorScreen({
    super.key,
    required this.loanParameters,
    required this.emiResult,
  });

  @override
  ConsumerState<PrepaymentCalculatorScreen> createState() => _PrepaymentCalculatorScreenState();
}

class _PrepaymentCalculatorScreenState extends ConsumerState<PrepaymentCalculatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabLabels = [
    'One-time',
    'Recurring',
    'Extra EMI',
  ];

  final List<IconData> _tabIcons = [
    Icons.payment,
    Icons.repeat,
    Icons.add_circle_outline,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    return AppScaffold(
      title: 'Prepayment Calculator',
      body: Column(
        children: [
          // Current Loan Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Loan Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Stack vertically on smaller screens
                        return Column(
                          children: [
                            _buildSummaryRow(
                              'Loan Amount',
                              widget.loanParameters.loanAmount.toIndianFormat(),
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              'Current EMI',
                              widget.emiResult.monthlyEMI.toEMIFormat(),
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              'Total Interest',
                              widget.emiResult.totalInterest.toIndianFormat(),
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              'Remaining Tenure',
                              '${widget.loanParameters.tenureYears} years',
                            ),
                          ],
                        );
                      } else {
                        // Grid layout for larger screens
                        return Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth - 24) / 2,
                              child: _buildSummaryRow(
                                'Loan Amount',
                                widget.loanParameters.loanAmount.toIndianFormat(),
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 24) / 2,
                              child: _buildSummaryRow(
                                'Current EMI',
                                widget.emiResult.monthlyEMI.toEMIFormat(),
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 24) / 2,
                              child: _buildSummaryRow(
                                'Total Interest',
                                widget.emiResult.totalInterest.toIndianFormat(),
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 24) / 2,
                              child: _buildSummaryRow(
                                'Remaining Tenure',
                                '${widget.loanParameters.tenureYears} years',
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

          // Strategy Selection Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Tab Header
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calculate,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Choose Prepayment Strategy',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return TabBar(
                      controller: _tabController,
                      isScrollable: constraints.maxWidth < 400,
                      tabAlignment: constraints.maxWidth < 400 
                          ? TabAlignment.start 
                          : TabAlignment.fill,
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth < 400 ? 8 : 0,
                      ),
                      tabs: List.generate(
                        _tabLabels.length,
                        (index) => Tab(
                          icon: Icon(_tabIcons[index], size: 20),
                          text: _tabLabels[index],
                          iconMargin: const EdgeInsets.only(bottom: 4),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: PrepaymentTabs(
              tabController: _tabController,
              selectedIndex: _selectedIndex,
              loanParameters: widget.loanParameters,
              emiResult: widget.emiResult,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: FinancialTypography.moneyMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}