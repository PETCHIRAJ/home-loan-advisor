import '../entities/loan_scenario.dart';
import '../entities/loan_parameters.dart';
import '../entities/emi_result.dart';
import 'calculate_emi_usecase.dart';

/// Use case for managing scenario comparisons
class ScenarioComparisonUseCase {
  final CalculateEMIUseCase _calculateEMIUseCase;

  ScenarioComparisonUseCase(this._calculateEMIUseCase);

  /// Create a base scenario from current loan parameters and EMI result
  LoanScenario createBaseScenario(
    LoanParameters parameters,
    EMIResult result,
  ) {
    return LoanScenario(
      id: 'base',
      name: 'Current Scenario',
      description: 'Your current loan parameters',
      parameters: parameters,
      result: result,
      isBaseScenario: true,
    );
  }

  /// Create preset scenarios from base scenario
  List<LoanScenario> createPresetScenarios(LoanScenario baseScenario) {
    final baseParams = baseScenario.parameters;
    final scenarios = <LoanScenario>[];

    // Lower Rate scenario
    scenarios.add(LoanScenario(
      id: 'lower_rate',
      name: ScenarioPreset.lowerRate.displayName,
      description: ScenarioPreset.lowerRate.description,
      parameters: baseParams.copyWith(
        interestRate: (baseParams.interestRate - 0.5).clamp(1.0, 50.0),
      ),
    ));

    // Higher Rate scenario
    scenarios.add(LoanScenario(
      id: 'higher_rate',
      name: ScenarioPreset.higherRate.displayName,
      description: ScenarioPreset.higherRate.description,
      parameters: baseParams.copyWith(
        interestRate: (baseParams.interestRate + 0.5).clamp(1.0, 50.0),
      ),
    ));

    // Shorter Tenure scenario
    scenarios.add(LoanScenario(
      id: 'shorter_tenure',
      name: ScenarioPreset.shorterTenure.displayName,
      description: ScenarioPreset.shorterTenure.description,
      parameters: baseParams.copyWith(
        tenureYears: (baseParams.tenureYears - 5).clamp(1, 50),
      ),
    ));

    // Longer Tenure scenario
    scenarios.add(LoanScenario(
      id: 'longer_tenure',
      name: ScenarioPreset.longerTenure.displayName,
      description: ScenarioPreset.longerTenure.description,
      parameters: baseParams.copyWith(
        tenureYears: (baseParams.tenureYears + 5).clamp(1, 50),
      ),
    ));

    // Lower Amount scenario
    scenarios.add(LoanScenario(
      id: 'lower_amount',
      name: ScenarioPreset.lowerAmount.displayName,
      description: ScenarioPreset.lowerAmount.description,
      parameters: baseParams.copyWith(
        loanAmount: (baseParams.loanAmount * 0.8).clamp(100000, double.infinity),
      ),
    ));

    // Higher Amount scenario
    scenarios.add(LoanScenario(
      id: 'higher_amount',
      name: ScenarioPreset.higherAmount.displayName,
      description: ScenarioPreset.higherAmount.description,
      parameters: baseParams.copyWith(
        loanAmount: (baseParams.loanAmount * 1.2).clamp(100000, double.infinity),
      ),
    ));

    return scenarios;
  }

  /// Calculate EMI for a scenario
  Future<LoanScenario> calculateScenarioEMI(LoanScenario scenario) async {
    try {
      final resultEither = await _calculateEMIUseCase.call(scenario.parameters);
      return resultEither.fold(
        (error) => scenario, // Return scenario without result if calculation fails
        (result) => scenario.copyWith(result: result),
      );
    } catch (e) {
      // Return scenario without result if calculation fails
      return scenario;
    }
  }

  /// Calculate EMI for multiple scenarios
  Future<List<LoanScenario>> calculateMultipleScenarios(
    List<LoanScenario> scenarios,
  ) async {
    final results = <LoanScenario>[];
    
    for (final scenario in scenarios) {
      if (scenario.result == null) {
        final calculatedScenario = await calculateScenarioEMI(scenario);
        results.add(calculatedScenario);
      } else {
        results.add(scenario);
      }
    }
    
    return results;
  }

  /// Generate comparison metrics
  ScenarioComparisonMetrics generateComparisonMetrics(
    List<LoanScenario> scenarios,
  ) {
    final scenariosWithResults = scenarios
        .where((s) => s.result != null && s.isEnabled)
        .toList();

    if (scenariosWithResults.isEmpty) {
      return const ScenarioComparisonMetrics(
        maxEMI: 0,
        minEMI: 0,
        maxTotalInterest: 0,
        minTotalInterest: 0,
        maxTotalAmount: 0,
        minTotalAmount: 0,
        maxTaxBenefits: 0,
        minTaxBenefits: 0,
        differences: [],
      );
    }

    final emis = scenariosWithResults.map((s) => s.result!.monthlyEMI).toList();
    final totalInterests = scenariosWithResults.map((s) => s.result!.totalInterest).toList();
    final totalAmounts = scenariosWithResults.map((s) => s.result!.totalAmount).toList();
    final taxBenefits = scenariosWithResults
        .map((s) => s.result!.taxBenefits.totalAnnualSavings)
        .toList();

    // Generate differences between scenarios
    final differences = <ScenarioDifference>[];
    for (int i = 0; i < scenariosWithResults.length; i++) {
      for (int j = i + 1; j < scenariosWithResults.length; j++) {
        final scenario1 = scenariosWithResults[i];
        final scenario2 = scenariosWithResults[j];
        
        differences.add(ScenarioDifference(
          fromScenarioId: scenario1.id,
          toScenarioId: scenario2.id,
          emiDifference: scenario2.result!.monthlyEMI - scenario1.result!.monthlyEMI,
          totalInterestDifference: scenario2.result!.totalInterest - scenario1.result!.totalInterest,
          totalAmountDifference: scenario2.result!.totalAmount - scenario1.result!.totalAmount,
          taxBenefitsDifference: scenario2.result!.taxBenefits.totalAnnualSavings - 
              scenario1.result!.taxBenefits.totalAnnualSavings,
          effectiveRateDifference: scenario2.effectiveInterestRate - scenario1.effectiveInterestRate,
        ));
      }
    }

    return ScenarioComparisonMetrics(
      maxEMI: emis.reduce((a, b) => a > b ? a : b),
      minEMI: emis.reduce((a, b) => a < b ? a : b),
      maxTotalInterest: totalInterests.reduce((a, b) => a > b ? a : b),
      minTotalInterest: totalInterests.reduce((a, b) => a < b ? a : b),
      maxTotalAmount: totalAmounts.reduce((a, b) => a > b ? a : b),
      minTotalAmount: totalAmounts.reduce((a, b) => a < b ? a : b),
      maxTaxBenefits: taxBenefits.reduce((a, b) => a > b ? a : b),
      minTaxBenefits: taxBenefits.reduce((a, b) => a < b ? a : b),
      differences: differences,
    );
  }

  /// Find the best scenario based on total cost after benefits
  String? findBestScenario(List<LoanScenario> scenarios) {
    final scenariosWithResults = scenarios
        .where((s) => s.result != null && s.isEnabled)
        .toList();

    if (scenariosWithResults.isEmpty) return null;

    LoanScenario bestScenario = scenariosWithResults.first;
    for (final scenario in scenariosWithResults) {
      if (scenario.totalCostAfterBenefits < bestScenario.totalCostAfterBenefits) {
        bestScenario = scenario;
      }
    }

    return bestScenario.id;
  }

  /// Create a complete scenario comparison
  Future<ScenarioComparison> createScenarioComparison(
    LoanParameters baseParameters,
    EMIResult baseResult, {
    List<LoanScenario>? customScenarios,
    bool includePresets = true,
  }) async {
    final baseScenario = createBaseScenario(baseParameters, baseResult);
    final scenarios = <LoanScenario>[baseScenario];

    // Add preset scenarios if requested
    if (includePresets) {
      final presetScenarios = createPresetScenarios(baseScenario);
      scenarios.addAll(presetScenarios);
    }

    // Add custom scenarios if provided
    if (customScenarios != null) {
      scenarios.addAll(customScenarios);
    }

    // Calculate EMI for scenarios without results
    final calculatedScenarios = await calculateMultipleScenarios(scenarios);

    // Generate metrics
    final metrics = generateComparisonMetrics(calculatedScenarios);

    // Find best scenario
    final bestScenarioId = findBestScenario(calculatedScenarios);

    return ScenarioComparison(
      scenarios: calculatedScenarios,
      metrics: metrics,
      bestScenarioId: bestScenarioId,
    );
  }

  /// Update a scenario's parameters and recalculate
  Future<LoanScenario> updateScenarioParameters(
    LoanScenario scenario,
    LoanParameters newParameters,
  ) async {
    final updatedScenario = scenario.copyWith(
      parameters: newParameters,
      result: null, // Clear existing result
    );
    
    return await calculateScenarioEMI(updatedScenario);
  }

  /// Create a custom scenario
  LoanScenario createCustomScenario({
    required String name,
    required String description,
    required LoanParameters parameters,
    String? id,
  }) {
    return LoanScenario(
      id: id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      parameters: parameters,
    );
  }
}