import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class LoanHealthScore extends StatefulWidget {
  final double score; // 0-100
  final VoidCallback onTap;

  const LoanHealthScore({
    super.key,
    required this.score,
    required this.onTap,
  });

  @override
  State<LoanHealthScore> createState() => _LoanHealthScoreState();
}

class _LoanHealthScoreState extends State<LoanHealthScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.score / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (widget.score >= 80) return AppTheme.successGreen;
    if (widget.score >= 60) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  String get _scoreLabel {
    if (widget.score >= 80) return 'Excellent';
    if (widget.score >= 70) return 'Good';
    if (widget.score >= 60) return 'Average';
    if (widget.score >= 40) return 'Below Average';
    return 'Needs Attention';
  }

  String get _scoreEmoji {
    if (widget.score >= 80) return '🎉';
    if (widget.score >= 70) return '😊';
    if (widget.score >= 60) return '😐';
    if (widget.score >= 40) return '😕';
    return '😰';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _scoreColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: _scoreColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Circular Score Display
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        // Background Circle
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _scoreColor.withOpacity(0.1),
                          ),
                        ),
                        // Progress Circle
                        CustomPaint(
                          size: const Size(100, 100),
                          painter: _CircularProgressPainter(
                            progress: _progressAnimation.value,
                            color: _scoreColor,
                            strokeWidth: 8,
                          ),
                        ),
                        // Score Text
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.score.toInt()}',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: _scoreColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                '/100',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppTheme.outline,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Score Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Loan Health Score',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppTheme.outline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppTheme.outline,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Text(
                              _scoreLabel,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: _scoreColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _scoreEmoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          _getScoreDescription(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppTheme.outline,
                            fontSize: 13,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Quick Actions
                        Row(
                          children: [
                            _buildQuickAction(
                              'Improve',
                              Icons.trending_up,
                              _scoreColor,
                            ),
                            const SizedBox(width: 16),
                            _buildQuickAction(
                              'Details',
                              Icons.analytics,
                              AppTheme.primaryBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription() {
    if (widget.score >= 80) {
      return 'Your loan terms are excellent! You\'re paying competitive rates with good tenure.';
    } else if (widget.score >= 70) {
      return 'Good loan health, but there\'s room for optimization to save more.';
    } else if (widget.score >= 60) {
      return 'Average loan health. Consider strategies to improve your savings.';
    } else if (widget.score >= 40) {
      return 'Below average health. You could save significantly with optimization.';
    } else {
      return 'Your loan needs immediate attention! High savings potential available.';
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

// Health Score Breakdown Modal
class HealthScoreBreakdownModal extends StatelessWidget {
  final double score;
  final Map<String, double> factors;

  const HealthScoreBreakdownModal({
    super.key,
    required this.score,
    required this.factors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          const Text(
            'Loan Health Score Breakdown',
            style: AppTextStyles.headlineLarge,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Understanding what affects your score',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppTheme.outline,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Score Factors
          ...factors.entries.map((entry) => _buildFactorItem(
            entry.key,
            entry.value,
          )),
          
          const SizedBox(height: 24),
          
          // Improvement Suggestions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.successGreen.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Quick Improvements',
                      style: AppTextStyles.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '• Switch to bi-weekly payments (+10 points)\n'
                  '• Round up your EMI to nearest thousand (+5 points)\n'
                  '• Pay one extra EMI annually (+8 points)',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorItem(String factor, double impact) {
    final isPositive = impact >= 0;
    final color = isPositive ? AppTheme.successGreen : AppTheme.errorRed;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              factor,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${impact.toStringAsFixed(0)}',
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}