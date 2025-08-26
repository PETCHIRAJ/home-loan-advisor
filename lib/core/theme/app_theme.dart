import 'package:flutter/material.dart';
import '../constants/color_constants.dart';
import '../constants/text_styles.dart';

/// Complete Material 3 theme system for Home Loan Advisor
/// 
/// Implements professional, trustworthy design system with:
/// - Inter font family for excellent readability
/// - Trust blue color scheme suitable for financial apps
/// - Indian market-aware design choices
/// - Full light and dark mode support
/// - Accessibility-compliant color contrast
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme based on trust blue with financial context
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: ColorConstants.primary,
        onPrimary: ColorConstants.onPrimary,
        primaryContainer: ColorConstants.primaryContainer,
        onPrimaryContainer: ColorConstants.onPrimaryContainer,
        secondary: ColorConstants.secondary,
        onSecondary: ColorConstants.onSecondary,
        secondaryContainer: ColorConstants.secondaryContainer,
        onSecondaryContainer: ColorConstants.onSecondaryContainer,
        surface: ColorConstants.surface,
        onSurface: ColorConstants.onSurface,
        surfaceVariant: ColorConstants.surfaceVariant,
        onSurfaceVariant: ColorConstants.onSurfaceVariant,
        background: ColorConstants.background,
        onBackground: ColorConstants.onBackground,
        error: ColorConstants.error,
        onError: ColorConstants.onError,
        errorContainer: ColorConstants.errorContainer,
        onErrorContainer: ColorConstants.onErrorContainer,
        outline: ColorConstants.outline,
        outlineVariant: ColorConstants.outlineVariant,
      ),

      // Typography using Inter font
      textTheme: _buildTextTheme(Brightness.light),
      
      // App bar theme
      appBarTheme: _buildAppBarTheme(Brightness.light),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      filledButtonTheme: _buildFilledButtonTheme(Brightness.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(Brightness.light),
      
      // Card theme
      cardTheme: _buildCardTheme(Brightness.light),
      
      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavigationTheme(Brightness.light),
      
      // Navigation bar theme (Material 3)
      navigationBarTheme: _buildNavigationBarTheme(Brightness.light),
      
      // Chip theme
      chipTheme: _buildChipTheme(Brightness.light),
      
      // Dialog theme
      dialogTheme: _buildDialogTheme(Brightness.light),
      
      // Divider theme
      dividerTheme: _buildDividerTheme(Brightness.light),
      
      // Icon theme
      iconTheme: _buildIconTheme(Brightness.light),
      
      // Switch theme
      switchTheme: _buildSwitchTheme(Brightness.light),
      
      // Slider theme
      sliderTheme: _buildSliderTheme(Brightness.light),
      
      // Progress indicator theme
      progressIndicatorTheme: _buildProgressIndicatorTheme(Brightness.light),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Dark color scheme
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: Color(0xFF90CAF9), // Lighter blue for dark mode
        onPrimary: Color(0xFF0D47A1), // Dark blue text
        primaryContainer: Color(0xFF1565C0), // Medium blue container
        onPrimaryContainer: Color(0xFFE3F2FD), // Light blue text
        secondary: Color(0xFF81C784), // Lighter green for dark mode
        onSecondary: Color(0xFF1B5E20), // Dark green text
        secondaryContainer: Color(0xFF388E3C), // Medium green container
        onSecondaryContainer: Color(0xFFF1F8E9), // Light green text
        surface: Color(0xFF121212), // Dark surface
        onSurface: Color(0xFFE0E0E0), // Light text
        surfaceVariant: Color(0xFF1E1E1E), // Darker surface variant
        onSurfaceVariant: Color(0xFFBDBDBD), // Medium light text
        background: Color(0xFF121212), // Dark background
        onBackground: Color(0xFFE0E0E0), // Light text
        error: Color(0xFFEF5350), // Lighter red for dark mode
        onError: Color(0xFF000000), // Black text on error
        errorContainer: Color(0xFFD32F2F), // Medium red container
        onErrorContainer: Color(0xFFFFEBEE), // Light red text
        outline: Color(0xFF424242), // Medium gray borders
        outlineVariant: Color(0xFF2E2E2E), // Darker gray
      ),

      // Typography using Inter font
      textTheme: _buildTextTheme(Brightness.dark),
      
      // App bar theme
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      filledButtonTheme: _buildFilledButtonTheme(Brightness.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(Brightness.dark),
      
      // Card theme
      cardTheme: _buildCardTheme(Brightness.dark),
      
      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavigationTheme(Brightness.dark),
      
      // Navigation bar theme (Material 3)
      navigationBarTheme: _buildNavigationBarTheme(Brightness.dark),
      
      // Chip theme
      chipTheme: _buildChipTheme(Brightness.dark),
      
      // Dialog theme
      dialogTheme: _buildDialogTheme(Brightness.dark),
      
      // Divider theme
      dividerTheme: _buildDividerTheme(Brightness.dark),
      
      // Icon theme
      iconTheme: _buildIconTheme(Brightness.dark),
      
      // Switch theme
      switchTheme: _buildSwitchTheme(Brightness.dark),
      
      // Slider theme
      sliderTheme: _buildSliderTheme(Brightness.dark),
      
      // Progress indicator theme
      progressIndicatorTheme: _buildProgressIndicatorTheme(Brightness.dark),
    );
  }

  // Private helper methods for building component themes

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light 
        ? ColorConstants.onBackground 
        : const Color(0xFFE0E0E0);
        
    return TextTheme(
      // Display styles
      displayLarge: TextStyles.displayLarge.copyWith(color: textColor),
      displayMedium: TextStyles.displayMedium.copyWith(color: textColor),
      displaySmall: TextStyles.displaySmall.copyWith(color: textColor),
      
      // Headline styles
      headlineLarge: TextStyles.headlineLarge.copyWith(color: textColor),
      headlineMedium: TextStyles.headlineMedium.copyWith(color: textColor),
      headlineSmall: TextStyles.headlineSmall.copyWith(color: textColor),
      
      // Title styles
      titleLarge: TextStyles.titleLarge.copyWith(color: textColor),
      titleMedium: TextStyles.titleMedium.copyWith(color: textColor),
      titleSmall: TextStyles.titleSmall.copyWith(color: textColor),
      
      // Body styles
      bodyLarge: TextStyles.bodyLarge.copyWith(color: textColor),
      bodyMedium: TextStyles.bodyMedium.copyWith(color: textColor),
      bodySmall: TextStyles.bodySmall.copyWith(color: textColor),
      
      // Label styles
      labelLarge: TextStyles.labelLarge.copyWith(color: textColor),
      labelMedium: TextStyles.labelMedium.copyWith(color: textColor),
      labelSmall: TextStyles.labelSmall.copyWith(color: textColor),
    );
  }

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: brightness == Brightness.light 
          ? ColorConstants.surface 
          : const Color(0xFF121212),
      foregroundColor: brightness == Brightness.light 
          ? ColorConstants.onSurface 
          : const Color(0xFFE0E0E0),
      titleTextStyle: TextStyles.titleLarge.copyWith(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurface 
            : const Color(0xFFE0E0E0),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurface 
            : const Color(0xFFE0E0E0),
        size: 24,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorConstants.onPrimary,
        backgroundColor: ColorConstants.primary,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonMedium,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(Brightness brightness) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: ColorConstants.onPrimary,
        backgroundColor: ColorConstants.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonMedium,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Brightness brightness) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        side: const BorderSide(
          color: ColorConstants.primary,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonMedium,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyles.buttonMedium,
        minimumSize: const Size(64, 48),
      ),
    );
  }

  static CardThemeData _buildCardTheme(Brightness brightness) {
    return CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.transparent,
      color: brightness == Brightness.light 
          ? ColorConstants.cardBackground 
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: brightness == Brightness.light 
              ? ColorConstants.outline.withOpacity(0.12)
              : const Color(0xFF424242).withOpacity(0.12),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(8),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light 
          ? ColorConstants.surfaceVariant 
          : const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.light 
              ? ColorConstants.outline 
              : const Color(0xFF424242),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.light 
              ? ColorConstants.outline 
              : const Color(0xFF424242),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: ColorConstants.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: ColorConstants.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: ColorConstants.error,
          width: 2,
        ),
      ),
      labelStyle: TextStyles.bodyMedium.copyWith(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurfaceVariant 
            : const Color(0xFFBDBDBD),
      ),
      hintStyle: TextStyles.bodyMedium.copyWith(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurfaceVariant.withOpacity(0.6)
            : const Color(0xFFBDBDBD).withOpacity(0.6),
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationTheme(Brightness brightness) {
    return BottomNavigationBarThemeData(
      backgroundColor: brightness == Brightness.light 
          ? ColorConstants.surface 
          : const Color(0xFF121212),
      selectedItemColor: ColorConstants.primary,
      unselectedItemColor: brightness == Brightness.light 
          ? ColorConstants.onSurfaceVariant 
          : const Color(0xFFBDBDBD),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyles.navigationLabel,
      unselectedLabelStyle: TextStyles.navigationLabel,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(Brightness brightness) {
    return NavigationBarThemeData(
      backgroundColor: brightness == Brightness.light 
          ? ColorConstants.surface 
          : const Color(0xFF121212),
      indicatorColor: ColorConstants.primaryContainer,
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
        if (states.contains(MaterialState.selected)) {
          return TextStyles.navigationLabel.copyWith(color: ColorConstants.primary);
        }
        return TextStyles.navigationLabel.copyWith(
          color: brightness == Brightness.light 
              ? ColorConstants.onSurfaceVariant 
              : const Color(0xFFBDBDBD),
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: ColorConstants.onPrimaryContainer, size: 24);
        }
        return IconThemeData(
          color: brightness == Brightness.light 
              ? ColorConstants.onSurfaceVariant 
              : const Color(0xFFBDBDBD),
          size: 24,
        );
      }),
    );
  }

  static ChipThemeData _buildChipTheme(Brightness brightness) {
    return ChipThemeData(
      backgroundColor: brightness == Brightness.light 
          ? ColorConstants.surfaceVariant 
          : const Color(0xFF1E1E1E),
      deleteIconColor: brightness == Brightness.light 
          ? ColorConstants.onSurfaceVariant 
          : const Color(0xFFBDBDBD),
      disabledColor: brightness == Brightness.light 
          ? ColorConstants.outline.withOpacity(0.12)
          : const Color(0xFF424242).withOpacity(0.12),
      selectedColor: ColorConstants.primaryContainer,
      secondarySelectedColor: ColorConstants.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyles.labelMedium,
      secondaryLabelStyle: TextStyles.labelMedium,
      brightness: brightness,
      elevation: 0,
      pressElevation: 1,
    );
  }

  static DialogThemeData _buildDialogTheme(Brightness brightness) {
    return DialogThemeData(
      backgroundColor: brightness == Brightness.light 
          ? ColorConstants.surface 
          : const Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyles.headlineSmall.copyWith(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurface 
            : const Color(0xFFE0E0E0),
      ),
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: brightness == Brightness.light 
            ? ColorConstants.onSurfaceVariant 
            : const Color(0xFFBDBDBD),
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(Brightness brightness) {
    return DividerThemeData(
      color: brightness == Brightness.light 
          ? ColorConstants.outline.withOpacity(0.12)
          : const Color(0xFF424242).withOpacity(0.12),
      thickness: 1,
      space: 1,
    );
  }

  static IconThemeData _buildIconTheme(Brightness brightness) {
    return IconThemeData(
      color: brightness == Brightness.light 
          ? ColorConstants.onSurface 
          : const Color(0xFFE0E0E0),
      size: 24,
    );
  }

  static SwitchThemeData _buildSwitchTheme(Brightness brightness) {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorConstants.onPrimary;
        }
        return brightness == Brightness.light 
            ? ColorConstants.outline 
            : const Color(0xFF424242);
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorConstants.primary;
        }
        return brightness == Brightness.light 
            ? ColorConstants.surfaceVariant 
            : const Color(0xFF1E1E1E);
      }),
    );
  }

  static SliderThemeData _buildSliderTheme(Brightness brightness) {
    return SliderThemeData(
      activeTrackColor: ColorConstants.primary,
      inactiveTrackColor: brightness == Brightness.light 
          ? ColorConstants.outline.withOpacity(0.38)
          : const Color(0xFF424242).withOpacity(0.38),
      thumbColor: ColorConstants.primary,
      overlayColor: ColorConstants.primary.withOpacity(0.12),
      valueIndicatorColor: ColorConstants.primary,
      valueIndicatorTextStyle: TextStyles.labelMedium.copyWith(
        color: ColorConstants.onPrimary,
      ),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(Brightness brightness) {
    return const ProgressIndicatorThemeData(
      color: ColorConstants.primary,
      linearTrackColor: ColorConstants.outline,
      circularTrackColor: ColorConstants.outline,
    );
  }
}