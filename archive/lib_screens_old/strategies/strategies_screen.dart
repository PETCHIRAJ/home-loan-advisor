import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/color_constants.dart';
import '../../models/loan_model.dart';
import '../../providers/loan_provider.dart';
import '../../widgets/common/unified_header.dart';
import 'strategy_detail_screen.dart';

/// Strategies screen matching the HTML mockup design exactly
/// 
/// Features:
/// - 20 strategies in 5 categories
/// - Sticky category headers with color coding
/// - Eye-opener cards with special styling
/// - Effort badges on strategy cards
/// - Smart header with loan summary
/// - Impact metrics (savings and time)
class StrategiesScreen extends ConsumerStatefulWidget {
  const StrategiesScreen({super.key});

  @override
  ConsumerState<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends ConsumerState<StrategiesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToStrategy(String strategyName) {
    HapticFeedback.lightImpact();
    
    if (strategyName.contains('Extra EMI Strategy')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const StrategyDetailScreen(),
        ),
      );
    } else {
      // Show placeholder for other strategies
      _showStrategyPlaceholder(strategyName);
    }
  }

  void _showStrategyPlaceholder(String strategyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strategyName),
        content: const Text(
          'This strategy details would open here.\n\n'
          'In the full app, this would show:\n'
          '• Detailed explanation\n'
          '• Step-by-step implementation\n'
          '• Calculator specific to this strategy\n'
          '• Success stories\n'
          '• Related strategies',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: const UnifiedHeader(
        title: 'Strategies',
        showLoanSummary: true,
        showBackButton: false,
        currentTabIndex: 1, // Strategies is at index 1
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Main Content
          SliverList(
            delegate: SliverChildListDelegate([
              _buildInstantEyeOpenersSection(),
              _buildCoreSavingsSection(),
              _buildTaxInvestmentSection(),
              _buildBehavioralMotivationSection(),
              _buildLifePlanningSection(),
              const SizedBox(height: 100), // Space for bottom nav
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInstantEyeOpenersSection() {
    return Column(
      children: [
        _buildCategoryHeader(
          '🔥 INSTANT EYE-OPENERS (4)',
          'Emotional impact, motivational awareness',
          ColorConstants.error,
        ),
        _buildStrategiesGrid([
          _buildEyeOpenerCard(
            '🔥',
            'Daily Interest Burn Counter',
            '₹696/day - Live counter showing daily loss',
            '₹696/day',
            'Interest burn',
            'Live',
            'Real-time',
          ),
          _buildEyeOpenerCard(
            '📊',
            '78% Rule Revealer',
            'See breakdown - Why 78% interest paid in 1st half',
            '78%',
            'Front-loaded',
            'Critical',
            'Early years',
          ),
          _buildEyeOpenerCard(
            '😱',
            'Total Interest Shock',
            '₹32.6L lifetime - Reality check of total cost',
            '₹32.6L',
            'Total interest',
            '108%',
            'Of principal',
          ),
          _buildEyeOpenerCard(
            '⚖️',
            'Break-Even Point Tracker',
            'Year 12 - When you own more than bank',
            'Year 12',
            'Break-even',
            '60%',
            'Through loan',
          ),
        ]),
      ],
    );
  }

  Widget _buildCoreSavingsSection() {
    return Column(
      children: [
        _buildCategoryHeader(
          '📈 CORE SAVINGS STRATEGIES (4)',
          'Highest impact, universal applicability',
          ColorConstants.primary,
        ),
        _buildStrategiesGrid([
          _buildStrategyCard(
            '💸',
            'Extra EMI Strategy (12+1)',
            'Save ₹7.2L - Pay one additional EMI per year',
            'Save ₹7.2L',
            'Lifetime savings',
            '3.2yr early',
            'Completion',
            'Low Effort',
            ColorConstants.secondary,
            true, // clickable
          ),
          _buildStrategyCard(
            '🎯',
            'Round-Up Optimizer',
            'Save ₹2.1L - Round EMI to nearest thousand',
            'Save ₹2.1L',
            'Lifetime savings',
            '1.8yr early',
            'Completion',
            'Low Effort',
            ColorConstants.secondary,
            false,
          ),
          _buildStrategyCard(
            '💰',
            'Prepayment Impact Calculator',
            'Shows exact savings potential for any amount',
            'Variable',
            'Based on amount',
            'Calculate',
            'For your loan',
            'Planning Required',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '⏰',
            'Part-Payment Timing Guide',
            'When to make prepayments for maximum impact',
            'Optimize',
            'Impact timing',
            'Max',
            'Effect',
            'Timing Critical',
            const Color(0xFFFF8F00),
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildTaxInvestmentSection() {
    return Column(
      children: [
        _buildCategoryHeader(
          '🧠 TAX & INVESTMENT (4)',
          'Smart money management and tax optimization',
          const Color(0xFF00796B),
        ),
        _buildStrategiesGrid([
          _buildStrategyCard(
            '📊',
            'Tax Arbitrage Calculator',
            '5.95% effective - Compare prepay vs invest after tax',
            '5.95%',
            'Effective rate',
            '30%',
            'Tax bracket',
            'Analysis Required',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '⚖️',
            'Prepay vs Investment Guide',
            'When to prepay vs invest in markets/FDs',
            'Optimize',
            'Returns',
            'Risk vs',
            'Certainty',
            'Decision Tool',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '🏛️',
            'PPF vs Prepayment Analyzer',
            'Compare 15-year PPF vs loan prepayment',
            '7.1%',
            'PPF returns',
            '15yr',
            'Lock-in',
            'Long-term',
            ColorConstants.error,
            false,
          ),
          _buildStrategyCard(
            '📉',
            'Partial Tenure Reduction',
            'Reduce tenure vs EMI - hybrid approach',
            'Balanced',
            'Approach',
            'Flexible',
            'Strategy',
            'Strategic',
            const Color(0xFFFF8F00),
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildBehavioralMotivationSection() {
    return Column(
      children: [
        _buildCategoryHeader(
          '🎯 BEHAVIORAL MOTIVATION (4)',
          'Psychology-based strategies for consistent action',
          const Color(0xFFFF8F00),
        ),
        _buildStrategiesGrid([
          _buildStrategyCard(
            '☕',
            'Coffee-to-EMI Converter',
            '₹5.2L savings - Daily ₹150 coffee → prepayment',
            '₹5.2L',
            'Coffee money',
            '₹150',
            'Per day',
            'Eye-opener',
            ColorConstants.secondary,
            false,
          ),
          _buildStrategyCard(
            '📈',
            'Increment Allocator',
            'Auto-allocate 50% of salary increments to loan',
            '50%',
            'Of increments',
            'Annual',
            'Boost',
            'Auto-pilot',
            ColorConstants.secondary,
            false,
          ),
          _buildStrategyCard(
            '🎛️',
            'Fixed vs Floating Optimizer',
            'Switch timing based on rate trends',
            'Rate',
            'Optimization',
            'Market',
            'Timing',
            'Analysis',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '🔄',
            'Refinancing ROI Calculator',
            'Calculate break-even for loan switching',
            'Variable',
            'Break-even',
            '2-3yr',
            'Payback',
            'Complex',
            ColorConstants.error,
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildLifePlanningSection() {
    return Column(
      children: [
        _buildCategoryHeader(
          '👨‍👩‍👧 LIFE PLANNING (4)',
          'Life events and milestone-based strategies',
          const Color(0xFF9C27B0), // Purple
        ),
        _buildStrategiesGrid([
          _buildStrategyCard(
            '💑',
            'Marriage Dual-Income Strategy',
            'Combine incomes for accelerated prepayment',
            'Double',
            'Income power',
            'Fast',
            'Closure',
            'Planning',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '💼',
            'Job Change EMI Planner',
            'Prepare for income transitions',
            'Safety',
            'Net planning',
            'Risk',
            'Mitigation',
            'Contingency',
            const Color(0xFFFF8F00),
            false,
          ),
          _buildStrategyCard(
            '👶',
            'Children\'s Milestone Planner',
            'Balance loan vs education/marriage savings',
            'Balance',
            'Priorities',
            '18-25yr',
            'Planning',
            'Life planning',
            ColorConstants.error,
            false,
          ),
          _buildStrategyCard(
            '📋',
            'Section 80C/24b Maximizer',
            'Optimize tax benefits with EMI timing',
            '₹1.5L',
            '80C limit',
            'Annual',
            'Benefits',
            'Tax planning',
            const Color(0xFFFF8F00),
            false,
          ),
        ]),
      ],
    );
  }

  Widget _buildCategoryHeader(String title, String subtitle, Color borderColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF5F5F5)],
        ),
        border: Border(
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorConstants.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: ColorConstants.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategiesGrid(List<Widget> strategies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: strategies,
      ),
    );
  }

  Widget _buildEyeOpenerCard(
    String icon,
    String name,
    String description,
    String savingsAmount,
    String savingsLabel,
    String timeAmount,
    String timeLabel,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: ColorConstants.error,
          width: 4,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToStrategy(name),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Strategy header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(
                        fontSize: 24,
                        color: ColorConstants.error,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorConstants.onSurfaceVariant,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Impact section with special background
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorConstants.error.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: ColorConstants.error.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            savingsAmount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.secondary,
                            ),
                          ),
                          Text(
                            savingsLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              color: ColorConstants.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeAmount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF8F00),
                            ),
                          ),
                          Text(
                            timeLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              color: ColorConstants.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrategyCard(
    String icon,
    String name,
    String description,
    String savingsAmount,
    String savingsLabel,
    String timeAmount,
    String timeLabel,
    String effortBadgeText,
    Color effortBadgeColor,
    bool isClickable,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ColorConstants.outline.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isClickable ? () => _navigateToStrategy(name) : () => _navigateToStrategy(name),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Strategy header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 60), // Space for badge
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: ColorConstants.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Impact section
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: ColorConstants.outline, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                savingsAmount,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.secondary,
                                ),
                              ),
                              Text(
                                savingsLabel,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ColorConstants.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeAmount,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF8F00),
                                ),
                              ),
                              Text(
                                timeLabel,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ColorConstants.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Effort badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getEffortBadgeBackground(effortBadgeColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      effortBadgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: effortBadgeColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getEffortBadgeBackground(Color badgeColor) {
    if (badgeColor == ColorConstants.secondary) {
      return const Color(0xFFE8F5E8);
    } else if (badgeColor == const Color(0xFFFF8F00)) {
      return const Color(0xFFFFF3E0);
    } else if (badgeColor == ColorConstants.error) {
      return const Color(0xFFFFEBEE);
    }
    return const Color(0xFFF5F5F5);
  }

}