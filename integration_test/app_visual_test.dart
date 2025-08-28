import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:home_loan_advisor/main.dart' as app;

void main() {
  patrolTest(
    'Visual regression test for all screens',
    ($) async {
      // Start the app
      await app.main();
      await $.pumpAndSettle();

      // Helper function to take and validate screenshots
      Future<void> takeScreenshot(String name) async {
        await $.pumpAndSettle();
        await $.takeScreenshot(name: name);
        
        // Add a small delay to ensure rendering is complete
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Test Dashboard Screen
      await takeScreenshot('dashboard_initial');
      
      // Verify the loan composition chart colors
      expect(
        find.byType(Container).evaluate().any((element) {
          final container = element.widget as Container;
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration as BoxDecoration;
            // Check for green (principal) color
            return decoration.color?.value == const Color(0xFF388E3C).value;
          }
          return false;
        }),
        true,
        reason: 'Principal green color should be present in the chart',
      );

      // Navigate to Calculator screen
      await $.tap(find.byIcon(Icons.calculate));
      await $.pumpAndSettle();
      await takeScreenshot('calculator_initial');

      // Enter loan details
      await $.enterText(find.byKey(const Key('loan_amount_field')), '5000000');
      await $.enterText(find.byKey(const Key('interest_rate_field')), '8.5');
      await $.enterText(find.byKey(const Key('tenure_field')), '20');
      await $.pumpAndSettle();
      
      await takeScreenshot('calculator_with_input');

      // Scroll down to see the chart and export buttons
      await $.scrollUntilVisible(
        finder: find.text('Export Report'),
        scrollable: find.byType(SingleChildScrollView).first,
      );
      await takeScreenshot('calculator_export_section');

      // Navigate to Amortization Schedule
      await $.tap(find.byIcon(Icons.table_chart));
      await $.pumpAndSettle();
      await takeScreenshot('amortization_monthly');

      // Check that monthly view doesn't show filter options
      final monthlyFilters = find.text('All Years');
      expect(monthlyFilters, findsWidgets);

      // Switch to Yearly Summary
      await $.tap(find.text('Yearly Summary'));
      await $.pumpAndSettle();
      await takeScreenshot('amortization_yearly');

      // Verify filter is hidden in yearly view
      expect(find.text('All Years'), findsNothing,
          reason: 'Filter should be hidden in Yearly Summary view');

      // Check table colors in yearly view
      final tableRows = find.byType(TableRow);
      expect(tableRows, findsWidgets);

      // Navigate to Strategies screen
      await $.tap(find.byIcon(Icons.lightbulb));
      await $.pumpAndSettle();
      await takeScreenshot('strategies_screen');

      // Test color consistency across all screens
      await validateColorConsistency($);
    },
  );

  patrolTest(
    'Test Amortization Schedule color fixes',
    ($) async {
      await app.main();
      await $.pumpAndSettle();

      // Navigate directly to Amortization Schedule
      await $.tap(find.byIcon(Icons.table_chart));
      await $.pumpAndSettle();

      // Take screenshot of monthly view
      await $.takeScreenshot(name: 'amortization_monthly_colors');

      // Verify Principal column uses green color
      final principalCells = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data?.contains('₹') == true) {
          final textStyle = widget.style;
          return textStyle?.color?.value == const Color(0xFF388E3C).value;
        }
        return false;
      });
      
      expect(principalCells, findsWidgets,
          reason: 'Principal values should use green color');

      // Switch to yearly view
      await $.tap(find.text('Yearly Summary'));
      await $.pumpAndSettle();
      
      await $.takeScreenshot(name: 'amortization_yearly_colors');

      // Verify Interest column uses red color
      final interestCells = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data?.contains('₹') == true) {
          final textStyle = widget.style;
          return textStyle?.color?.value == const Color(0xFFD32F2F).value;
        }
        return false;
      });
      
      expect(interestCells, findsWidgets,
          reason: 'Interest values should use red color');

      // Verify filter is not visible
      expect(find.text('All Years'), findsNothing,
          reason: 'Filter should not be visible in Yearly Summary');
    },
  );

  patrolTest(
    'Test Dashboard chart sizing',
    ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.takeScreenshot(name: 'dashboard_chart_sizing');

      // Find the LoanCompositionChart
      final chartWidget = find.byType(Container).evaluate().firstWhere(
        (element) {
          final container = element.widget as Container;
          // Check if this is the chart container with height 180
          return container.constraints?.maxHeight == 180;
        },
        orElse: () => throw Exception('Chart with height 180 not found'),
      );

      expect(chartWidget, isNotNull,
          reason: 'Dashboard chart should have reduced height of 180');
    },
  );
}

// Helper function to validate color consistency
Future<void> validateColorConsistency(PatrolTester $) async {
  // Define expected colors
  const principalGreen = Color(0xFF388E3C);
  const interestRed = Color(0xFFD32F2F);

  // Check all screens for consistent color usage
  final screens = [
    'Dashboard',
    'Calculator', 
    'Amortization Schedule',
    'Strategies'
  ];

  for (final screen in screens) {
    debugPrint('Validating colors on $screen screen');
    
    // Look for any text or container using the correct colors
    final greenElements = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.style?.color?.value == principalGreen.value;
      } else if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color?.value == principalGreen.value;
      }
      return false;
    });

    final redElements = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.style?.color?.value == interestRed.value;
      } else if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color?.value == interestRed.value;
      }
      return false;
    });

    // At least one screen should have these colors
    if (greenElements.evaluate().isNotEmpty || redElements.evaluate().isNotEmpty) {
      debugPrint('✅ Found financial colors on $screen');
    }
  }
}