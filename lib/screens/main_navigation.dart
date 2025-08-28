import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'calculator/calculator_screen.dart';
import 'strategies/strategies_screen.dart';
import 'progress/progress_screen.dart';

/// Main navigation widget with bottom navigation bar matching HTML mockup
/// 
/// Provides navigation between the four main screens (in mockup order):
/// - Home: Daily interest burn counter and loan health overview
/// - Strategies: 20 Money-saving strategies with categories  
/// - Progress: Achievement tracking and savings progress
/// - Calculator: EMI calculation, charts, and loan settings
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Start on Dashboard (Home)

  // List of screen widgets for navigation - ORDER MATCHES HTML MOCKUP
  static const List<Widget> _screens = [
    DashboardScreen(),    // Home (mockup position 1)
    StrategiesScreen(),   // Strategies (mockup position 2)
    ProgressScreen(),     // Progress (mockup position 3)
    CalculatorScreen(),   // Calculator (mockup position 4)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Public method for external navigation
  void navigateToTab(int index) {
    _onItemTapped(index);
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
          // Home (mockup: 🏠)
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Strategies (mockup: 💰)
          NavigationDestination(
            icon: Icon(Icons.monetization_on_outlined),
            selectedIcon: Icon(Icons.monetization_on),
            label: 'Strategies',
          ),
          // Progress (mockup: 📈)
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          // Calculator (mockup: 📊)
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Calculator',
          ),
        ],
      ),
    );
  }
}