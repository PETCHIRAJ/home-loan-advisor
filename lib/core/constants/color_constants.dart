import 'package:flutter/material.dart';

/// Material 3 color system for Home Loan Advisor
///
/// Defines the complete color palette following Material Design 3
/// guidelines with focus on Indian market preferences.
class ColorConstants {
  // Private constructor to prevent instantiation
  ColorConstants._();

  // Primary Brand Colors (Trust & Reliability - Blue theme)
  static const Color primarySeed = Color(0xFF1976D2);
  static const Color primary = Color(0xFF1976D2);        // Primary blue
  static const Color onPrimary = Color(0xFFFFFFFF);      // White text on primary
  static const Color primaryContainer = Color(0xFFE3F2FD);  // Light blue container
  static const Color onPrimaryContainer = Color(0xFF0D47A1); // Dark blue text

  // Secondary Colors (Growth & Success - Green accents)
  static const Color secondary = Color(0xFF4CAF50);      // Success green
  static const Color onSecondary = Color(0xFFFFFFFF);    // White text on secondary
  static const Color secondaryContainer = Color(0xFFF1F8E9); // Light green container
  static const Color onSecondaryContainer = Color(0xFF1B5E20); // Dark green text

  // Surface Colors (Clean & Modern)
  static const Color surface = Color(0xFFFCFCFC);        // Almost white
  static const Color onSurface = Color(0xFF1A1A1A);      // Almost black text
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light gray surface
  static const Color onSurfaceVariant = Color(0xFF484848); // Medium gray text

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);     // Pure white
  static const Color onBackground = Color(0xFF1A1A1A);   // Almost black

  // Error Colors (Financial warnings)
  static const Color error = Color(0xFFD32F2F);          // Red
  static const Color onError = Color(0xFFFFFFFF);        // White text on error
  static const Color errorContainer = Color(0xFFFFEBEE); // Light red container
  static const Color onErrorContainer = Color(0xFFB71C1C); // Dark red text

  // Outline Colors
  static const Color outline = Color(0xFFE0E0E0);        // Light gray borders
  static const Color outlineVariant = Color(0xFFF5F5F5); // Very light gray

  // Financial Status Colors
  static const Color savingsGreen = Color(0xFF2E7D32);   // Money saved
  static const Color warningAmber = Color(0xFFFF8F00);   // Caution
  static const Color infoBlue = Color(0xFF1565C0);       // Information

  // Chart Colors (Professional & Distinct)
  static const List<Color> chartColors = [
    Color(0xFF1976D2), // Primary blue
    Color(0xFF4CAF50), // Success green
    Color(0xFFFF8F00), // Warning amber
    Color(0xFF7B1FA2), // Purple
    Color(0xFFD32F2F), // Error red
    Color(0xFF00796B), // Teal
    Color(0xFF5E35B1), // Deep purple
    Color(0xFFE64A19), // Deep orange
  ];

  // Semantic Colors for Loan Status
  static const Color loanHealthExcellent = Color(0xFF2E7D32); // Dark green
  static const Color loanHealthGood = Color(0xFF689F38);      // Light green
  static const Color loanHealthAverage = Color(0xFFFF8F00);   // Amber
  static const Color loanHealthPoor = Color(0xFFD32F2F);      // Red

  // Currency Display Colors
  static const Color currencyPositive = Color(0xFF2E7D32);   // Green for savings
  static const Color currencyNegative = Color(0xFFD32F2F);   // Red for costs
  static const Color currencyNeutral = Color(0xFF424242);    // Gray for neutral

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1976D2);
  static const Color buttonSecondary = Color(0xFF4CAF50);
  static const Color buttonOutlined = Color(0x001976D2);     // Transparent with border
  static const Color buttonText = Color(0xFF1976D2);

  // Card & Container Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color cardShadow = Color(0x1A000000);         // 10% black shadow

  // Progress & Achievement Colors
  static const Color progressIncomplete = Color(0xFFE0E0E0);
  static const Color progressComplete = Color(0xFF4CAF50);
  static const Color achievementGold = Color(0xFFFFD700);
  static const Color achievementSilver = Color(0xFFC0C0C0);
  static const Color achievementBronze = Color(0xFFCD7F32);
}