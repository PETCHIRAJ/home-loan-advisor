import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/emi_result.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/responsive_chart_container.dart';
import '../../../widgets/common/responsive_layout.dart';

class OverviewTab extends StatefulWidget {
  final EMIResult result;
  final bool isVisible;

  const OverviewTab({super.key, required this.result, required this.isVisible});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(OverviewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      _animationController.forward();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Breakdown',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ResponsiveChartContainer(
                chart: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use AppBreakpoints for consistent responsive behavior
                    final isCompactLayout = constraints.maxWidth < AppBreakpoints.tablet;
                  
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: isCompactLayout ? 400 : 250,
                      maxHeight: isCompactLayout ? 500 : 300,
                    ),
                    child: isCompactLayout 
                        ? Column(
                            children: [
                              // Pie Chart on top for compact layout
                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: PieChart(
                                      PieChartData(
                                        sections: _buildPieChartSections(),
                                        centerSpaceRadius: 35,
                                        sectionsSpace: 2,
                                        pieTouchData: PieTouchData(
                                          enabled: true,
                                          touchCallback: (FlTouchEvent event, response) {
                                            if (!event.isInterestedForInteractions ||
                                                response == null ||
                                                response.touchedSection == null) {
                                              setState(() {
                                                touchedIndex = -1;
                                              });
                                              return;
                                            }
                                            setState(() {
                                              touchedIndex = response
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Legend below for compact layout
                              Row(
                                children: [
                                  Expanded(
                                    child: _LegendItem(
                                      color: Theme.of(context).colorScheme.primary,
                                      label: 'Principal',
                                      value: widget.result.principalAmount
                                          .toCompactFormat(),
                                      percentage:
                                          (widget.result.principalAmount /
                                                  widget.result.totalAmount *
                                                  100)
                                              .toStringAsFixed(1),
                                      isSelected: touchedIndex == 0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _LegendItem(
                                      color: FinancialColors.cost,
                                      label: 'Interest',
                                      value: widget.result.totalInterest.toCompactFormat(),
                                      percentage:
                                          (widget.result.totalInterest /
                                                  widget.result.totalAmount *
                                                  100)
                                              .toStringAsFixed(1),
                                      isSelected: touchedIndex == 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              // Pie Chart on left for wide layout
                              Expanded(
                                flex: 2,
                                child: PieChart(
                                  PieChartData(
                                    sections: _buildPieChartSections(),
                                    centerSpaceRadius: 40,
                                    sectionsSpace: 2,
                                    pieTouchData: PieTouchData(
                                      enabled: true,
                                      touchCallback: (FlTouchEvent event, response) {
                                        if (!event.isInterestedForInteractions ||
                                            response == null ||
                                            response.touchedSection == null) {
                                          setState(() {
                                            touchedIndex = -1;
                                          });
                                          return;
                                        }
                                        setState(() {
                                          touchedIndex = response
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Legend on right for wide layout
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _LegendItem(
                                      color: Theme.of(context).colorScheme.primary,
                                      label: 'Principal',
                                      value: widget.result.principalAmount
                                          .toIndianFormat(),
                                      percentage:
                                          (widget.result.principalAmount /
                                                  widget.result.totalAmount *
                                                  100)
                                              .toStringAsFixed(1),
                                      isSelected: touchedIndex == 0,
                                    ),
                                    const SizedBox(height: 16),
                                    _LegendItem(
                                      color: FinancialColors.cost,
                                      label: 'Interest',
                                      value: widget.result.totalInterest.toIndianFormat(),
                                      percentage:
                                          (widget.result.totalInterest /
                                                  widget.result.totalAmount *
                                                  100)
                                              .toStringAsFixed(1),
                                      isSelected: touchedIndex == 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Key Insights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Key Insights',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _InsightRow(
                  icon: Icons.trending_up,
                  label: 'Interest Component',
                  value:
                      '${(widget.result.totalInterest / widget.result.totalAmount * 100).toStringAsFixed(1)}%',
                  description: 'of your total payment',
                ),

                const SizedBox(height: 8),

                _InsightRow(
                  icon: Icons.calendar_month,
                  label: 'Total Payments',
                  value: widget.result.totalAmount.toIndianFormat(),
                  description: 'over the loan tenure',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
        value: widget.result.principalAmount * _animation.value,
        title: touchedIndex == 0
            ? 'Principal\n${widget.result.principalAmount.toCompactFormat()}'
            : '',
        color: Theme.of(context).colorScheme.primary,
        radius: touchedIndex == 0 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: touchedIndex == 0 ? _buildBadge('Principal') : null,
      ),
      PieChartSectionData(
        value: widget.result.totalInterest * _animation.value,
        title: touchedIndex == 1
            ? 'Interest\n${widget.result.totalInterest.toCompactFormat()}'
            : '',
        color: FinancialColors.cost,
        radius: touchedIndex == 1 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: touchedIndex == 1 ? _buildBadge('Interest') : null,
      ),
    ];
  }

  Widget _buildBadge(String label) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String percentage;
  final bool isSelected;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.percentage,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: color, width: 1) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String description;

  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
