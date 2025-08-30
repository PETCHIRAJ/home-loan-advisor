import 'dart:math';
import '../constants/app_constants.dart';

class CalculationUtils {
  /// Calculate EMI using the standard formula
  /// EMI = P * r * (1 + r)^n / ((1 + r)^n - 1)
  static double calculateEMI({
    required double principal,
    required double annualRate,
    required int tenureYears,
  }) {
    if (principal <= 0 || annualRate <= 0 || tenureYears <= 0) {
      return 0;
    }

    final monthlyRate = annualRate / 100 / 12;
    final totalMonths = tenureYears * 12;

    if (monthlyRate == 0) {
      return principal / totalMonths;
    }

    final numerator =
        principal * monthlyRate * pow(1 + monthlyRate, totalMonths);
    final denominator = pow(1 + monthlyRate, totalMonths) - 1;

    return numerator / denominator;
  }

  /// Calculate total interest payable
  static double calculateTotalInterest({
    required double emi,
    required int tenureYears,
    required double principal,
  }) {
    final totalAmount = emi * tenureYears * 12;
    return totalAmount - principal;
  }

  /// Calculate Section 80C tax benefit
  static double calculateSection80CTaxBenefit({
    required double principalRepayment,
    required int taxSlabPercentage,
  }) {
    final eligibleAmount = principalRepayment > AppConstants.section80CLimit
        ? AppConstants.section80CLimit
        : principalRepayment;

    return eligibleAmount * taxSlabPercentage / 100;
  }

  /// Calculate Section 24B tax benefit
  static double calculateSection24BTaxBenefit({
    required double interestPayment,
    required int taxSlabPercentage,
    required bool isSelfOccupied,
  }) {
    double eligibleAmount;

    if (isSelfOccupied) {
      eligibleAmount =
          interestPayment > AppConstants.section24BLimitSelfOccupied
          ? AppConstants.section24BLimitSelfOccupied
          : interestPayment;
    } else {
      // For let-out property, there's no upper limit
      eligibleAmount = interestPayment;
    }

    return eligibleAmount * taxSlabPercentage / 100;
  }

  /// Calculate PMAY subsidy based on income and category
  static Map<String, dynamic> calculatePMAYSubsidy({
    required double annualIncome,
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) {
    String category = _getPMAYCategory(annualIncome);

    if (category == 'Not Eligible') {
      return {
        'category': category,
        'subsidy': 0.0,
        'subsidyRate': 0.0,
        'maxSubsidy': 0.0,
      };
    }

    Map<String, dynamic> pmayData = _getPMAYData(category);

    // Calculate NPV of interest subsidy
    double subsidyAmount = _calculatePMAYSubsidyAmount(
      loanAmount: loanAmount,
      marketRate: interestRate,
      subsidizedRate: pmayData['subsidizedRate'],
      tenureYears: tenureYears,
      maxSubsidy: pmayData['maxSubsidy'],
      npvRate: pmayData['npvRate'],
    );

    return {
      'category': category,
      'subsidy': subsidyAmount,
      'subsidyRate': pmayData['subsidizedRate'],
      'maxSubsidy': pmayData['maxSubsidy'],
    };
  }

  /// Get PMAY category based on annual income
  static String _getPMAYCategory(double annualIncome) {
    if (annualIncome <= AppConstants.pmayEWSLIGLimit) {
      return 'EWS/LIG';
    } else if (annualIncome <= AppConstants.pmayMIG1Limit) {
      return 'MIG-I';
    } else if (annualIncome <= AppConstants.pmayMIG2Limit) {
      return 'MIG-II';
    } else {
      return 'Not Eligible';
    }
  }

  /// Get PMAY data for each category
  static Map<String, dynamic> _getPMAYData(String category) {
    switch (category) {
      case 'EWS/LIG':
        return {'subsidizedRate': 6.5, 'maxSubsidy': 267000.0, 'npvRate': 9.0};
      case 'MIG-I':
        return {'subsidizedRate': 4.0, 'maxSubsidy': 235000.0, 'npvRate': 9.0};
      case 'MIG-II':
        return {'subsidizedRate': 3.0, 'maxSubsidy': 230000.0, 'npvRate': 9.0};
      default:
        return {'subsidizedRate': 0.0, 'maxSubsidy': 0.0, 'npvRate': 0.0};
    }
  }

  /// Calculate PMAY subsidy amount using NPV method
  static double _calculatePMAYSubsidyAmount({
    required double loanAmount,
    required double marketRate,
    required double subsidizedRate,
    required int tenureYears,
    required double maxSubsidy,
    required double npvRate,
  }) {
    if (subsidizedRate == 0) return 0;

    // Calculate EMI at market rate and subsidized rate
    final marketEMI = calculateEMI(
      principal: loanAmount,
      annualRate: marketRate,
      tenureYears: tenureYears,
    );

    final subsidizedEMI = calculateEMI(
      principal: loanAmount,
      annualRate: subsidizedRate,
      tenureYears: tenureYears,
    );

    final monthlySavings = marketEMI - subsidizedEMI;
    final totalMonths = tenureYears * 12;
    final monthlyNPVRate = npvRate / 100 / 12;

    // Calculate NPV of monthly savings for 20 years (max PMAY period)
    double npvSubsidy = 0;
    final maxMonths = min(totalMonths, 20 * 12); // Max 20 years for PMAY

    for (int month = 1; month <= maxMonths; month++) {
      npvSubsidy += monthlySavings / pow(1 + monthlyNPVRate, month);
    }

    // Cap at maximum subsidy
    return min(npvSubsidy, maxSubsidy);
  }

  /// Calculate prepayment benefits
  static Map<String, dynamic> calculatePrepaymentBenefit({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required double prepaymentAmount,
    required int prepaymentAfterMonths,
  }) {
    // Original loan details
    final originalEMI = calculateEMI(
      principal: principal,
      annualRate: annualRate,
      tenureYears: tenureYears,
    );
    final originalTotalInterest = calculateTotalInterest(
      emi: originalEMI,
      tenureYears: tenureYears,
      principal: principal,
    );

    // Calculate outstanding principal after prepayment months
    double outstandingPrincipal = _calculateOutstandingPrincipal(
      principal: principal,
      annualRate: annualRate,
      emi: originalEMI,
      monthsPaid: prepaymentAfterMonths,
    );

    // New principal after prepayment
    final newPrincipal = outstandingPrincipal - prepaymentAmount;
    if (newPrincipal <= 0) {
      return {
        'newEMI': 0.0,
        'newTenure': 0,
        'interestSaved': originalTotalInterest,
        'tenureReduced': tenureYears * 12 - prepaymentAfterMonths,
      };
    }

    // Recalculate with same EMI (tenure reduction)
    final remainingTenure = _calculateRemainingTenure(
      principal: newPrincipal,
      emi: originalEMI,
      annualRate: annualRate,
    );

    final newTotalInterest =
        originalEMI * (prepaymentAfterMonths + remainingTenure) -
        principal -
        prepaymentAmount;
    final interestSaved = originalTotalInterest - newTotalInterest;
    final tenureReduced =
        (tenureYears * 12) - (prepaymentAfterMonths + remainingTenure);

    return {
      'newEMI': originalEMI,
      'newTenure': remainingTenure,
      'interestSaved': interestSaved,
      'tenureReduced': tenureReduced,
    };
  }

  /// Calculate outstanding principal after given months
  static double _calculateOutstandingPrincipal({
    required double principal,
    required double annualRate,
    required double emi,
    required int monthsPaid,
  }) {
    if (monthsPaid <= 0) return principal;

    final monthlyRate = annualRate / 100 / 12;
    final totalMonths =
        (log(emi) - log(emi - principal * monthlyRate)) / log(1 + monthlyRate);

    if (monthsPaid >= totalMonths) return 0;

    return principal * pow(1 + monthlyRate, monthsPaid) -
        emi * (pow(1 + monthlyRate, monthsPaid) - 1) / monthlyRate;
  }

  /// Calculate remaining tenure for given principal and EMI
  static int _calculateRemainingTenure({
    required double principal,
    required double emi,
    required double annualRate,
  }) {
    final monthlyRate = annualRate / 100 / 12;
    if (monthlyRate == 0) {
      return (principal / emi).ceil();
    }

    final tenure =
        log(1 + (principal * monthlyRate / emi)) / log(1 + monthlyRate);
    return tenure.ceil();
  }

  /// Validate input ranges
  static Map<String, String?> validateInputs({
    required double loanAmount,
    required double interestRate,
    required int tenure,
    required double income,
  }) {
    Map<String, String?> errors = {};

    if (loanAmount < AppConstants.minLoanAmount ||
        loanAmount > AppConstants.maxLoanAmount) {
      errors['loanAmount'] =
          'Loan amount should be between ₹${AppConstants.minLoanAmount.toInt()} and ₹${AppConstants.maxLoanAmount.toInt()}';
    }

    if (interestRate < AppConstants.minInterestRate ||
        interestRate > AppConstants.maxInterestRate) {
      errors['interestRate'] =
          'Interest rate should be between ${AppConstants.minInterestRate}% and ${AppConstants.maxInterestRate}%';
    }

    if (tenure < AppConstants.minTenureYears ||
        tenure > AppConstants.maxTenureYears) {
      errors['tenure'] =
          'Loan tenure should be between ${AppConstants.minTenureYears} and ${AppConstants.maxTenureYears} years';
    }

    if (income <= 0) {
      errors['income'] = 'Please enter a valid annual income';
    }

    return errors;
  }
}
