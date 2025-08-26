import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loan_model.dart';
import '../models/strategy_model.dart';
import 'loan_provider.dart';
import 'dart:convert';

part 'progress_provider.g.dart';

/// Loan progress tracking model
class LoanProgress {
  final DateTime startDate;
  final int monthsPaid;
  final double principalPaid;
  final double interestPaid;
  final double remainingPrincipal;
  final List<PaymentRecord> paymentHistory;
  final StrategyModel? activeStrategy;
  final double totalExtraPaid;
  final int savedMonths;
  final double savedInterest;
  
  const LoanProgress({
    required this.startDate,
    this.monthsPaid = 0,
    this.principalPaid = 0.0,
    this.interestPaid = 0.0,
    required this.remainingPrincipal,
    this.paymentHistory = const [],
    this.activeStrategy,
    this.totalExtraPaid = 0.0,
    this.savedMonths = 0,
    this.savedInterest = 0.0,
  });
  
  LoanProgress copyWith({
    DateTime? startDate,
    int? monthsPaid,
    double? principalPaid,
    double? interestPaid,
    double? remainingPrincipal,
    List<PaymentRecord>? paymentHistory,
    StrategyModel? activeStrategy,
    double? totalExtraPaid,
    int? savedMonths,
    double? savedInterest,
  }) {
    return LoanProgress(
      startDate: startDate ?? this.startDate,
      monthsPaid: monthsPaid ?? this.monthsPaid,
      principalPaid: principalPaid ?? this.principalPaid,
      interestPaid: interestPaid ?? this.interestPaid,
      remainingPrincipal: remainingPrincipal ?? this.remainingPrincipal,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      activeStrategy: activeStrategy ?? this.activeStrategy,
      totalExtraPaid: totalExtraPaid ?? this.totalExtraPaid,
      savedMonths: savedMonths ?? this.savedMonths,
      savedInterest: savedInterest ?? this.savedInterest,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'monthsPaid': monthsPaid,
      'principalPaid': principalPaid,
      'interestPaid': interestPaid,
      'remainingPrincipal': remainingPrincipal,
      'paymentHistory': paymentHistory.map((p) => p.toJson()).toList(),
      'activeStrategy': activeStrategy?.toJson(),
      'totalExtraPaid': totalExtraPaid,
      'savedMonths': savedMonths,
      'savedInterest': savedInterest,
    };
  }
  
  factory LoanProgress.fromJson(Map<String, dynamic> json) {
    return LoanProgress(
      startDate: DateTime.parse(json['startDate']),
      monthsPaid: json['monthsPaid'] ?? 0,
      principalPaid: (json['principalPaid'] ?? 0.0).toDouble(),
      interestPaid: (json['interestPaid'] ?? 0.0).toDouble(),
      remainingPrincipal: (json['remainingPrincipal']).toDouble(),
      paymentHistory: (json['paymentHistory'] as List?)
          ?.map((p) => PaymentRecord.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
      activeStrategy: json['activeStrategy'] != null
          ? StrategyModel.fromJson(json['activeStrategy'] as Map<String, dynamic>)
          : null,
      totalExtraPaid: (json['totalExtraPaid'] ?? 0.0).toDouble(),
      savedMonths: json['savedMonths'] ?? 0,
      savedInterest: (json['savedInterest'] ?? 0.0).toDouble(),
    );
  }
  
  /// Calculate completion percentage
  double get completionPercentage {
    final totalPrincipal = principalPaid + remainingPrincipal;
    if (totalPrincipal <= 0) return 0.0;
    return (principalPaid / totalPrincipal) * 100;
  }
  
  /// Check if loan is completed
  bool get isCompleted => remainingPrincipal <= 0;
  
  /// Calculate average monthly payment including extras
  double get averageMonthlyPayment {
    if (monthsPaid <= 0) return 0.0;
    return (principalPaid + interestPaid + totalExtraPaid) / monthsPaid;
  }
  
  /// Estimated remaining months based on current progress
  int get estimatedRemainingMonths {
    if (remainingPrincipal <= 0) return 0;
    
    final avgPayment = averageMonthlyPayment;
    if (avgPayment <= 0) return 0;
    
    // Simplified calculation - in practice would need amortization schedule
    return (remainingPrincipal / avgPayment).ceil();
  }
}

/// Individual payment record
class PaymentRecord {
  final DateTime date;
  final double emiAmount;
  final double principalComponent;
  final double interestComponent;
  final double extraPayment;
  final double remainingBalance;
  final String? notes;
  
  const PaymentRecord({
    required this.date,
    required this.emiAmount,
    required this.principalComponent,
    required this.interestComponent,
    this.extraPayment = 0.0,
    required this.remainingBalance,
    this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'emiAmount': emiAmount,
      'principalComponent': principalComponent,
      'interestComponent': interestComponent,
      'extraPayment': extraPayment,
      'remainingBalance': remainingBalance,
      'notes': notes,
    };
  }
  
  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      date: DateTime.parse(json['date']),
      emiAmount: (json['emiAmount']).toDouble(),
      principalComponent: (json['principalComponent']).toDouble(),
      interestComponent: (json['interestComponent']).toDouble(),
      extraPayment: (json['extraPayment'] ?? 0.0).toDouble(),
      remainingBalance: (json['remainingBalance']).toDouble(),
      notes: json['notes'],
    );
  }
}

/// Progress provider with loan tracking capabilities
@riverpod
class ProgressNotifier extends _$ProgressNotifier {
  static const String _storageKey = 'loan_progress';
  
  @override
  Future<LoanProgress?> build() async {
    // Load saved progress data
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final savedData = prefs.getString(_storageKey);
    
    if (savedData != null) {
      try {
        final json = jsonDecode(savedData) as Map<String, dynamic>;
        return LoanProgress.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }
  
  /// Initialize progress tracking for a new loan
  Future<void> initializeProgress(LoanModel loan) async {
    final progress = LoanProgress(
      startDate: loan.loanStartDate ?? DateTime.now(),
      remainingPrincipal: loan.loanAmount,
    );
    
    state = AsyncData(progress);
    await _saveToStorage(progress);
  }
  
  /// Add a new payment record
  Future<void> addPayment({
    required double emiAmount,
    required double principalComponent,
    required double interestComponent,
    double extraPayment = 0.0,
    String? notes,
  }) async {
    final current = await future;
    if (current == null) return;
    
    final newBalance = current.remainingPrincipal - principalComponent;
    
    final payment = PaymentRecord(
      date: DateTime.now(),
      emiAmount: emiAmount,
      principalComponent: principalComponent,
      interestComponent: interestComponent,
      extraPayment: extraPayment,
      remainingBalance: newBalance,
      notes: notes,
    );
    
    final updatedProgress = current.copyWith(
      monthsPaid: current.monthsPaid + 1,
      principalPaid: current.principalPaid + principalComponent,
      interestPaid: current.interestPaid + interestComponent,
      remainingPrincipal: newBalance,
      totalExtraPaid: current.totalExtraPaid + extraPayment,
      paymentHistory: [...current.paymentHistory, payment],
    );
    
    state = AsyncData(updatedProgress);
    await _saveToStorage(updatedProgress);
  }
  
  /// Set active strategy
  Future<void> setActiveStrategy(StrategyModel strategy) async {
    final current = await future;
    if (current == null) return;
    
    final updated = current.copyWith(activeStrategy: strategy);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Update savings from strategy
  Future<void> updateSavings({
    required int savedMonths,
    required double savedInterest,
  }) async {
    final current = await future;
    if (current == null) return;
    
    final updated = current.copyWith(
      savedMonths: savedMonths,
      savedInterest: savedInterest,
    );
    
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Clear all progress data
  Future<void> clearProgress() async {
    state = const AsyncData(null);
    
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Failed to clear progress data: $e');
    }
  }
  
  /// Save progress to storage
  Future<void> _saveToStorage(LoanProgress progress) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final json = progress.toJson();
      await prefs.setString(_storageKey, jsonEncode(json));
    } catch (e) {
      print('Failed to save progress: $e');
    }
  }
}

/// Computed provider for loan completion percentage
@riverpod
double loanCompletionPercentage(LoanCompletionPercentageRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.completionPercentage ?? 0.0,
  ) ?? 0.0;
}

/// Computed provider for months paid
@riverpod
int monthsPaid(MonthsPaidRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.monthsPaid ?? 0,
  ) ?? 0;
}

/// Computed provider for remaining balance
@riverpod
double remainingBalance(RemainingBalanceRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.remainingPrincipal ?? 0.0,
  ) ?? 0.0;
}

/// Computed provider for total interest paid
@riverpod
double totalInterestPaid(TotalInterestPaidRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.interestPaid ?? 0.0,
  ) ?? 0.0;
}

/// Computed provider for active strategy
@riverpod
StrategyModel? activeStrategy(ActiveStrategyRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.activeStrategy,
  );
}

/// Computed provider for total extra payments
@riverpod
double totalExtraPayments(TotalExtraPaymentsRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.totalExtraPaid ?? 0.0,
  ) ?? 0.0;
}

/// Computed provider for estimated remaining months
@riverpod
int estimatedRemainingMonths(EstimatedRemainingMonthsRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress?.estimatedRemainingMonths ?? 0,
  ) ?? 0;
}

/// Provider for checking if progress tracking is active
@riverpod
bool isProgressTrackingActive(IsProgressTrackingActiveRef ref) {
  return ref.watch(progressNotifierProvider).whenOrNull(
    data: (progress) => progress != null,
  ) ?? false;
}