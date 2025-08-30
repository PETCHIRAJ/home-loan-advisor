import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color seedColor = Color(0xFF1565C0); // Trust Blue

  // Light Theme Colors
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0), // Trust Blue
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD4E3FF),
    onPrimaryContainer: Color(0xFF001C3A),

    secondary: Color(0xFF00897B), // Success Teal (for savings)
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFA2F0E3),
    onSecondaryContainer: Color(0xFF002020),

    tertiary: Color(0xFFFF6F00), // Alert Orange (for urgency)
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDDB3),
    onTertiaryContainer: Color(0xFF291800),

    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    surface: Color(0xFFFAFDFF),
    onSurface: Color(0xFF001F2A),

    surfaceContainerHighest: Color(0xFFDFE2EB),
    onSurfaceVariant: Color(0xFF43474E),

    outline: Color(0xFF73777F),
    outlineVariant: Color(0xFFC3C6CF),
  );

  // Dark Theme Colors
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA6C8FF),
    onPrimary: Color(0xFF003060),
    primaryContainer: Color(0xFF004788),
    onPrimaryContainer: Color(0xFFD4E3FF),

    secondary: Color(0xFF4FD8C9),
    onSecondary: Color(0xFF003733),
    secondaryContainer: Color(0xFF00504A),
    onSecondaryContainer: Color(0xFFA2F0E3),

    tertiary: Color(0xFFFFB871),
    onTertiary: Color(0xFF452B00),
    tertiaryContainer: Color(0xFF633F00),
    onTertiaryContainer: Color(0xFFFFDDB3),

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    surface: Color(0xFF001F2A),
    onSurface: Color(0xFFB4E6FF),

    surfaceContainerHighest: Color(0xFF43474E),
    onSurfaceVariant: Color(0xFFC3C6CF),

    outline: Color(0xFF8D9199),
    outlineVariant: Color(0xFF43474E),
  );

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: _textTheme,

      // Component Themes
      cardTheme: const CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: lightColorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      chipTheme: const ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      sliderTheme: const SliderThemeData(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: _textTheme,

      // Similar component themes with dark colors
      cardTheme: const CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: darkColorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  static TextTheme get _textTheme => TextTheme(
    // Display - For hero EMI amount
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),

    // Headlines - For section titles
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),

    // Titles - For cards and lists
    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),

    // Body - For descriptions
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),

    // Labels - For buttons and inputs
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

// Semantic Colors for Financial Context
class FinancialColors {
  // Status Colors
  static const Color savings = Color(0xFF00897B); // Teal for positive savings
  static const Color cost = Color(0xFFD32F2F); // Red for costs
  static const Color neutral = Color(0xFF757575); // Grey for neutral info

  // Special Features
  static const Color taxBenefit = Color(0xFF2E7D32); // Green for tax savings
  static const Color pmayBenefit = Color(0xFF1565C0); // Blue for PMAY
  static const Color prepayment = Color(0xFFF57C00); // Orange for prepayment

  // Bank Categories
  static const Color publicBank = Color(0xFF1976D2); // Blue for PSU banks
  static const Color privateBank = Color(
    0xFF7B1FA2,
  ); // Purple for private banks
  static const Color nbfc = Color(0xFF00796B); // Teal for NBFCs
}

// Typography for Financial Data
class FinancialTypography {
  // Special Number Formatting for EMI/Money
  static TextStyle emiAmount = GoogleFonts.robotoMono(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static TextStyle moneyLarge = GoogleFonts.robotoMono(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle moneyMedium = GoogleFonts.robotoMono(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle moneySmall = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

// Spacing System
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
