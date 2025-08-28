import 'package:flutter/material.dart';
import '../models/strategy_detail_model.dart';

/// Repository containing all 20 home loan optimization strategies
///
/// Based on STRATEGY_DETAIL_SPECS.md, this repository provides
/// complete data for each strategy including calculations,
/// implementation steps, and UI presentation data.
class StrategyRepository {
  StrategyRepository._();

  /// Get all strategies organized by category
  static Map<StrategyCategory, List<StrategyDetailModel>> getAllStrategiesByCategory() {
    return {
      StrategyCategory.instantEyeOpeners: getInstantEyeOpeners(),
      StrategyCategory.coreSavings: getCoreSavingsStrategies(),
      StrategyCategory.taxInvestment: getTaxInvestmentStrategies(),
      StrategyCategory.behavioralMotivation: getBehavioralMotivationStrategies(),
      StrategyCategory.lifeEventPlanning: getLifeEventPlanningStrategies(),
    };
  }

  /// Get all strategies as a flat list
  static List<StrategyDetailModel> getAllStrategies() {
    final strategiesByCategory = getAllStrategiesByCategory();
    return strategiesByCategory.values.expand((strategies) => strategies).toList();
  }

  /// Get strategy by type
  static StrategyDetailModel? getStrategy(StrategyType type) {
    return getAllStrategies().firstWhere(
      (strategy) => strategy.type == type,
      orElse: () => throw ArgumentError('Strategy not found: $type'),
    );
  }

  /// Get strategies by category
  static List<StrategyDetailModel> getStrategiesByCategory(StrategyCategory category) {
    return getAllStrategiesByCategory()[category] ?? [];
  }

  // Category-specific strategy collections

  /// 🔥 INSTANT EYE-OPENERS (Awareness-focused)
  static List<StrategyDetailModel> getInstantEyeOpeners() {
    return [
      const StrategyDetailModel(
        type: StrategyType.dailyInterestBurn,
        title: 'Daily Interest Burn Counter',
        description: 'See how much money burns away every single day',
        category: StrategyCategory.instantEyeOpeners,
        icon: Icons.local_fire_department,
        accentColor: Colors.red,
        implementationSteps: [],
        tips: [
          'Check this daily to stay motivated',
          'Share with family to create awareness',
          'Use as motivation for other strategies',
        ],
        considerations: [
          'This is just awareness - no direct action needed',
          'The real impact comes from implementing reduction strategies',
          'Numbers can be emotionally overwhelming',
        ],
        difficultyLevel: 1,
        estimatedTime: Duration(minutes: 2),
        hasVisualComponent: true,
      ),

      const StrategyDetailModel(
        type: StrategyType.rule78Revealer,
        title: 'The 78% Rule Revealer',
        description: 'Discover why banks love the first 10 years of your loan',
        category: StrategyCategory.instantEyeOpeners,
        icon: Icons.pie_chart,
        accentColor: Colors.orange,
        implementationSteps: [],
        tips: [
          'Understand why prepayments work best early',
          'Use the timeline slider to explore any year',
          'Share this insight with other homeowners',
        ],
        considerations: [
          'This pattern is standard for all home loans',
          'Early years heavily favor the bank',
          'Knowledge alone doesn\'t save money - action does',
        ],
        difficultyLevel: 1,
        estimatedTime: Duration(minutes: 5),
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.totalInterestShock,
        title: 'Total Interest Shock Display',
        description: 'See the shocking reality: you\'ll pay 2X the loan amount',
        category: StrategyCategory.instantEyeOpeners,
        icon: Icons.trending_up,
        accentColor: Colors.red[700]!,
        implementationSteps: [],
        tips: [
          'Think about what else this money could buy',
          'Use as motivation for aggressive prepayment',
          'Compare with property appreciation potential',
        ],
        considerations: [
          'This is the cost of leveraged real estate',
          'Consider tax benefits that reduce effective cost',
          'Property appreciation might offset this cost',
        ],
        difficultyLevel: 1,
        estimatedTime: const Duration(minutes: 3),
        hasVisualComponent: true,
      ),

      const StrategyDetailModel(
        type: StrategyType.breakEvenTracker,
        title: 'Break-Even Point Tracker',
        description: 'Track when you\'ll own more than the bank',
        category: StrategyCategory.instantEyeOpeners,
        icon: Icons.balance,
        accentColor: Colors.purple,
        implementationSteps: [],
        tips: [
          'Mark this date on your calendar',
          'Plan a celebration when you reach it',
          'Use prepayments to reach it faster',
        ],
        considerations: [
          'This is just an ownership milestone',
          'Doesn\'t account for property appreciation',
          'Reaching it faster saves significant interest',
        ],
        difficultyLevel: 1,
        estimatedTime: Duration(minutes: 3),
        hasVisualComponent: true,
      ),
    ];
  }

  /// 📈 CORE SAVINGS STRATEGIES (Action-focused)
  static List<StrategyDetailModel> getCoreSavingsStrategies() {
    return [
      const StrategyDetailModel(
        type: StrategyType.extraEMIStrategy,
        title: 'Extra EMI Strategy (12+1)',
        description: 'Pay 13 EMIs instead of 12 every year',
        category: StrategyCategory.coreSavings,
        icon: Icons.add_circle,
        accentColor: Colors.green,
        implementationSteps: [
          'Calculate one EMI amount',
          'Save this amount throughout the year',
          'Use annual bonus if available',
          'Pay as lump sum in December',
          'Inform bank it\'s for principal reduction',
          'Get receipt confirming principal application',
        ],
        tips: [
          'Best timing is after receiving annual bonus',
          'Check if your bank charges prepayment fees',
          'Some banks waive fees once per year',
          'Tax benefits may apply to additional principal',
        ],
        considerations: [
          'Need to plan cash flow throughout the year',
          'Verify prepayment terms with your bank',
          'Emergency fund should remain intact',
          'Consider tax implications of large prepayment',
        ],
        difficultyLevel: 2,
        estimatedTime: Duration(hours: 2),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      const StrategyDetailModel(
        type: StrategyType.roundUpOptimizer,
        title: 'Round-Up Optimizer',
        description: 'Round your EMI to the nearest thousand',
        category: StrategyCategory.coreSavings,
        icon: Icons.rounded_corner,
        accentColor: Colors.blue,
        implementationSteps: [
          'Calculate current EMI amount',
          'Round up to nearest thousand',
          'Calculate the difference',
          'Update auto-debit mandate',
          'Inform bank about extra amount purpose',
          'Confirm it goes towards principal',
        ],
        tips: [
          'Psychologically satisfying round numbers',
          'No lifestyle impact due to small amount',
          'Creates automatic savings discipline',
          'Easy to remember and track',
        ],
        considerations: [
          'Very small impact if EMI is already rounded',
          'May need to adjust if income changes',
          'Ensure bank applies extra to principal, not advance EMI',
        ],
        difficultyLevel: 1,
        estimatedTime: Duration(minutes: 30),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      const StrategyDetailModel(
        type: StrategyType.prepaymentCalculator,
        title: 'Prepayment Impact Calculator',
        description: 'Calculate exact impact of any lump sum payment',
        category: StrategyCategory.coreSavings,
        icon: Icons.calculate,
        accentColor: Colors.teal,
        implementationSteps: [
          'Enter available lump sum amount',
          'Check current loan balance',
          'Calculate interest savings',
          'Compare with investment returns',
          'Make informed decision',
          'Execute if prepayment wins',
        ],
        tips: [
          'Earlier the prepayment, higher the savings',
          'Consider opportunity cost of money',
          'Factor in tax benefits of interest paid',
          'Keep emergency fund separate',
        ],
        considerations: [
          'Prepayment charges may apply',
          'Loss of tax benefits on paid interest',
          'Liquidity impact of lump sum',
          'Alternative investment opportunities',
        ],
        difficultyLevel: 3,
        estimatedTime: Duration(minutes: 45),
        requiresCalculation: true,
        hasVisualComponent: true,
        calculatorHint: 'Interactive calculator to try different amounts',
      ),

      const StrategyDetailModel(
        type: StrategyType.partPaymentTiming,
        title: 'Part-Payment Timing Guide',
        description: 'Optimize when to make prepayments for maximum benefit',
        category: StrategyCategory.coreSavings,
        icon: Icons.schedule,
        accentColor: Colors.amber,
        implementationSteps: [
          'Review your loan agreement for charges',
          'Identify charge-free prepayment windows',
          'Plan prepayments for March (financial year-end)',
          'Keep emergency fund intact before prepaying',
          'Execute during optimal windows',
        ],
        tips: [
          'Many banks waive charges once per year',
          'March is often the best timing',
          'Some banks offer charge-free windows quarterly',
          'Coordinate with bonus/increment timing',
        ],
        considerations: [
          'Prepayment charges typically 2-3% of amount',
          'Charge-free benefits vary by bank',
          'Don\'t compromise emergency fund',
          'Interest savings should exceed charges',
        ],
        difficultyLevel: 2,
        estimatedTime: Duration(hours: 1),
        hasVisualComponent: true,
      ),
    ];
  }

  /// 🧠 TAX & INVESTMENT OPTIMIZATION
  static List<StrategyDetailModel> getTaxInvestmentStrategies() {
    return [
      const StrategyDetailModel(
        type: StrategyType.taxArbitrage,
        title: 'Tax Arbitrage Calculator',
        description: 'Calculate your effective interest rate after tax benefits',
        category: StrategyCategory.taxInvestment,
        icon: Icons.account_balance,
        accentColor: Colors.indigo,
        implementationSteps: [
          'Identify your tax bracket (10%/20%/30%)',
          'Calculate interest tax deduction under Section 24b',
          'Compute effective interest rate post-tax',
          'Compare with safe investment returns',
          'Make prepay vs invest decision',
        ],
        tips: [
          'Higher tax bracket = higher benefits',
          'Consider both 80C and 24b benefits',
          'Factor in LTCG tax on investments',
          'Review annually as tax brackets change',
        ],
        considerations: [
          'Tax benefits only if you pay tax',
          'Interest deduction capped at ₹2L under 24b',
          'Investment returns are not guaranteed',
          'Tax laws can change over time',
        ],
        difficultyLevel: 4,
        estimatedTime: Duration(hours: 1),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      const StrategyDetailModel(
        type: StrategyType.prepayVsInvestment,
        title: 'Prepay vs Investment Guide',
        description: 'Stage-based analysis: when to prepay vs when to invest',
        category: StrategyCategory.taxInvestment,
        icon: Icons.trending_up,
        accentColor: Colors.purple,
        implementationSteps: [
          'Assess current stage of loan (year 1-5, 6-15, 16+)',
          'Evaluate risk appetite and investment knowledge',
          'Compare guaranteed savings vs expected returns',
          'Consider diversification benefits',
          'Make stage-appropriate decision',
        ],
        tips: [
          'Years 1-10: Prepayment usually wins',
          'Years 16+: Consider equity investments',
          'Middle years: Balanced approach works',
          'Review strategy every 3-5 years',
        ],
        considerations: [
          'Market returns are not guaranteed',
          'Prepayment gives guaranteed savings',
          'Diversification reduces risk',
          'Personal comfort with risk matters',
        ],
        difficultyLevel: 4,
        estimatedTime: Duration(hours: 2),
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.ppfVsPrepay,
        title: 'PPF vs Prepayment Analyzer',
        description: 'Compare tax-free PPF returns with loan prepayment savings',
        category: StrategyCategory.taxInvestment,
        icon: Icons.savings,
        accentColor: Colors.green[700]!,
        implementationSteps: [
          'Max out Section 80C limit first (₹1.5L)',
          'Calculate effective loan rate after tax',
          'Compare with current PPF rate (tax-free)',
          'Consider 15-year lock-in of PPF',
          'Evaluate liquidity needs',
          'Make optimal allocation decision',
        ],
        tips: [
          'PPF offers tax-free returns',
          'Loan prepayment gives guaranteed savings',
          'Consider partial allocation to both',
          'PPF has 15-year lock-in period',
        ],
        considerations: [
          'PPF rates can change annually',
          'Loan savings are guaranteed',
          'Liquidity differs significantly',
          'Tax benefits vary by income bracket',
        ],
        difficultyLevel: 3,
        estimatedTime: const Duration(minutes: 45),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.tenureReduction,
        title: 'Partial Tenure Reduction',
        description: 'Reduce tenure instead of EMI after prepayment',
        category: StrategyCategory.taxInvestment,
        icon: Icons.compress,
        accentColor: Colors.orange[700]!,
        implementationSteps: [
          'Make lump sum prepayment',
          'Inform bank to reduce tenure, not EMI',
          'Get revised schedule in writing',
          'Track new timeline and savings',
          'Plan next prepayment strategy',
        ],
        tips: [
          'Often saves more than EMI reduction',
          'Clears debt faster',
          'Frees up future cash flow earlier',
          'Reduces total interest significantly',
        ],
        considerations: [
          'Higher ongoing EMI burden',
          'Less monthly cash flow improvement',
          'Need to ensure bank implements correctly',
          'May not suit tight cash flow situations',
        ],
        difficultyLevel: 2,
        estimatedTime: const Duration(hours: 1),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),
    ];
  }

  /// 🎯 BEHAVIORAL MOTIVATION
  static List<StrategyDetailModel> getBehavioralMotivationStrategies() {
    return [
      const StrategyDetailModel(
        type: StrategyType.coffeeToEMI,
        title: 'Coffee-to-EMI Converter',
        description: 'Convert daily spending habits into EMI savings',
        category: StrategyCategory.behavioralMotivation,
        icon: Icons.coffee,
        accentColor: Colors.brown,
        implementationSteps: [
          'Track daily discretionary spending',
          'Identify recurring habits (coffee, snacks, etc.)',
          'Calculate monthly impact',
          'Find realistic reduction opportunities',
          'Redirect savings to EMI increase',
          'Monitor and adjust regularly',
        ],
        tips: [
          'Focus on high-frequency, low-value purchases',
          'Don\'t eliminate all pleasures',
          'Make substitutions rather than cuts',
          'Track progress to stay motivated',
        ],
        considerations: [
          'Requires sustained behavioral change',
          'Should not impact quality of life severely',
          'May need family buy-in',
          'Results compound over time',
        ],
        difficultyLevel: 3,
        estimatedTime: Duration(days: 7), // Week to track habits
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.incrementAllocator,
        title: 'Increment Allocator',
        description: 'Allocate part of salary increments to EMI',
        category: StrategyCategory.behavioralMotivation,
        icon: Icons.trending_up_sharp,
        accentColor: Colors.green[600]!,
        implementationSteps: [
          'Plan allocation before increment arrives',
          'Decide percentage (25-50% recommended)',
          'Update EMI auto-debit immediately after increment',
          'Avoid lifestyle inflation with remaining amount',
          'Set up automatic increase for future increments',
        ],
        tips: [
          'Plan before increment to avoid lifestyle inflation',
          'Start with 25% allocation if unsure',
          'Can increase percentage in subsequent years',
          'Celebrate the balance guilt-free',
        ],
        considerations: [
          'Requires discipline to avoid lifestyle inflation',
          'Should leave room for other financial goals',
          'May need adjustment if expenses increase',
          'Coordinate with partner if joint finances',
        ],
        difficultyLevel: 2,
        estimatedTime: const Duration(hours: 1),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.fixedVsFloating,
        title: 'Fixed vs Floating Optimizer',
        description: 'Optimize between fixed and floating interest rates',
        category: StrategyCategory.behavioralMotivation,
        icon: Icons.swap_horiz,
        accentColor: Colors.blue[700]!,
        implementationSteps: [
          'Analyze current rate vs market trends',
          'Calculate switching costs (if any)',
          'Monitor RBI repo rate trends',
          'Evaluate risk tolerance for rate volatility',
          'Time the switch optimally',
          'Execute switch with bank',
        ],
        tips: [
          'Fixed rates protect against rate hikes',
          'Floating rates benefit from rate cuts',
          'Consider remaining tenure in decision',
          'Switching costs can be significant',
        ],
        considerations: [
          'Rate predictions are inherently uncertain',
          'Switching may involve processing fees',
          'Legal documentation may be required',
          'Consider rate cycle timing',
        ],
        difficultyLevel: 4,
        estimatedTime: const Duration(hours: 3),
        hasVisualComponent: true,
      ),
    ];
  }

  /// 👨‍👩‍👧 LIFE EVENT PLANNING
  static List<StrategyDetailModel> getLifeEventPlanningStrategies() {
    return [
      const StrategyDetailModel(
        type: StrategyType.marriageStrategy,
        title: 'Marriage Dual-Income Strategy',
        description: 'Optimize EMI with combined household income',
        category: StrategyCategory.lifeEventPlanning,
        icon: Icons.favorite,
        accentColor: Colors.pink,
        implementationSteps: [
          'Assess combined income potential',
          'Evaluate co-borrower tax benefits',
          'Plan optimal EMI increase timeline',
          'Restructure loan if beneficial',
          'Coordinate with other financial goals',
          'Set up joint tracking system',
        ],
        tips: [
          'Co-borrower increases loan eligibility',
          'Tax benefits can be split optimally',
          'Joint financial planning is crucial',
          'Consider both incomes for sustainability',
        ],
        considerations: [
          'Both parties share liability',
          'Career breaks may affect income',
          'Requires coordination and planning',
          'Impact on individual credit scores',
        ],
        difficultyLevel: 3,
        estimatedTime: Duration(hours: 4),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.jobChangeEMI,
        title: 'Job Change EMI Planner',
        description: 'Plan EMI optimization around career moves',
        category: StrategyCategory.lifeEventPlanning,
        icon: Icons.work,
        accentColor: Colors.blue[800]!,
        implementationSteps: [
          'Plan during notice period',
          'Calculate sustainable EMI increase',
          'Account for new role expenses',
          'Update EMI after probation period',
          'Balance with emergency fund building',
          'Monitor cash flow in new role',
        ],
        tips: [
          'Wait for probation completion',
          'Factor in new job expenses',
          'Build emergency fund first',
          'Conservative approach initially',
        ],
        considerations: [
          'Job stability in new role',
          'Probation period risks',
          'Changed expense patterns',
          'Location change impacts',
        ],
        difficultyLevel: 3,
        estimatedTime: const Duration(hours: 2),
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.childrenPlanning,
        title: 'Children\'s Milestone Planner',
        description: 'Plan loan closure around children\'s major expenses',
        category: StrategyCategory.lifeEventPlanning,
        icon: Icons.child_care,
        accentColor: Colors.amber[700]!,
        implementationSteps: [
          'Map children\'s ages and future milestones',
          'Estimate major education expenses',
          'Plan accelerated prepayment schedule',
          'Build separate education corpus',
          'Target loan closure before college',
          'Balance both goals simultaneously',
        ],
        tips: [
          'Start early for maximum impact',
          'College expenses are typically highest',
          'Consider inflation in planning',
          'Separate corpus vs prepayment balance',
        ],
        considerations: [
          'Education costs inflate rapidly',
          'Multiple children multiply complexity',
          'Career breaks may affect income',
          'Opportunity cost of aggressive prepayment',
        ],
        difficultyLevel: 4,
        estimatedTime: const Duration(hours: 3),
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.taxMaximizer,
        title: 'Section 80C/24b Maximizer',
        description: 'Maximize all available tax benefits',
        category: StrategyCategory.lifeEventPlanning,
        icon: Icons.receipt_long,
        accentColor: Colors.grey[700]!,
        implementationSteps: [
          'Track principal repayment for 80C',
          'Monitor interest payments for 24b',
          'Ensure proper documentation',
          'Claim benefits in ITR filing',
          'Get Form 26AS verification',
          'Plan for maximum utilization',
        ],
        tips: [
          'Principal repayment qualifies for 80C',
          'Interest up to ₹2L deductible under 24b',
          'Keep all bank statements and certificates',
          'Coordinate with other 80C investments',
        ],
        considerations: [
          'Benefits only if you pay income tax',
          'Limits change with tax law updates',
          'Proper documentation is crucial',
          'Timing of payments affects tax year',
        ],
        difficultyLevel: 2,
        estimatedTime: const Duration(hours: 2),
        hasVisualComponent: true,
      ),

      StrategyDetailModel(
        type: StrategyType.emiRentCrossover,
        title: 'EMI-to-Rent Crossover',
        description: 'Analyze when EMI becomes better than rent',
        category: StrategyCategory.lifeEventPlanning,
        icon: Icons.home,
        accentColor: Colors.teal[700]!,
        implementationSteps: [
          'Research current market rent for similar property',
          'Factor in maintenance and society costs',
          'Consider tax benefits of EMI',
          'Evaluate property appreciation potential',
          'Include opportunity cost analysis',
          'Make hold vs rent decision',
        ],
        tips: [
          'Include all ownership costs in comparison',
          'Factor in tax benefits that reduce EMI cost',
          'Consider flexibility needs',
          'Property appreciation adds to returns',
        ],
        considerations: [
          'Rent-free periods in calculation',
          'Maintenance and repair costs',
          'Opportunity cost of down payment',
          'Flexibility to relocate',
        ],
        difficultyLevel: 4,
        estimatedTime: const Duration(hours: 2),
        requiresCalculation: true,
        hasVisualComponent: true,
      ),
    ];
  }
}