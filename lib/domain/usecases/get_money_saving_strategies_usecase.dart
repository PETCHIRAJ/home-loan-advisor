import '../entities/loan_parameters.dart';
import '../entities/emi_result.dart';
import '../entities/money_saving_strategy.dart';
import '../../core/utils/calculation_utils.dart';
import 'dart:math';

/// Use case to get personalized money-saving strategies for Indian home loans
class GetMoneySavingStrategiesUseCase {
  
  /// Get all available strategies with personalized calculations
  Future<List<PersonalizedStrategyResult>> call({
    required LoanParameters parameters,
    required EMIResult currentResult,
  }) async {
    try {
      final strategies = _getTop5Strategies();
      final personalizedResults = <PersonalizedStrategyResult>[];

      for (final strategy in strategies) {
        final result = _calculatePersonalizedResult(
          strategy: strategy,
          parameters: parameters,
          currentResult: currentResult,
        );
        personalizedResults.add(result);
      }

      // Sort by savings amount (highest first)
      personalizedResults.sort((a, b) => 
          b.personalizedSavings.compareTo(a.personalizedSavings));

      return personalizedResults;
    } catch (e) {
      throw Exception('Failed to calculate strategies: ${e.toString()}');
    }
  }

  /// Get the top 5 money-saving strategies for Indian market
  List<MoneySavingStrategy> _getTop5Strategies() {
    return [
      // 1. Extra EMI Payment (13th EMI yearly)
      const MoneySavingStrategy(
        id: 'extra_emi_yearly',
        title: 'Extra EMI Strategy',
        description: 'Pay one additional EMI every year to save massive interest',
        emoji: '💰',
        category: StrategyCategory.prepayment,
        complexity: StrategyComplexity.low,
        potentialSavingsMin: 800000, // 8 lakhs
        potentialSavingsMax: 1200000, // 12 lakhs
        setupTimeMinutes: 5,
        successProbability: 0.95,
        implementationSteps: [
          'Calculate your annual EMI amount',
          'Set up automatic transfer for December (bonus month)',
          'Instruct bank to apply as prepayment towards principal',
          'Track savings annually',
        ],
        requirements: [
          'Annual bonus or savings equivalent to 1 EMI',
          'Bank account with sufficient balance',
          'Standing instruction facility',
        ],
        benefits: [
          'Save ₹8-12 lakhs in total interest',
          'Reduce loan tenure by 4-6 years',
          'No paperwork or bank visits required',
          'Can be automated with standing instruction',
        ],
        considerations: [
          'Requires discipline to save extra amount',
          'May impact annual cash flow',
          'Alternative investments might give better returns',
        ],
        calculationMethod: StrategyCalculation.extraEmiYearly,
        isPopular: true,
        quickWinLabel: 'Quick Win',
      ),

      // 2. EMI Step-up (5% yearly increase)
      const MoneySavingStrategy(
        id: 'emi_step_up_5percent',
        title: '5% EMI Increase Yearly',
        description: 'Increase your EMI by 5% every year as your income grows',
        emoji: '📈',
        category: StrategyCategory.prepayment,
        complexity: StrategyComplexity.medium,
        potentialSavingsMin: 1000000, // 10 lakhs
        potentialSavingsMax: 1500000, // 15 lakhs
        setupTimeMinutes: 30,
        successProbability: 0.85,
        implementationSteps: [
          'Calculate 5% increase of current EMI',
          'Set up annual EMI revision with bank',
          'Plan budget to accommodate increased EMI',
          'Monitor and adjust based on income growth',
        ],
        requirements: [
          'Annual income growth of 8-10%',
          'Stable employment with regular increments',
          'Emergency fund for 6 months expenses',
        ],
        benefits: [
          'Save ₹10-15 lakhs in total interest',
          'Reduce tenure by 8-10 years',
          'Matches typical salary growth',
          'Builds wealth through forced saving',
        ],
        considerations: [
          'Requires consistent income growth',
          'May strain budget during economic downturns',
          'Need flexibility to reduce if required',
        ],
        calculationMethod: StrategyCalculation.emiStepUp,
        isPopular: true,
        quickWinLabel: 'High Impact',
      ),

      // 3. Lump Sum Prepayment
      const MoneySavingStrategy(
        id: 'lump_sum_prepayment',
        title: 'Lump Sum Prepayment',
        description: 'Use bonus, inheritance, or savings for one-time prepayment',
        emoji: '💸',
        category: StrategyCategory.prepayment,
        complexity: StrategyComplexity.low,
        potentialSavingsMin: 300000, // 3 lakhs
        potentialSavingsMax: 2000000, // 20 lakhs
        setupTimeMinutes: 15,
        successProbability: 0.90,
        implementationSteps: [
          'Identify available lump sum amount',
          'Visit bank branch or use net banking',
          'Choose principal reduction option',
          'Get updated loan schedule and savings report',
        ],
        requirements: [
          'Available lump sum (bonus, savings, inheritance)',
          'Retain 6-month emergency fund',
          'No high-interest debt (credit cards)',
        ],
        benefits: [
          'Immediate interest savings',
          'Reduce loan tenure significantly',
          'Lower monthly financial burden',
          'Psychological relief of reduced debt',
        ],
        considerations: [
          'Opportunity cost of alternative investments',
          'Maintain adequate emergency fund',
          'Consider tax implications on withdrawn investments',
        ],
        calculationMethod: StrategyCalculation.lumpSumPrepayment,
        isPopular: true,
        quickWinLabel: 'Instant Impact',
      ),

      // 4. Refinancing to Lower Rate
      const MoneySavingStrategy(
        id: 'refinance_lower_rate',
        title: 'Refinance at Lower Rate',
        description: 'Switch to a bank offering lower interest rates',
        emoji: '🏦',
        category: StrategyCategory.refinancing,
        complexity: StrategyComplexity.high,
        potentialSavingsMin: 500000, // 5 lakhs
        potentialSavingsMax: 1500000, // 15 lakhs
        setupTimeMinutes: 240, // 4 hours
        successProbability: 0.70,
        implementationSteps: [
          'Research banks offering lower rates',
          'Check eligibility and processing charges',
          'Apply for loan takeover/balance transfer',
          'Complete documentation and legal formalities',
          'Close existing loan after new loan approval',
        ],
        requirements: [
          'Good credit score (750+)',
          'Stable income for 2+ years',
          'Existing loan with 10+ years remaining',
          'Property papers in order',
        ],
        benefits: [
          'Save ₹5-15 lakhs over loan tenure',
          'Lower monthly EMI',
          'Better bank services',
          'Potential for additional facilities',
        ],
        considerations: [
          'Processing fees and legal charges (₹25,000-50,000)',
          'Break-even time of 2-3 years',
          'Documentation and approval time',
          'Risk of rejection affecting credit score',
        ],
        calculationMethod: StrategyCalculation.refinanceRate,
        isPopular: false,
        quickWinLabel: 'Long-term Win',
      ),

      // 5. Round-up EMI Strategy
      const MoneySavingStrategy(
        id: 'emi_round_up',
        title: 'Round-up EMI Strategy',
        description: 'Round your EMI to the nearest ₹1,000 for effortless saving',
        emoji: '🎯',
        category: StrategyCategory.optimization,
        complexity: StrategyComplexity.low,
        potentialSavingsMin: 300000, // 3 lakhs
        potentialSavingsMax: 500000, // 5 lakhs
        setupTimeMinutes: 10,
        successProbability: 0.98,
        implementationSteps: [
          'Round current EMI to next ₹1,000',
          'Update EMI amount with bank',
          'Set up auto-debit for new amount',
          'Track annual savings',
        ],
        requirements: [
          'Monthly surplus of ₹500-2,000',
          'Auto-debit facility',
          'Stable monthly income',
        ],
        benefits: [
          'Save ₹3-5 lakhs in total interest',
          'Reduce tenure by 2-3 years',
          'Effortless and automatic',
          'Builds saving habit',
        ],
        considerations: [
          'Small monthly impact',
          'Requires consistent surplus',
          'Alternative investment options',
        ],
        calculationMethod: StrategyCalculation.emiRoundUp,
        isPopular: true,
        quickWinLabel: 'Effortless',
      ),
    ];
  }

  /// Calculate personalized result for a specific strategy
  PersonalizedStrategyResult _calculatePersonalizedResult({
    required MoneySavingStrategy strategy,
    required LoanParameters parameters,
    required EMIResult currentResult,
  }) {
    switch (strategy.calculationMethod) {
      case StrategyCalculation.extraEmiYearly:
        return _calculateExtraEMIStrategy(strategy, parameters, currentResult);
      case StrategyCalculation.emiStepUp:
        return _calculateStepUpStrategy(strategy, parameters, currentResult);
      case StrategyCalculation.lumpSumPrepayment:
        return _calculateLumpSumStrategy(strategy, parameters, currentResult);
      case StrategyCalculation.refinanceRate:
        return _calculateRefinanceStrategy(strategy, parameters, currentResult);
      case StrategyCalculation.emiRoundUp:
        return _calculateRoundUpStrategy(strategy, parameters, currentResult);
      default:
        return PersonalizedStrategyResult(
          strategyId: strategy.id,
          personalizedSavings: 0,
          currentEMI: currentResult.monthlyEMI,
          newEMI: currentResult.monthlyEMI,
          currentTenureMonths: parameters.tenureYears * 12,
          newTenureMonths: parameters.tenureYears * 12,
          tenureReductionMonths: 0,
          totalInterestSaved: 0,
          roiOnInvestment: 0,
          feasibility: StrategyFeasibility.notRecommended,
          feasibilityReason: 'Calculation method not implemented',
          calculationDetails: {},
        );
    }
  }

  /// Calculate Extra EMI (13th EMI) strategy
  PersonalizedStrategyResult _calculateExtraEMIStrategy(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    final currentEMI = currentResult.monthlyEMI;
    final extraAmount = currentEMI; // One additional EMI per year
    final originalTenure = parameters.tenureYears * 12;
    
    // Calculate savings from extra EMI payment
    final prepaymentResult = CalculationUtils.calculatePrepaymentBenefit(
      principal: parameters.loanAmount,
      annualRate: parameters.interestRate,
      tenureYears: parameters.tenureYears,
      prepaymentAmount: extraAmount,
      prepaymentAfterMonths: 12, // After first year
    );

    // Estimate annual repetition impact
    final annualSavings = prepaymentResult['interestSaved'] as double;
    final estimatedTotalSavings = annualSavings * (parameters.tenureYears / 2); // Conservative estimate
    
    // Assess feasibility
    final monthlyIncome = parameters.annualIncome / 12;
    final currentEMItoIncome = currentEMI / monthlyIncome;
    final feasibility = _assessFeasibility(
      monthlyIncome: monthlyIncome,
      currentEMItoIncome: currentEMItoIncome,
      additionalAmount: extraAmount / 12, // Monthly impact
      strategy: strategy,
    );

    return PersonalizedStrategyResult(
      strategyId: strategy.id,
      personalizedSavings: estimatedTotalSavings,
      currentEMI: currentEMI,
      newEMI: currentEMI, // EMI remains same, just one extra payment
      currentTenureMonths: originalTenure,
      newTenureMonths: originalTenure - (prepaymentResult['tenureReduced'] as int),
      tenureReductionMonths: prepaymentResult['tenureReduced'] as int,
      totalInterestSaved: estimatedTotalSavings,
      roiOnInvestment: (estimatedTotalSavings / (extraAmount * parameters.tenureYears)) * 100,
      feasibility: feasibility.$1,
      feasibilityReason: feasibility.$2,
      calculationDetails: {
        'extraEMIAmount': extraAmount,
        'paymentFrequency': 'Yearly',
        'totalExtraPayments': parameters.tenureYears,
        'totalExtraAmount': extraAmount * parameters.tenureYears,
      },
    );
  }

  /// Calculate 5% EMI step-up strategy
  PersonalizedStrategyResult _calculateStepUpStrategy(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    final currentEMI = currentResult.monthlyEMI;
    final stepUpRate = 0.05; // 5% per year
    final originalTenure = parameters.tenureYears * 12;
    
    // Simulate step-up EMI calculation
    double totalInterestSaved = 0;
    double currentPrincipal = parameters.loanAmount;
    double emi = currentEMI;
    int monthsToPayOff = 0;
    
    for (int year = 1; year <= parameters.tenureYears; year++) {
      // Increase EMI by 5% from second year onwards
      if (year > 1) {
        emi *= (1 + stepUpRate);
      }
      
      // Calculate payments for this year
      for (int month = 1; month <= 12 && currentPrincipal > 0; month++) {
        final monthlyRate = parameters.interestRate / 100 / 12;
        final interestComponent = currentPrincipal * monthlyRate;
        final principalComponent = min(emi - interestComponent, currentPrincipal);
        
        currentPrincipal -= principalComponent;
        monthsToPayOff++;
        
        if (currentPrincipal <= 0) break;
      }
      
      if (currentPrincipal <= 0) break;
    }
    
    // Calculate total savings
    final originalTotalAmount = currentResult.monthlyEMI * originalTenure;
    final stepUpTotalAmount = _calculateTotalAmountWithStepUp(
      currentEMI, stepUpRate, monthsToPayOff);
    totalInterestSaved = (originalTotalAmount - parameters.loanAmount) - 
                        (stepUpTotalAmount - parameters.loanAmount);

    // Assess feasibility
    final monthlyIncome = parameters.annualIncome / 12;
    final finalEMI = currentEMI * pow(1 + stepUpRate, parameters.tenureYears - 1);
    final feasibility = _assessFeasibility(
      monthlyIncome: monthlyIncome,
      currentEMItoIncome: currentEMI / monthlyIncome,
      additionalAmount: finalEMI - currentEMI,
      strategy: strategy,
    );

    return PersonalizedStrategyResult(
      strategyId: strategy.id,
      personalizedSavings: totalInterestSaved,
      currentEMI: currentEMI,
      newEMI: currentEMI * 1.05, // First year increase
      currentTenureMonths: originalTenure,
      newTenureMonths: monthsToPayOff,
      tenureReductionMonths: originalTenure - monthsToPayOff,
      totalInterestSaved: totalInterestSaved,
      roiOnInvestment: (totalInterestSaved / 
          (finalEMI - currentEMI) * parameters.tenureYears) * 100,
      feasibility: feasibility.$1,
      feasibilityReason: feasibility.$2,
      calculationDetails: {
        'stepUpRate': stepUpRate * 100,
        'firstYearEMI': currentEMI,
        'finalYearEMI': finalEMI,
        'averageEMI': (currentEMI + finalEMI) / 2,
      },
    );
  }

  /// Calculate lump sum prepayment strategy
  PersonalizedStrategyResult _calculateLumpSumStrategy(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    // Assume lump sum as 10% of loan amount or 2 years of EMI, whichever is lower
    final twoYearEMI = currentResult.monthlyEMI * 24;
    final tenPercentLoan = parameters.loanAmount * 0.1;
    final lumpSumAmount = min(twoYearEMI, tenPercentLoan);
    
    final prepaymentResult = CalculationUtils.calculatePrepaymentBenefit(
      principal: parameters.loanAmount,
      annualRate: parameters.interestRate,
      tenureYears: parameters.tenureYears,
      prepaymentAmount: lumpSumAmount,
      prepaymentAfterMonths: 24, // After 2 years
    );

    // Assess feasibility
    final annualIncome = parameters.annualIncome;
    final feasibility = _assessLumpSumFeasibility(
      annualIncome: annualIncome,
      lumpSumAmount: lumpSumAmount,
      strategy: strategy,
    );

    return PersonalizedStrategyResult(
      strategyId: strategy.id,
      personalizedSavings: prepaymentResult['interestSaved'] as double,
      currentEMI: currentResult.monthlyEMI,
      newEMI: prepaymentResult['newEMI'] as double,
      currentTenureMonths: parameters.tenureYears * 12,
      newTenureMonths: (parameters.tenureYears * 12) - 
          (prepaymentResult['tenureReduced'] as int),
      tenureReductionMonths: prepaymentResult['tenureReduced'] as int,
      totalInterestSaved: prepaymentResult['interestSaved'] as double,
      roiOnInvestment: ((prepaymentResult['interestSaved'] as double) / 
          lumpSumAmount) * 100,
      feasibility: feasibility.$1,
      feasibilityReason: feasibility.$2,
      calculationDetails: {
        'lumpSumAmount': lumpSumAmount,
        'paymentTiming': 'After 2 years',
        'roiEquivalent': ((prepaymentResult['interestSaved'] as double) / 
            lumpSumAmount * 100).toStringAsFixed(1),
      },
    );
  }

  /// Calculate refinancing strategy
  PersonalizedStrategyResult _calculateRefinanceStrategy(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    // Assume 0.5% to 1% rate reduction is possible
    final rateReduction = 0.75; // 0.75% reduction
    final newRate = parameters.interestRate - rateReduction;
    
    final newEMI = CalculationUtils.calculateEMI(
      principal: parameters.loanAmount,
      annualRate: newRate,
      tenureYears: parameters.tenureYears,
    );
    
    final currentTotalAmount = currentResult.monthlyEMI * parameters.tenureYears * 12;
    final newTotalAmount = newEMI * parameters.tenureYears * 12;
    final totalSavings = currentTotalAmount - newTotalAmount;
    
    // Subtract switching costs
    final switchingCost = 50000; // Typical switching cost
    final netSavings = totalSavings - switchingCost;

    // Assess feasibility
    final feasibility = _assessRefinanceFeasibility(
      currentRate: parameters.interestRate,
      availableRate: newRate,
      loanAmount: parameters.loanAmount,
      remainingTenure: parameters.tenureYears,
      strategy: strategy,
    );

    return PersonalizedStrategyResult(
      strategyId: strategy.id,
      personalizedSavings: netSavings,
      currentEMI: currentResult.monthlyEMI,
      newEMI: newEMI,
      currentTenureMonths: parameters.tenureYears * 12,
      newTenureMonths: parameters.tenureYears * 12, // Same tenure
      tenureReductionMonths: 0,
      totalInterestSaved: netSavings,
      roiOnInvestment: (netSavings / switchingCost) * 100,
      feasibility: feasibility.$1,
      feasibilityReason: feasibility.$2,
      calculationDetails: {
        'currentRate': parameters.interestRate,
        'newRate': newRate,
        'rateReduction': rateReduction,
        'switchingCost': switchingCost,
        'breakEvenMonths': (switchingCost / (currentResult.monthlyEMI - newEMI)).ceil(),
      },
    );
  }

  /// Calculate round-up EMI strategy
  PersonalizedStrategyResult _calculateRoundUpStrategy(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    final currentEMI = currentResult.monthlyEMI;
    final roundedEMI = (currentEMI / 1000).ceil() * 1000.0; // Round up to nearest 1000
    final extraAmount = roundedEMI - currentEMI;
    
    if (extraAmount < 100) {
      // If difference is too small, round to next thousand
      final nextRoundedEMI = roundedEMI + 1000;
      final nextExtraAmount = nextRoundedEMI - currentEMI;
      return _calculateRoundUpWithAmount(
        strategy, parameters, currentResult, nextRoundedEMI, nextExtraAmount);
    }
    
    return _calculateRoundUpWithAmount(
        strategy, parameters, currentResult, roundedEMI, extraAmount);
  }

  /// Helper for round-up calculation
  PersonalizedStrategyResult _calculateRoundUpWithAmount(
    MoneySavingStrategy strategy,
    LoanParameters parameters,
    EMIResult currentResult,
    double newEMI,
    double extraAmount,
  ) {
    // Calculate new tenure with rounded EMI
    final monthlyRate = parameters.interestRate / 100 / 12;
    final newTenure = monthlyRate == 0 
        ? (parameters.loanAmount / newEMI).ceil()
        : (log(1 + (parameters.loanAmount * monthlyRate / newEMI)) / 
           log(1 + monthlyRate)).ceil();
    
    final originalTotalAmount = currentResult.monthlyEMI * parameters.tenureYears * 12;
    final newTotalAmount = newEMI * newTenure;
    final totalSavings = originalTotalAmount - newTotalAmount;

    // Assess feasibility
    final monthlyIncome = parameters.annualIncome / 12;
    final feasibility = _assessFeasibility(
      monthlyIncome: monthlyIncome,
      currentEMItoIncome: currentResult.monthlyEMI / monthlyIncome,
      additionalAmount: extraAmount,
      strategy: strategy,
    );

    return PersonalizedStrategyResult(
      strategyId: strategy.id,
      personalizedSavings: totalSavings,
      currentEMI: currentResult.monthlyEMI,
      newEMI: newEMI,
      currentTenureMonths: parameters.tenureYears * 12,
      newTenureMonths: newTenure,
      tenureReductionMonths: (parameters.tenureYears * 12) - newTenure,
      totalInterestSaved: totalSavings,
      roiOnInvestment: (totalSavings / (extraAmount * parameters.tenureYears)) * 100,
      feasibility: feasibility.$1,
      feasibilityReason: feasibility.$2,
      calculationDetails: {
        'originalEMI': currentResult.monthlyEMI,
        'roundedEMI': newEMI,
        'extraMonthly': extraAmount,
        'extraAnnual': extraAmount * 12,
      },
    );
  }

  /// Helper method to calculate total amount with step-up
  double _calculateTotalAmountWithStepUp(
      double baseEMI, double stepUpRate, int totalMonths) {
    double totalAmount = 0;
    double currentEMI = baseEMI;
    int monthsInYear = 0;
    
    for (int month = 1; month <= totalMonths; month++) {
      totalAmount += currentEMI;
      monthsInYear++;
      
      // Increase EMI at year-end
      if (monthsInYear == 12) {
        currentEMI *= (1 + stepUpRate);
        monthsInYear = 0;
      }
    }
    
    return totalAmount;
  }

  /// Assess feasibility for regular strategies
  (StrategyFeasibility, String) _assessFeasibility({
    required double monthlyIncome,
    required double currentEMItoIncome,
    required double additionalAmount,
    required MoneySavingStrategy strategy,
  }) {
    final newEMItoIncome = (currentEMItoIncome * monthlyIncome + additionalAmount) / monthlyIncome;
    
    if (newEMItoIncome > 0.6) {
      return (StrategyFeasibility.notRecommended, 
             'EMI would exceed 60% of income');
    } else if (newEMItoIncome > 0.5) {
      return (StrategyFeasibility.conditional, 
             'Consider if you have stable income and low expenses');
    } else if (newEMItoIncome > 0.4) {
      return (StrategyFeasibility.recommended, 
             'Good option with some budget planning');
    } else {
      return (StrategyFeasibility.highlyRecommended, 
             'Excellent fit for your financial profile');
    }
  }

  /// Assess feasibility for lump sum strategies
  (StrategyFeasibility, String) _assessLumpSumFeasibility({
    required double annualIncome,
    required double lumpSumAmount,
    required MoneySavingStrategy strategy,
  }) {
    final lumpSumToIncome = lumpSumAmount / annualIncome;
    
    if (lumpSumToIncome > 0.5) {
      return (StrategyFeasibility.notRecommended, 
             'Amount exceeds 50% of annual income');
    } else if (lumpSumToIncome > 0.3) {
      return (StrategyFeasibility.conditional, 
             'Ensure emergency fund remains intact');
    } else if (lumpSumToIncome > 0.15) {
      return (StrategyFeasibility.recommended, 
             'Good use of available surplus');
    } else {
      return (StrategyFeasibility.highlyRecommended, 
             'Perfect opportunity for prepayment');
    }
  }

  /// Assess feasibility for refinancing
  (StrategyFeasibility, String) _assessRefinanceFeasibility({
    required double currentRate,
    required double availableRate,
    required double loanAmount,
    required int remainingTenure,
    required MoneySavingStrategy strategy,
  }) {
    final rateDifference = currentRate - availableRate;
    
    if (rateDifference < 0.5) {
      return (StrategyFeasibility.notRecommended, 
             'Rate difference too small to justify switching cost');
    } else if (rateDifference < 0.75) {
      return (StrategyFeasibility.conditional, 
             'Consider only if switching costs are low');
    } else if (rateDifference < 1.0) {
      return (StrategyFeasibility.recommended, 
             'Good savings potential with moderate effort');
    } else {
      return (StrategyFeasibility.highlyRecommended, 
             'Excellent opportunity for significant savings');
    }
  }
}