import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class DailyBurnCounter extends StatefulWidget {
  final double dailyBurn;
  final VoidCallback onTap;

  const DailyBurnCounter({
    super.key,
    required this.dailyBurn,
    required this.onTap,
  });

  @override
  State<DailyBurnCounter> createState() => _DailyBurnCounterState();
}

class _DailyBurnCounterState extends State<DailyBurnCounter>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _countController;
  late Animation<double> _countAnimation;
  
  double _currentBurn = 0;
  final DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the fire icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);

    // Count up animation
    _countController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _countAnimation = Tween<double>(
      begin: 0,
      end: widget.dailyBurn,
    ).animate(CurvedAnimation(
      parent: _countController,
      curve: Curves.easeOut,
    ));
    
    _countController.forward();

    // Real-time counter updates
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final elapsed = DateTime.now().difference(_startTime).inSeconds;
          _currentBurn = (widget.dailyBurn / 86400) * elapsed; // Per second rate
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.errorRed.withOpacity(0.1),
              AppTheme.warningOrange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.errorRed.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header with fire icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interest Burning Right Now',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Every second costs you money',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppTheme.outline,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppTheme.errorRed,
                    size: 32,
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Daily burn amount with animation
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: _countAnimation,
                  builder: (context, child) {
                    return Text(
                      '₹${_countAnimation.value.toStringAsFixed(0)}',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 48,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'per day',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppTheme.outline,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Real-time counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.errorRed.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.errorRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live: ₹${_currentBurn.toStringAsFixed(2)} burned today',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppTheme.errorRed,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showBreakdown(context),
                    icon: const Icon(Icons.pie_chart_outlined, size: 16),
                    label: const Text('Breakdown'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorRed,
                      side: const BorderSide(color: AppTheme.errorRed),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showSolutions(context),
                    icon: const Icon(Icons.lightbulb_outline, size: 16),
                    label: const Text('Stop This'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBreakdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Interest Breakdown',
                      style: AppTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Understanding where your money goes',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppTheme.outline,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Breakdown items
                    _buildBreakdownItem(
                      'Per Day',
                      '₹${widget.dailyBurn.toStringAsFixed(0)}',
                      'Based on your current EMI',
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownItem(
                      'Per Hour',
                      '₹${(widget.dailyBurn / 24).toStringAsFixed(0)}',
                      'Money lost every hour',
                      Icons.access_time,
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownItem(
                      'Per Minute',
                      '₹${(widget.dailyBurn / 1440).toStringAsFixed(2)}',
                      'Interest charged per minute',
                      Icons.timer,
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownItem(
                      'Per Second',
                      '₹${(widget.dailyBurn / 86400).toStringAsFixed(4)}',
                      'Every tick of the clock',
                      Icons.timer_outlined,
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

  Widget _buildBreakdownItem(String period, String amount, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.errorRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: AppTextStyles.labelLarge,
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppTheme.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppTheme.errorRed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showSolutions(BuildContext context) {
    // Show quick solutions to reduce interest burn
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔥 Stop the Burn!',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick actions to reduce your daily interest:',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 20),
            _buildSolutionTile('Switch to Bi-weekly', 'Save ₹50-100 daily', Icons.payment),
            _buildSolutionTile('Round up EMI', 'Small change, big impact', Icons.trending_up),
            _buildSolutionTile('Add ₹1000 extra', 'Reduce years of payments', Icons.add_circle),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.successGreen),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        // Navigate to specific solution
      },
    );
  }
}