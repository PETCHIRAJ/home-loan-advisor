import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_navigation.dart';
import 'onboarding/onboarding_screen.dart';
import 'strategies/strategy_detail_screen.dart';
import 'calculator/amortization_schedule_screen.dart';

/// Test screen that displays all app screens in a scrollable list
/// This allows comprehensive UI testing without manual navigation
class TestAllUIScreen extends ConsumerWidget {
  const TestAllUIScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Test - All Screens'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildScreenCard(
            context,
            'Onboarding Screen',
            const OnboardingScreen(),
          ),
          _buildScreenCard(
            context,
            'Main App (Dashboard, Calculator, etc.)',
            const MainNavigation(),
          ),
          _buildScreenCard(
            context,
            'Strategy Detail Screen',
            const StrategyDetailScreen(),
          ),
          _buildScreenCard(
            context,
            'Amortization Schedule',
            const AmortizationScheduleScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenCard(BuildContext context, String title, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 600,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRect(
              child: screen,
            ),
          ),
        ],
      ),
    );
  }
}