import 'package:equatable/equatable.dart';

/// Represents different types of prepayment strategies
enum PrepaymentType {
  oneTime,
  recurring,
  extraEMI,
}

/// Represents the frequency of recurring prepayments
enum PrepaymentFrequency {
  monthly,
  quarterly,
  yearly,
}

/// Represents a prepayment scenario input
class PrepaymentScenario extends Equatable {
  final PrepaymentType type;
  final double amount;
  final PrepaymentFrequency frequency;
  final int startMonth; // Month number when to start prepayment (1-based)
  final int startYear; // Year when to start prepayment
  final int? extraEMIsPerYear; // For extra EMI strategy (1-4)

  const PrepaymentScenario({
    required this.type,
    required this.amount,
    this.frequency = PrepaymentFrequency.monthly,
    this.startMonth = 1,
    this.startYear = 1,
    this.extraEMIsPerYear,
  });

  PrepaymentScenario copyWith({
    PrepaymentType? type,
    double? amount,
    PrepaymentFrequency? frequency,
    int? startMonth,
    int? startYear,
    int? extraEMIsPerYear,
  }) {
    return PrepaymentScenario(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      extraEMIsPerYear: extraEMIsPerYear ?? this.extraEMIsPerYear,
    );
  }

  @override
  List<Object?> get props => [
        type,
        amount,
        frequency,
        startMonth,
        startYear,
        extraEMIsPerYear,
      ];
}

/// Represents the result of prepayment calculations
class PrepaymentResult extends Equatable {
  final PrepaymentScenario scenario;
  final LoanComparison comparison;
  final PrepaymentBreakdown breakdown;
  final PrepaymentBenefits benefits;

  const PrepaymentResult({
    required this.scenario,
    required this.comparison,
    required this.breakdown,
    required this.benefits,
  });

  @override
  List<Object?> get props => [
        scenario,
        comparison,
        breakdown,
        benefits,
      ];
}

/// Compares original loan vs loan with prepayments
class LoanComparison extends Equatable {
  final double originalEMI;
  final double newEMI; // Same as original for tenure reduction
  final int originalTenureMonths;
  final int newTenureMonths;
  final double originalTotalInterest;
  final double newTotalInterest;
  final double originalTotalAmount;
  final double newTotalAmount;

  const LoanComparison({
    required this.originalEMI,
    required this.newEMI,
    required this.originalTenureMonths,
    required this.newTenureMonths,
    required this.originalTotalInterest,
    required this.newTotalInterest,
    required this.originalTotalAmount,
    required this.newTotalAmount,
  });

  // Calculated properties
  double get interestSaved => originalTotalInterest - newTotalInterest;
  int get tenureReducedMonths => originalTenureMonths - newTenureMonths;
  double get totalSavings => originalTotalAmount - newTotalAmount;

  @override
  List<Object?> get props => [
        originalEMI,
        newEMI,
        originalTenureMonths,
        newTenureMonths,
        originalTotalInterest,
        newTotalInterest,
        originalTotalAmount,
        newTotalAmount,
      ];
}

/// Detailed breakdown of prepayment schedule
class PrepaymentBreakdown extends Equatable {
  final double totalPrepaymentAmount;
  final List<PrepaymentSchedule> schedule;
  final List<MonthlyBalance> balanceProgression;

  const PrepaymentBreakdown({
    required this.totalPrepaymentAmount,
    required this.schedule,
    required this.balanceProgression,
  });

  @override
  List<Object?> get props => [
        totalPrepaymentAmount,
        schedule,
        balanceProgression,
      ];
}

/// Individual prepayment in the schedule
class PrepaymentSchedule extends Equatable {
  final int month;
  final double amount;
  final double outstandingBeforePrepayment;
  final double outstandingAfterPrepayment;

  const PrepaymentSchedule({
    required this.month,
    required this.amount,
    required this.outstandingBeforePrepayment,
    required this.outstandingAfterPrepayment,
  });

  @override
  List<Object?> get props => [
        month,
        amount,
        outstandingBeforePrepayment,
        outstandingAfterPrepayment,
      ];
}

/// Monthly balance progression for comparison
class MonthlyBalance extends Equatable {
  final int month;
  final double originalBalance;
  final double newBalance; // After prepayments
  final double cumulativeSavings;

  const MonthlyBalance({
    required this.month,
    required this.originalBalance,
    required this.newBalance,
    required this.cumulativeSavings,
  });

  @override
  List<Object?> get props => [
        month,
        originalBalance,
        newBalance,
        cumulativeSavings,
      ];
}

/// Benefits and ROI analysis of prepayment
class PrepaymentBenefits extends Equatable {
  final double totalPrepaymentAmount;
  final double totalInterestSaved;
  final double totalAmountSaved;
  final int tenureReducedMonths;
  final double roiPercentage; // Return on Investment
  final double breakEvenMonths; // When benefits exceed prepayment cost
  final double monthlyTaxSavingsLost; // Tax benefits lost due to prepayment
  final double netBenefit; // After considering tax implications

  const PrepaymentBenefits({
    required this.totalPrepaymentAmount,
    required this.totalInterestSaved,
    required this.totalAmountSaved,
    required this.tenureReducedMonths,
    required this.roiPercentage,
    required this.breakEvenMonths,
    required this.monthlyTaxSavingsLost,
    required this.netBenefit,
  });

  // Calculated properties
  int get tenureReducedYears => tenureReducedMonths ~/ 12;
  int get tenureReducedRemainingMonths => tenureReducedMonths % 12;
  
  String get formattedTenureReduction {
    if (tenureReducedYears > 0 && tenureReducedRemainingMonths > 0) {
      return '$tenureReducedYears years $tenureReducedRemainingMonths months';
    } else if (tenureReducedYears > 0) {
      return '$tenureReducedYears years';
    } else {
      return '$tenureReducedMonths months';
    }
  }

  @override
  List<Object?> get props => [
        totalPrepaymentAmount,
        totalInterestSaved,
        totalAmountSaved,
        tenureReducedMonths,
        roiPercentage,
        breakEvenMonths,
        monthlyTaxSavingsLost,
        netBenefit,
      ];
}

/// Comparison data for multiple scenarios
class PrepaymentComparison extends Equatable {
  final List<PrepaymentResult> scenarios;
  final PrepaymentResult? recommendedScenario;

  const PrepaymentComparison({
    required this.scenarios,
    this.recommendedScenario,
  });

  @override
  List<Object?> get props => [scenarios, recommendedScenario];
}