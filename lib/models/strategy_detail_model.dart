import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'loan_model.dart';
import '../core/utils/loan_calculations.dart';

part 'strategy_detail_model.freezed.dart';
part 'strategy_detail_model.g.dart';

/// Comprehensive model for strategy details with calculations and content
///
/// Based on STRATEGY_DETAIL_SPECS.md - contains all 20 strategies organized
/// by categories with personalized calculations and implementation guidance.
@freezed
class StrategyDetailModel with _$StrategyDetailModel {
  const factory StrategyDetailModel({
    required StrategyType type,
    required String title,
    required String description,
    required StrategyCategory category,
    @JsonKey(includeFromJson: false, includeToJson: false) IconData? icon,
    @JsonKey(includeFromJson: false, includeToJson: false) Color? accentColor,
    required List<String> implementationSteps,
    required List<String> tips,
    required List<String> considerations,
    required int difficultyLevel, // 1-5 scale
    required Duration estimatedTime, // Time to implement
    @Default(false) bool requiresCalculation,
    @Default(false) bool hasVisualComponent,
    String? calculatorHint,
  }) = _StrategyDetailModel;

  factory StrategyDetailModel.fromJson(Map<String, dynamic> json) =>
      _$StrategyDetailModelFromJson(json);
}

/// Extension for calculating strategy-specific impact
extension StrategyDetailCalculations on StrategyDetailModel {
  /// Calculate personalized impact based on loan parameters
  StrategyImpact calculateImpact(LoanModel loan) {
    switch (type) {
      case StrategyType.dailyInterestBurn:
        return _calculateDailyInterestBurn(loan);
      case StrategyType.rule78Revealer:
        return _calculateRule78Impact(loan);
      case StrategyType.totalInterestShock:
        return _calculateTotalInterestShock(loan);
      case StrategyType.breakEvenTracker:
        return _calculateBreakEvenPoint(loan);
      case StrategyType.extraEMIStrategy:
        return _calculateExtraEMIImpact(loan);
      case StrategyType.roundUpOptimizer:
        return _calculateRoundUpImpact(loan);
      case StrategyType.prepaymentCalculator:
        return _calculatePrepaymentImpact(loan);
      case StrategyType.partPaymentTiming:
        return _calculateOptimalTiming(loan);
      case StrategyType.taxArbitrage:
        return _calculateTaxArbitrage(loan);
      case StrategyType.prepayVsInvestment:
        return _calculatePrepayVsInvestment(loan);
      case StrategyType.ppfVsPrepay:
        return _calculatePPFComparison(loan);
      case StrategyType.tenureReduction:
        return _calculateTenureReduction(loan);
      case StrategyType.coffeeToEMI:
        return _calculateDailyHabitsImpact(loan);
      case StrategyType.incrementAllocator:
        return _calculateIncrementAllocation(loan);
      case StrategyType.fixedVsFloating:
        return _calculateRateComparison(loan);
      case StrategyType.marriageStrategy:
        return _calculateDualIncomeStrategy(loan);
      case StrategyType.jobChangeEMI:
        return _calculateCareerProgressionStrategy(loan);
      case StrategyType.childrenPlanning:
        return _calculateEducationMilestones(loan);
      case StrategyType.taxMaximizer:
        return _calculateTaxMaximization(loan);
      case StrategyType.emiRentCrossover:
        return _calculateRentComparison(loan);
    }
  }

  // Strategy-specific calculation methods
  StrategyImpact _calculateDailyInterestBurn(LoanModel loan) {
    final dailyInterest = (loan.loanAmount * loan.annualInterestRate / 100) / 365;
    final monthlyInterest = dailyInterest * 30;
    final yearlyInterest = dailyInterest * 365;

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Daily Interest Burn',
        value: dailyInterest,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Monthly Loss',
          value: monthlyInterest,
          format: MetricFormat.currency,
        ),
        MetricData(
          label: 'Yearly Loss',
          value: yearlyInterest,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Money burning away every single day',
      actionability: StrategyActionability.awareness,
    );
  }

  StrategyImpact _calculateRule78Impact(LoanModel loan) {
    final firstMonthBreakdown = LoanCalculations.calculateMonthlyBreakdown(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      monthNumber: 1,
    );
    
    final year10Breakdown = LoanCalculations.calculateMonthlyBreakdown(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      monthNumber: 120, // 10 years
    );

    final totalEMI = loan.monthlyEMI;
    final year1InterestRatio = (firstMonthBreakdown['interest']! / totalEMI) * 100;
    final year10InterestRatio = (year10Breakdown['interest']! / totalEMI) * 100;

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'First Year Interest Ratio',
        value: year1InterestRatio,
        format: MetricFormat.percentage,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Year 10 Interest Ratio',
          value: year10InterestRatio,
          format: MetricFormat.percentage,
        ),
        const MetricData(
          label: 'Final Year Interest Ratio',
          value: 10.0, // Approximate for final years
          format: MetricFormat.percentage,
        ),
      ],
      description: 'See how interest dominates early payments',
      actionability: StrategyActionability.educational,
    );
  }

  StrategyImpact _calculateTotalInterestShock(LoanModel loan) {
    final totalInterest = loan.totalInterest;
    final totalAmount = loan.totalAmount;
    final multipleOfPrincipal = totalAmount / loan.loanAmount;

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Total Interest Payable',
        value: totalInterest,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Total Amount',
          value: totalAmount,
          format: MetricFormat.currency,
        ),
        MetricData(
          label: 'Multiple of Principal',
          value: multipleOfPrincipal,
          format: MetricFormat.multiplier,
        ),
      ],
      description: 'You\'ll pay ${multipleOfPrincipal.toStringAsFixed(1)}X the loan amount!',
      actionability: StrategyActionability.motivational,
    );
  }

  StrategyImpact _calculateBreakEvenPoint(LoanModel loan) {
    // Find the month where remaining principal < half of original loan
    final halfLoan = loan.loanAmount / 2;
    int breakEvenMonth = 0;
    
    for (int month = 1; month <= loan.totalMonths; month++) {
      final balance = LoanCalculations.calculateOutstandingBalance(
        loanAmount: loan.loanAmount,
        annualInterestRate: loan.annualInterestRate,
        tenureYears: loan.tenureYears,
        paymentsMade: month,
      );
      
      if (balance < halfLoan) {
        breakEvenMonth = month;
        break;
      }
    }

    final breakEvenYears = breakEvenMonth / 12;

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Break-Even Point',
        value: breakEvenYears,
        format: MetricFormat.years,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Months to Break-Even',
          value: breakEvenMonth.toDouble(),
          format: MetricFormat.months,
        ),
        MetricData(
          label: 'Remaining Years',
          value: loan.tenureYears - breakEvenYears,
          format: MetricFormat.years,
        ),
      ],
      description: 'When you\'ll own more than the bank',
      actionability: StrategyActionability.milestone,
    );
  }

  StrategyImpact _calculateExtraEMIImpact(LoanModel loan) {
    final extraAmount = loan.monthlyEMI; // One extra EMI per year
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: extraAmount,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Interest Saved',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Time Saved',
          value: savingsData['timeSaved'] as double,
          format: MetricFormat.years,
        ),
        MetricData(
          label: 'Extra Amount Needed',
          value: extraAmount,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Pay one extra EMI yearly (12+1 strategy)',
      actionability: StrategyActionability.actionable,
    );
  }

  StrategyImpact _calculateRoundUpImpact(LoanModel loan) {
    final currentEMI = loan.monthlyEMI;
    final roundedEMI = (currentEMI / 1000).ceil() * 1000.0; // Round to nearest thousand
    final extraAmount = roundedEMI - currentEMI;
    
    if (extraAmount < 100) {
      // If already rounded, round to next thousand
      final nextRoundEMI = roundedEMI + 1000;
      final nextExtraAmount = nextRoundEMI - currentEMI;
      
      final savingsData = LoanCalculations.calculateExtraPaymentSavings(
        loanAmount: loan.loanAmount,
        annualInterestRate: loan.annualInterestRate,
        tenureYears: loan.tenureYears,
        extraPrincipal: nextExtraAmount,
      );

      return StrategyImpact(
        primaryMetric: MetricData(
          label: 'Interest Saved',
          value: savingsData['interestSaved'] as double,
          format: MetricFormat.currency,
        ),
        secondaryMetrics: [
          MetricData(
            label: 'Monthly Extra Amount',
            value: nextExtraAmount,
            format: MetricFormat.currency,
          ),
          MetricData(
            label: 'Time Saved',
            value: savingsData['timeSaved'] as double,
            format: MetricFormat.years,
          ),
        ],
        description: 'Round EMI to ₹${nextRoundEMI.toInt()}',
        actionability: StrategyActionability.actionable,
      );
    }

    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: extraAmount,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Interest Saved',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Monthly Extra Amount',
          value: extraAmount,
          format: MetricFormat.currency,
        ),
        MetricData(
          label: 'Time Saved',
          value: savingsData['timeSaved'] as double,
          format: MetricFormat.years,
        ),
      ],
      description: 'Round EMI to ₹${roundedEMI.toInt()}',
      actionability: StrategyActionability.actionable,
    );
  }

  // Placeholder implementations for remaining strategies
  StrategyImpact _calculatePrepaymentImpact(LoanModel loan) {
    const prepayAmount = 100000.0; // Example ₹1L prepayment
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: prepayAmount,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Savings from ₹1L Prepayment',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Time Saved',
          value: savingsData['timeSaved'] as double,
          format: MetricFormat.years,
        ),
      ],
      description: 'Impact of lump sum prepayment',
      actionability: StrategyActionability.actionable,
    );
  }

  StrategyImpact _calculateOptimalTiming(LoanModel loan) {
    return const StrategyImpact(
      primaryMetric: MetricData(
        label: 'Optimal Prepayment Window',
        value: 3.0, // March (financial year end)
        format: MetricFormat.month,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Typical Charges',
          value: 2.0,
          format: MetricFormat.percentage,
        ),
      ],
      description: 'Best timing for prepayments',
      actionability: StrategyActionability.tactical,
    );
  }

  StrategyImpact _calculateTaxArbitrage(LoanModel loan) {
    final effectiveRate = loan.annualInterestRate * 0.7; // Assuming 30% tax bracket
    
    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Effective Interest Rate',
        value: effectiveRate,
        format: MetricFormat.percentage,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Tax Benefit',
          value: loan.annualInterestRate - effectiveRate,
          format: MetricFormat.percentage,
        ),
      ],
      description: 'Post-tax cost of your loan',
      actionability: StrategyActionability.analytical,
    );
  }

  StrategyImpact _calculatePrepayVsInvestment(LoanModel loan) {
    final loanStage = (DateTime.now().year - (loan.loanStartDate?.year ?? DateTime.now().year)) + 1;
    final recommendation = loanStage <= 10 ? 'Prepay' : 'Consider Investing';

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Current Loan Stage',
        value: loanStage.toDouble(),
        format: MetricFormat.years,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Recommended Action',
          value: recommendation == 'Prepay' ? 1.0 : 0.0,
          format: MetricFormat.text,
        ),
      ],
      description: recommendation,
      actionability: StrategyActionability.analytical,
    );
  }

  StrategyImpact _calculatePPFComparison(LoanModel loan) {
    const ppfReturn = 7.1; // Current PPF rate
    final effectiveRate = loan.annualInterestRate * 0.7; // Post tax
    final winner = ppfReturn > effectiveRate ? 'PPF' : 'Prepayment';

    return StrategyImpact(
      primaryMetric: const MetricData(
        label: 'PPF Return',
        value: ppfReturn,
        format: MetricFormat.percentage,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Loan Effective Rate',
          value: effectiveRate,
          format: MetricFormat.percentage,
        ),
      ],
      description: '$winner wins in your tax bracket',
      actionability: StrategyActionability.analytical,
    );
  }

  StrategyImpact _calculateTenureReduction(LoanModel loan) {
    // Calculate keeping EMI same after prepayment
    const prepayAmount = 200000.0; // ₹2L example
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: prepayAmount,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Additional Savings',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Tenure Reduction',
          value: savingsData['timeSaved'] as double,
          format: MetricFormat.years,
        ),
      ],
      description: 'Reduce tenure, keep EMI same',
      actionability: StrategyActionability.actionable,
    );
  }

  StrategyImpact _calculateDailyHabitsImpact(LoanModel loan) {
    const dailyHabit = 150.0; // ₹150 coffee
    const monthlyAmount = dailyHabit * 30;
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: monthlyAmount,
    );

    return StrategyImpact(
      primaryMetric: const MetricData(
        label: 'Monthly Redirected',
        value: monthlyAmount,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Interest Saved',
          value: savingsData['interestSaved'] as double,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Skip daily coffee, pay towards EMI',
      actionability: StrategyActionability.behavioral,
    );
  }

  StrategyImpact _calculateIncrementAllocation(LoanModel loan) {
    final currentEMI = loan.monthlyEMI;
    final incrementAmount = currentEMI * 0.2; // 20% of current EMI as increment
    final allocationAmount = incrementAmount * 0.5; // 50% allocation to EMI
    
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: allocationAmount,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Interest Saved',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Monthly Allocation',
          value: allocationAmount,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Allocate 50% of increment to EMI',
      actionability: StrategyActionability.behavioral,
    );
  }

  StrategyImpact _calculateRateComparison(LoanModel loan) {
    final currentRate = loan.annualInterestRate;
    const marketFloating = 8.75; // Example floating rate
    final difference = (currentRate - marketFloating).abs();

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Rate Difference',
        value: difference,
        format: MetricFormat.percentage,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Current Rate',
          value: currentRate,
          format: MetricFormat.percentage,
        ),
        const MetricData(
          label: 'Market Floating',
          value: marketFloating,
          format: MetricFormat.percentage,
        ),
      ],
      description: 'Compare fixed vs floating rates',
      actionability: StrategyActionability.tactical,
    );
  }

  StrategyImpact _calculateDualIncomeStrategy(LoanModel loan) {
    final combinedEMIIncrease = loan.monthlyEMI * 0.5; // 50% increase capability
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: combinedEMIIncrease,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Combined Income Benefit',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Possible EMI Increase',
          value: combinedEMIIncrease,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Dual income, faster closure',
      actionability: StrategyActionability.lifestage,
    );
  }

  StrategyImpact _calculateCareerProgressionStrategy(LoanModel loan) {
    const salaryJump = 0.4; // 40% jump
    final currentEMI = loan.monthlyEMI;
    final potentialIncrease = currentEMI * salaryJump;
    
    final savingsData = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: loan.loanAmount,
      annualInterestRate: loan.annualInterestRate,
      tenureYears: loan.tenureYears,
      extraPrincipal: potentialIncrease,
    );

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Career Jump Impact',
        value: savingsData['interestSaved'] as double,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Potential EMI Increase',
          value: potentialIncrease,
          format: MetricFormat.currency,
        ),
      ],
      description: '40% salary jump, optimize EMI',
      actionability: StrategyActionability.lifestage,
    );
  }

  StrategyImpact _calculateEducationMilestones(LoanModel loan) {
    const childAge = 5; // Assume 5-year-old child
    const schoolStart = 10 - childAge; // Years until school
    const collegeStart = 18 - childAge; // Years until college
    
    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'Years to School Start',
        value: schoolStart.toDouble(),
        format: MetricFormat.years,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Years to College',
          value: collegeStart.toDouble(),
          format: MetricFormat.years,
        ),
      ],
      description: 'Plan loan closure before major expenses',
      actionability: StrategyActionability.lifestage,
    );
  }

  StrategyImpact _calculateTaxMaximization(LoanModel loan) {
    const principalBenefit = 150000.0; // 80C limit
    const interestBenefit = 200000.0; // 24b limit
    const totalBenefit = principalBenefit + interestBenefit;

    return const StrategyImpact(
      primaryMetric: MetricData(
        label: 'Total Tax Deduction',
        value: totalBenefit,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Principal Benefit (80C)',
          value: principalBenefit,
          format: MetricFormat.currency,
        ),
        MetricData(
          label: 'Interest Benefit (24b)',
          value: interestBenefit,
          format: MetricFormat.currency,
        ),
      ],
      description: 'Maximize tax benefits',
      actionability: StrategyActionability.compliance,
    );
  }

  StrategyImpact _calculateRentComparison(LoanModel loan) {
    final currentEMI = loan.monthlyEMI;
    const marketRent = 20000.0; // Example rent
    final difference = currentEMI - marketRent;

    return StrategyImpact(
      primaryMetric: MetricData(
        label: 'EMI vs Rent Difference',
        value: difference,
        format: MetricFormat.currency,
      ),
      secondaryMetrics: [
        MetricData(
          label: 'Current EMI',
          value: currentEMI,
          format: MetricFormat.currency,
        ),
        const MetricData(
          label: 'Market Rent',
          value: marketRent,
          format: MetricFormat.currency,
        ),
      ],
      description: difference > 0 ? 'EMI exceeds rent' : 'EMI below rent',
      actionability: StrategyActionability.analytical,
    );
  }
}

/// Impact calculation result for a strategy
@freezed
class StrategyImpact with _$StrategyImpact {
  const factory StrategyImpact({
    required MetricData primaryMetric,
    required List<MetricData> secondaryMetrics,
    required String description,
    required StrategyActionability actionability,
  }) = _StrategyImpact;

  factory StrategyImpact.fromJson(Map<String, dynamic> json) =>
      _$StrategyImpactFromJson(json);
}

/// Metric data with formatting information
@freezed
class MetricData with _$MetricData {
  const factory MetricData({
    required String label,
    required double value,
    required MetricFormat format,
    String? unit,
  }) = _MetricData;

  factory MetricData.fromJson(Map<String, dynamic> json) =>
      _$MetricDataFromJson(json);
}

/// Strategy categories from the specs
enum StrategyCategory {
  @JsonValue('instant_eye_openers')
  instantEyeOpeners,

  @JsonValue('core_savings')
  coreSavings,

  @JsonValue('tax_investment')
  taxInvestment,

  @JsonValue('behavioral_motivation')
  behavioralMotivation,

  @JsonValue('life_event_planning')
  lifeEventPlanning,
}

/// All 20 strategy types
enum StrategyType {
  @JsonValue('daily_interest_burn')
  dailyInterestBurn,

  @JsonValue('rule_78_revealer')
  rule78Revealer,

  @JsonValue('total_interest_shock')
  totalInterestShock,

  @JsonValue('break_even_tracker')
  breakEvenTracker,

  @JsonValue('extra_emi_strategy')
  extraEMIStrategy,

  @JsonValue('round_up_optimizer')
  roundUpOptimizer,

  @JsonValue('prepayment_calculator')
  prepaymentCalculator,

  @JsonValue('part_payment_timing')
  partPaymentTiming,

  @JsonValue('tax_arbitrage')
  taxArbitrage,

  @JsonValue('prepay_vs_investment')
  prepayVsInvestment,

  @JsonValue('ppf_vs_prepay')
  ppfVsPrepay,

  @JsonValue('tenure_reduction')
  tenureReduction,

  @JsonValue('coffee_to_emi')
  coffeeToEMI,

  @JsonValue('increment_allocator')
  incrementAllocator,

  @JsonValue('fixed_vs_floating')
  fixedVsFloating,

  @JsonValue('marriage_strategy')
  marriageStrategy,

  @JsonValue('job_change_emi')
  jobChangeEMI,

  @JsonValue('children_planning')
  childrenPlanning,

  @JsonValue('tax_maximizer')
  taxMaximizer,

  @JsonValue('emi_rent_crossover')
  emiRentCrossover,
}

/// Metric formatting options
enum MetricFormat {
  currency,
  percentage,
  years,
  months,
  multiplier,
  text,
  month, // Month number (1-12)
}

/// Strategy actionability levels
enum StrategyActionability {
  awareness,     // Just for understanding
  educational,   // Learn how loans work
  motivational,  // Inspire to take action
  milestone,     // Track progress
  actionable,    // Can implement immediately
  tactical,      // Requires timing/planning
  analytical,    // Requires analysis/comparison
  behavioral,    // Requires habit changes
  lifestage,     // Life event dependent
  compliance,    // Tax/legal compliance
}

/// Extensions for enum display
extension StrategyCategoryExtension on StrategyCategory {
  String get displayName {
    switch (this) {
      case StrategyCategory.instantEyeOpeners:
        return '🔥 Instant Eye-Openers';
      case StrategyCategory.coreSavings:
        return '📈 Core Savings Strategies';
      case StrategyCategory.taxInvestment:
        return '🧠 Tax & Investment Optimization';
      case StrategyCategory.behavioralMotivation:
        return '🎯 Behavioral Motivation';
      case StrategyCategory.lifeEventPlanning:
        return '👨‍👩‍👧 Life Event Planning';
    }
  }

  String get description {
    switch (this) {
      case StrategyCategory.instantEyeOpeners:
        return 'Shocking revelations about your loan';
      case StrategyCategory.coreSavings:
        return 'Actionable strategies to save money';
      case StrategyCategory.taxInvestment:
        return 'Smart tax and investment decisions';
      case StrategyCategory.behavioralMotivation:
        return 'Psychology-based optimization';
      case StrategyCategory.lifeEventPlanning:
        return 'Plan around life changes';
    }
  }
}

extension StrategyActionabilityExtension on StrategyActionability {
  String get displayName {
    switch (this) {
      case StrategyActionability.awareness:
        return 'Awareness';
      case StrategyActionability.educational:
        return 'Educational';
      case StrategyActionability.motivational:
        return 'Motivational';
      case StrategyActionability.milestone:
        return 'Milestone';
      case StrategyActionability.actionable:
        return 'Actionable';
      case StrategyActionability.tactical:
        return 'Tactical';
      case StrategyActionability.analytical:
        return 'Analytical';
      case StrategyActionability.behavioral:
        return 'Behavioral';
      case StrategyActionability.lifestage:
        return 'Life Stage';
      case StrategyActionability.compliance:
        return 'Compliance';
    }
  }

  Color get color {
    switch (this) {
      case StrategyActionability.awareness:
        return Colors.orange;
      case StrategyActionability.educational:
        return Colors.blue;
      case StrategyActionability.motivational:
        return Colors.purple;
      case StrategyActionability.milestone:
        return Colors.amber;
      case StrategyActionability.actionable:
        return Colors.green;
      case StrategyActionability.tactical:
        return Colors.teal;
      case StrategyActionability.analytical:
        return Colors.indigo;
      case StrategyActionability.behavioral:
        return Colors.pink;
      case StrategyActionability.lifestage:
        return Colors.brown;
      case StrategyActionability.compliance:
        return Colors.grey;
    }
  }
}