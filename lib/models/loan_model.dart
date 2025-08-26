import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math' as math;

part 'loan_model.freezed.dart';
part 'loan_model.g.dart';

/// Immutable model representing a home loan with all its parameters
///
/// This is the core data model that drives all calculations and UI updates
/// in the Home Loan Advisor app. Uses Freezed for immutability and
/// code generation for JSON serialization.
@freezed
class LoanModel with _$LoanModel {
  const factory LoanModel({
    /// Principal loan amount in INR
    @Default(3000000.0) double loanAmount,

    /// Annual interest rate as percentage (e.g., 8.5 for 8.5%)
    @Default(8.5) double annualInterestRate,

    /// Loan tenure in years
    @Default(20) int tenureYears,

    /// Property value for LTV calculation (optional)
    double? propertyValue,

    /// Monthly income for affordability calculation (optional)
    double? monthlyIncome,

    /// Processing fee and other charges
    @Default(0.0) double processingFee,

    /// Insurance premium (optional)
    double? insurancePremium,

    /// Extra EMI amount per month (for prepayment strategy)
    @Default(0.0) double extraEMIAmount,

    /// One-time extra principal payment
    @Default(0.0) double lumpSumPayment,

    /// Month when lump sum is paid (1-based index)
    @Default(0) int lumpSumMonth,

    /// Loan type for different calculation methods
    @Default(LoanType.homeLoan) LoanType loanType,

    /// Interest rate type
    @Default(InterestRateType.fixed) InterestRateType rateType,

    /// Date when loan was/will be started
    DateTime? loanStartDate,

    /// Bank or lender name (optional)
    String? bankName,

    /// Whether this loan data has been modified
    @Default(false) bool isModified,

    /// Last calculation timestamp for cache validation
    DateTime? lastCalculated,
  }) = _LoanModel;

  /// Creates LoanModel from JSON
  factory LoanModel.fromJson(Map<String, dynamic> json) =>
      _$LoanModelFromJson(json);

  /// Creates a loan with smart defaults for Indian market
  factory LoanModel.initial() => LoanModel(
        loanAmount: 3000000.0, // ₹30 lakhs - typical home loan amount
        annualInterestRate: 8.5, // Current market rate
        tenureYears: 20, // Standard tenure
        loanStartDate: DateTime.now(),
        lastCalculated: DateTime.now(),
      );

  /// Creates a loan for testing/demo purposes
  factory LoanModel.demo() => LoanModel(
        loanAmount: 5000000.0, // ₹50 lakhs
        annualInterestRate: 8.75,
        tenureYears: 25,
        propertyValue: 7500000.0, // ₹75 lakhs
        monthlyIncome: 150000.0, // ₹1.5 lakhs/month
        processingFee: 50000.0, // ₹50K processing fee
        bankName: 'Demo Bank',
        loanStartDate: DateTime.now(),
        lastCalculated: DateTime.now(),
      );
}

/// Extension on LoanModel for calculated properties and validation
extension LoanModelExtension on LoanModel {
  /// Calculated monthly EMI
  double get monthlyEMI {
    if (loanAmount <= 0 || annualInterestRate <= 0 || tenureYears <= 0) {
      return 0.0;
    }

    final monthlyRate = annualInterestRate / 12 / 100;
    final numberOfMonths = tenureYears * 12;

    if (monthlyRate == 0) {
      return loanAmount / numberOfMonths;
    }

    final onePlusRateToN = math.pow(1 + monthlyRate, numberOfMonths);
    return loanAmount * monthlyRate * onePlusRateToN / (onePlusRateToN - 1);
  }

  /// Total amount payable over loan tenure
  double get totalAmount => monthlyEMI * tenureYears * 12;

  /// Total interest payable
  double get totalInterest => totalAmount - loanAmount;

  /// Loan-to-Value ratio as percentage
  double? get ltvRatio {
    if (propertyValue == null || propertyValue! <= 0) return null;
    return (loanAmount / propertyValue!) * 100;
  }

  /// EMI-to-Income ratio as percentage
  double? get emiToIncomeRatio {
    if (monthlyIncome == null || monthlyIncome! <= 0) return null;
    return (monthlyEMI / monthlyIncome!) * 100;
  }

  /// Effective interest rate including processing fees
  double get effectiveInterestRate {
    if (processingFee <= 0) return annualInterestRate;

    // Simplified calculation - in practice would use iterative method
    return annualInterestRate + (processingFee / loanAmount * 100);
  }

  /// Monthly EMI with extra payment
  double get monthlyEMIWithExtra => monthlyEMI + extraEMIAmount;

  /// Total tenure in months
  int get totalMonths => tenureYears * 12;

  /// Validates if loan parameters are reasonable
  bool get isValid {
    return loanAmount >= 100000 && // Minimum ₹1 lakh
        loanAmount <= 100000000 && // Maximum ₹10 crore
        annualInterestRate >= 1.0 && // Minimum 1%
        annualInterestRate <= 30.0 && // Maximum 30%
        tenureYears >= 1 && // Minimum 1 year
        tenureYears <= 50; // Maximum 50 years
  }

  /// Checks if loan is affordable based on EMI-to-income ratio
  bool get isAffordable {
    if (monthlyIncome == null) return true; // Can't determine without income
    final ratio = emiToIncomeRatio;
    return ratio != null && ratio <= 40.0; // 40% is typical affordability limit
  }

  /// Returns loan risk level based on LTV and affordability
  LoanRiskLevel get riskLevel {
    final ltv = ltvRatio;
    final emiRatio = emiToIncomeRatio;

    // High risk conditions
    if ((ltv != null && ltv > 90) ||
        (emiRatio != null && emiRatio > 50) ||
        annualInterestRate > 15) {
      return LoanRiskLevel.high;
    }

    // Medium risk conditions
    if ((ltv != null && ltv > 80) ||
        (emiRatio != null && emiRatio > 40) ||
        annualInterestRate > 12) {
      return LoanRiskLevel.medium;
    }

    return LoanRiskLevel.low;
  }

  /// Creates a copy with calculated fields updated
  LoanModel withUpdatedCalculations() {
    return copyWith(
      lastCalculated: DateTime.now(),
      isModified: false,
    );
  }
}

/// Types of loans supported by the calculator
enum LoanType {
  @JsonValue('home_loan')
  homeLoan,

  @JsonValue('home_improvement')
  homeImprovement,

  @JsonValue('land_purchase')
  landPurchase,

  @JsonValue('construction')
  construction,

  @JsonValue('loan_against_property')
  loanAgainstProperty,
}

/// Extension for LoanType display names
extension LoanTypeExtension on LoanType {
  String get displayName {
    switch (this) {
      case LoanType.homeLoan:
        return 'Home Loan';
      case LoanType.homeImprovement:
        return 'Home Improvement';
      case LoanType.landPurchase:
        return 'Land Purchase';
      case LoanType.construction:
        return 'Construction Loan';
      case LoanType.loanAgainstProperty:
        return 'Loan Against Property';
    }
  }

  String get description {
    switch (this) {
      case LoanType.homeLoan:
        return 'Purchase of residential property';
      case LoanType.homeImprovement:
        return 'Renovation and improvement of existing property';
      case LoanType.landPurchase:
        return 'Purchase of land/plot';
      case LoanType.construction:
        return 'Construction of new property';
      case LoanType.loanAgainstProperty:
        return 'Loan using property as collateral';
    }
  }
}

/// Interest rate types
enum InterestRateType {
  @JsonValue('fixed')
  fixed,

  @JsonValue('floating')
  floating,

  @JsonValue('hybrid')
  hybrid,
}

/// Extension for InterestRateType display
extension InterestRateTypeExtension on InterestRateType {
  String get displayName {
    switch (this) {
      case InterestRateType.fixed:
        return 'Fixed Rate';
      case InterestRateType.floating:
        return 'Floating Rate';
      case InterestRateType.hybrid:
        return 'Hybrid Rate';
    }
  }

  String get description {
    switch (this) {
      case InterestRateType.fixed:
        return 'Interest rate remains constant throughout tenure';
      case InterestRateType.floating:
        return 'Interest rate varies based on market conditions';
      case InterestRateType.hybrid:
        return 'Fixed rate initially, then converts to floating';
    }
  }
}

/// Risk levels for loan assessment
enum LoanRiskLevel {
  low,
  medium,
  high,
}

/// Extension for risk level display
extension LoanRiskLevelExtension on LoanRiskLevel {
  String get displayName {
    switch (this) {
      case LoanRiskLevel.low:
        return 'Low Risk';
      case LoanRiskLevel.medium:
        return 'Medium Risk';
      case LoanRiskLevel.high:
        return 'High Risk';
    }
  }

  String get description {
    switch (this) {
      case LoanRiskLevel.low:
        return 'Comfortable loan parameters';
      case LoanRiskLevel.medium:
        return 'Moderate risk, manageable with discipline';
      case LoanRiskLevel.high:
        return 'High risk, consider reducing loan amount or tenure';
    }
  }
}