import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_scenario.dart';
import '../../domain/entities/loan_parameters.dart';
import '../../domain/entities/emi_result.dart';
import '../../domain/usecases/scenario_comparison_usecase.dart';
import '../../domain/usecases/calculate_emi_usecase.dart';
import '../providers/app_providers.dart';

/// Provider for ScenarioComparisonUseCase
final scenarioComparisonUseCaseProvider = Provider<ScenarioComparisonUseCase>((ref) {
  final calculationRepo = ref.watch(calculationRepositoryProvider);
  final calculateEMIUseCase = CalculateEMIUseCase(calculationRepo);
  return ScenarioComparisonUseCase(calculateEMIUseCase);
});

/// State class for scenario comparison
class ScenarioComparisonState {
  final ScenarioComparison? comparison;
  final bool isLoading;
  final String? error;
  final bool showPresetsOnly;

  const ScenarioComparisonState({
    this.comparison,
    this.isLoading = false,
    this.error,
    this.showPresetsOnly = true,
  });

  ScenarioComparisonState copyWith({
    ScenarioComparison? comparison,
    bool? isLoading,
    String? error,
    bool? showPresetsOnly,
  }) {
    return ScenarioComparisonState(
      comparison: comparison ?? this.comparison,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showPresetsOnly: showPresetsOnly ?? this.showPresetsOnly,
    );
  }
}

/// Provider for scenario comparison state
class ScenarioComparisonNotifier extends StateNotifier<ScenarioComparisonState> {
  final ScenarioComparisonUseCase _useCase;

  ScenarioComparisonNotifier(this._useCase) : super(const ScenarioComparisonState());

  /// Initialize comparison with base scenario
  Future<void> initializeComparison(
    LoanParameters baseParameters,
    EMIResult baseResult,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final comparison = await _useCase.createScenarioComparison(
        baseParameters,
        baseResult,
        includePresets: true,
      );
      
      state = state.copyWith(
        comparison: comparison,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize comparison: ${e.toString()}',
      );
    }
  }

  /// Toggle scenario enabled/disabled state
  Future<void> toggleScenario(String scenarioId) async {
    final comparison = state.comparison;
    if (comparison == null) return;

    final updatedScenarios = comparison.scenarios.map((scenario) {
      if (scenario.id == scenarioId && !scenario.isBaseScenario) {
        return scenario.copyWith(isEnabled: !scenario.isEnabled);
      }
      return scenario;
    }).toList();

    // Regenerate metrics and find best scenario
    final metrics = _useCase.generateComparisonMetrics(updatedScenarios);
    final bestScenarioId = _useCase.findBestScenario(updatedScenarios);

    final updatedComparison = comparison.copyWith(
      scenarios: updatedScenarios,
      metrics: metrics,
      bestScenarioId: bestScenarioId,
    );

    state = state.copyWith(comparison: updatedComparison);
  }

  /// Update scenario parameters
  Future<void> updateScenarioParameters(
    String scenarioId,
    LoanParameters newParameters,
  ) async {
    final comparison = state.comparison;
    if (comparison == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final scenarioIndex = comparison.scenarios.indexWhere((s) => s.id == scenarioId);
      if (scenarioIndex == -1) {
        state = state.copyWith(isLoading: false, error: 'Scenario not found');
        return;
      }

      final scenario = comparison.scenarios[scenarioIndex];
      final updatedScenario = await _useCase.updateScenarioParameters(
        scenario,
        newParameters,
      );

      final updatedScenarios = List<LoanScenario>.from(comparison.scenarios);
      updatedScenarios[scenarioIndex] = updatedScenario;

      // Regenerate metrics and find best scenario
      final metrics = _useCase.generateComparisonMetrics(updatedScenarios);
      final bestScenarioId = _useCase.findBestScenario(updatedScenarios);

      final updatedComparison = comparison.copyWith(
        scenarios: updatedScenarios,
        metrics: metrics,
        bestScenarioId: bestScenarioId,
      );

      state = state.copyWith(
        comparison: updatedComparison,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update scenario: ${e.toString()}',
      );
    }
  }

  /// Add custom scenario
  Future<void> addCustomScenario(
    String name,
    String description,
    LoanParameters parameters,
  ) async {
    final comparison = state.comparison;
    if (comparison == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final customScenario = _useCase.createCustomScenario(
        name: name,
        description: description,
        parameters: parameters,
      );

      final calculatedScenario = await _useCase.calculateScenarioEMI(customScenario);
      
      final updatedScenarios = List<LoanScenario>.from(comparison.scenarios)
        ..add(calculatedScenario);

      // Regenerate metrics and find best scenario
      final metrics = _useCase.generateComparisonMetrics(updatedScenarios);
      final bestScenarioId = _useCase.findBestScenario(updatedScenarios);

      final updatedComparison = comparison.copyWith(
        scenarios: updatedScenarios,
        metrics: metrics,
        bestScenarioId: bestScenarioId,
      );

      state = state.copyWith(
        comparison: updatedComparison,
        isLoading: false,
        showPresetsOnly: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add custom scenario: ${e.toString()}',
      );
    }
  }

  /// Remove scenario (except base scenario)
  void removeScenario(String scenarioId) {
    final comparison = state.comparison;
    if (comparison == null) return;

    final updatedScenarios = comparison.scenarios
        .where((s) => s.id != scenarioId || s.isBaseScenario)
        .toList();

    // Regenerate metrics and find best scenario
    final metrics = _useCase.generateComparisonMetrics(updatedScenarios);
    final bestScenarioId = _useCase.findBestScenario(updatedScenarios);

    final updatedComparison = comparison.copyWith(
      scenarios: updatedScenarios,
      metrics: metrics,
      bestScenarioId: bestScenarioId,
    );

    state = state.copyWith(comparison: updatedComparison);
  }

  /// Apply scenario preset
  Future<void> applyScenarioPreset(String scenarioId, ScenarioPreset preset) async {
    final comparison = state.comparison;
    if (comparison == null) return;

    final baseScenario = comparison.baseScenario;
    if (baseScenario == null) return;

    final baseParams = baseScenario.parameters;
    LoanParameters newParameters;

    switch (preset) {
      case ScenarioPreset.lowerRate:
        newParameters = baseParams.copyWith(
          interestRate: (baseParams.interestRate - 0.5).clamp(1.0, 50.0),
        );
        break;
      case ScenarioPreset.higherRate:
        newParameters = baseParams.copyWith(
          interestRate: (baseParams.interestRate + 0.5).clamp(1.0, 50.0),
        );
        break;
      case ScenarioPreset.shorterTenure:
        newParameters = baseParams.copyWith(
          tenureYears: (baseParams.tenureYears - 5).clamp(1, 50),
        );
        break;
      case ScenarioPreset.longerTenure:
        newParameters = baseParams.copyWith(
          tenureYears: (baseParams.tenureYears + 5).clamp(1, 50),
        );
        break;
      case ScenarioPreset.lowerAmount:
        newParameters = baseParams.copyWith(
          loanAmount: (baseParams.loanAmount * 0.8).clamp(100000, double.infinity),
        );
        break;
      case ScenarioPreset.higherAmount:
        newParameters = baseParams.copyWith(
          loanAmount: (baseParams.loanAmount * 1.2).clamp(100000, double.infinity),
        );
        break;
    }

    await updateScenarioParameters(scenarioId, newParameters);
  }

  /// Reset all scenarios to defaults
  Future<void> resetToDefaults() async {
    final comparison = state.comparison;
    if (comparison?.baseScenario == null) return;

    await initializeComparison(
      comparison!.baseScenario!.parameters,
      comparison.baseScenario!.result!,
    );
  }

  /// Toggle between showing presets only or all scenarios
  void toggleShowPresetsOnly() {
    state = state.copyWith(showPresetsOnly: !state.showPresetsOnly);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final scenarioComparisonProvider = StateNotifierProvider<ScenarioComparisonNotifier, ScenarioComparisonState>((ref) {
  final useCase = ref.watch(scenarioComparisonUseCaseProvider);
  return ScenarioComparisonNotifier(useCase);
});

/// Provider for enabled scenarios
final enabledScenariosProvider = Provider<List<LoanScenario>>((ref) {
  final state = ref.watch(scenarioComparisonProvider);
  return state.comparison?.enabledScenarios ?? [];
});

/// Provider for scenarios with results
final scenariosWithResultsProvider = Provider<List<LoanScenario>>((ref) {
  final state = ref.watch(scenarioComparisonProvider);
  return state.comparison?.scenariosWithResults ?? [];
});

/// Provider for best scenario
final bestScenarioProvider = Provider<LoanScenario?>((ref) {
  final state = ref.watch(scenarioComparisonProvider);
  return state.comparison?.bestScenario;
});

/// Provider for comparison metrics
final comparisonMetricsProvider = Provider<ScenarioComparisonMetrics?>((ref) {
  final state = ref.watch(scenarioComparisonProvider);
  return state.comparison?.metrics;
});

/// Filtered scenarios based on display preferences
final filteredScenariosProvider = Provider<List<LoanScenario>>((ref) {
  final state = ref.watch(scenarioComparisonProvider);
  final comparison = state.comparison;
  
  if (comparison == null) return [];
  
  if (state.showPresetsOnly) {
    // Show base scenario + enabled preset scenarios
    return comparison.scenarios
        .where((s) => s.isBaseScenario || (s.isEnabled && !s.id.startsWith('custom_')))
        .toList();
  } else {
    // Show all enabled scenarios
    return comparison.enabledScenarios;
  }
});