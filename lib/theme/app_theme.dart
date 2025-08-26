import 'package:flutter/material.dart';

class AppTheme {
  // Color Scheme
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color primaryBlueDark = Color(0xFF0D47A1);
  static const Color secondaryTeal = Color(0xFF00796B);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningOrange = Color(0xFFF57C00);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color goldAccent = Color(0xFFFFB300);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color outline = Color(0xFF79747E);

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: primaryBlue,
    brightness: Brightness.light,
    primary: primaryBlue,
    secondary: secondaryTeal,
    surface: surface,
    onSurface: onSurface,
    outline: outline,
    error: errorRed,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: outline,
        elevation: 8,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),

      // Text Field Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }
}

// Custom Text Styles
class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    height: 64/57,
    fontWeight: FontWeight.w700,
    color: AppTheme.onSurface,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    height: 40/32,
    fontWeight: FontWeight.w600,
    color: AppTheme.onSurface,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    height: 28/22,
    fontWeight: FontWeight.w500,
    color: AppTheme.onSurface,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 24/16,
    fontWeight: FontWeight.w400,
    color: AppTheme.onSurface,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 20/14,
    fontWeight: FontWeight.w500,
    color: AppTheme.onSurface,
  );

  // Currency specific styles
  static const TextStyle currencyLarge = TextStyle(
    fontSize: 32,
    height: 40/32,
    fontWeight: FontWeight.w700,
    color: AppTheme.primaryBlue,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle currencyMedium = TextStyle(
    fontSize: 20,
    height: 24/20,
    fontWeight: FontWeight.w600,
    color: AppTheme.primaryBlue,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}