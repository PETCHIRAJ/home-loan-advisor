import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/main_navigation.dart';

/// App initializer that handles onboarding flow and initial setup
/// 
/// Checks if user has completed onboarding and routes accordingly
class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      // Check onboarding status
      _hasCompletedOnboarding = await OnboardingService.hasCompletedOnboarding();
      
      // Add a small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // On error, assume onboarding not completed
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasCompletedOnboarding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _LoadingScreen();
    }

    if (_hasCompletedOnboarding) {
      return const MainNavigation();
    } else {
      return const OnboardingScreen();
    }
  }
}

/// Loading screen shown during app initialization
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.home,
                size: 50,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'Home Loan Advisor',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Save lakhs on your home loan',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Initializing...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Onboarding service helper functions
class OnboardingService {
  static Future<bool> hasCompletedOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('onboarding_completed') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (e) {
      // Handle error silently
    }
  }
  
  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('onboarding_completed');
    } catch (e) {
      // Handle error silently
    }
  }
}