import 'package:equatable/equatable.dart';

/// Represents a comprehensive money-saving strategy for Indian home loans
class MoneySavingStrategy extends Equatable {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final StrategyCategory category;
  final StrategyComplexity complexity;
  final double potentialSavingsMin; // Minimum savings in rupees
  final double potentialSavingsMax; // Maximum savings in rupees
  final int setupTimeMinutes; // Time to implement in minutes
  final double successProbability; // 0.0 to 1.0
  final List<String> implementationSteps;
  final List<String> requirements;
  final List<String> benefits;
  final List<String> considerations;
  final StrategyCalculation calculationMethod;
  final bool isPopular; // Popular strategies to highlight
  final String quickWinLabel; // e.g., "Quick Win", "High Impact"

  const MoneySavingStrategy({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.complexity,
    required this.potentialSavingsMin,
    required this.potentialSavingsMax,
    required this.setupTimeMinutes,
    required this.successProbability,
    required this.implementationSteps,
    required this.requirements,
    required this.benefits,
    required this.considerations,
    required this.calculationMethod,
    this.isPopular = false,
    this.quickWinLabel = '',
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    emoji,
    category,
    complexity,
    potentialSavingsMin,
    potentialSavingsMax,
    setupTimeMinutes,
    successProbability,
    implementationSteps,
    requirements,
    benefits,
    considerations,
    calculationMethod,
    isPopular,
    quickWinLabel,
  ];
}

/// Personalized strategy calculation result for a specific user
class PersonalizedStrategyResult extends Equatable {
  final String strategyId;
  final double personalizedSavings; // Actual calculated savings for user
  final double currentEMI;
  final double newEMI;
  final int currentTenureMonths;
  final int newTenureMonths;
  final int tenureReductionMonths;
  final double totalInterestSaved;
  final double roiOnInvestment; // ROI if applicable
  final StrategyFeasibility feasibility;
  final String feasibilityReason;
  final Map<String, dynamic> calculationDetails;

  const PersonalizedStrategyResult({
    required this.strategyId,
    required this.personalizedSavings,
    required this.currentEMI,
    required this.newEMI,
    required this.currentTenureMonths,
    required this.newTenureMonths,
    required this.tenureReductionMonths,
    required this.totalInterestSaved,
    required this.roiOnInvestment,
    required this.feasibility,
    required this.feasibilityReason,
    required this.calculationDetails,
  });

  @override
  List<Object?> get props => [
    strategyId,
    personalizedSavings,
    currentEMI,
    newEMI,
    currentTenureMonths,
    newTenureMonths,
    tenureReductionMonths,
    totalInterestSaved,
    roiOnInvestment,
    feasibility,
    feasibilityReason,
    calculationDetails,
  ];
}

/// Represents a strategy that the user has marked as active
class ActiveStrategy extends Equatable {
  final String strategyId;
  final DateTime activatedDate;
  final Map<String, dynamic> userInputs; // Strategy-specific inputs
  final double targetSavings;
  final bool isCompleted;
  final DateTime? completedDate;
  final String notes;

  const ActiveStrategy({
    required this.strategyId,
    required this.activatedDate,
    required this.userInputs,
    required this.targetSavings,
    this.isCompleted = false,
    this.completedDate,
    this.notes = '',
  });

  ActiveStrategy copyWith({
    String? strategyId,
    DateTime? activatedDate,
    Map<String, dynamic>? userInputs,
    double? targetSavings,
    bool? isCompleted,
    DateTime? completedDate,
    String? notes,
  }) {
    return ActiveStrategy(
      strategyId: strategyId ?? this.strategyId,
      activatedDate: activatedDate ?? this.activatedDate,
      userInputs: userInputs ?? this.userInputs,
      targetSavings: targetSavings ?? this.targetSavings,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    strategyId,
    activatedDate,
    userInputs,
    targetSavings,
    isCompleted,
    completedDate,
    notes,
  ];
}

/// Strategy categories for organization
enum StrategyCategory {
  prepayment,      // Extra EMI, Lump sum, Step-up
  refinancing,     // Rate switch, bank transfer
  optimization,    // Round-up, tenure adjustment
  taxPlanning,     // Section 80C, 24B optimization
  emergency,       // Emergency fund strategies
}

/// Complexity levels for strategies
enum StrategyComplexity {
  low,    // 1-2 steps, minimal documentation
  medium, // 3-4 steps, some paperwork
  high,   // 5+ steps, significant effort/documentation
}

/// Strategy feasibility based on user's financial profile
enum StrategyFeasibility {
  highlyRecommended, // Perfect fit for user
  recommended,       // Good fit with minor considerations
  conditional,       // Requires specific conditions
  notRecommended,    // Not suitable for user's profile
}

/// Different calculation methods for strategies
enum StrategyCalculation {
  extraEmiYearly,    // 13th EMI calculation
  emiStepUp,         // 5% yearly increase
  lumpSumPrepayment, // One-time prepayment
  refinanceRate,     // Interest rate reduction
  emiRoundUp,        // Round EMI to nearest 1000
  tenureOptimization, // Optimal tenure calculation
}

/// Extension to get display values
extension StrategyCategoryExtension on StrategyCategory {
  String get displayName {
    switch (this) {
      case StrategyCategory.prepayment:
        return 'Prepayment Strategies';
      case StrategyCategory.refinancing:
        return 'Refinancing Options';
      case StrategyCategory.optimization:
        return 'EMI Optimization';
      case StrategyCategory.taxPlanning:
        return 'Tax Planning';
      case StrategyCategory.emergency:
        return 'Emergency Planning';
    }
  }

  String get description {
    switch (this) {
      case StrategyCategory.prepayment:
        return 'Reduce total interest through prepayments';
      case StrategyCategory.refinancing:
        return 'Switch to better interest rates';
      case StrategyCategory.optimization:
        return 'Optimize your EMI structure';
      case StrategyCategory.taxPlanning:
        return 'Maximize tax benefits';
      case StrategyCategory.emergency:
        return 'Build financial safety nets';
    }
  }
}

extension StrategyComplexityExtension on StrategyComplexity {
  String get displayName {
    switch (this) {
      case StrategyComplexity.low:
        return 'Low Effort';
      case StrategyComplexity.medium:
        return 'Medium Effort';
      case StrategyComplexity.high:
        return 'High Effort';
    }
  }

  String get description {
    switch (this) {
      case StrategyComplexity.low:
        return '5-15 mins setup';
      case StrategyComplexity.medium:
        return '30-60 mins setup';
      case StrategyComplexity.high:
        return '2-4 hours setup';
    }
  }
}

extension StrategyFeasibilityExtension on StrategyFeasibility {
  String get displayName {
    switch (this) {
      case StrategyFeasibility.highlyRecommended:
        return 'Highly Recommended';
      case StrategyFeasibility.recommended:
        return 'Recommended';
      case StrategyFeasibility.conditional:
        return 'Consider If';
      case StrategyFeasibility.notRecommended:
        return 'Not Recommended';
    }
  }

  String get emoji {
    switch (this) {
      case StrategyFeasibility.highlyRecommended:
        return '🔥';
      case StrategyFeasibility.recommended:
        return '👍';
      case StrategyFeasibility.conditional:
        return '⚠️';
      case StrategyFeasibility.notRecommended:
        return '❌';
    }
  }
}