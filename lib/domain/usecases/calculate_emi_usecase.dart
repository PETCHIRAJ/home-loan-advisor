import 'package:fpdart/fpdart.dart';
import '../entities/loan_parameters.dart';
import '../entities/emi_result.dart';
import '../repositories/calculation_repository.dart';

class CalculateEMIUseCase {
  final CalculationRepository _repository;

  CalculateEMIUseCase(this._repository);

  Future<Either<String, EMIResult>> call(LoanParameters parameters) async {
    // Validate parameters first
    final validationResult = await _repository.validateParameters(parameters);

    return validationResult.fold((error) => Left(error), (isValid) async {
      if (!isValid) {
        return const Left('Invalid loan parameters provided');
      }

      // Calculate EMI with all tax benefits
      return await _repository.calculateEMI(parameters);
    });
  }

  /// Calculate EMI for multiple scenarios (sensitivity analysis)
  Future<Either<String, List<EMIResult>>> calculateScenarios({
    required LoanParameters baseParameters,
    required List<double> interestRateScenarios,
    required List<int> tenureScenarios,
  }) async {
    try {
      List<EMIResult> results = [];

      for (final rate in interestRateScenarios) {
        for (final tenure in tenureScenarios) {
          final scenarioParams = baseParameters.copyWith(
            interestRate: rate,
            tenureYears: tenure,
          );

          final result = await call(scenarioParams);
          result.fold(
            (error) => null, // Skip failed calculations
            (emiResult) => results.add(emiResult),
          );
        }
      }

      if (results.isEmpty) {
        return const Left('Failed to calculate any scenarios');
      }

      return Right(results);
    } catch (e) {
      return Left('Error calculating scenarios: ${e.toString()}');
    }
  }
}
