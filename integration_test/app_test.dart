import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_loan_advisor/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation and Content Tests', () {
    testWidgets('Navigate through all screens and verify content', (WidgetTester tester) async {
      // Start the app
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeLoanAdvisorApp(),
        ),
      );
      await tester.pumpAndSettle();
      
      print('🔍 Starting navigation test...');
      
      // 1. Verify Dashboard loads (default screen)
      print('📍 Testing Dashboard...');
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Daily Interest Burn'), findsOneWidget);
      expect(find.text('Loan Breakdown'), findsOneWidget);
      print('✅ Dashboard loaded successfully');
      
      // 2. Navigate to Strategies
      print('📍 Navigating to Strategies...');
      await tester.tap(find.byIcon(Icons.monetization_on_outlined));
      await tester.pumpAndSettle();
      
      expect(find.text('Strategies'), findsOneWidget);
      expect(find.text('Smart Strategies'), findsOneWidget);
      print('✅ Strategies page loaded');
      
      // 3. Navigate to Progress
      print('📍 Navigating to Progress...');
      await tester.tap(find.byIcon(Icons.trending_up_outlined));
      await tester.pumpAndSettle();
      
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Achievement Tracker'), findsOneWidget);
      print('✅ Progress page loaded');
      
      // 4. Navigate to Calculator
      print('📍 Navigating to Calculator...');
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      
      expect(find.text('Calculator'), findsOneWidget);
      expect(find.text('LOAN DETAILS'), findsOneWidget);
      expect(find.text('Loan Amount'), findsOneWidget);
      expect(find.text('Interest Rate'), findsOneWidget);
      expect(find.text('Loan Tenure'), findsOneWidget);
      print('✅ Calculator page loaded');
      
      // 5. Test Calculator input
      print('📝 Testing Calculator inputs...');
      
      // Clear and enter loan amount
      final loanAmountField = find.ancestor(
        of: find.text('Loan Amount'),
        matching: find.byType(Column),
      ).evaluate().first.widget as Column;
      
      final textField = find.descendant(
        of: find.byType(TextFormField),
        matching: find.byType(EditableText),
      ).first;
      
      await tester.enterText(textField, '5000000');
      await tester.pumpAndSettle();
      print('✅ Loan amount entered');
      
      // 6. Navigate back to Home
      print('📍 Returning to Dashboard...');
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      
      expect(find.text('Dashboard'), findsOneWidget);
      print('✅ Returned to Dashboard');
      
      // Summary
      print('\n' + '=' * 50);
      print('📊 NAVIGATION TEST RESULTS');
      print('=' * 50);
      print('✅ Dashboard - Loaded successfully');
      print('✅ Strategies - Loaded successfully');
      print('✅ Progress - Loaded successfully');
      print('✅ Calculator - Loaded successfully');
      print('✅ Navigation - Working correctly');
      print('✅ All screens accessible');
      print('=' * 50);
    });

    testWidgets('Check for overflow issues on Calculator screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeLoanAdvisorApp(),
        ),
      );
      await tester.pumpAndSettle();
      
      print('🔍 Checking for overflow issues...');
      
      // Navigate to Calculator
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      
      // Check if there are any overflow errors in the render tree
      // Simply check if the screen renders without errors
      await tester.pump();
      
      // If we got here without exceptions, no overflow
      print('✅ No overflow detected on Calculator screen');
    });

    testWidgets('Verify all bottom navigation tabs are clickable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeLoanAdvisorApp(),
        ),
      );
      await tester.pumpAndSettle();
      
      print('🔍 Testing bottom navigation...');
      
      // Test each navigation tab
      final tabs = [
        (Icons.home_outlined, 'Home'),
        (Icons.monetization_on_outlined, 'Strategies'),
        (Icons.trending_up_outlined, 'Progress'),
        (Icons.analytics_outlined, 'Calculator'),
      ];
      
      for (final (icon, name) in tabs) {
        print('Testing $name tab...');
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
        
        // Verify we can tap it without errors
        expect(find.byIcon(icon), findsOneWidget);
        print('✅ $name tab is clickable');
      }
      
      print('✅ All navigation tabs working');
    });
  });
}