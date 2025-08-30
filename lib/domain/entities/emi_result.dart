import 'package:equatable/equatable.dart';
import 'step_emi.dart';

/// Represents the complete EMI calculation result with tax benefits
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

  @override
  List<Object?> get props => [
    section80C,
    section24B,
    section80EEA,
    totalAnnualSavings,
  ];
}

/// Represents PMAY subsidy information
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
class LoanBreakdown extends Equatable {
  final List<YearlyBreakdown> yearlyBreakdown;
  final double totalPrincipalPaid;
  final double totalInterestPaid;

  const LoanBreakdown({
    required this.yearlyBreakdown,
    required this.totalPrincipalPaid,
    required this.totalInterestPaid,
  });

  @override
  List<Object?> get props => [
    yearlyBreakdown,
    totalPrincipalPaid,
    totalInterestPaid,
  ];
}

/// Represents yearly payment breakdown
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

  @override
  List<Object?> get props => [
    year,
    principalPaid,
    interestPaid,
    outstandingBalance,
    taxSavings,
  ];
}
