// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:home_loan_advisor/main.dart';

void main() {
  testWidgets('Home Loan Advisor app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeLoanAdvisorApp());
    await tester.pumpAndSettle();

    // Verify that the app loads with navigation tabs
    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Strategies'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);

    // Verify main calculator elements are present
    expect(find.text('Loan Details'), findsOneWidget);
  });
}
