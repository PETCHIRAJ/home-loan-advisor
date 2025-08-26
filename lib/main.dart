import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation.dart';
import 'providers/settings_provider.dart';

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
    // Watch theme mode from settings provider
    final themeMode = ref.watch(currentThemeModeProvider);
    
    return MaterialApp(
      title: 'Home Loan Advisor',
      debugShowCheckedModeBanner: false,
      
      // Use our custom Material 3 theme system with reactive theme mode
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Main app navigation
      home: const MainNavigation(),
    );
  }
}

// Theme test page moved to separate file for development reference
