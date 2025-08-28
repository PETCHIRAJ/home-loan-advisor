import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class to verify theme consistency and font loading
class ThemeVerification {
  static const String _fontFamily = 'Inter';
  
  /// Verify that fonts are properly loaded
  static Future<bool> verifyFontsLoaded() async {
    try {
      // Check if font files exist in the asset bundle
      final bundle = rootBundle;
      
      final fontFiles = [
        'assets/fonts/Inter-Regular.ttf',
        'assets/fonts/Inter-Medium.ttf', 
        'assets/fonts/Inter-Bold.ttf',
      ];
      
      for (final fontFile in fontFiles) {
        try {
          await bundle.load(fontFile);
        } catch (e) {
          debugPrint('Font file not found: $fontFile');
          return false;
        }
      }
      
      return true;
    } catch (e) {
      debugPrint('Error verifying fonts: $e');
      return false;
    }
  }
  
  /// Verify header consistency across different screen configurations
  static bool verifyHeaderConsistency(
    AppBar appBar1, 
    AppBar appBar2,
  ) {
    // Check if both AppBars have consistent properties
    return appBar1.preferredSize == appBar2.preferredSize &&
           appBar1.backgroundColor == appBar2.backgroundColor &&
           appBar1.elevation == appBar2.elevation &&
           appBar1.toolbarHeight == appBar2.toolbarHeight;
  }
  
  /// Get diagnostic information about theme and fonts
  static Map<String, dynamic> getDiagnosticInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return {
      'font_family': theme.textTheme.bodyMedium?.fontFamily,
      'expected_font': _fontFamily,
      'is_correct_font': theme.textTheme.bodyMedium?.fontFamily == _fontFamily,
      'app_bar_height': AppBar().preferredSize.height,
      'color_scheme_brightness': theme.brightness.name,
      'surface_color': theme.colorScheme.surface.toString(),
      'primary_color': theme.colorScheme.primary.toString(),
    };
  }
  
  /// Print theme diagnostic information to console
  static void printDiagnostics(BuildContext context) {
    final info = getDiagnosticInfo(context);
    debugPrint('=== Theme Diagnostics ===');
    info.forEach((key, value) {
      debugPrint('$key: $value');
    });
    debugPrint('========================');
  }
}