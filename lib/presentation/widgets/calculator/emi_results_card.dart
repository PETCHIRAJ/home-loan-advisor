import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/emi_result.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';

class EMIResultsCard extends StatelessWidget {
  final EMIResult result;

  const EMIResultsCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main EMI Card
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
                  result.monthlyEMI.toEMIFormat(),
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
                        value: result.totalInterest.toIndianFormat(),
                        color: FinancialColors.cost,
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Amount',
                        value: result.totalAmount.toIndianFormat(),
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

        // Principal vs Interest Chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: result.principalAmount,
                                title: 'Principal',
                                color: Theme.of(context).colorScheme.primary,
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: result.totalInterest,
                                title: 'Interest',
                                color: FinancialColors.cost,
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 30,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LegendItem(
                              color: Theme.of(context).colorScheme.primary,
                              label: 'Principal',
                              value: result.principalAmount.toIndianFormat(),
                              percentage:
                                  (result.principalAmount /
                                          result.totalAmount *
                                          100)
                                      .toStringAsFixed(1),
                            ),
                            const SizedBox(height: 12),
                            _LegendItem(
                              color: FinancialColors.cost,
                              label: 'Interest',
                              value: result.totalInterest.toIndianFormat(),
                              percentage:
                                  (result.totalInterest /
                                          result.totalAmount *
                                          100)
                                      .toStringAsFixed(1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Tax Benefits Card
        if (result.taxBenefits.totalAnnualSavings > 0)
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

                  if (result.taxBenefits.section80C > 0)
                    _TaxBenefitRow(
                      section: 'Section 80C',
                      description: 'Principal repayment',
                      amount: result.taxBenefits.section80C,
                    ),

                  if (result.taxBenefits.section24B > 0) ...[
                    const SizedBox(height: 8),
                    _TaxBenefitRow(
                      section: 'Section 24B',
                      description: 'Interest payment',
                      amount: result.taxBenefits.section24B,
                    ),
                  ],

                  if (result.taxBenefits.section80EEA > 0) ...[
                    const SizedBox(height: 8),
                    _TaxBenefitRow(
                      section: 'Section 80EEA',
                      description: 'Additional interest (First-time buyer)',
                      amount: result.taxBenefits.section80EEA,
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
                        result.taxBenefits.totalAnnualSavings.toEMIFormat(),
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

        // PMAY Benefit Card
        if (result.pmayBenefit != null && result.pmayBenefit!.isEligible)
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
                              result.pmayBenefit!.category,
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
                              result.pmayBenefit!.subsidyAmount.toEMIFormat(),
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

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                '$value ($percentage%)',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
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
