# Material 3 Design System - Home Loan Advisor

## 1. Color System

### Primary Color Scheme
Based on trust and financial stability while maintaining approachability.

```dart
// Flutter ThemeData Configuration
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color seedColor = Color(0xFF1565C0); // Trust Blue
  
  // Light Theme Colors
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0),        // Trust Blue
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD4E3FF),
    onPrimaryContainer: Color(0xFF001C3A),
    
    secondary: Color(0xFF00897B),       // Success Teal (for savings)
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFA2F0E3),
    onSecondaryContainer: Color(0xFF002020),
    
    tertiary: Color(0xFFFF6F00),        // Alert Orange (for urgency)
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDDB3),
    onTertiaryContainer: Color(0xFF291800),
    
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    background: Color(0xFFFAFDFF),
    onBackground: Color(0xFF001F2A),
    
    surface: Color(0xFFFAFDFF),
    onSurface: Color(0xFF001F2A),
    surfaceVariant: Color(0xFFDFE2EB),
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
    
    // ... (complete dark theme)
  );
}
```

### Semantic Colors for Financial Context

```dart
class FinancialColors {
  // Status Colors
  static const Color savings = Color(0xFF00897B);      // Teal for positive savings
  static const Color cost = Color(0xFFD32F2F);         // Red for costs
  static const Color neutral = Color(0xFF757575);      // Grey for neutral info
  
  // Special Features
  static const Color taxBenefit = Color(0xFF2E7D32);   // Green for tax savings
  static const Color pmayBenefit = Color(0xFF1565C0);  // Blue for PMAY
  static const Color prepayment = Color(0xFFF57C00);   // Orange for prepayment
  
  // Bank Categories
  static const Color publicBank = Color(0xFF1976D2);   // Blue for PSU banks
  static const Color privateBank = Color(0xFF7B1FA2);  // Purple for private banks
  static const Color nbfc = Color(0xFF00796B);         // Teal for NBFCs
}
```

## 2. Typography System

### Font Selection
```dart
// Google Fonts for Flutter
dependencies:
  google_fonts: ^6.1.0

// Typography Configuration
class AppTypography {
  static TextTheme textTheme = TextTheme(
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
}
```

## 3. Component Specifications

### Custom Calculator Widgets

```dart
// Hybrid Slider + TextField Widget
class HybridNumberInput extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final String prefix;
  final Function(double) onChanged;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: 8),
            Row(
              children: [
                Text(prefix, style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _formatNumber(value)),
                    style: AppTypography.moneyLarge,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (text) => _handleTextChange(text),
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: 100,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// Tax Benefit Card
class TaxBenefitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: FinancialColors.taxBenefit.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: FinancialColors.taxBenefit, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: FinancialColors.taxBenefit),
                SizedBox(width: 8),
                Text('Tax Benefits', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            // Tax calculations UI
          ],
        ),
      ),
    );
  }
}

// Strategy Card Design
class StrategyCard extends StatelessWidget {
  final Strategy strategy;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(strategy.difficulty),
                    backgroundColor: _getDifficultyColor(strategy.difficulty),
                  ),
                  Text(
                    '₹${_formatIndianNumber(strategy.savings)}',
                    style: AppTypography.moneyLarge.copyWith(
                      color: FinancialColors.savings,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(strategy.title, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text(strategy.description, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: strategy.impactScore / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(FinancialColors.savings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Button Hierarchy

```dart
class AppButtons {
  // Primary CTA - Calculate EMI
  static Widget primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
  
  // Secondary Actions
  static Widget secondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
  
  // Tertiary Actions
  static Widget textButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

## 4. Iconography

### Icon Set
```dart
class AppIcons {
  // Custom Icons for Indian Context
  static const IconData rupee = IconData(0x20B9, fontFamily: 'MaterialIcons');
  static const IconData pmay = Icons.home_work_outlined;
  static const IconData tax = Icons.receipt_long_outlined;
  
  // Navigation Icons
  static const IconData calculator = Icons.calculate_outlined;
  static const IconData strategies = Icons.lightbulb_outline;
  
  // Feature Icons
  static const IconData banks = Icons.account_balance_outlined;
  static const IconData savings = Icons.savings_outlined;
  static const IconData prepayment = Icons.trending_down_outlined;
  static const IconData comparison = Icons.compare_arrows_outlined;
  
  // Status Icons
  static const IconData eligible = Icons.check_circle_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData info = Icons.info_outline;
}
```

## 5. Motion & Interactions

### Animation Specifications
```dart
class AppAnimations {
  // Page Transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;
  
  // Micro-interactions
  static const Duration microInteraction = Duration(milliseconds: 200);
  static const Duration numberCounter = Duration(milliseconds: 1000);
  
  // Loading States
  static Widget shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  // Success Animation
  static Widget successCheckmark() {
    return Lottie.asset(
      'assets/animations/success.json',
      width: 120,
      height: 120,
      repeat: false,
    );
  }
}
```

## 6. Responsive Breakpoints

```dart
class Breakpoints {
  static const double mobileSmall = 320;   // SE, older phones
  static const double mobile = 375;        // Standard phones
  static const double mobileLarge = 414;   // Plus size phones
  static const double tablet = 768;        // iPad Mini
  static const double tabletLarge = 1024;  // iPad Pro
  static const double foldable = 800;      // Unfolded state
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.tablet && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
```

## 7. Accessibility Guidelines

```dart
class AccessibilityConfig {
  // Minimum touch targets
  static const double minTouchTarget = 48.0; // Material guideline
  
  // Color Contrast Ratios (WCAG AA)
  static const double normalTextContrast = 4.5;
  static const double largeTextContrast = 3.0;
  
  // Semantic Labels
  static String emiAmountLabel(String amount) => 
    'Your monthly EMI will be $amount rupees';
  
  static String taxSavingsLabel(String amount) => 
    'You can save $amount rupees in taxes annually';
  
  // Screen Reader Hints
  static const Map<String, String> hints = {
    'slider': 'Double tap and swipe to adjust the value',
    'expandable': 'Double tap to expand for more options',
    'result': 'Calculation complete. Swipe down for details',
  };
}
```

## 8. Indian Market Adaptations

```dart
class IndianNumberFormatter {
  // Format as lakhs and crores
  static String formatIndianNumber(double number) {
    if (number >= 10000000) {
      return '₹${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '₹${(number / 100000).toStringAsFixed(2)} L';
    } else {
      return '₹${NumberFormat('#,##,###').format(number)}';
    }
  }
  
  // Input formatter for text fields
  static TextInputFormatter indianNumberFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(',', '');
      if (text.isEmpty) return newValue;
      
      final number = int.tryParse(text);
      if (number == null) return oldValue;
      
      final formatted = NumberFormat('#,##,##,###').format(number);
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }
}
```

## 9. Complete Theme Configuration

```dart
class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: AppTypography.textTheme,
      
      // Component Themes
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: AppTypography.textTheme,
      // Similar component themes with dark colors
    );
  }
}
```

## 10. Implementation Guidelines

### Widget Composition Best Practices

1. **Use Composition Over Inheritance**
```dart
// Good: Composed widget
class EMIResultCard extends StatelessWidget {
  final double emiAmount;
  final double taxSavings;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildEMIDisplay(),
          if (taxSavings > 0) _buildTaxSavingsChip(),
          _buildActionButtons(),
        ],
      ),
    );
  }
}
```

2. **Consistent Spacing System**
```dart
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
```

3. **State Management for Theme**
```dart
// Using Riverpod for theme management
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);
  
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
```

## Summary

This Material 3 design system provides:
- ✅ Complete color system with semantic financial colors
- ✅ Typography optimized for financial data display
- ✅ Custom widgets for calculator and strategies
- ✅ Indian market adaptations (₹, lakhs/crores)
- ✅ Accessibility-first approach
- ✅ Responsive design patterns
- ✅ Motion and interaction guidelines
- ✅ Complete Flutter theme configuration

The design balances professionalism with approachability, ensuring users trust the app with their financial calculations while finding it easy to use.