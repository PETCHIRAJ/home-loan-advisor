import 'package:flutter/material.dart';

/// Responsive breakpoints and utility methods for adaptive layouts
class AppBreakpoints {
  static const double mobile = 0; // 0-639px
  static const double mobileLarge = 480; // 480-639px
  static const double tablet = 640; // 640-1023px
  static const double desktop = 1024; // 1024px+

  static double get(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return desktop;
    if (width >= tablet) return tablet;
    if (width >= mobileLarge) return mobileLarge;
    return mobile;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tablet;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}

/// Enhanced spacing scale for responsive design
class ResponsiveSpacing {
  static const double xs = 4; // Micro spacing
  static const double sm = 8; // Small spacing
  static const double md = 16; // Medium spacing (base)
  static const double lg = 24; // Large spacing
  static const double xl = 32; // Extra large
  static const double xxl = 48; // Section spacing
  static const double xxxl = 64; // Screen padding

  // Touch Target Sizes (Material 3)
  static const double minTouchTarget = 48;
  static const double comfortableTouchTarget = 56;
  static const double largeTouchTarget = 64;

  /// Get adaptive spacing based on screen size
  static double adaptive(
    BuildContext context, {
    double mobile = md,
    double tablet = lg,
    double desktop = xl,
  }) {
    if (AppBreakpoints.isDesktop(context)) return desktop;
    if (AppBreakpoints.isTablet(context)) return tablet;
    return mobile;
  }
}

/// Responsive layout builder with common patterns
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileBreakpoint = AppBreakpoints.tablet,
    this.tabletBreakpoint = AppBreakpoints.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= tabletBreakpoint && desktop != null) {
      return desktop!;
    }

    if (screenWidth >= mobileBreakpoint && tablet != null) {
      return tablet!;
    }

    return mobile;
  }
}

/// Responsive grid that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = ResponsiveSpacing.md,
    this.runSpacing = ResponsiveSpacing.md,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int columnCount = mobileColumns;
    if (screenWidth >= AppBreakpoints.desktop) {
      columnCount = desktopColumns;
    } else if (screenWidth >= AppBreakpoints.tablet) {
      columnCount = tabletColumns;
    }

    return Padding(
      padding: padding ?? EdgeInsets.all(ResponsiveSpacing.adaptive(context)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children.map((child) {
              final itemWidth =
                  (constraints.maxWidth - (spacing * (columnCount - 1))) /
                  columnCount;
              return SizedBox(width: itemWidth, child: child);
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Responsive stacked layout for mobile with grid layout for larger screens
class ResponsiveStackedGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final int tabletColumns;
  final int desktopColumns;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const ResponsiveStackedGrid({
    super.key,
    required this.children,
    this.spacing = ResponsiveSpacing.md,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (AppBreakpoints.isMobile(context)) {
      return ListView.separated(
        padding: padding ?? EdgeInsets.all(ResponsiveSpacing.adaptive(context)),
        physics: physics,
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      );
    }

    return ResponsiveGrid(
      padding: padding,
      spacing: spacing,
      runSpacing: spacing,
      mobileColumns: 1,
      tabletColumns: tabletColumns,
      desktopColumns: desktopColumns,
      children: children,
    );
  }
}

/// Typography enhancement for responsive text scaling
class ResponsiveTypography {
  static TextStyle scaledTextStyle(BuildContext context, TextStyle baseStyle) {
    final textScaler = MediaQuery.textScalerOf(context);
    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null
          ? textScaler.scale(baseStyle.fontSize!)
          : null,
    );
  }

  /// Chart-specific typography
  static TextStyle chartLabel(BuildContext context) {
    return scaledTextStyle(
      context,
      TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Adaptive font size based on screen size
  static double adaptiveFontSize(BuildContext context, double baseFontSize) {
    final textScaler = MediaQuery.textScalerOf(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale based on screen size and user preferences
    double scaleFactor = 1.0;
    if (screenWidth < AppBreakpoints.mobileLarge) {
      scaleFactor = 0.9; // Slightly smaller on very small screens
    } else if (screenWidth >= AppBreakpoints.desktop) {
      scaleFactor = 1.1; // Slightly larger on desktop
    }

    return textScaler.scale(baseFontSize * scaleFactor);
  }
}

/// Responsive padding helper
class ResponsivePadding {
  /// Adaptive padding based on screen size
  static EdgeInsets adaptive(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= AppBreakpoints.desktop && desktop != null) {
      return desktop;
    }

    if (screenWidth >= AppBreakpoints.tablet && tablet != null) {
      return tablet;
    }

    return mobile ?? const EdgeInsets.all(ResponsiveSpacing.md);
  }

  /// Standard screen padding that adapts to screen size
  static EdgeInsets screen(BuildContext context) {
    return adaptive(
      context,
      mobile: const EdgeInsets.all(ResponsiveSpacing.md),
      tablet: const EdgeInsets.all(ResponsiveSpacing.lg),
      desktop: const EdgeInsets.all(ResponsiveSpacing.xl),
    );
  }

  /// Card padding that adapts to screen size
  static EdgeInsets card(BuildContext context) {
    return adaptive(
      context,
      mobile: const EdgeInsets.all(ResponsiveSpacing.md),
      tablet: const EdgeInsets.all(ResponsiveSpacing.lg),
      desktop: const EdgeInsets.all(ResponsiveSpacing.lg),
    );
  }
}

/// Helper for responsive container constraints
class ResponsiveConstraints {
  /// Maximum width constraint that adapts to screen size
  static BoxConstraints maxWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    double maxWidth = double.infinity;
    if (screenWidth >= AppBreakpoints.desktop && desktop != null) {
      maxWidth = desktop;
    } else if (screenWidth >= AppBreakpoints.tablet && tablet != null) {
      maxWidth = tablet;
    } else if (mobile != null) {
      maxWidth = mobile;
    }

    return BoxConstraints(maxWidth: maxWidth);
  }

  /// Common dialog constraints
  static BoxConstraints dialog(BuildContext context) {
    return maxWidth(
      context,
      mobile: MediaQuery.of(context).size.width * 0.9,
      tablet: 500,
      desktop: 600,
    );
  }

  /// Common card constraints
  static BoxConstraints card(BuildContext context) {
    return maxWidth(
      context,
      mobile: double.infinity,
      tablet: 400,
      desktop: 450,
    );
  }
}

/// Utility for responsive bottom sheet heights
class ResponsiveBottomSheet {
  /// Show responsive bottom sheet with height constraints
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    double? maxHeightFactor, // Fraction of screen height (0.0 to 1.0)
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * (maxHeightFactor ?? 0.8),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: ResponsivePadding.adaptive(
            context,
            mobile: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            tablet: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            desktop: const EdgeInsets.fromLTRB(32, 32, 32, 0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: ResponsiveSpacing.md),
              Flexible(child: builder(context)),
              SizedBox(
                height:
                    MediaQuery.of(context).viewPadding.bottom +
                    ResponsiveSpacing.md,
              ),
            ],
          ),
        );
      },
    );
  }
}
