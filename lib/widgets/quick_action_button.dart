import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final double? width;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.width,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: widget.width ?? 160,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: widget.color.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon and Arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 24,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.outline,
                          size: 16,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Label
                    Text(
                      widget.label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Subtitle with savings amount
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppTheme.outline,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Specialized Quick Action Buttons

class SavingsQuickActionButton extends StatelessWidget {
  final String strategy;
  final double savingsAmount;
  final String timeframe;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SavingsQuickActionButton({
    super.key,
    required this.strategy,
    required this.savingsAmount,
    required this.timeframe,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionButton(
      icon: icon,
      label: strategy,
      subtitle: 'Save ${savingsAmount.toIndianCurrencyCompact}\n$timeframe',
      color: color,
      onTap: onTap,
    );
  }
}

class InsightQuickActionButton extends StatelessWidget {
  final String title;
  final String revelation;
  final IconData icon;
  final VoidCallback onTap;

  const InsightQuickActionButton({
    super.key,
    required this.title,
    required this.revelation,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionButton(
      icon: icon,
      label: title,
      subtitle: revelation,
      color: AppTheme.errorRed,
      onTap: onTap,
    );
  }
}

class LifestyleQuickActionButton extends StatelessWidget {
  final String activity;
  final String impact;
  final IconData icon;
  final VoidCallback onTap;

  const LifestyleQuickActionButton({
    super.key,
    required this.activity,
    required this.impact,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionButton(
      icon: icon,
      label: activity,
      subtitle: impact,
      color: AppTheme.warningOrange,
      onTap: onTap,
      width: 180, // Slightly wider for lifestyle buttons
    );
  }
}

// Extension for currency formatting
extension CurrencyFormatter on double {
  String get toIndianCurrencyCompact {
    if (this >= 10000000) {
      return '₹${(this / 10000000).toStringAsFixed(1)}Cr';
    } else if (this >= 100000) {
      return '₹${(this / 100000).toStringAsFixed(1)}L';
    } else if (this >= 1000) {
      return '₹${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${this.toStringAsFixed(0)}';
    }
  }
}

// Quick Actions Row Widget for Dashboard
class QuickActionsRow extends StatelessWidget {
  final List<QuickActionData> actions;
  final ScrollController? scrollController;

  const QuickActionsRow({
    super.key,
    required this.actions,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Actions',
              style: AppTextStyles.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // Navigate to all strategies
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('View All'),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        SizedBox(
          height: 140,
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: actions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final action = actions[index];
              return QuickActionButton(
                icon: action.icon,
                label: action.label,
                subtitle: action.subtitle,
                color: action.color,
                onTap: action.onTap,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Data class for Quick Actions
class QuickActionData {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  QuickActionData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  // Factory constructors for common action types
  factory QuickActionData.savings({
    required String strategy,
    required double amount,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return QuickActionData(
      icon: icon,
      label: strategy,
      subtitle: 'Save ${amount.toIndianCurrencyCompact}',
      color: color,
      onTap: onTap,
    );
  }

  factory QuickActionData.insight({
    required String title,
    required String revelation,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return QuickActionData(
      icon: icon,
      label: title,
      subtitle: revelation,
      color: AppTheme.errorRed,
      onTap: onTap,
    );
  }

  factory QuickActionData.lifestyle({
    required String activity,
    required String impact,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return QuickActionData(
      icon: icon,
      label: activity,
      subtitle: impact,
      color: AppTheme.warningOrange,
      onTap: onTap,
    );
  }
}

// Animated Quick Action Button with Loading State
class AnimatedQuickActionButton extends StatefulWidget {
  final QuickActionData action;
  final bool isLoading;
  final Duration animationDelay;

  const AnimatedQuickActionButton({
    super.key,
    required this.action,
    this.isLoading = false,
    this.animationDelay = Duration.zero,
  });

  @override
  State<AnimatedQuickActionButton> createState() => _AnimatedQuickActionButtonState();
}

class _AnimatedQuickActionButtonState extends State<AnimatedQuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    // Delayed animation start
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.isLoading
            ? _buildLoadingState()
            : QuickActionButton(
                icon: widget.action.icon,
                label: widget.action.label,
                subtitle: widget.action.subtitle,
                color: widget.action.color,
                onTap: widget.action.onTap,
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: 160,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculating...',
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}