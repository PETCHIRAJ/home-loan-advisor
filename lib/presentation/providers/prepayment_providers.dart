import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/prepayment_result.dart';
import '../../domain/entities/loan_parameters.dart';
import '../../domain/entities/emi_result.dart';
import '../../core/utils/prepayment_calculation_utils.dart';

/// State for prepayment calculator screen
class PrepaymentCalculatorState {
  final bool isLoading;
  final String? errorMessage;
  final List<PrepaymentResult> calculationHistory;

  const PrepaymentCalculatorState({
    this.isLoading = false,
    this.errorMessage,
    this.calculationHistory = const [],
  });

  PrepaymentCalculatorState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<PrepaymentResult>? calculationHistory,
  }) {
    return PrepaymentCalculatorState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      calculationHistory: calculationHistory ?? this.calculationHistory,
    );
  }
}

/// State notifier for prepayment calculator
class PrepaymentCalculatorStateNotifier extends StateNotifier<PrepaymentCalculatorState> {
  PrepaymentCalculatorStateNotifier() : super(const PrepaymentCalculatorState());

  /// Calculate prepayment result for a scenario
  Future<PrepaymentResult?> calculatePrepayment({
    required PrepaymentScenario scenario,
    required LoanParameters loanParams,
    required EMIResult originalEMI,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = PrepaymentCalculationUtils.calculatePrepaymentResult(
        scenario: scenario,
        loanParams: loanParams,
        originalEMI: originalEMI,
      );

      // Add to history
      final updatedHistory = [...state.calculationHistory, result];
      state = state.copyWith(
        isLoading: false,
        calculationHistory: updatedHistory,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Compare multiple prepayment scenarios
  Future<PrepaymentComparison?> compareScenarios({
    required List<PrepaymentScenario> scenarios,
    required LoanParameters loanParams,
    required EMIResult originalEMI,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final comparison = PrepaymentCalculationUtils.compareScenarios(
        scenarios: scenarios,
        loanParams: loanParams,
        originalEMI: originalEMI,
      );

      // Add all results to history
      final updatedHistory = [...state.calculationHistory, ...comparison.scenarios];
      state = state.copyWith(
        isLoading: false,
        calculationHistory: updatedHistory,
      );

      return comparison;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Clear calculation history
  void clearHistory() {
    state = state.copyWith(calculationHistory: []);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = const PrepaymentCalculatorState();
  }
}

/// Current prepayment scenario being configured
class PrepaymentScenarioState {
  final PrepaymentType type;
  final double amount;
  final PrepaymentFrequency frequency;
  final int startMonth;
  final int startYear;
  final int? extraEMIsPerYear;

  const PrepaymentScenarioState({
    this.type = PrepaymentType.oneTime,
    this.amount = 100000,
    this.frequency = PrepaymentFrequency.monthly,
    this.startMonth = 1,
    this.startYear = 1,
    this.extraEMIsPerYear,
  });

  PrepaymentScenarioState copyWith({
    PrepaymentType? type,
    double? amount,
    PrepaymentFrequency? frequency,
    int? startMonth,
    int? startYear,
    int? extraEMIsPerYear,
  }) {
    return PrepaymentScenarioState(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      extraEMIsPerYear: extraEMIsPerYear ?? this.extraEMIsPerYear,
    );
  }

  PrepaymentScenario toScenario() {
    return PrepaymentScenario(
      type: type,
      amount: amount,
      frequency: frequency,
      startMonth: startMonth,
      startYear: startYear,
      extraEMIsPerYear: extraEMIsPerYear,
    );
  }
}

/// State notifier for current prepayment scenario
class PrepaymentScenarioStateNotifier extends StateNotifier<PrepaymentScenarioState> {
  PrepaymentScenarioStateNotifier() : super(const PrepaymentScenarioState());

  void updateType(PrepaymentType type) {
    state = state.copyWith(type: type);
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updateFrequency(PrepaymentFrequency frequency) {
    state = state.copyWith(frequency: frequency);
  }

  void updateStartMonth(int month) {
    state = state.copyWith(startMonth: month);
  }

  void updateStartYear(int year) {
    state = state.copyWith(startYear: year);
  }

  void updateExtraEMIsPerYear(int count) {
    state = state.copyWith(extraEMIsPerYear: count);
  }

  void reset() {
    state = const PrepaymentScenarioState();
  }

  void resetForType(PrepaymentType type) {
    state = PrepaymentScenarioState(type: type);
  }
}

/// Providers
final prepaymentCalculatorStateProvider = 
    StateNotifierProvider<PrepaymentCalculatorStateNotifier, PrepaymentCalculatorState>(
  (ref) => PrepaymentCalculatorStateNotifier(),
);

final prepaymentScenarioStateProvider = 
    StateNotifierProvider<PrepaymentScenarioStateNotifier, PrepaymentScenarioState>(
  (ref) => PrepaymentScenarioStateNotifier(),
);

/// Provider for optimal prepayment calculation
final optimalPrepaymentProvider = Provider.family<double, Map<String, dynamic>>(
  (ref, params) {
    final availableFunds = params['availableFunds'] as double;
    final outstandingBalance = params['outstandingBalance'] as double;
    final currentInterestRate = params['currentInterestRate'] as double;
    final alternativeInvestmentRate = params['alternativeInvestmentRate'] as double? ?? 8.0;

    return PrepaymentCalculationUtils.calculateOptimalPrepaymentAmount(
      availableFunds: availableFunds,
      outstandingBalance: outstandingBalance,
      currentInterestRate: currentInterestRate,
      alternativeInvestmentRate: alternativeInvestmentRate,
    );
  },
);

/// Provider for tax-adjusted prepayment benefit
final taxAdjustedBenefitProvider = Provider.family<double, Map<String, dynamic>>(
  (ref, params) {
    final interestSaved = params['interestSaved'] as double;
    final taxSlabPercentage = params['taxSlabPercentage'] as double;
    final isSelfOccupied = params['isSelfOccupied'] as bool? ?? true;

    return PrepaymentCalculationUtils.calculateTaxAdjustedBenefit(
      interestSaved: interestSaved,
      taxSlabPercentage: taxSlabPercentage,
      isSelfOccupied: isSelfOccupied,
    );
  },
);

/// Provider for quick prepayment calculations
final quickPrepaymentResultProvider = 
    Provider.family<PrepaymentResult?, Map<String, dynamic>>(
  (ref, params) {
    try {
      final scenario = params['scenario'] as PrepaymentScenario;
      final loanParams = params['loanParams'] as LoanParameters;
      final originalEMI = params['originalEMI'] as EMIResult;

      return PrepaymentCalculationUtils.calculatePrepaymentResult(
        scenario: scenario,
        loanParams: loanParams,
        originalEMI: originalEMI,
      );
    } catch (e) {
      return null;
    }
  },
);