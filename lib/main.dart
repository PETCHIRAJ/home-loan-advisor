import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const HomeLoanAdvisorApp());
}

class HomeLoanAdvisorApp extends StatelessWidget {
  const HomeLoanAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Loan Advisor',
      debugShowCheckedModeBanner: false,
      
      // Use our custom Material 3 theme system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respects user's system preference
      
      // Main app navigation
      home: const MainNavigation(),
    );
  }
}

// Theme test page moved to separate file for development reference
