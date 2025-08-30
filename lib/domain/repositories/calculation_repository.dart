import 'package:fpdart/fpdart.dart';
import '../entities/loan_parameters.dart';
import '../entities/emi_result.dart';
import '../entities/optimization_strategy.dart';

abstract class CalculationRepository {
  /// Calculate EMI with tax benefits
  Future<Either<String, EMIResult>> calculateEMI(LoanParameters parameters);

  /// Get optimization strategies for given loan
  Future<Either<String, List<OptimizationStrategy>>> getOptimizationStrategies(
    LoanParameters parameters,
    EMIResult currentResult,
  );

  /// Calculate prepayment benefits
  Future<Either<String, PrepaymentStrategy>> calculatePrepayment({
    required LoanParameters parameters,
    required double prepaymentAmount,
    required int afterMonths,
    required PrepaymentType type,
  });

  /// Calculate refinancing benefits
  Future<Either<String, List<RefinancingStrategy>>> calculateRefinancing({
    required LoanParameters currentLoan,
    required List<String> targetBankIds,
  });

  /// Get tax benefit breakdown
  Future<Either<String, TaxBenefits>> calculateTaxBenefits({
    required double principalPayment,
    required double interestPayment,
    required int taxSlabPercentage,
    required bool isSelfOccupied,
    required bool isFirstTimeHomeBuyer,
  });

  /// Calculate PMAY subsidy
  Future<Either<String, PMAYBenefit>> calculatePMAYBenefit({
    required double annualIncome,
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  });

  /// Save calculation history
  Future<Either<String, bool>> saveCalculation({
    required LoanParameters parameters,
    required EMIResult result,
    required String userId,
  });

  /// Get calculation history
  Future<Either<String, List<Map<String, dynamic>>>> getCalculationHistory(
    String userId,
  );

  /// Validate loan parameters
  Future<Either<String, bool>> validateParameters(LoanParameters parameters);
}
