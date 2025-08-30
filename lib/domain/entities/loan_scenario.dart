import 'package:equatable/equatable.dart';
import 'loan_parameters.dart';
import 'emi_result.dart';

/// Represents a loan scenario for comparison
class LoanScenario extends Equatable {
  final String id;
  final String name;
  final String description;
  final LoanParameters parameters;
  final EMIResult? result;
  final bool isBaseScenario;
  final bool isEnabled;

  const LoanScenario({
    required this.id,
    required this.name,
    required this.description,
    required this.parameters,
    this.result,
    this.isBaseScenario = false,
    this.isEnabled = true,
  });

  LoanScenario copyWith({
    String? id,
    String? name,
    String? description,
    LoanParameters? parameters,
    EMIResult? result,
    bool? isBaseScenario,
    bool? isEnabled,
  }) {
    return LoanScenario(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      result: result ?? this.result,
      isBaseScenario: isBaseScenario ?? this.isBaseScenario,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    parameters,
    result,
    isBaseScenario,
    isEnabled,
  ];
}

/// Represents the complete scenario comparison data
class ScenarioComparison extends Equatable {
  final List<LoanScenario> scenarios;
  final ScenarioComparisonMetrics? metrics;
  final String? bestScenarioId;

  const ScenarioComparison({
    required this.scenarios,
    this.metrics,
    this.bestScenarioId,
  });

  List<LoanScenario> get enabledScenarios => scenarios.where((s) => s.isEnabled).toList();

  List<LoanScenario> get scenariosWithResults => scenarios.where((s) => s.result != null).toList();

  LoanScenario? get baseScenario => scenarios.where((s) => s.isBaseScenario).firstOrNull;

  LoanScenario? get bestScenario => bestScenarioId != null 
      ? scenarios.where((s) => s.id == bestScenarioId).firstOrNull 
      : null;

  ScenarioComparison copyWith({
    List<LoanScenario>? scenarios,
    ScenarioComparisonMetrics? metrics,
    String? bestScenarioId,
  }) {
    return ScenarioComparison(
      scenarios: scenarios ?? this.scenarios,
      metrics: metrics ?? this.metrics,
      bestScenarioId: bestScenarioId ?? this.bestScenarioId,
    );
  }

  @override
  List<Object?> get props => [scenarios, metrics, bestScenarioId];
}

/// Represents comparison metrics between scenarios
class ScenarioComparisonMetrics extends Equatable {
  final double maxEMI;
  final double minEMI;
  final double maxTotalInterest;
  final double minTotalInterest;
  final double maxTotalAmount;
  final double minTotalAmount;
  final double maxTaxBenefits;
  final double minTaxBenefits;
  final List<ScenarioDifference> differences;

  const ScenarioComparisonMetrics({
    required this.maxEMI,
    required this.minEMI,
    required this.maxTotalInterest,
    required this.minTotalInterest,
    required this.maxTotalAmount,
    required this.minTotalAmount,
    required this.maxTaxBenefits,
    required this.minTaxBenefits,
    required this.differences,
  });

  double get emiRange => maxEMI - minEMI;
  double get totalInterestRange => maxTotalInterest - minTotalInterest;
  double get totalAmountRange => maxTotalAmount - minTotalAmount;
  double get taxBenefitsRange => maxTaxBenefits - minTaxBenefits;

  @override
  List<Object?> get props => [
    maxEMI,
    minEMI,
    maxTotalInterest,
    minTotalInterest,
    maxTotalAmount,
    minTotalAmount,
    maxTaxBenefits,
    minTaxBenefits,
    differences,
  ];
}

/// Represents difference between scenarios
class ScenarioDifference extends Equatable {
  final String fromScenarioId;
  final String toScenarioId;
  final double emiDifference;
  final double totalInterestDifference;
  final double totalAmountDifference;
  final double taxBenefitsDifference;
  final double effectiveRateDifference;

  const ScenarioDifference({
    required this.fromScenarioId,
    required this.toScenarioId,
    required this.emiDifference,
    required this.totalInterestDifference,
    required this.totalAmountDifference,
    required this.taxBenefitsDifference,
    required this.effectiveRateDifference,
  });

  @override
  List<Object?> get props => [
    fromScenarioId,
    toScenarioId,
    emiDifference,
    totalInterestDifference,
    totalAmountDifference,
    taxBenefitsDifference,
    effectiveRateDifference,
  ];
}

/// Represents preset scenario types
enum ScenarioPreset {
  lowerRate('Lower Rate', 'Interest rate 0.5% lower than base'),
  higherRate('Higher Rate', 'Interest rate 0.5% higher than base'),
  shorterTenure('Shorter Tenure', 'Loan tenure 5 years less than base'),
  longerTenure('Longer Tenure', 'Loan tenure 5 years more than base'),
  lowerAmount('Lower Amount', 'Loan amount 20% less than base'),
  higherAmount('Higher Amount', 'Loan amount 20% more than base');

  const ScenarioPreset(this.displayName, this.description);
  
  final String displayName;
  final String description;
}

/// Extension methods for scenario operations
extension LoanScenarioExtensions on LoanScenario {
  /// Calculate effective interest rate after tax benefits
  double get effectiveInterestRate {
    if (result == null) return parameters.interestRate;
    
    final totalInterestAfterTax = result!.totalInterest - 
        (result!.taxBenefits.totalAnnualSavings * parameters.tenureYears);
    final effectiveRate = (totalInterestAfterTax / parameters.loanAmount) * 
        (100 / parameters.tenureYears);
    
    return effectiveRate.clamp(0, parameters.interestRate);
  }

  /// Get total cost including PMAY benefits
  double get totalCostAfterBenefits {
    if (result == null) return 0;
    
    double totalCost = result!.totalAmount;
    
    // Subtract PMAY subsidy
    if (result!.pmayBenefit?.isEligible == true) {
      totalCost -= result!.pmayBenefit!.subsidyAmount;
    }
    
    // Subtract tax benefits over the loan tenure
    totalCost -= result!.taxBenefits.totalAnnualSavings * parameters.tenureYears;
    
    return totalCost.clamp(0, result!.totalAmount);
  }

  /// Check if this scenario is better than another
  bool isBetterThan(LoanScenario other) {
    if (result == null || other.result == null) return false;
    return totalCostAfterBenefits < other.totalCostAfterBenefits;
  }
}