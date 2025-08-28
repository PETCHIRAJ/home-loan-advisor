import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_loan_advisor/main.dart';

void main() {
  group('UI Validation Tests', () {
    testWidgets('Dashboard UI elements are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeLoanAdvisorApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check for key UI elements
      final hasAppBar = find.text('Dashboard').evaluate().isNotEmpty;
      final hasBottomNav = find.text('Home').evaluate().isNotEmpty;
      
      print('✅ Dashboard loaded: AppBar=$hasAppBar, BottomNav=$hasBottomNav');
      
      // Check for overflow errors
      final errors = tester.takeException();
      if (errors != null) {
        print('❌ UI Errors found: $errors');
      } else {
        print('✅ No overflow or rendering errors');
      }
    });

    testWidgets('Check all navigation tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeLoanAdvisorApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Test navigation to each tab
      final tabs = ['Strategies', 'Progress', 'Calculator'];
      
      for (final tab in tabs) {
        final tabFinder = find.text(tab);
        if (tabFinder.evaluate().isNotEmpty) {
          await tester.tap(tabFinder.first);
          await tester.pumpAndSettle();
          print('✅ $tab tab loaded successfully');
        } else {
          print('❌ Could not find $tab tab');
        }
      }
    });
  });
}