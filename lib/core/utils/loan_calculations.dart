import 'dart:math' as math;

/// Core loan calculation utilities
///
/// Provides accurate EMI, interest, and amortization calculations
/// following standard banking formulas used in India.
class LoanCalculations {
  // Private constructor to prevent instantiation
  LoanCalculations._();

  /// Calculates monthly EMI (Equated Monthly Installment)
  ///
  /// Formula: EMI = P * r * (1+r)^n / ((1+r)^n - 1)
  /// Where:
  /// - P = Principal loan amount
  /// - r = Monthly interest rate (annual rate / 12 / 100)
  /// - n = Number of monthly installments (years * 12)
  ///
  /// Example:
  /// ```dart
  /// calculateEMI(5000000, 8.5, 20) // Returns monthly EMI for ₹50L at 8.5% for 20 years
  /// ```
  static double calculateEMI({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
  }) {
    if (loanAmount <= 0 || annualInterestRate <= 0 || tenureYears <= 0) {
      return 0.0;
    }

    final monthlyRate = annualInterestRate / 12 / 100;
    final numberOfMonths = tenureYears * 12;

    if (monthlyRate == 0) {
      // If interest rate is 0, EMI is just principal divided by months
      return loanAmount / numberOfMonths;
    }

    final onePlusRateToN = math.pow(1 + monthlyRate, numberOfMonths);
    final emi = loanAmount * monthlyRate * onePlusRateToN / (onePlusRateToN - 1);

    return emi;
  }

  /// Calculates total amount payable over the loan tenure
  ///
  /// Example:
  /// ```dart
  /// calculateTotalAmount(47000, 20) // Returns total amount for EMI of ₹47K over 20 years
  /// ```
  static double calculateTotalAmount({
    required double monthlyEMI,
    required int tenureYears,
  }) {
    if (monthlyEMI <= 0 || tenureYears <= 0) return 0.0;
    
    return monthlyEMI * tenureYears * 12;
  }

  /// Calculates total interest payable
  ///
  /// Example:
  /// ```dart
  /// calculateTotalInterest(5000000, 47000, 20) // Returns total interest
  /// ```
  static double calculateTotalInterest({
    required double loanAmount,
    required double monthlyEMI,
    required int tenureYears,
  }) {
    final totalAmount = calculateTotalAmount(
      monthlyEMI: monthlyEMI,
      tenureYears: tenureYears,
    );
    
    return totalAmount - loanAmount;
  }

  /// Calculates outstanding balance after a number of payments
  ///
  /// Formula: Balance = P * ((1+r)^n - (1+r)^p) / ((1+r)^n - 1)
  /// Where:
  /// - P = Principal loan amount
  /// - r = Monthly interest rate
  /// - n = Total number of payments
  /// - p = Number of payments made
  ///
  /// Example:
  /// ```dart
  /// calculateOutstandingBalance(
  ///   loanAmount: 5000000,
  ///   annualInterestRate: 8.5,
  ///   tenureYears: 20,
  ///   paymentsMade: 60
  /// ) // Returns balance after 5 years (60 payments)
  /// ```
  static double calculateOutstandingBalance({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
    required int paymentsMade,
  }) {
    if (loanAmount <= 0 || annualInterestRate <= 0 || tenureYears <= 0) {
      return 0.0;
    }

    if (paymentsMade <= 0) return loanAmount;

    final monthlyRate = annualInterestRate / 12 / 100;
    final totalPayments = tenureYears * 12;

    if (paymentsMade >= totalPayments) return 0.0;

    if (monthlyRate == 0) {
      // If interest rate is 0
      return loanAmount * (totalPayments - paymentsMade) / totalPayments;
    }

    final onePlusRateToN = math.pow(1 + monthlyRate, totalPayments);
    final onePlusRateToP = math.pow(1 + monthlyRate, paymentsMade);

    final balance = loanAmount * (onePlusRateToN - onePlusRateToP) / (onePlusRateToN - 1);

    return math.max(0.0, balance);
  }

  /// Calculates principal and interest components for a specific month
  ///
  /// Returns a map with 'principal' and 'interest' keys
  ///
  /// Example:
  /// ```dart
  /// calculateMonthlyBreakdown(
  ///   loanAmount: 5000000,
  ///   annualInterestRate: 8.5,
  ///   tenureYears: 20,
  ///   monthNumber: 1
  /// ) // Returns {principal: 29750, interest: 18250} for first month
  /// ```
  static Map<String, double> calculateMonthlyBreakdown({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
    required int monthNumber,
  }) {
    if (monthNumber <= 0 || monthNumber > tenureYears * 12) {
      return {'principal': 0.0, 'interest': 0.0};
    }

    final emi = calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      tenureYears: tenureYears,
    );

    final outstandingAtStart = calculateOutstandingBalance(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      tenureYears: tenureYears,
      paymentsMade: monthNumber - 1,
    );

    final monthlyRate = annualInterestRate / 12 / 100;
    final interestForMonth = outstandingAtStart * monthlyRate;
    final principalForMonth = emi - interestForMonth;

    return {
      'principal': math.max(0.0, principalForMonth),
      'interest': math.max(0.0, interestForMonth),
    };
  }

  /// Calculates savings from extra principal payments
  ///
  /// Example:
  /// ```dart
  /// calculateExtraPaymentSavings(
  ///   loanAmount: 5000000,
  ///   annualInterestRate: 8.5,
  ///   tenureYears: 20,
  ///   extraPrincipal: 5000
  /// ) // Returns savings and new tenure
  /// ```
  static Map<String, dynamic> calculateExtraPaymentSavings({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
    required double extraPrincipal,
  }) {
    if (extraPrincipal <= 0) {
      return {
        'interestSaved': 0.0,
        'timeSaved': 0.0,
        'newTenureYears': tenureYears.toDouble(),
      };
    }

    final originalEMI = calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      tenureYears: tenureYears,
    );

    final newEMI = originalEMI + extraPrincipal;

    // Calculate new tenure with extra payments
    final monthlyRate = annualInterestRate / 12 / 100;
    final newTenureMonths = (math.log(1 + (loanAmount * monthlyRate / newEMI)) /
            math.log(1 + monthlyRate))
        .ceil();

    final originalTotalInterest = calculateTotalInterest(
      loanAmount: loanAmount,
      monthlyEMI: originalEMI,
      tenureYears: tenureYears,
    );

    final newTotalInterest = (newEMI * newTenureMonths) - loanAmount;
    final interestSaved = originalTotalInterest - newTotalInterest;
    final timeSavedMonths = (tenureYears * 12) - newTenureMonths;

    return {
      'interestSaved': math.max(0.0, interestSaved),
      'timeSaved': timeSavedMonths / 12.0, // In years
      'newTenureYears': newTenureMonths / 12.0,
    };
  }

  /// Calculates loan-to-value ratio
  ///
  /// Example:
  /// ```dart
  /// calculateLTV(5000000, 7500000) // Returns 66.67% LTV
  /// ```
  static double calculateLTV({
    required double loanAmount,
    required double propertyValue,
  }) {
    if (propertyValue <= 0) return 0.0;
    return (loanAmount / propertyValue) * 100;
  }

  /// Calculates affordability ratio (EMI to Income)
  ///
  /// Example:
  /// ```dart
  /// calculateAffordabilityRatio(47000, 150000) // Returns 31.33%
  /// ```
  static double calculateAffordabilityRatio({
    required double monthlyEMI,
    required double monthlyIncome,
  }) {
    if (monthlyIncome <= 0) return 0.0;
    return (monthlyEMI / monthlyIncome) * 100;
  }

  /// Generates amortization schedule for first N months
  ///
  /// Returns list of maps with month, emi, principal, interest, balance
  ///
  /// Example:
  /// ```dart
  /// generateAmortizationSchedule(
  ///   loanAmount: 5000000,
  ///   annualInterestRate: 8.5,
  ///   tenureYears: 20,
  ///   numberOfMonths: 12
  /// ) // Returns first year's amortization
  /// ```
  static List<Map<String, dynamic>> generateAmortizationSchedule({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
    int numberOfMonths = 240, // Default to 20 years
  }) {
    final List<Map<String, dynamic>> schedule = [];
    final totalMonths = tenureYears * 12;
    final monthsToGenerate = math.min(numberOfMonths, totalMonths);

    final emi = calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      tenureYears: tenureYears,
    );

    for (int month = 1; month <= monthsToGenerate; month++) {
      final breakdown = calculateMonthlyBreakdown(
        loanAmount: loanAmount,
        annualInterestRate: annualInterestRate,
        tenureYears: tenureYears,
        monthNumber: month,
      );

      final balance = calculateOutstandingBalance(
        loanAmount: loanAmount,
        annualInterestRate: annualInterestRate,
        tenureYears: tenureYears,
        paymentsMade: month,
      );

      schedule.add({
        'month': month,
        'emi': emi,
        'principal': breakdown['principal']!,
        'interest': breakdown['interest']!,
        'balance': balance,
      });
    }

    return schedule;
  }

  /// Calculates effective interest rate including processing fees
  ///
  /// Example:
  /// ```dart
  /// calculateEffectiveRate(5000000, 8.5, 20, 50000) // With ₹50K processing fee
  /// ```
  static double calculateEffectiveRate({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureYears,
    required double processingFee,
  }) {
    if (processingFee <= 0) return annualInterestRate;

    final emi = calculateEMI(
      loanAmount: loanAmount,
      annualInterestRate: annualInterestRate,
      tenureYears: tenureYears,
    );

    final netLoanAmount = loanAmount - processingFee;

    // Use iterative method to find effective rate
    double low = 0.0;
    double high = 50.0;
    double tolerance = 0.001;

    while (high - low > tolerance) {
      final mid = (low + high) / 2;
      final testEMI = calculateEMI(
        loanAmount: netLoanAmount,
        annualInterestRate: mid,
        tenureYears: tenureYears,
      );

      if (testEMI < emi) {
        low = mid;
      } else {
        high = mid;
      }
    }

    return (low + high) / 2;
  }
}