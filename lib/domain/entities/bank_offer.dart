import 'package:equatable/equatable.dart';

/// Represents a bank's home loan offer
class BankOffer extends Equatable {
  final String bankId;
  final String bankName;
  final BankType bankType;
  final double marketShare;
  final InterestRates interestRates;
  final ProcessingFee processingFee;
  final Eligibility eligibility;
  final DateTime lastUpdated;

  const BankOffer({
    required this.bankId,
    required this.bankName,
    required this.bankType,
    required this.marketShare,
    required this.interestRates,
    required this.processingFee,
    required this.eligibility,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    bankId,
    bankName,
    bankType,
    marketShare,
    interestRates,
    processingFee,
    eligibility,
    lastUpdated,
  ];
}

enum BankType { public, private, nbfc }

/// Represents interest rate structure
class InterestRates extends Equatable {
  final CategoryRates salaried;
  final CategoryRates selfEmployed;
  final WomenSpecialRates? womenSpecial;

  const InterestRates({
    required this.salaried,
    required this.selfEmployed,
    this.womenSpecial,
  });

  @override
  List<Object?> get props => [salaried, selfEmployed, womenSpecial];
}

/// Represents rates for different credit categories
class CategoryRates extends Equatable {
  final CreditRates excellentCredit;
  final CreditRates goodCredit;
  final CreditRates averageCredit;

  const CategoryRates({
    required this.excellentCredit,
    required this.goodCredit,
    required this.averageCredit,
  });

  @override
  List<Object?> get props => [excellentCredit, goodCredit, averageCredit];
}

/// Represents rate range for a credit category
class CreditRates extends Equatable {
  final double minRate;
  final double maxRate;
  final double effectiveRate;

  const CreditRates({
    required this.minRate,
    required this.maxRate,
    required this.effectiveRate,
  });

  @override
  List<Object?> get props => [minRate, maxRate, effectiveRate];
}

/// Represents special rates for women
class WomenSpecialRates extends Equatable {
  final double discount;
  final double minRate;

  const WomenSpecialRates({required this.discount, required this.minRate});

  @override
  List<Object?> get props => [discount, minRate];
}

/// Represents processing fee structure
class ProcessingFee extends Equatable {
  final double percentage;
  final double minimum;
  final double maximum;
  final bool gstApplicable;
  final double gstRate;

  const ProcessingFee({
    required this.percentage,
    required this.minimum,
    required this.maximum,
    required this.gstApplicable,
    required this.gstRate,
  });

  /// Calculate total processing fee including GST
  double calculateTotalFee(double loanAmount) {
    double baseFee = loanAmount * percentage / 100;
    baseFee = baseFee.clamp(minimum, maximum);

    if (gstApplicable) {
      baseFee = baseFee + (baseFee * gstRate / 100);
    }

    return baseFee;
  }

  @override
  List<Object?> get props => [
    percentage,
    minimum,
    maximum,
    gstApplicable,
    gstRate,
  ];
}

/// Represents eligibility criteria
class Eligibility extends Equatable {
  final int minAge;
  final int maxAge;
  final double minIncomeSalaried;
  final double minIncomeSelfEmployed;
  final int creditScoreMinimum;

  const Eligibility({
    required this.minAge,
    required this.maxAge,
    required this.minIncomeSalaried,
    required this.minIncomeSelfEmployed,
    required this.creditScoreMinimum,
  });

  /// Check if user meets basic eligibility criteria
  bool isEligible({
    required int age,
    required double income,
    required String employmentType,
    required int creditScore,
  }) {
    if (age < minAge || age > maxAge) return false;
    if (creditScore < creditScoreMinimum) return false;

    if (employmentType == 'salaried') {
      return income >= minIncomeSalaried;
    } else {
      return income >= minIncomeSelfEmployed;
    }
  }

  @override
  List<Object?> get props => [
    minAge,
    maxAge,
    minIncomeSalaried,
    minIncomeSelfEmployed,
    creditScoreMinimum,
  ];
}
