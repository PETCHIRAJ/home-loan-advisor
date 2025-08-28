import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/color_constants.dart';
import '../../widgets/common/unified_header.dart';

/// Strategy detail screen showing Extra EMI strategy details
/// 
/// Features:
/// - Simplified implementation focused on Extra EMI strategy
/// - Matches the strategy-detail-extra-emi.html mockup
/// - Clean design with actionable guidance
class StrategyDetailScreen extends ConsumerStatefulWidget {
  const StrategyDetailScreen({super.key});

  @override
  ConsumerState<StrategyDetailScreen> createState() =>
      _StrategyDetailScreenState();
}

class _StrategyDetailScreenState extends ConsumerState<StrategyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: const UnifiedHeader(
        title: 'Extra EMI Strategy (12+1)',
        showLoanSummary: true,
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '💸',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Extra EMI Strategy (12+1)',
                    style: TextStyle(
                      fontSize: 24,
                      color: ColorConstants.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pay one additional EMI per year to save ₹7.2L',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Save ₹7.2L', 'Lifetime Savings', ColorConstants.secondary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('3.2yr early', 'Loan Completion', const Color(0xFFFF8F00)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // How it works
            _buildSectionCard(
              'How It Works',
              'Instead of making 12 EMI payments per year, make 13. This extra payment goes directly toward reducing your principal balance.',
              Icons.lightbulb,
              ColorConstants.primary,
            ),
            
            const SizedBox(height: 16),
            
            // Implementation
            _buildSectionCard(
              'Implementation',
              '1. Calculate your current EMI amount\n2. Set up automatic payment for 13th EMI in December\n3. Apply extra payment directly to principal\n4. Continue this pattern every year',
              Icons.checklist,
              ColorConstants.secondary,
            ),
            
            const SizedBox(height: 16),
            
            // Benefits
            _buildSectionCard(
              'Benefits',
              '• Reduces total loan tenure significantly\n• Saves thousands in interest payments\n• Simple to implement and maintain\n• Accelerates equity building',
              Icons.trending_up,
              const Color(0xFF00796B),
            ),
            
            const SizedBox(height: 24),
            
            // Action button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Ready to Start?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact your lender to set up additional EMI payments',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorConstants.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to calculator or contact info
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feature coming soon! Contact your lender directly.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primary,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: ColorConstants.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionCard(String title, String content, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: ColorConstants.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}