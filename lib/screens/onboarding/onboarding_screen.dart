import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_initializer.dart';
import '../../core/theme/app_theme.dart';

/// Single-page onboarding experience matching the HTML mockup design
/// 
/// Features:
/// - Hero section with house emoji and bouncing animation
/// - Four value propositions with icons and descriptions
/// - CTA button with gradient background
/// - Offline badge with green background
/// - Slide-in animations for all elements
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bounceController;
  late Animation<double> _containerAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _buttonScaleAnimation;

  final List<AnimationController> _valueItemControllers = [];
  final List<Animation<Offset>> _valueItemAnimations = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    // Main container animation
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Bounce animation for house icon
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _containerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    // Value item animations
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      _valueItemControllers.add(controller);

      final animation = Tween<Offset>(
        begin: const Offset(-0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
      _valueItemAnimations.add(animation);
    }
  }

  void _startAnimationSequence() async {
    // Start main container animation
    await Future.delayed(const Duration(milliseconds: 200));
    _mainController.forward();

    // Start bounce animation (continuous)
    _bounceController.repeat(reverse: true);

    // Stagger value item animations
    for (int i = 0; i < _valueItemControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _valueItemControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bounceController.dispose();
    for (final controller in _valueItemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Complete onboarding and navigate to main app
  Future<void> _completeOnboarding() async {
    // Use SharedPreferences directly since OnboardingService is in app_initializer
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      // Add haptic feedback
      HapticFeedback.mediumImpact();
      
      // Refresh the entire app to show main navigation
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const AppInitializer(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.financialColors.loanHealthGood,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _containerAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _containerAnimation,
                    child: _buildMainContainer(theme, screenSize),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContainer(ThemeData theme, Size screenSize) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 414),
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(theme),
            const SizedBox(height: 32),
            _buildValuePropositions(theme),
            const SizedBox(height: 32),
            _buildCTAButton(theme),
            const SizedBox(height: 16),
            _buildOfflineBadge(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Column(
      children: [
        // Bouncing house icon
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: const Text(
                '🏠',
                style: TextStyle(fontSize: 64),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        
        // Title
        Text(
          'Home Loan Advisor',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // Subtitle
        Text(
          'Save lakhs on your home loan with smart, offline strategies',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildValuePropositions(ThemeData theme) {
    final valueProps = [
      {
        'icon': '⚡',
        'title': 'Live Money Burn Counter',
        'description': 'See exactly how much interest you\'re losing every day',
      },
      {
        'icon': '💰',
        'title': '20 Money-Saving Strategies',
        'description': 'Proven techniques to reduce your loan burden significantly',
      },
      {
        'icon': '📊',
        'title': 'Smart Calculator',
        'description': '3-input form reveals shocking loan truths instantly',
      },
      {
        'icon': '📈',
        'title': 'Progress Tracking',
        'description': 'Monitor your savings journey and celebrate milestones',
      },
    ];

    return Column(
      children: valueProps.asMap().entries.map((entry) {
        final index = entry.key;
        final prop = entry.value;
        
        return AnimatedBuilder(
          animation: _valueItemAnimations[index],
          builder: (context, child) {
            return SlideTransition(
              position: _valueItemAnimations[index],
              child: FadeTransition(
                opacity: _valueItemControllers[index],
                child: _buildValueItem(
                  theme,
                  prop['icon']!,
                  prop['title']!,
                  prop['description']!,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildValueItem(ThemeData theme, String icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.financialColors.loanHealthGood,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _completeOnboarding,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Text(
                    '🚀 START FREE ANALYSIS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.financialColors.savingsGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '📴 100% Offline • No Internet Required',
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

}
