import 'package:flutter/material.dart';
import '../../../domain/entities/step_emi.dart';
import '../../../core/utils/step_emi_calculation_utils.dart';
import 'responsive_layout.dart';

/// Responsive Step EMI selector with horizontal scrollable percentage chips
/// and adaptive layouts for different screen sizes
class ResponsiveStepEMISelector extends StatelessWidget {
  final StepEMIParameters parameters;
  final Function(StepEMIParameters) onParametersChanged;

  const ResponsiveStepEMISelector({
    super.key,
    required this.parameters,
    required this.onParametersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: ResponsivePadding.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: ResponsiveSpacing.lg),
            _buildEMITypeSelector(context),
            if (parameters.type != StepEMIType.none) ...[
              const SizedBox(height: ResponsiveSpacing.xl),
              _buildResponsiveStepConfiguration(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMI Structure',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: ResponsiveSpacing.xs),
        Text(
          'Choose how your EMI changes over time',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEMITypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMI Type',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: ResponsiveSpacing.sm),

        // Responsive layout for EMI type cards
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < AppBreakpoints.tablet) {
              // Mobile: Stack vertically
              return Column(
                children: StepEMIType.values
                    .map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: ResponsiveSpacing.sm,
                        ),
                        child: _buildEMITypeCard(context, type),
                      ),
                    )
                    .toList(),
              );
            } else {
              // Tablet/Desktop: Grid layout
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: ResponsiveSpacing.sm,
                mainAxisSpacing: ResponsiveSpacing.sm,
                childAspectRatio: 2.5,
                children: StepEMIType.values
                    .map((type) => _buildEMITypeCard(context, type))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildEMITypeCard(BuildContext context, StepEMIType type) {
    final isSelected = parameters.type == type;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _handleEMITypeChange(type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: ResponsiveSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.all(ResponsiveSpacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.2)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForEMIType(type),
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  size: 20,
                ),
              ),
              const SizedBox(width: ResponsiveSpacing.sm),

              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected)
                Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveStepConfiguration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Configuration',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: ResponsiveSpacing.lg),

        // Responsive percentage selector
        _buildResponsivePercentageSelector(context),

        const SizedBox(height: ResponsiveSpacing.xl),

        // Frequency selector
        _buildResponsiveFrequencySelector(context),

        const SizedBox(height: ResponsiveSpacing.lg),

        // Configuration preview
        _buildConfigurationPreview(context),
      ],
    );
  }

  Widget _buildResponsivePercentageSelector(BuildContext context) {
    final suggestedPercentages =
        StepEMICalculationUtils.getSuggestedStepPercentages();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              parameters.type == StepEMIType.stepUp
                  ? Icons.trending_up
                  : Icons.trending_down,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: ResponsiveSpacing.sm),
            Text(
              'Step Percentage',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: ResponsiveSpacing.sm),
        Text(
          'How much should your EMI ${parameters.type == StepEMIType.stepUp ? 'increase' : 'decrease'}?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: ResponsiveSpacing.md),

        // Horizontal scrollable chips for mobile, wrap for larger screens
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < AppBreakpoints.tablet) {
              // Mobile: Horizontal scroll
              return SizedBox(
                height: 48, // Touch target height
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: suggestedPercentages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: ResponsiveSpacing.sm),
                  itemBuilder: (context, index) {
                    final percentage = suggestedPercentages[index];
                    final isSelected = parameters.stepPercentage == percentage;

                    return _buildPercentageChip(
                      context,
                      percentage,
                      isSelected,
                    );
                  },
                ),
              );
            } else {
              // Tablet/Desktop: Wrap layout
              return Wrap(
                spacing: ResponsiveSpacing.sm,
                runSpacing: ResponsiveSpacing.sm,
                children: suggestedPercentages.map((percentage) {
                  final isSelected = parameters.stepPercentage == percentage;
                  return _buildPercentageChip(context, percentage, isSelected);
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPercentageChip(
    BuildContext context,
    double percentage,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => onParametersChanged(
          parameters.copyWith(stepPercentage: percentage),
        ),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: ResponsiveSpacing.minTouchTarget,
            minHeight: 48,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ResponsiveSpacing.lg,
            vertical: ResponsiveSpacing.sm,
          ),
          child: Center(
            child: Text(
              '${percentage.toStringAsFixed(percentage % 1 == 0 ? 0 : 1)}%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveFrequencySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: ResponsiveSpacing.sm),
            Text(
              'Step Frequency',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: ResponsiveSpacing.sm),
        Text(
          'How often should the EMI change?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: ResponsiveSpacing.md),

        // Responsive frequency selector
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 350) {
              // Very narrow screens: Stack vertically
              return Column(
                children: StepFrequency.values.map((frequency) {
                  final isSelected = parameters.frequency == frequency;
                  return Container(
                    width: double.infinity,
                    height: ResponsiveSpacing.minTouchTarget,
                    margin: const EdgeInsets.only(bottom: ResponsiveSpacing.xs),
                    child: _buildFrequencyButton(
                      context,
                      frequency,
                      isSelected,
                    ),
                  );
                }).toList(),
              );
            } else {
              // Use segmented button for wider screens
              return SegmentedButton<StepFrequency>(
                segments: StepFrequency.values.map((frequency) {
                  return ButtonSegment<StepFrequency>(
                    value: frequency,
                    label: Text(
                      frequency.displayName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                }).toList(),
                selected: {parameters.frequency},
                onSelectionChanged: (Set<StepFrequency> selection) {
                  onParametersChanged(
                    parameters.copyWith(frequency: selection.first),
                  );
                },
                style: SegmentedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    ResponsiveSpacing.minTouchTarget,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildFrequencyButton(
    BuildContext context,
    StepFrequency frequency,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () =>
            onParametersChanged(parameters.copyWith(frequency: frequency)),
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            frequency.displayName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigurationPreview(BuildContext context) {
    if (parameters.type == StepEMIType.none) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final changeVerb = parameters.type == StepEMIType.stepUp
        ? 'increases'
        : 'decreases';
    final benefitText = _getConfigurationBenefit();

    return Container(
      padding: const EdgeInsets.all(ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: ResponsiveSpacing.sm),
              Text(
                'Preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: ResponsiveSpacing.sm),
          Text(
            'Your EMI $changeVerb by ${parameters.stepPercentage}% ${parameters.frequency.displayName.toLowerCase()}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          if (benefitText.isNotEmpty) ...[
            const SizedBox(height: ResponsiveSpacing.xs),
            Text(
              benefitText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForEMIType(StepEMIType type) {
    switch (type) {
      case StepEMIType.none:
        return Icons.straighten;
      case StepEMIType.stepUp:
        return Icons.trending_up;
      case StepEMIType.stepDown:
        return Icons.trending_down;
    }
  }

  String _getConfigurationBenefit() {
    switch (parameters.type) {
      case StepEMIType.stepUp:
        return 'Perfect for growing income - start with lower EMIs and increase as your salary grows';
      case StepEMIType.stepDown:
        return 'Ideal for retirement planning - higher EMIs initially, then reduce as you approach retirement';
      default:
        return '';
    }
  }

  void _handleEMITypeChange(StepEMIType newType) {
    if (newType == parameters.type) return;

    StepEMIParameters newParameters;

    switch (newType) {
      case StepEMIType.none:
        newParameters = StepEMIParameters.none();
        break;
      case StepEMIType.stepUp:
        newParameters = StepEMIParameters.stepUp(
          stepPercentage: parameters.type == StepEMIType.stepDown
              ? parameters.stepPercentage
              : 10.0,
          frequency: parameters.frequency,
        );
        break;
      case StepEMIType.stepDown:
        newParameters = StepEMIParameters.stepDown(
          stepPercentage: parameters.type == StepEMIType.stepUp
              ? parameters.stepPercentage
              : 10.0,
          frequency: parameters.frequency,
        );
        break;
    }

    onParametersChanged(newParameters);
  }
}

/// Expandable card widget to solve text truncation issues
class ExpandableCard extends StatefulWidget {
  final String title;
  final String content;
  final Widget? icon;
  final int maxLines;
  final bool initiallyExpanded;
  final EdgeInsets? padding;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.maxLines = 2,
    this.initiallyExpanded = false,
    this.padding,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: _toggleExpansion,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: widget.padding ?? ResponsivePadding.card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: ResponsiveSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: ResponsiveSpacing.sm),

              // Content
              AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return Text(
                    widget.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: _isExpanded ? null : widget.maxLines,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  );
                },
              ),

              // Read more/less indicator
              if (_shouldShowReadMore()) ...[
                const SizedBox(height: ResponsiveSpacing.xs),
                Text(
                  _isExpanded ? 'Read less' : 'Read more',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  bool _shouldShowReadMore() {
    // Simple heuristic: show read more if content is longer than estimated visible text
    final estimatedVisibleChars = widget.maxLines * 50; // Rough estimate
    return widget.content.length > estimatedVisibleChars;
  }
}
