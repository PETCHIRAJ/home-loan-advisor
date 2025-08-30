import 'package:fpdart/fpdart.dart';
import '../entities/loan_parameters.dart';
import '../entities/emi_result.dart';
import '../entities/optimization_strategy.dart';
import '../repositories/calculation_repository.dart';

class GetOptimizationStrategiesUseCase {
  final CalculationRepository _repository;

  GetOptimizationStrategiesUseCase(this._repository);

  Future<Either<String, List<OptimizationStrategy>>> call({
    required LoanParameters parameters,
    required EMIResult currentResult,
  }) async {
    return await _repository.getOptimizationStrategies(
      parameters,
      currentResult,
    );
  }

  /// Get prepayment strategies with calculations
  Future<Either<String, List<PrepaymentStrategy>>> getPrepaymentStrategies({
    required LoanParameters parameters,
    required List<PrepaymentScenario> scenarios,
  }) async {
    try {
      List<PrepaymentStrategy> strategies = [];

      for (final scenario in scenarios) {
        final result = await _repository.calculatePrepayment(
          parameters: parameters,
          prepaymentAmount: scenario.amount,
          afterMonths: scenario.afterMonths,
          type: scenario.type,
        );

        result.fold(
          (error) => null, // Skip failed calculations
          (strategy) => strategies.add(strategy),
        );
      }

      // Sort by total savings (highest first)
      strategies.sort(
        (a, b) => b.result.totalSavings.compareTo(a.result.totalSavings),
      );

      return Right(strategies);
    } catch (e) {
      return Left('Error calculating prepayment strategies: ${e.toString()}');
    }
  }

  /// Get refinancing opportunities
  Future<Either<String, List<RefinancingStrategy>>> getRefinancingStrategies({
    required LoanParameters currentLoan,
    required List<String> targetBankIds,
  }) async {
    return await _repository.calculateRefinancing(
      currentLoan: currentLoan,
      targetBankIds: targetBankIds,
    );
  }

  /// Generate common prepayment scenarios
  List<PrepaymentScenario> generateCommonScenarios({
    required double monthlyEMI,
    required double loanAmount,
  }) {
    return [
      // Extra EMI scenarios
      PrepaymentScenario(
        type: PrepaymentType.extraEMI,
        amount: monthlyEMI * 0.1, // 10% extra
        afterMonths: 12,
        description: 'Pay 10% extra EMI monthly',
      ),
      PrepaymentScenario(
        type: PrepaymentType.extraEMI,
        amount: monthlyEMI * 0.2, // 20% extra
        afterMonths: 12,
        description: 'Pay 20% extra EMI monthly',
      ),

      // Lump sum scenarios
      PrepaymentScenario(
        type: PrepaymentType.lumpsum,
        amount: loanAmount * 0.05, // 5% of loan amount
        afterMonths: 12,
        description: 'Prepay 5% of loan amount after 1 year',
      ),
      PrepaymentScenario(
        type: PrepaymentType.lumpsum,
        amount: loanAmount * 0.10, // 10% of loan amount
        afterMonths: 24,
        description: 'Prepay 10% of loan amount after 2 years',
      ),

      // Step-up scenarios
      PrepaymentScenario(
        type: PrepaymentType.stepUp,
        amount: monthlyEMI * 0.05, // 5% increase annually
        afterMonths: 12,
        description: 'Increase EMI by 5% annually',
      ),

      // Round-up scenarios
      PrepaymentScenario(
        type: PrepaymentType.roundUp,
        amount: _calculateRoundUpAmount(monthlyEMI),
        afterMonths: 1,
        description: 'Round up EMI to nearest thousand',
      ),
    ];
  }

  /// Get personalized strategies based on user profile
  Future<Either<String, List<OptimizationStrategy>>> getPersonalizedStrategies({
    required LoanParameters parameters,
    required EMIResult currentResult,
    required Map<String, dynamic> userPreferences,
  }) async {
    final strategiesResult = await call(
      parameters: parameters,
      currentResult: currentResult,
    );

    return strategiesResult.fold((error) => Left(error), (strategies) {
      // Filter and rank strategies based on user preferences
      final filteredStrategies = strategies.where((strategy) {
        // Filter by difficulty preference
        final maxDifficulty = _getDifficultyLevel(
          userPreferences['maxDifficulty'] as String? ?? 'medium',
        );
        if (_getDifficultyNumericValue(strategy.difficulty) >
            _getDifficultyNumericValue(maxDifficulty)) {
          return false;
        }

        // Filter by minimum savings threshold
        final minSavings = userPreferences['minSavings'] as double? ?? 0;
        if (strategy.potentialSavings < minSavings) {
          return false;
        }

        // Filter by implementation time preference
        final maxTimeWeeks =
            userPreferences['maxImplementationWeeks'] as int? ?? 52;
        if (strategy.implementationTimeWeeks > maxTimeWeeks) {
          return false;
        }

        return true;
      }).toList();

      // Sort by impact score (highest first)
      filteredStrategies.sort((a, b) => b.impactScore.compareTo(a.impactScore));

      return Right(filteredStrategies);
    });
  }

  // Private helper methods
  double _calculateRoundUpAmount(double emi) {
    final roundedUp = ((emi / 1000).ceil() * 1000).toDouble();
    return roundedUp - emi;
  }

  DifficultyLevel _getDifficultyLevel(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return DifficultyLevel.easy;
      case 'hard':
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.medium;
    }
  }

  int _getDifficultyNumericValue(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 1;
      case DifficultyLevel.medium:
        return 2;
      case DifficultyLevel.hard:
        return 3;
    }
  }
}

/// Represents a prepayment scenario for calculation
class PrepaymentScenario {
  final PrepaymentType type;
  final double amount;
  final int afterMonths;
  final String description;

  const PrepaymentScenario({
    required this.type,
    required this.amount,
    required this.afterMonths,
    required this.description,
  });
}
