import 'package:equatable/equatable.dart';

/// Represents a loan optimization strategy
class OptimizationStrategy extends Equatable {
  final String id;
  final String title;
  final String description;
  final StrategyType type;
  final DifficultyLevel difficulty;
  final double potentialSavings;
  final double impactScore; // 0-100
  final int implementationTimeWeeks;
  final List<String> steps;
  final List<String> requirements;
  final List<String> benefits;
  final List<String> risks;

  const OptimizationStrategy({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.potentialSavings,
    required this.impactScore,
    required this.implementationTimeWeeks,
    required this.steps,
    required this.requirements,
    required this.benefits,
    required this.risks,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    difficulty,
    potentialSavings,
    impactScore,
    implementationTimeWeeks,
    steps,
    requirements,
    benefits,
    risks,
  ];
}

enum StrategyType {
  prepayment,
  refinancing,
  taxOptimization,
  tenureOptimization,
  rateNegotiation,
}

enum DifficultyLevel { easy, medium, hard }

/// Represents a prepayment strategy with specific calculations
class PrepaymentStrategy extends Equatable {
  final String strategyId;
  final PrepaymentType type;
  final double amount;
  final int afterMonths;
  final PrepaymentResult result;

  const PrepaymentStrategy({
    required this.strategyId,
    required this.type,
    required this.amount,
    required this.afterMonths,
    required this.result,
  });

  @override
  List<Object?> get props => [strategyId, type, amount, afterMonths, result];
}

enum PrepaymentType { lumpsum, extraEMI, stepUp, roundUp }

/// Represents the result of a prepayment strategy
class PrepaymentResult extends Equatable {
  final double interestSaved;
  final int tenureReduced; // in months
  final double newEMI;
  final int newTenure; // in months
  final double totalSavings;

  const PrepaymentResult({
    required this.interestSaved,
    required this.tenureReduced,
    required this.newEMI,
    required this.newTenure,
    required this.totalSavings,
  });

  @override
  List<Object?> get props => [
    interestSaved,
    tenureReduced,
    newEMI,
    newTenure,
    totalSavings,
  ];
}

/// Represents a refinancing opportunity
class RefinancingStrategy extends Equatable {
  final String currentBankId;
  final String newBankId;
  final double currentRate;
  final double newRate;
  final double switchingCost;
  final double monthlySavings;
  final double totalSavings;
  final int breakEvenMonths;
  final bool isWorthwhile;

  const RefinancingStrategy({
    required this.currentBankId,
    required this.newBankId,
    required this.currentRate,
    required this.newRate,
    required this.switchingCost,
    required this.monthlySavings,
    required this.totalSavings,
    required this.breakEvenMonths,
    required this.isWorthwhile,
  });

  @override
  List<Object?> get props => [
    currentBankId,
    newBankId,
    currentRate,
    newRate,
    switchingCost,
    monthlySavings,
    totalSavings,
    breakEvenMonths,
    isWorthwhile,
  ];
}
