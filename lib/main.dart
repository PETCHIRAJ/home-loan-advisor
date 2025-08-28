import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/app_initializer.dart';

void main() {
  runApp(
    const ProviderScope(
      child: HomeLoanAdvisorApp(),
    ),
  );
}

class HomeLoanAdvisorApp extends ConsumerWidget {
  const HomeLoanAdvisorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return MaterialApp(
      title: 'Home Loan Advisor',
      debugShowCheckedModeBanner: false,
      
      // Use only light theme - consistent light mode throughout
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      
      // App initializer (handles onboarding and main navigation)
      home: const AppInitializer(),
    );
  }
}

// Theme test page moved to separate file for development reference
