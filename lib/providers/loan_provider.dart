import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loan_model.dart';
import 'dart:convert';

part 'loan_provider.g.dart';

/// SharedPreferences instance provider for dependency injection
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

/// Core loan state provider with persistence
///
/// This provider manages the entire loan state including:
/// - Loan parameters (amount, rate, tenure)
/// - Calculated values (EMI, total interest, etc.)
/// - User preferences and settings
/// - Automatic persistence to local storage
@riverpod
class LoanNotifier extends _$LoanNotifier {
  static const String _storageKey = 'loan_data';
  
  @override
  Future<LoanModel> build() async {
    // Load saved loan data or use initial values
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final savedData = prefs.getString(_storageKey);
    
    if (savedData != null) {
      try {
        final json = jsonDecode(savedData) as Map<String, dynamic>;
        return LoanModel.fromJson(json).withUpdatedCalculations();
      } catch (e) {
        // If loading fails, fall back to initial values
        return LoanModel.initial();
      }
    }
    
    return LoanModel.initial();
  }
  
  /// Updates loan parameters and automatically saves to storage
  Future<void> updateLoan(LoanModel newLoan) async {
    final updatedLoan = newLoan.copyWith(
      isModified: true,
      lastCalculated: DateTime.now(),
    );
    
    state = AsyncData(updatedLoan);
    await _saveToStorage(updatedLoan);
  }
  
  /// Updates only the loan amount
  Future<void> updateLoanAmount(double amount) async {
    final current = await future;
    await updateLoan(current.copyWith(loanAmount: amount));
  }
  
  /// Updates only the interest rate
  Future<void> updateInterestRate(double rate) async {
    final current = await future;
    await updateLoan(current.copyWith(annualInterestRate: rate));
  }
  
  /// Updates only the tenure
  Future<void> updateTenure(int years) async {
    final current = await future;
    await updateLoan(current.copyWith(tenureYears: years));
  }
  
  /// Updates extra EMI amount for prepayment strategies
  Future<void> updateExtraEMI(double extraAmount) async {
    final current = await future;
    await updateLoan(current.copyWith(extraEMIAmount: extraAmount));
  }
  
  /// Updates lump sum payment details
  Future<void> updateLumpSum(double amount, int month) async {
    final current = await future;
    await updateLoan(current.copyWith(
      lumpSumPayment: amount,
      lumpSumMonth: month,
    ));
  }
  
  /// Updates optional fields (property value, income, etc.)
  Future<void> updateOptionalFields({
    double? propertyValue,
    double? monthlyIncome,
    double? processingFee,
    double? insurancePremium,
    String? bankName,
  }) async {
    final current = await future;
    await updateLoan(current.copyWith(
      propertyValue: propertyValue,
      monthlyIncome: monthlyIncome,
      processingFee: processingFee ?? current.processingFee,
      insurancePremium: insurancePremium,
      bankName: bankName,
    ));
  }
  
  /// Resets loan to initial/default values
  Future<void> resetLoan() async {
    await updateLoan(LoanModel.initial());
  }
  
  /// Loads demo loan data for testing
  Future<void> loadDemoData() async {
    await updateLoan(LoanModel.demo());
  }
  
  /// Saves loan data to local storage
  Future<void> _saveToStorage(LoanModel loan) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final json = loan.toJson();
      await prefs.setString(_storageKey, jsonEncode(json));
    } catch (e) {
      // Handle storage errors gracefully
      print('Failed to save loan data: $e');
    }
  }
  
  /// Clears all saved data
  Future<void> clearSavedData() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.remove(_storageKey);
      state = AsyncData(LoanModel.initial());
    } catch (e) {
      print('Failed to clear saved data: $e');
    }
  }
}

/// Computed provider for EMI calculation
@riverpod
double monthlyEMI(MonthlyEMIRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.monthlyEMI,
  ) ?? 0.0;
}

/// Computed provider for total amount
@riverpod
double totalAmount(TotalAmountRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.totalAmount,
  ) ?? 0.0;
}

/// Computed provider for total interest
@riverpod
double totalInterest(TotalInterestRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.totalInterest,
  ) ?? 0.0;
}

/// Computed provider for loan affordability check
@riverpod
bool isLoanAffordable(IsLoanAffordableRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.isAffordable,
  ) ?? true;
}

/// Computed provider for loan risk level
@riverpod
LoanRiskLevel loanRiskLevel(LoanRiskLevelRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.riskLevel,
  ) ?? LoanRiskLevel.low;
}

/// Computed provider for LTV ratio
@riverpod
double? ltvRatio(LtvRatioRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.ltvRatio,
  );
}

/// Computed provider for EMI-to-income ratio
@riverpod
double? emiToIncomeRatio(EmiToIncomeRatioRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.emiToIncomeRatio,
  );
}

/// Computed provider for daily interest amount
@riverpod
double dailyInterest(DailyInterestRef ref) {
  final loan = ref.watch(loanNotifierProvider).valueOrNull;
  if (loan == null) return 0.0;
  
  // Calculate daily interest based on reducing balance
  final monthlyRate = loan.annualInterestRate / 12 / 100;
  final dailyRate = monthlyRate / 30; // Approximate daily rate
  
  return loan.loanAmount * dailyRate;
}

/// Computed provider for EMI with extra payments
@riverpod
double monthlyEMIWithExtra(MonthlyEMIWithExtraRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.monthlyEMIWithExtra,
  ) ?? 0.0;
}

/// Provider for loan validation status
@riverpod
bool isLoanValid(IsLoanValidRef ref) {
  return ref.watch(loanNotifierProvider).whenOrNull(
    data: (loan) => loan.isValid,
  ) ?? false;
}