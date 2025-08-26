import 'package:flutter/material.dart';

/// Typography system using Inter font family
///
/// Defines text styles following Material Design 3 typography scale
/// with Inter font for excellent readability and modern appearance.
class TextStyles {
  // Private constructor to prevent instantiation
  TextStyles._();

  // Base font family
  static const String fontFamily = 'Inter';

  // Display Styles (Large promotional content)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.0,
    height: 1.22,
  );

  // Headline Styles (Page titles, major sections)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 0.0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.0,
    height: 1.33,
  );

  // Title Styles (Card titles, section headers)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Label Styles (Button text, field labels)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Body Styles (Main content, descriptions)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.5,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Custom Financial Display Styles
  static const TextStyle currencyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.5,
    height: 1.25,
    // Optimized for Indian currency display like ₹50,00,000
  );

  static const TextStyle currencyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.25,
    height: 1.33,
    // Perfect for EMI amounts and savings displays
  );

  static const TextStyle currencySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.0,
    height: 1.22,
    // Ideal for percentage displays and smaller amounts
  );

  // Navigation Styles
  static const TextStyle navigationLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.5,
    height: 1.33,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.5,
    height: 1.33,
  );

  // Chart and Data Display
  static const TextStyle chartTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle chartLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle chartValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    height: 1.43,
  );
}