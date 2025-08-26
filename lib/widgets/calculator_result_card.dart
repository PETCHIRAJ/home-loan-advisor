import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CalculatorResultCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;
  final bool showTrend;
  final bool isPositive;

  const CalculatorResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.showTrend = false,
    this.isPositive = true,
  });

  @override
  State<CalculatorResultCard> createState() => _CalculatorResultCardState();
}

class _CalculatorResultCardState extends State<CalculatorResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: widget.color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and trend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Transform.scale(
                          scale: _bounceAnimation.value,
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 20,
                          ),
                        ),
                      ),
                      if (widget.showTrend)
                        _buildTrendIndicator(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Value with counting animation
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTextStyles.titleLarge.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      child: Text(widget.value),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Title
                  Text(
                    widget.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppTheme.outline,
                    ),
                  ),
                  
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppTheme.outline,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (widget.isPositive ? AppTheme.successGreen : AppTheme.errorRed)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: widget.isPositive ? AppTheme.successGreen : AppTheme.errorRed,
          ),
          const SizedBox(width: 2),
          Text(
            widget.isPositive ? 'Good' : 'High',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: widget.isPositive ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }
}

// Specialized Result Cards

class EMIResultCard extends StatelessWidget {
  final double emiAmount;
  final VoidCallback onTap;

  const EMIResultCard({
    super.key,
    required this.emiAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CalculatorResultCard(
      title: 'Monthly EMI',
      value: emiAmount.toIndianCurrency,
      subtitle: 'Principal + Interest',
      icon: Icons.payment,
      color: AppTheme.primaryBlue,
      onTap: onTap,
    );
  }
}

class InterestResultCard extends StatelessWidget {
  final double totalInterest;
  final int tenureYears;
  final VoidCallback onTap;

  const InterestResultCard({
    super.key,
    required this.totalInterest,
    required this.tenureYears,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CalculatorResultCard(
      title: 'Total Interest',
      value: totalInterest.toIndianCurrencyCompact,
      subtitle: 'Over $tenureYears years',
      icon: Icons.trending_up,
      color: AppTheme.errorRed,
      showTrend: true,
      isPositive: false,
      onTap: onTap,
    );
  }
}

class SavingsResultCard extends StatelessWidget {
  final double savingsAmount;
  final String strategy;
  final VoidCallback onTap;

  const SavingsResultCard({
    super.key,
    required this.savingsAmount,
    required this.strategy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CalculatorResultCard(
      title: 'Potential Savings',
      value: savingsAmount.toIndianCurrencyCompact,
      subtitle: 'With $strategy',
      icon: Icons.savings,
      color: AppTheme.successGreen,
      showTrend: true,
      isPositive: true,
      onTap: onTap,
    );
  }
}

class BreakEvenResultCard extends StatelessWidget {
  final int breakEvenMonths;
  final int totalMonths;
  final VoidCallback onTap;

  const BreakEvenResultCard({
    super.key,
    required this.breakEvenMonths,
    required this.totalMonths,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final years = (breakEvenMonths / 12).toStringAsFixed(1);
    final percentage = ((breakEvenMonths / totalMonths) * 100).toInt();
    
    return CalculatorResultCard(
      title: 'Break-Even Point',
      value: '$years years',
      subtitle: '$percentage% into loan term',
      icon: Icons.balance,
      color: AppTheme.secondaryTeal,
      onTap: onTap,
    );
  }
}

// Animated Counter for Result Values
class AnimatedResultValue extends StatefulWidget {
  final double targetValue;
  final String Function(double) formatter;
  final Duration duration;
  final TextStyle style;

  const AnimatedResultValue({
    super.key,
    required this.targetValue,
    required this.formatter,
    this.duration = const Duration(milliseconds: 1500),
    required this.style,
  });

  @override
  State<AnimatedResultValue> createState() => _AnimatedResultValueState();
}

class _AnimatedResultValueState extends State<AnimatedResultValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.targetValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.formatter(_animation.value),
          style: widget.style,
        );
      },
    );
  }
}

// Extensions for currency formatting
extension CalculatorCurrencyFormatter on double {
  String get toIndianCurrency {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

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

// Add this import at the top of the file
import 'package:intl/intl.dart';

// Results Grid Widget for Calculator Screen
class CalculatorResultsGrid extends StatelessWidget {
  final List<CalculatorResultCard> resultCards;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const CalculatorResultsGrid({
    super.key,
    required this.resultCards,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: resultCards.length,
      itemBuilder: (context, index) {
        return resultCards[index];
      },
    );
  }
}