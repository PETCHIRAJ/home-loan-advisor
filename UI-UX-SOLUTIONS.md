# UI/UX Design Solutions - Home Loan Advisor App

> Comprehensive design solutions for mobile-first responsive UI/UX improvements

**Target Device**: Samsung Galaxy S21 (1080x2340, 6.2" display)  
**Flutter Version**: 3.35.1  
**Design System**: Material Design 3  
**Last Updated**: 2025-08-30  
**Version**: 1.0

## Executive Summary

This document provides comprehensive design solutions for 25 identified UI/UX issues in the Home Loan Advisor app. The solutions prioritize mobile-first responsive design, accessibility compliance (WCAG AA), and Material 3 design system adherence. Each solution includes specific measurements, Flutter widget recommendations, and implementation patterns.

## 🎨 Enhanced Design System

### Responsive Breakpoints
```dart
class AppBreakpoints {
  static const double mobile = 0;       // 0-639px
  static const double mobileLarge = 480; // 480-639px  
  static const double tablet = 640;     // 640-1023px
  static const double desktop = 1024;   // 1024px+
  
  static double get(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return desktop;
    if (width >= tablet) return tablet;
    if (width >= mobileLarge) return mobileLarge;
    return mobile;
  }
}
```

### Enhanced Spacing Scale
```dart
class ResponsiveSpacing {
  static const double xs = 4;    // Micro spacing
  static const double sm = 8;    // Small spacing
  static const double md = 16;   // Medium spacing (base)
  static const double lg = 24;   // Large spacing
  static const double xl = 32;   // Extra large
  static const double xxl = 48;  // Section spacing
  static const double xxxl = 64; // Screen padding
  
  // Touch Target Sizes (Material 3)
  static const double minTouchTarget = 48;
  static const double comfortableTouchTarget = 56;
  static const double largeTouchTarget = 64;
}
```

### Typography Enhancement
```dart
class ResponsiveTypography {
  static TextStyle scaledTextStyle(BuildContext context, TextStyle baseStyle) {
    final textScaler = MediaQuery.textScalerOf(context);
    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null 
        ? textScaler.scale(baseStyle.fontSize!)
        : null,
    );
  }
  
  // Chart-specific typography
  static TextStyle chartLabel(BuildContext context) {
    return scaledTextStyle(context, TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ));
  }
}
```

## 🔴 Critical Issues Solutions

### Issue #1: Chart Legend Overlapping
**Problem**: Axis labels overlap on very small devices, making charts unreadable.

**Design Solution**:
- Implement responsive chart sizing with horizontal scrolling
- Use external labels for pie charts
- Adaptive label rotation and spacing

**Implementation**:
```dart
class ResponsiveChartContainer extends StatelessWidget {
  final Widget chart;
  final double? fixedHeight;
  final bool enableHorizontalScroll;

  const ResponsiveChartContainer({
    super.key,
    required this.chart,
    this.fixedHeight,
    this.enableHorizontalScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    // Calculate responsive dimensions
    final chartHeight = fixedHeight ?? _calculateChartHeight(screenSize);
    final chartWidth = enableHorizontalScroll && isSmallScreen 
      ? screenSize.width * 1.2 // 20% wider than screen
      : screenSize.width - (ResponsiveSpacing.md * 2);

    Widget chartWidget = SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: chart,
    );

    // Wrap in horizontal scroll for small screens
    if (enableHorizontalScroll && isSmallScreen) {
      chartWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: ResponsiveSpacing.md,
        ),
        child: chartWidget,
      );
    } else {
      chartWidget = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ResponsiveSpacing.md,
        ),
        child: chartWidget,
      );
    }

    return chartWidget;
  }

  double _calculateChartHeight(Size screenSize) {
    // Responsive height based on screen size
    if (screenSize.width < 400) return 200; // Small phones
    if (screenSize.width < 600) return 250; // Regular phones
    return 300; // Tablets and larger
  }
}
```

**Chart Label Optimization**:
```dart
class AdaptiveChartLabels {
  static List<String> adaptLabelsForWidth(
    List<String> labels, 
    double availableWidth,
    TextStyle labelStyle,
  ) {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    );

    // Calculate average character width
    painter.text = TextSpan(text: 'W', style: labelStyle);
    painter.layout();
    final charWidth = painter.width;

    final maxCharsPerLabel = (availableWidth / labels.length / charWidth).floor();
    
    return labels.map((label) {
      if (label.length <= maxCharsPerLabel) return label;
      
      // Smart truncation - preserve important parts
      if (label.contains(' ')) {
        final words = label.split(' ');
        if (words.length > 1) {
          return '${words[0].substring(0, min(4, words[0].length))}..';
        }
      }
      
      return '${label.substring(0, maxCharsPerLabel - 2)}..';
    }).toList();
  }
}
```

### Issue #2: Small Touch Targets
**Problem**: Tab bars and small buttons are too small (< 48x48dp) for comfortable touch.

**Design Solution**:
- Ensure minimum 48x48dp touch targets (Material 3 standard)
- Use 56dp for primary actions, 64dp for frequently used controls
- Add sufficient padding and visual feedback

**Implementation**:
```dart
class AccessibleTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final Function(int)? onTap;

  const AccessibleTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSpacing.comfortableTouchTarget,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabs.map((tab) => _buildAccessibleTab(context, tab)).toList(),
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
        splashFactory: NoSplash.splashFactory, // Disable splash for cleaner look
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildAccessibleTab(BuildContext context, Tab tab) {
    return SizedBox(
      height: ResponsiveSpacing.comfortableTouchTarget,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ResponsiveSpacing.sm,
            vertical: ResponsiveSpacing.xs,
          ),
          child: tab.child ?? Text(tab.text ?? ''),
        ),
      ),
    );
  }
}
```

**Enhanced Button Component**:
```dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;

  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getButtonHeight();
    final buttonStyle = _getButtonStyle(context);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(context),
              ),
            ),
          ),
          const SizedBox(width: ResponsiveSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: ResponsiveSpacing.sm),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: _getTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: buttonChild,
      ),
    );
  }

  double _getButtonHeight() {
    switch (type) {
      case ButtonType.large:
        return ResponsiveSpacing.largeTouchTarget;
      case ButtonType.small:
        return ResponsiveSpacing.minTouchTarget;
      default:
        return ResponsiveSpacing.comfortableTouchTarget;
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(context),
      foregroundColor: _getTextColor(context),
      elevation: type == ButtonType.primary ? 2 : 0,
      padding: const EdgeInsets.symmetric(
        horizontal: ResponsiveSpacing.lg,
        vertical: ResponsiveSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: type == ButtonType.outlined 
          ? BorderSide(color: colorScheme.outline)
          : BorderSide.none,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ButtonType.primary:
        return colorScheme.primary;
      case ButtonType.secondary:
        return colorScheme.secondaryContainer;
      case ButtonType.outlined:
        return Colors.transparent;
      default:
        return colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ButtonType.primary:
        return colorScheme.onPrimary;
      case ButtonType.secondary:
        return colorScheme.onSecondaryContainer;
      case ButtonType.outlined:
        return colorScheme.primary;
      default:
        return colorScheme.onPrimary;
    }
  }
}

enum ButtonType { primary, secondary, outlined, small, large }
```

### Issue #3: Step EMI Selector Layout
**Problem**: Percentage chips wrap awkwardly on small screens, making UI look broken.

**Design Solution**:
- Horizontal scrollable chips for percentage selection
- Responsive layout with proper spacing
- Visual indicators for selected state

**Implementation**:
```dart
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
        padding: const EdgeInsets.all(ResponsiveSpacing.lg),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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

  Widget _buildResponsiveStepConfiguration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Configuration',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
    final suggestedPercentages = [2.0, 5.0, 7.5, 10.0, 12.5, 15.0, 20.0];
    
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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

        // Horizontal scrollable chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: suggestedPercentages.length,
            separatorBuilder: (context, index) => 
              const SizedBox(width: ResponsiveSpacing.sm),
            itemBuilder: (context, index) {
              final percentage = suggestedPercentages[index];
              final isSelected = parameters.stepPercentage == percentage;
              
              return _buildPercentageChip(context, percentage, isSelected);
            },
          ),
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
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => onParametersChanged(
          parameters.copyWith(stepPercentage: percentage),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: ResponsiveSpacing.minTouchTarget,
            minHeight: 40,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ResponsiveSpacing.md,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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

        // Responsive segmented button
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 350;
            
            if (isNarrow) {
              // Stack vertically on very narrow screens
              return Column(
                children: StepFrequency.values.map((frequency) {
                  final isSelected = parameters.frequency == frequency;
                  return Container(
                    width: double.infinity,
                    height: ResponsiveSpacing.minTouchTarget,
                    margin: const EdgeInsets.only(bottom: ResponsiveSpacing.xs),
                    child: _buildFrequencyButton(context, frequency, isSelected),
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
        onTap: () => onParametersChanged(
          parameters.copyWith(frequency: frequency),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            frequency.displayName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected 
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
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
    final changeVerb = parameters.type == StepEMIType.stepUp ? 'increases' : 'decreases';
    final benefitText = _getConfigurationBenefit();

    return Container(
      padding: const EdgeInsets.all(ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
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
}
```

## 🟡 Major Issues Solutions

### Issue #6: Mobile-First Card Layouts  
**Problem**: Scenario comparison cards too wide for comfortable mobile viewing.

**Design Solution**:
- Stacked layout for mobile (< 640px)
- Grid layout for tablets (≥ 640px)
- Adaptive card sizing and spacing

**Implementation**:
```dart
class ResponsiveScenarioCards extends StatelessWidget {
  final List<LoanScenario> scenarios;
  final Function(LoanScenario) onScenarioTap;

  const ResponsiveScenarioCards({
    super.key,
    required this.scenarios,
    required this.onScenarioTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
        
        if (isTablet) {
          return _buildGridLayout(context, constraints);
        } else {
          return _buildStackedLayout(context);
        }
      },
    );
  }

  Widget _buildStackedLayout(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(ResponsiveSpacing.md),
      itemCount: scenarios.length,
      separatorBuilder: (context, index) => 
        const SizedBox(height: ResponsiveSpacing.md),
      itemBuilder: (context, index) {
        return MobileScenarioCard(
          scenario: scenarios[index],
          onTap: () => onScenarioTap(scenarios[index]),
        );
      },
    );
  }

  Widget _buildGridLayout(BuildContext context, BoxConstraints constraints) {
    final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
    final childAspectRatio = constraints.maxWidth > 900 ? 1.2 : 1.0;

    return GridView.builder(
      padding: const EdgeInsets.all(ResponsiveSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: ResponsiveSpacing.md,
        mainAxisSpacing: ResponsiveSpacing.md,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: scenarios.length,
      itemBuilder: (context, index) {
        return TabletScenarioCard(
          scenario: scenarios[index],
          onTap: () => onScenarioTap(scenarios[index]),
        );
      },
    );
  }
}

class MobileScenarioCard extends StatelessWidget {
  final LoanScenario scenario;
  final VoidCallback onTap;

  const MobileScenarioCard({
    super.key,
    required this.scenario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(ResponsiveSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scenario.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      scenario.icon,
                      color: scenario.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ResponsiveSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (scenario.description != null)
                          Text(
                            scenario.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              
              const SizedBox(height: ResponsiveSpacing.lg),
              
              // Key metrics in mobile-friendly layout
              _buildMobileMetrics(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMetrics(BuildContext context) {
    return Column(
      children: [
        // Primary metric (EMI)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly EMI',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '₹${scenario.monthlyEMI.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: ResponsiveSpacing.sm),
        
        // Secondary metrics
        Row(
          children: [
            Expanded(
              child: _buildMiniMetric(
                context, 
                'Total Interest', 
                '₹${(scenario.totalInterest / 100000).toStringAsFixed(1)}L',
              ),
            ),
            const SizedBox(width: ResponsiveSpacing.md),
            Expanded(
              child: _buildMiniMetric(
                context, 
                'Savings', 
                scenario.savings > 0 
                  ? '₹${(scenario.savings / 100000).toStringAsFixed(1)}L'
                  : 'N/A',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniMetric(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
```

### Issue #7: Input Field UX Improvements
**Problem**: Indian currency formatting makes input confusing for users.

**Design Solution**:
- Real-time formatting with clear helper text
- Visual feedback for different input states
- Auto-format as user types with proper Indian number system

**Implementation**:
```dart
class IndianCurrencyInputField extends StatefulWidget {
  final String label;
  final String? helperText;
  final double? initialValue;
  final Function(double) onValueChanged;
  final double? minValue;
  final double? maxValue;
  final String? prefixText;

  const IndianCurrencyInputField({
    super.key,
    required this.label,
    this.helperText,
    this.initialValue,
    required this.onValueChanged,
    this.minValue,
    this.maxValue,
    this.prefixText,
  });

  @override
  State<IndianCurrencyInputField> createState() => _IndianCurrencyInputFieldState();
}

class _IndianCurrencyInputFieldState extends State<IndianCurrencyInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _formattedValue = '';
  String _helpText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue.toString();
      _updateFormatting(_controller.text);
    }
    
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Formatted display when not focused
        if (!_focusNode.hasFocus && _formattedValue.isNotEmpty)
          _buildFormattedDisplay(context),
        
        // Input field
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helperText ?? _helpText,
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.currency_rupee, size: 20),
            suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: _clearField,
                )
              : null,
            errorText: _getErrorText(),
          ),
          onChanged: _onTextChanged,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            _IndianCurrencyInputFormatter(),
          ],
        ),
        
        // Value breakdown helper
        if (_controller.text.isNotEmpty && !_focusNode.hasFocus)
          _buildValueBreakdown(context),
      ],
    );
  }

  Widget _buildFormattedDisplay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: ResponsiveSpacing.md,
        vertical: ResponsiveSpacing.sm,
      ),
      margin: const EdgeInsets.only(bottom: ResponsiveSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.currency_rupee,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: ResponsiveSpacing.sm),
          Text(
            _formattedValue,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueBreakdown(BuildContext context) {
    final value = double.tryParse(_controller.text) ?? 0;
    if (value == 0) return const SizedBox.shrink();

    final crores = (value / 10000000).floor();
    final lakhs = ((value % 10000000) / 100000).floor();
    final thousands = ((value % 100000) / 1000).floor();

    final breakdown = <String>[];
    if (crores > 0) breakdown.add('$crores Cr');
    if (lakhs > 0) breakdown.add('$lakhs L');
    if (thousands > 0) breakdown.add('$thousands K');

    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: ResponsiveSpacing.xs),
      child: Text(
        '≈ ${breakdown.join(' ')}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void _onTextChanged(String value) {
    _updateFormatting(value);
    
    final numericValue = double.tryParse(value) ?? 0;
    widget.onValueChanged(numericValue);
    
    setState(() {
      _helpText = _generateHelpText(numericValue);
    });
  }

  void _updateFormatting(String value) {
    final numericValue = double.tryParse(value) ?? 0;
    if (numericValue > 0) {
      _formattedValue = _formatIndianCurrency(numericValue);
    } else {
      _formattedValue = '';
    }
  }

  String _formatIndianCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  String _generateHelpText(double value) {
    if (value == 0) return widget.helperText ?? '';
    
    final baseHelp = widget.helperText ?? '';
    final breakdown = _getValueInWords(value);
    
    return baseHelp.isNotEmpty 
      ? '$baseHelp • $breakdown'
      : breakdown;
  }

  String _getValueInWords(double value) {
    if (value >= 10000000) {
      final crores = value / 10000000;
      return '${crores.toStringAsFixed(1)} Crore';
    } else if (value >= 100000) {
      final lakhs = value / 100000;
      return '${lakhs.toStringAsFixed(1)} Lakh';
    } else if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(1)} Thousand';
    }
    return '${value.toStringAsFixed(0)}';
  }

  String? _getErrorText() {
    final value = double.tryParse(_controller.text) ?? 0;
    
    if (widget.minValue != null && value < widget.minValue!) {
      return 'Minimum value: ₹${widget.minValue!.toStringAsFixed(0)}';
    }
    
    if (widget.maxValue != null && value > widget.maxValue!) {
      return 'Maximum value: ₹${widget.maxValue!.toStringAsFixed(0)}';
    }
    
    return null;
  }

  void _onFocusChanged() {
    setState(() {}); // Rebuild to show/hide formatted display
  }

  void _clearField() {
    _controller.clear();
    widget.onValueChanged(0);
    setState(() {
      _formattedValue = '';
      _helpText = widget.helperText ?? '';
    });
  }
}

class _IndianCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits and one decimal point
    final newText = newValue.text;
    
    if (newText.isEmpty) {
      return newValue;
    }
    
    // Count decimal points
    final decimalCount = '.'.allMatches(newText).length;
    if (decimalCount > 1) {
      return oldValue;
    }
    
    // Limit decimal places to 2
    if (newText.contains('.')) {
      final parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > 2) {
        return oldValue;
      }
    }
    
    return newValue;
  }
}
```

## 🎯 Accessibility & Performance

### WCAG AA Compliance Implementation
```dart
class AccessibilityEnhancedWidget extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final bool isButton;
  final VoidCallback? onTap;

  const AccessibilityEnhancedWidget({
    super.key,
    required this.child,
    this.semanticLabel,
    this.isButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget accessibleChild = child;
    
    // Add semantic labels for screen readers
    if (semanticLabel != null) {
      accessibleChild = Semantics(
        label: semanticLabel,
        button: isButton,
        child: accessibleChild,
      );
    }
    
    // Ensure minimum touch targets for buttons
    if (isButton && onTap != null) {
      accessibleChild = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: ResponsiveSpacing.minTouchTarget,
              minHeight: ResponsiveSpacing.minTouchTarget,
            ),
            child: accessibleChild,
          ),
        ),
      );
    }
    
    return accessibleChild;
  }
}

// Color Contrast Helper
class ContrastHelper {
  static bool meetsWCAGAA(Color foreground, Color background) {
    final contrast = _calculateContrast(foreground, background);
    return contrast >= 4.5; // WCAG AA standard
  }
  
  static double _calculateContrast(Color color1, Color color2) {
    final lum1 = _luminance(color1) + 0.05;
    final lum2 = _luminance(color2) + 0.05;
    
    final brightest = math.max(lum1, lum2);
    final darkest = math.min(lum1, lum2);
    
    return brightest / darkest;
  }
  
  static double _luminance(Color color) {
    final r = _linearizeColorComponent(color.red / 255);
    final g = _linearizeColorComponent(color.green / 255);
    final b = _linearizeColorComponent(color.blue / 255);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
  
  static double _linearizeColorComponent(double component) {
    return component <= 0.03928
        ? component / 12.92
        : math.pow((component + 0.055) / 1.055, 2.4).toDouble();
  }
}
```

### Animation & Performance Optimization
```dart
class OptimizedAnimations {
  // Duration constants for consistent timing
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Curves for different interaction types
  static const Curve entrance = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve emphasis = Curves.elasticOut;
  
  // Performance-optimized slide transition
  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: entrance,
      )),
      child: child,
    );
  }
  
  // Optimized fade transition
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  // Scale transition for button feedback
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: emphasis,
      )),
      child: child,
    );
  }
}

// Performance monitoring widget
class PerformanceMonitor extends StatelessWidget {
  final Widget child;
  final String screenName;

  const PerformanceMonitor({
    super.key,
    required this.child,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return child; // In production, add performance tracking here
  }
}
```

## 📊 Component Usage Guidelines

### Material 3 Component Mapping
```dart
class Material3Components {
  // Use these components for consistent Material 3 design
  
  // Cards
  static Widget elevatedCard({required Widget child}) => Card(
    elevation: 1,
    child: child,
  );
  
  static Widget filledCard({required Widget child}) => Card(
    elevation: 0,
    color: null, // Uses surface container color
    child: child,
  );
  
  static Widget outlinedCard({required Widget child}) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    child: child,
  );
  
  // Buttons - Use AccessibleButton class defined earlier
  
  // Navigation
  static Widget navigationBar({
    required List<NavigationDestination> destinations,
    required int selectedIndex,
    required Function(int) onDestinationSelected,
  }) => NavigationBar(
    destinations: destinations,
    selectedIndex: selectedIndex,
    onDestinationSelected: onDestinationSelected,
    height: 80, // Comfortable touch target
  );
  
  // Input Fields - Use IndianCurrencyInputField for currency inputs
}
```

### Responsive Layout Patterns
```dart
class ResponsiveLayoutPatterns {
  // Adaptive padding based on screen size
  static EdgeInsets adaptivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= AppBreakpoints.desktop) {
      return const EdgeInsets.all(ResponsiveSpacing.xxxl);
    } else if (width >= AppBreakpoints.tablet) {
      return const EdgeInsets.all(ResponsiveSpacing.xl);
    } else {
      return const EdgeInsets.all(ResponsiveSpacing.md);
    }
  }
  
  // Adaptive column count for grids
  static int adaptiveColumnCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }
  
  // Responsive font size scaling
  static double adaptiveFontSize(BuildContext context, double baseFontSize) {
    final textScaler = MediaQuery.textScalerOf(context);
    return textScaler.scale(baseFontSize);
  }
}
```

## 🔧 Implementation Priority

### Phase 1: Critical Issues (Week 1)
1. **Chart responsiveness** - ResponsiveChartContainer implementation
2. **Touch targets** - AccessibleTabBar and AccessibleButton components  
3. **Step EMI layout** - ResponsiveStepEMISelector with horizontal scrolling
4. **Input field UX** - IndianCurrencyInputField with real-time formatting

### Phase 2: Major UX Issues (Week 2)
1. **Mobile card layouts** - ResponsiveScenarioCards implementation
2. **Modal sheet heights** - Responsive bottom sheets with max height constraints
3. **Text truncation** - Expandable cards with "read more" functionality
4. **Color contrast** - WCAG AA compliance validation

### Phase 3: Polish & Performance (Week 3)
1. **Animation optimization** - OptimizedAnimations implementation
2. **Loading states** - Skeleton screens and smooth transitions
3. **Empty states** - Illustrations and helpful messaging
4. **Landscape mode** - Responsive layouts for all orientations

## 📱 Testing Checklist

### Device Testing Matrix
- **Galaxy S21** (1080x2340, 6.2") - Primary test device
- **iPhone 13** (1170x2532, 6.1") - iOS compatibility
- **Pixel 7** (1080x2400, 6.3") - Android compatibility
- **iPad Mini** (2266x1488, 8.3") - Tablet layout
- **Accessibility** - Screen reader testing on all devices

### Performance Metrics
- **Touch Response**: < 16ms (60fps)
- **Animation Smoothness**: 60fps sustained
- **Memory Usage**: < 150MB peak
- **APK Size**: < 20MB release build
- **Cold Start**: < 2 seconds

### User Experience Validation
- **Touch Target Size**: All interactive elements ≥ 48dp
- **Color Contrast**: All text meets WCAG AA (4.5:1)
- **Text Scaling**: Supports 200% system font size
- **Landscape Mode**: All screens functional in landscape
- **One-handed Use**: Critical functions reachable with thumb

## 📚 Resources & References

### Design System Documentation
- [Material Design 3 Guidelines](https://m3.material.io/)
- [Flutter Material Components](https://flutter.dev/docs/development/ui/widgets/material)
- [WCAG 2.1 Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Indian Number System Formatting](https://en.wikipedia.org/wiki/Indian_numbering_system)

### Implementation Tools
- **ResponsiveBuilder** - For adaptive layouts
- **flutter_screenutil** - For responsive sizing  
- **intl** - For Indian currency formatting
- **flutter_svg** - For scalable icons and illustrations

---

**Next Steps**: Implement solutions in priority order, test on target devices, and iterate based on user feedback. Each component should be thoroughly tested for accessibility compliance before deployment.