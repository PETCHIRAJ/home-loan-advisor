import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'calculator/calculator_screen.dart';
import 'strategies/strategies_screen.dart';
import 'progress/progress_screen.dart';

/// Main navigation widget with Material 3 bottom navigation bar
/// 
/// Provides navigation between the four main screens:
/// - Dashboard: Daily interest burn counter and loan health overview
/// - Calculator: EMI calculation and loan input forms
/// - Strategies: Loan optimization strategies and recommendations
/// - Progress: Loan payment tracking and progress visualization
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of screen widgets for navigation
  static const List<Widget> _screens = [
    DashboardScreen(),
    CalculatorScreen(),
    StrategiesScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Strategies',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline),
            selectedIcon: Icon(Icons.timeline),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}