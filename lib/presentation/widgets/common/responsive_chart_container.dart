import 'package:flutter/material.dart';

/// Responsive chart container that handles chart sizing and horizontal scrolling
/// for small screens to fix chart readability issues
class ResponsiveChartContainer extends StatelessWidget {
  final Widget chart;
  final double? fixedHeight;
  final bool enableHorizontalScroll;
  final EdgeInsets? padding;

  const ResponsiveChartContainer({
    super.key,
    required this.chart,
    this.fixedHeight,
    this.enableHorizontalScroll = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    // Calculate responsive dimensions
    final chartHeight = fixedHeight ?? _calculateChartHeight(screenSize);
    final chartWidth = enableHorizontalScroll && isSmallScreen 
      ? screenSize.width * 1.2 // 20% wider than screen for scrolling
      : screenSize.width - (padding?.horizontal ?? 32);

    Widget chartWidget = SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: chart,
    );

    // Wrap in horizontal scroll for small screens
    if (enableHorizontalScroll && isSmallScreen) {
      chartWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: chartWidget,
      );
    } else {
      chartWidget = Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
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

/// Helper class for adaptive chart labels to prevent overlapping
class AdaptiveChartLabels {
  static List<String> adaptLabelsForWidth(
    List<String> labels, 
    double availableWidth,
    TextStyle labelStyle,
  ) {
    if (labels.isEmpty) return labels;
    
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    );

    // Calculate average character width
    painter.text = TextSpan(text: 'W', style: labelStyle);
    painter.layout();
    final charWidth = painter.width;

    final maxCharsPerLabel = (availableWidth / labels.length / charWidth).floor();
    
    if (maxCharsPerLabel <= 2) return labels; // Don't truncate if too small
    
    return labels.map((label) {
      if (label.length <= maxCharsPerLabel) return label;
      
      // Smart truncation - preserve important parts
      if (label.contains(' ')) {
        final words = label.split(' ');
        if (words.length > 1) {
          final firstWordLength = words[0].length > 4 ? 4 : words[0].length;
          return '${words[0].substring(0, firstWordLength)}..';
        }
      }
      
      return '${label.substring(0, maxCharsPerLabel - 2)}..';
    }).toList();
  }
  
  /// Calculate optimal rotation angle for labels based on width
  static double calculateLabelRotation(List<String> labels, double availableWidth) {
    if (labels.isEmpty) return 0.0;
    
    final averageLabelWidth = availableWidth / labels.length;
    const minLabelWidth = 40.0; // Minimum width for readable text
    
    if (averageLabelWidth < minLabelWidth) {
      return -45.0; // Rotate 45 degrees for better readability
    }
    
    return 0.0; // No rotation needed
  }
}