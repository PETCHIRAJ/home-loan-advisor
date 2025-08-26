import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StrategiesScreen extends StatelessWidget {
  const StrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Optimization Strategies'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 64,
              color: AppTheme.primaryBlue,
            ),
            SizedBox(height: 16),
            Text(
              'Strategies Screen',
              style: AppTextStyles.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(color: AppTheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Eye-Opening Insights'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights,
              size: 64,
              color: AppTheme.errorRed,
            ),
            SizedBox(height: 16),
            Text(
              'Insights Screen',
              style: AppTextStyles.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(color: AppTheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up,
              size: 64,
              color: AppTheme.successGreen,
            ),
            SizedBox(height: 16),
            Text(
              'Progress Screen',
              style: AppTextStyles.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(color: AppTheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
              size: 64,
              color: AppTheme.outline,
            ),
            SizedBox(height: 16),
            Text(
              'Settings Screen',
              style: AppTextStyles.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(color: AppTheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}