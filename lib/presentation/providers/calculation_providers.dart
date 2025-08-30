import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_parameters.dart' as domain;
import '../../domain/entities/emi_result.dart';
import '../../domain/entities/optimization_strategy.dart';
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
