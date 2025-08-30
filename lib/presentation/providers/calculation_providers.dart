import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_parameters.dart' as domain;
import '../../domain/entities/emi_result.dart';
import '../../domain/entities/optimization_strategy.dart';
import '../../domain/entities/money_saving_strategy.dart';
import '../../domain/entities/step_emi.dart';
import '../../core/utils/step_emi_calculation_utils.dart';
import 'app_providers.dart';

// Loan parameters state notifier
class LoanParametersNotifier extends StateNotifier<domain.LoanParameters> {
  LoanParametersNotifier()
    : super(
        const domain.LoanParameters(
          loanAmount: 3500000, // 35 lakhs
          interestRate: 8.65,
          tenureYears: 20,
          annualIncome: 1200000, // 12 lakhs
          taxSlabPercentage: 20,
          isSelfOccupied: true,
          isFirstTimeHomeBuyer: false,
          age: 30,
          employmentType: 'salaried',
          gender: 'male',
        ),
      );

  void updateLoanAmount(double amount) {
    state = state.copyWith(loanAmount: amount);
  }

  void updateInterestRate(double rate) {
    state = state.copyWith(interestRate: rate);
  }

  void updateTenure(int years) {
    state = state.copyWith(tenureYears: years);
  }

  void updateAnnualIncome(double income) {
    state = state.copyWith(annualIncome: income);
  }

  void updateTaxSlab(int percentage) {
    state = state.copyWith(taxSlabPercentage: percentage);
  }

  void updatePropertyType(bool isSelfOccupied) {
    state = state.copyWith(isSelfOccupied: isSelfOccupied);
  }

  void updateFirstTimeBuyer(bool isFirstTime) {
    state = state.copyWith(isFirstTimeHomeBuyer: isFirstTime);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void updateEmploymentType(String type) {
    state = state.copyWith(employmentType: type);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void resetToDefaults() {
    state = const domain.LoanParameters(
      loanAmount: 3500000,
      interestRate: 8.65,
      tenureYears: 20,
      annualIncome: 1200000,
      taxSlabPercentage: 20,
      isSelfOccupied: true,
      isFirstTimeHomeBuyer: false,
      age: 30,
      employmentType: 'salaried',
      gender: 'male',
    );
  }
}

// EMI calculation notifier
class EMICalculationNotifier extends StateNotifier<AsyncValue<EMIResult?>> {
  EMICalculationNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> calculateEMI() async {
    final parameters = _ref.read(loanParametersProvider);
    state = const AsyncValue.loading();

    try {
      final useCase = _ref.read(calculateEMIUseCaseProvider);
      final result = await useCase(parameters);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (emiResult) => state = AsyncValue.data(emiResult),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

// Optimization strategies notifier
class OptimizationStrategiesNotifier
    extends StateNotifier<AsyncValue<List<OptimizationStrategy>>> {
  OptimizationStrategiesNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;

  Future<void> loadStrategies() async {
    final parameters = _ref.read(loanParametersProvider);
    final emiCalculation = _ref.read(emiCalculationProvider);

    // Wait for EMI calculation to complete
    if (!emiCalculation.hasValue || emiCalculation.value == null) {
      state = const AsyncValue.error(
        'EMI calculation required first',
        StackTrace.empty,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final useCase = _ref.read(getOptimizationStrategiesUseCaseProvider);
      final result = await useCase(
        parameters: parameters,
        currentResult: emiCalculation.value!,
      );

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (strategies) => state = AsyncValue.data(strategies),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearStrategies() {
    state = const AsyncValue.data([]);
  }
}

// State class for calculator UI
class CalculatorState {
  final int activeTabIndex;
  final bool isLoading;
  final String? error;
  final bool showResults;

  const CalculatorState({
    this.activeTabIndex = 0,
    this.isLoading = false,
    this.error,
    this.showResults = false,
  });

  CalculatorState copyWith({
    int? activeTabIndex,
    bool? isLoading,
    String? error,
    bool? showResults,
  }) {
    return CalculatorState(
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showResults: showResults ?? this.showResults,
    );
  }
}

// Calculator screen state notifier
class CalculatorScreenStateNotifier extends StateNotifier<CalculatorState> {
  CalculatorScreenStateNotifier() : super(const CalculatorState());

  void setActiveTab(int index) {
    state = state.copyWith(activeTabIndex: index);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void showResults() {
    state = state.copyWith(showResults: true);
  }

  void hideResults() {
    state = state.copyWith(showResults: false);
  }
}

// Calculation history notifier
class CalculationHistoryNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  CalculationHistoryNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;

  Future<void> loadHistory({String userId = 'default_user'}) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(calculationRepositoryProvider);
      final result = await repository.getCalculationHistory(userId);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (history) => state = AsyncValue.data(history),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> saveCalculation({String userId = 'default_user'}) async {
    final parameters = _ref.read(loanParametersProvider);
    final emiCalculation = _ref.read(emiCalculationProvider);

    if (!emiCalculation.hasValue || emiCalculation.value == null) {
      return;
    }

    try {
      final repository = _ref.read(calculationRepositoryProvider);
      await repository.saveCalculation(
        parameters: parameters,
        result: emiCalculation.value!,
        userId: userId,
      );

      // Reload history after saving
      await loadHistory(userId: userId);
    } catch (e) {
      // Handle error silently for now
    }
  }

  void clearHistory() {
    state = const AsyncValue.data([]);
  }
}

// Providers
final loanParametersProvider =
    StateNotifierProvider<LoanParametersNotifier, domain.LoanParameters>((ref) {
      return LoanParametersNotifier();
    });

final emiCalculationProvider =
    StateNotifierProvider<EMICalculationNotifier, AsyncValue<EMIResult?>>((
      ref,
    ) {
      return EMICalculationNotifier(ref);
    });

final optimizationStrategiesProvider =
    StateNotifierProvider<
      OptimizationStrategiesNotifier,
      AsyncValue<List<OptimizationStrategy>>
    >((ref) {
      return OptimizationStrategiesNotifier(ref);
    });

final calculatorScreenStateProvider =
    StateNotifierProvider<CalculatorScreenStateNotifier, CalculatorState>((
      ref,
    ) {
      return CalculatorScreenStateNotifier();
    });

final calculationHistoryProvider =
    StateNotifierProvider<
      CalculationHistoryNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      return CalculationHistoryNotifier(ref);
    });

// Money-saving strategies notifier
class MoneySavingStrategiesNotifier
    extends StateNotifier<AsyncValue<List<PersonalizedStrategyResult>>> {
  MoneySavingStrategiesNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;

  Future<void> loadStrategies() async {
    final parameters = _ref.read(loanParametersProvider);
    final emiCalculation = _ref.read(emiCalculationProvider);

    // Wait for EMI calculation to complete
    if (!emiCalculation.hasValue || emiCalculation.value == null) {
      state = const AsyncValue.error(
        'EMI calculation required first',
        StackTrace.empty,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final useCase = _ref.read(getMoneySavingStrategiesUseCaseProvider);
      final result = await useCase(
        parameters: parameters,
        currentResult: emiCalculation.value!,
      );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearStrategies() {
    state = const AsyncValue.data([]);
  }
}

final moneySavingStrategiesProvider =
    StateNotifierProvider<
      MoneySavingStrategiesNotifier,
      AsyncValue<List<PersonalizedStrategyResult>>
    >((ref) {
      return MoneySavingStrategiesNotifier(ref);
    });

// Step EMI parameters notifier
class StepEMIParametersNotifier extends StateNotifier<StepEMIParameters> {
  StepEMIParametersNotifier() : super(StepEMIParameters.none());

  void updateParameters(StepEMIParameters parameters) {
    state = parameters;
  }

  void updateType(StepEMIType type) {
    switch (type) {
      case StepEMIType.none:
        state = StepEMIParameters.none();
        break;
      case StepEMIType.stepUp:
        state = StepEMIParameters.stepUp(
          stepPercentage: state.stepPercentage > 0 ? state.stepPercentage : 10.0,
          frequency: state.frequency,
        );
        break;
      case StepEMIType.stepDown:
        state = StepEMIParameters.stepDown(
          stepPercentage: state.stepPercentage > 0 ? state.stepPercentage : 10.0,
          frequency: state.frequency,
        );
        break;
    }
  }

  void updateStepPercentage(double percentage) {
    state = state.copyWith(stepPercentage: percentage);
  }

  void updateFrequency(StepFrequency frequency) {
    state = state.copyWith(frequency: frequency);
  }

  void reset() {
    state = StepEMIParameters.none();
  }
}

// Step EMI calculation notifier
class StepEMICalculationNotifier extends StateNotifier<AsyncValue<StepEMIResult?>> {
  StepEMICalculationNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> calculateStepEMI() async {
    final loanParameters = _ref.read(loanParametersProvider);
    final stepParameters = _ref.read(stepEMIParametersProvider);
    
    state = const AsyncValue.loading();

    try {
      final result = StepEMICalculationUtils.calculateStepEMI(
        principal: loanParameters.loanAmount,
        annualRate: loanParameters.interestRate,
        tenureYears: loanParameters.tenureYears,
        parameters: stepParameters,
      );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

// Combined EMI calculation notifier (includes step EMI)
class EnhancedEMICalculationNotifier extends StateNotifier<AsyncValue<EMIResult?>> {
  EnhancedEMICalculationNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> calculateEMI() async {
    final parameters = _ref.read(loanParametersProvider);
    final stepParameters = _ref.read(stepEMIParametersProvider);
    
    state = const AsyncValue.loading();

    try {
      final useCase = _ref.read(calculateEMIUseCaseProvider);
      final result = await useCase(parameters);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (emiResult) async {
          // Calculate step EMI if enabled
          EMIResult finalResult = emiResult;
          
          if (stepParameters.type != StepEMIType.none) {
            final stepResult = StepEMICalculationUtils.calculateStepEMI(
              principal: parameters.loanAmount,
              annualRate: parameters.interestRate,
              tenureYears: parameters.tenureYears,
              parameters: stepParameters,
            );

            // Update EMI result with step EMI details
            finalResult = EMIResult(
              monthlyEMI: stepResult.averageEMI,
              totalInterest: stepResult.totalInterest,
              totalAmount: stepResult.totalAmount,
              principalAmount: parameters.loanAmount,
              taxBenefits: emiResult.taxBenefits,
              pmayBenefit: emiResult.pmayBenefit,
              breakdown: emiResult.breakdown,
              stepEMIResult: stepResult,
            );
          }

          state = AsyncValue.data(finalResult);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

// Providers for step EMI
final stepEMIParametersProvider =
    StateNotifierProvider<StepEMIParametersNotifier, StepEMIParameters>((ref) {
      return StepEMIParametersNotifier();
    });

final stepEMICalculationProvider =
    StateNotifierProvider<StepEMICalculationNotifier, AsyncValue<StepEMIResult?>>((ref) {
      return StepEMICalculationNotifier(ref);
    });

final enhancedEMICalculationProvider =
    StateNotifierProvider<EnhancedEMICalculationNotifier, AsyncValue<EMIResult?>>((ref) {
      return EnhancedEMICalculationNotifier(ref);
    });

// Auto-calculate step EMI when parameters change
final autoStepEMICalculationProvider = Provider<AsyncValue<StepEMIResult?>>((ref) {
  final loanParameters = ref.watch(loanParametersProvider);
  final stepParameters = ref.watch(stepEMIParametersProvider);
  
  if (stepParameters.type == StepEMIType.none) {
    return const AsyncValue.data(null);
  }

  try {
    final result = StepEMICalculationUtils.calculateStepEMI(
      principal: loanParameters.loanAmount,
      annualRate: loanParameters.interestRate,
      tenureYears: loanParameters.tenureYears,
      parameters: stepParameters,
    );

    return AsyncValue.data(result);
  } catch (e, stackTrace) {
    return AsyncValue.error(e, stackTrace);
  }
});

// Provider for step EMI validation
final stepEMIValidationProvider = Provider<Map<String, String?>>((ref) {
  final stepParameters = ref.watch(stepEMIParametersProvider);
  final loanParameters = ref.watch(loanParametersProvider);

  return StepEMICalculationUtils.validateStepEMIParameters(
    parameters: stepParameters,
    loanAmount: loanParameters.loanAmount,
    tenureYears: loanParameters.tenureYears,
  );
});
