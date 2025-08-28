import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_loan_advisor/main.dart';

void main() {
  testWidgets('App UI Test - Navigate through all screens', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Test Dashboard
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Daily Interest Burn'), findsOneWidget);
    
    // Navigate to Strategies
    await tester.tap(find.text('Strategies'));
    await tester.pumpAndSettle();
    expect(find.text('INSTANT EYE-OPENERS'), findsOneWidget);
    
    // Navigate to Progress
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsWidgets);
    
    // Navigate to Calculator
    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();
    expect(find.text('Loan Amount'), findsOneWidget);
    
    // Print success
    print('✅ All screens loaded successfully!');
  });
}