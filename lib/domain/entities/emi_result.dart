import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'step_emi.dart';

part 'emi_result.g.dart';

/// Represents the complete EMI calculation result with tax benefits
@JsonSerializable()
class EMIResult extends Equatable {
  final double monthlyEMI;
  final double totalInterest;
  final double totalAmount;
  final double principalAmount;
  final TaxBenefits taxBenefits;
  final PMAYBenefit? pmayBenefit;
  final LoanBreakdown breakdown;
  final StepEMIResult? stepEMIResult; // Optional step EMI details

  const EMIResult({
    required this.monthlyEMI,
    required this.totalInterest,
    required this.totalAmount,
    required this.principalAmount,
    required this.taxBenefits,
    this.pmayBenefit,
    required this.breakdown,
    this.stepEMIResult,
  });

  /// Factory for creating from JSON
  factory EMIResult.fromJson(Map<String, dynamic> json) =>
      _$EMIResultFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$EMIResultToJson(this);

  @override
  List<Object?> get props => [
    monthlyEMI,
    totalInterest,
    totalAmount,
    principalAmount,
    taxBenefits,
    pmayBenefit,
    breakdown,
    stepEMIResult,
  ];
}

/// Represents tax benefits available
@JsonSerializable()
class TaxBenefits extends Equatable {
  final double section80C; // Principal repayment benefit
  final double section24B; // Interest payment benefit
  final double
  section80EEA; // Additional interest benefit for first-time buyers
  final double totalAnnualSavings;

  const TaxBenefits({
    required this.section80C,
    required this.section24B,
    required this.section80EEA,
    required this.totalAnnualSavings,
  });

  /// Factory for creating from JSON
  factory TaxBenefits.fromJson(Map<String, dynamic> json) =>
      _$TaxBenefitsFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$TaxBenefitsToJson(this);

  @override
  List<Object?> get props => [
    section80C,
    section24B,
    section80EEA,
    totalAnnualSavings,
  ];
}

/// Represents PMAY subsidy information
@JsonSerializable()
class PMAYBenefit extends Equatable {
  final String category; // EWS/LIG, MIG-I, MIG-II
  final double subsidyAmount;
  final double subsidyRate;
  final double maxSubsidy;
  final bool isEligible;

  const PMAYBenefit({
    required this.category,
    required this.subsidyAmount,
    required this.subsidyRate,
    required this.maxSubsidy,
    required this.isEligible,
  });

  /// Factory for creating from JSON
  factory PMAYBenefit.fromJson(Map<String, dynamic> json) =>
      _$PMAYBenefitFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$PMAYBenefitToJson(this);

  @override
  List<Object?> get props => [
    category,
    subsidyAmount,
    subsidyRate,
    maxSubsidy,
    isEligible,
  ];
}

/// Represents year-wise loan breakdown
@JsonSerializable()
class LoanBreakdown extends Equatable {
  final List<YearlyBreakdown> yearlyBreakdown;
  final double totalPrincipalPaid;
  final double totalInterestPaid;

  const LoanBreakdown({
    required this.yearlyBreakdown,
    required this.totalPrincipalPaid,
    required this.totalInterestPaid,
  });

  /// Factory for creating from JSON
  factory LoanBreakdown.fromJson(Map<String, dynamic> json) =>
      _$LoanBreakdownFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$LoanBreakdownToJson(this);

  @override
  List<Object?> get props => [
    yearlyBreakdown,
    totalPrincipalPaid,
    totalInterestPaid,
  ];
}

/// Represents yearly payment breakdown
@JsonSerializable()
class YearlyBreakdown extends Equatable {
  final int year;
  final double principalPaid;
  final double interestPaid;
  final double outstandingBalance;
  final double taxSavings;

  const YearlyBreakdown({
    required this.year,
    required this.principalPaid,
    required this.interestPaid,
    required this.outstandingBalance,
    required this.taxSavings,
  });

  /// Factory for creating from JSON
  factory YearlyBreakdown.fromJson(Map<String, dynamic> json) =>
      _$YearlyBreakdownFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$YearlyBreakdownToJson(this);

  @override
  List<Object?> get props => [
    year,
    principalPaid,
    interestPaid,
    outstandingBalance,
    taxSavings,
  ];
}
