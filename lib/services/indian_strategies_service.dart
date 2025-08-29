import '../data/indian_strategies_content.dart';
import '../core/utils/loan_calculations.dart';

/// Service class to provide easy access to Indian home loan strategies
/// 
/// This service acts as a facade for the comprehensive content repository,
/// providing calculated results based on user's specific loan parameters.
class IndianStrategiesService {
  IndianStrategiesService._();
  static final IndianStrategiesService _instance = IndianStrategiesService._();
  static IndianStrategiesService get instance => _instance;

  /// Get all 7 strategies with calculated results for specific loan
  List<Map<String, dynamic>> getAllStrategiesForLoan({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) {
    final baseEMI = LoanCalculations.calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
    );

    return [
      _calculateStrategyForLoan(
        IndianStrategiesContent.extraEMIStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.stepUpStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.roundUpStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.festivalPrepaymentStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.balanceTransferStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.pfWithdrawalStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
      _calculateStrategyForLoan(
        IndianStrategiesContent.taxOptimizationStrategy,
        loanAmount,
        interestRate,
        tenureYears,
        baseEMI,
      ),
    ];
  }

  /// Get specific strategy by ID with calculated results
  Map<String, dynamic>? getStrategyById({
    required String strategyId,
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) {
    final strategies = getAllStrategiesForLoan(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    try {
      return strategies.firstWhere((strategy) => strategy['id'] == strategyId);
    } catch (e) {
      return null;
    }
  }

  /// Get strategies prioritized by effectiveness for the specific loan
  List<Map<String, dynamic>> getPrioritizedStrategies({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) {
    final strategies = getAllStrategiesForLoan(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    // Sort by prioritization score (higher is better)
    strategies.sort((a, b) => b['prioritizationScore'].compareTo(a['prioritizationScore']));
    
    return strategies;
  }

  /// Get strategies filtered by difficulty level
  List<Map<String, dynamic>> getStrategiesByDifficulty({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
    required int maxDifficultyLevel,
  }) {
    final strategies = getAllStrategiesForLoan(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    return strategies
        .where((strategy) => strategy['difficultyLevel'] <= maxDifficultyLevel)
        .toList();
  }

  /// Get strategies that work well together
  List<List<Map<String, dynamic>>> getComplementaryStrategies({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) {
    final strategies = getAllStrategiesForLoan(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    return [
      // Combination 1: Foundation + Systematic
      [
        strategies.firstWhere((s) => s['id'] == 'round_up_emi'),
        strategies.firstWhere((s) => s['id'] == 'extra_emi_yearly'),
        strategies.firstWhere((s) => s['id'] == 'tax_benefit_optimization'),
      ],
      
      // Combination 2: Aggressive Growth
      [
        strategies.firstWhere((s) => s['id'] == 'annual_step_up'),
        strategies.firstWhere((s) => s['id'] == 'festival_prepayment'),
        strategies.firstWhere((s) => s['id'] == 'tax_benefit_optimization'),
      ],
      
      // Combination 3: One-time + Ongoing
      [
        strategies.firstWhere((s) => s['id'] == 'balance_transfer'),
        strategies.firstWhere((s) => s['id'] == 'round_up_emi'),
        strategies.firstWhere((s) => s['id'] == 'tax_benefit_optimization'),
      ],
    ];
  }

  /// Calculate strategy impact for specific loan parameters
  Map<String, dynamic> _calculateStrategyForLoan(
    Map<String, dynamic> baseStrategy,
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    // Create a copy of the base strategy
    final calculatedStrategy = Map<String, dynamic>.from(baseStrategy);
    
    // Calculate specific impacts based on strategy type
    switch (baseStrategy['id']) {
      case 'extra_emi_yearly':
        calculatedStrategy['calculatedImpact'] = _calculateExtraEMIImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'annual_step_up':
        calculatedStrategy['calculatedImpact'] = _calculateStepUpImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'round_up_emi':
        calculatedStrategy['calculatedImpact'] = _calculateRoundUpImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'festival_prepayment':
        calculatedStrategy['calculatedImpact'] = _calculateFestivalImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'balance_transfer':
        calculatedStrategy['calculatedImpact'] = _calculateBalanceTransferImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'pf_withdrawal_prepayment':
        calculatedStrategy['calculatedImpact'] = _calculatePFWithdrawalImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
        
      case 'tax_benefit_optimization':
        calculatedStrategy['calculatedImpact'] = _calculateTaxOptimizationImpact(
          loanAmount, interestRate, tenureYears, baseEMI,
        );
        break;
    }
    
    return calculatedStrategy;
  }

  /// Calculate Extra EMI impact for specific loan
  Map<String, dynamic> _calculateExtraEMIImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    final extraPrincipal = baseEMI; // One EMI amount as extra
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      extraPrincipal: extraPrincipal,
    );

    return {
      'interestSaved': result['interestSaved'],
      'timeSavedYears': result['timeSaved'],
      'extraAnnualAmount': extraPrincipal,
      'totalSavings': result['interestSaved'],
      'roi': (result['interestSaved'] as double) / (extraPrincipal * 10) * 100,
    };
  }

  /// Calculate Step-up impact for specific loan
  Map<String, dynamic> _calculateStepUpImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    // Simplified step-up calculation
    double totalExtraPayment = 0;
    double totalInterestSaved = 0;
    double currentEMI = baseEMI;
    
    final yearsToCalculate = tenureYears > 10 ? 10 : tenureYears;
    
    for (int year = 1; year <= yearsToCalculate; year++) {
      currentEMI *= 1.05; // 5% increase
      final extraPayment = (currentEMI - baseEMI) * 12;
      totalExtraPayment += extraPayment;
      
      // Approximate interest saved
      final interestSavedThisYear = extraPayment * (interestRate / 100) * (tenureYears - year);
      totalInterestSaved += interestSavedThisYear;
    }
    
    return {
      'interestSaved': totalInterestSaved * 1.15, // Adjust for compounding
      'timeSavedYears': 4.0, // Approximate
      'totalExtraPayments': totalExtraPayment,
      'totalSavings': totalInterestSaved * 1.15,
      'roi': (totalInterestSaved * 1.15) / totalExtraPayment * 100,
    };
  }

  /// Calculate Round-up impact for specific loan
  Map<String, dynamic> _calculateRoundUpImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    final roundedEMI = ((baseEMI / 1000).ceil() * 1000).toDouble();
    final extraMonthly = roundedEMI - baseEMI;
    
    if (extraMonthly <= 0) {
      return {
        'interestSaved': 0.0,
        'timeSavedYears': 0.0,
        'extraMonthlyAmount': 0.0,
        'totalSavings': 0.0,
        'roi': 0.0,
      };
    }
    
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      extraPrincipal: extraMonthly,
    );

    return {
      'interestSaved': result['interestSaved'],
      'timeSavedYears': result['timeSaved'],
      'extraMonthlyAmount': extraMonthly,
      'totalSavings': result['interestSaved'],
      'roi': (result['interestSaved'] as double) / (extraMonthly * 12 * 10) * 100,
    };
  }

  /// Calculate Festival prepayment impact
  Map<String, dynamic> _calculateFestivalImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    const annualBonusAmount = 100000.0; // ₹1L typical bonus
    final monthlyEquivalent = annualBonusAmount / 12;
    
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      extraPrincipal: monthlyEquivalent,
    );

    return {
      'interestSaved': result['interestSaved'],
      'timeSavedYears': result['timeSaved'],
      'annualBonusAmount': annualBonusAmount,
      'totalSavings': result['interestSaved'],
      'roi': (result['interestSaved'] as double) / annualBonusAmount * 100,
    };
  }

  /// Calculate Balance Transfer impact
  Map<String, dynamic> _calculateBalanceTransferImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    const rateReduction = 0.5; // Assume 0.5% reduction
    final newRate = interestRate - rateReduction;
    
    if (newRate <= 0) {
      return {
        'interestSaved': 0.0,
        'monthlySaving': 0.0,
        'totalSavings': 0.0,
        'transferCosts': 50000.0,
        'netSavings': -50000.0,
      };
    }
    
    final newEMI = LoanCalculations.calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: newRate,
      tenureYears: tenureYears,
    );
    
    final monthlySaving = baseEMI - newEMI;
    final totalSavings = monthlySaving * tenureYears * 12;
    const transferCosts = 50000.0; // Approximate transfer costs
    
    return {
      'interestSaved': totalSavings,
      'monthlySaving': monthlySaving,
      'totalSavings': totalSavings,
      'transferCosts': transferCosts,
      'netSavings': totalSavings - transferCosts,
      'paybackMonths': transferCosts / monthlySaving,
    };
  }

  /// Calculate PF Withdrawal impact
  Map<String, dynamic> _calculatePFWithdrawalImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    const pfAmount = 500000.0; // ₹5L typical PF withdrawal
    final monthlyEquivalent = pfAmount / 12;
    
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenureYears,
      extraPrincipal: monthlyEquivalent,
    );

    return {
      'interestSaved': result['interestSaved'],
      'timeSavedYears': result['timeSaved'],
      'pfWithdrawalAmount': pfAmount,
      'totalSavings': result['interestSaved'],
      'roi': (result['interestSaved'] as double) / pfAmount * 100,
    };
  }

  /// Calculate Tax Optimization impact
  Map<String, dynamic> _calculateTaxOptimizationImpact(
    double loanAmount,
    double interestRate,
    int tenureYears,
    double baseEMI,
  ) {
    final annualInterest = baseEMI * 12 * 0.78; // Approximate interest portion
    final annualPrincipal = baseEMI * 12 * 0.22; // Approximate principal portion
    
    // Assume 30% tax bracket for calculation
    const taxRate = 0.30;
    
    final interestTaxSaved = (annualInterest > 200000 ? 200000 : annualInterest) * taxRate;
    final principalTaxSaved = (annualPrincipal > 150000 ? 150000 : annualPrincipal) * taxRate;
    
    final annualTaxSaved = interestTaxSaved + principalTaxSaved;
    final lifetimeTaxSaved = annualTaxSaved * (tenureYears > 15 ? 15 : tenureYears);
    
    return {
      'annualTaxSaved': annualTaxSaved,
      'lifetimeTaxSaved': lifetimeTaxSaved,
      'section80cBenefit': principalTaxSaved,
      'section24bBenefit': interestTaxSaved,
      'totalSavings': lifetimeTaxSaved,
    };
  }

  /// Format amount in lakhs for display
  String formatLakhs(double amount) {
    return (amount / 100000).toStringAsFixed(1);
  }

  /// Format amount in INR with proper comma separation
  String formatINR(double amount) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
      formatter,
      (Match match) => '${match[1]},',
    );
  }

  /// Get user-friendly description for any loan amount/rate/tenure
  String getStrategyDescription(String strategyId, double loanAmount, double interestRate, int tenureYears) {
    final strategy = getStrategyById(
      strategyId: strategyId,
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    if (strategy == null || strategy['calculatedImpact'] == null) {
      return 'Strategy not available for these loan parameters';
    }

    final impact = strategy['calculatedImpact'] as Map<String, dynamic>;
    final interestSaved = impact['interestSaved'] as double? ?? 0.0;
    
    switch (strategyId) {
      case 'extra_emi_yearly':
        return 'Pay one extra EMI per year to save ₹${formatLakhs(interestSaved)} lakhs in interest';
      case 'annual_step_up':
        return 'Increase EMI by 5% annually to save ₹${formatLakhs(interestSaved)} lakhs over loan tenure';
      case 'round_up_emi':
        return 'Round up EMI to nearest thousand to save ₹${formatLakhs(interestSaved)} lakhs with minimal effort';
      case 'festival_prepayment':
        return 'Use festival bonuses for prepayment to save ₹${formatLakhs(interestSaved)} lakhs in interest';
      case 'balance_transfer':
        return 'Transfer loan to lower rate bank and save ₹${formatLakhs(interestSaved)} lakhs over tenure';
      case 'pf_withdrawal_prepayment':
        return 'Use PF withdrawal strategically to save ₹${formatLakhs(interestSaved)} lakhs in total interest';
      case 'tax_benefit_optimization':
        final annualSaving = impact['annualTaxSaved'] as double? ?? 0.0;
        return 'Optimize tax benefits to save ₹${formatLakhs(annualSaving)} lakhs annually in taxes';
      default:
        return 'Strategy saves ₹${formatLakhs(interestSaved)} lakhs in interest';
    }
  }
}