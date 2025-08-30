import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/calculation_history.dart';
import '../../domain/entities/loan_parameters.dart';
import '../../domain/entities/emi_result.dart';
import '../../data/repositories/calculation_history_repository.dart';

part 'history_provider.g.dart';

/// SharedPreferences provider
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// Calculation history repository provider
@riverpod
CalculationHistoryRepository calculationHistoryRepository(
  Ref ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  if (prefs == null) {
    throw Exception('SharedPreferences not available');
  }
  return CalculationHistoryRepositoryImpl(prefs);
}

/// All calculation history provider
@riverpod
Future<List<CalculationHistory>> calculationHistory(Ref ref) async {
  final repository = ref.watch(calculationHistoryRepositoryProvider);
  final result = await repository.getAllHistory();
  
  return result.fold(
    (error) => throw Exception(error),
    (history) => history,
  );
}

/// History items provider (lighter weight for list display)
@riverpod
Future<List<HistoryItem>> historyItems(Ref ref) async {
  final repository = ref.watch(calculationHistoryRepositoryProvider);
  final result = await repository.getAllHistoryItems();
  
  return result.fold(
    (error) => throw Exception(error),
    (items) => items,
  );
}

/// Bookmarked history provider
@riverpod
Future<List<CalculationHistory>> bookmarkedHistory(Ref ref) async {
  final repository = ref.watch(calculationHistoryRepositoryProvider);
  final result = await repository.getBookmarkedHistory();
  
  return result.fold(
    (error) => throw Exception(error),
    (history) => history,
  );
}

/// History statistics provider
@riverpod
Future<HistoryStats> historyStats(Ref ref) async {
  final repository = ref.watch(calculationHistoryRepositoryProvider);
  final result = await repository.getHistoryStats();
  
  return result.fold(
    (error) => throw Exception(error),
    (stats) => stats,
  );
}

/// History filter state provider
@riverpod
class HistoryFilterNotifier extends _$HistoryFilterNotifier {
  @override
  HistoryFilterState build() {
    return const HistoryFilterState();
  }

  void updateFilter(HistoryFilter filter) {
    state = state.copyWith(currentFilter: filter);
  }

  void updateSortBy(HistorySortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void resetFilters() {
    state = const HistoryFilterState();
  }
}

/// History filter state class
class HistoryFilterState {
  final HistoryFilter currentFilter;
  final HistorySortBy sortBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;

  const HistoryFilterState({
    this.currentFilter = HistoryFilter.all,
    this.sortBy = HistorySortBy.dateNewest,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
  });

  HistoryFilterState copyWith({
    HistoryFilter? currentFilter,
    HistorySortBy? sortBy,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return HistoryFilterState(
      currentFilter: currentFilter ?? this.currentFilter,
      sortBy: sortBy ?? this.sortBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Filtered and sorted history provider
@riverpod
Future<List<HistoryItem>> filteredHistoryItems(Ref ref) async {
  final allItems = await ref.watch(historyItemsProvider.future);
  final filterState = ref.watch(historyFilterNotifierProvider);
  
  List<HistoryItem> filtered = [...allItems];
  
  // Apply filters
  switch (filterState.currentFilter) {
    case HistoryFilter.all:
      break;
    case HistoryFilter.bookmarked:
      filtered = filtered.where((item) => item.isBookmarked).toList();
      break;
    case HistoryFilter.today:
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      filtered = filtered.where((item) => 
        item.timestamp.isAfter(startOfDay) && item.timestamp.isBefore(endOfDay)
      ).toList();
      break;
    case HistoryFilter.thisWeek:
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered.where((item) => 
        item.timestamp.isAfter(startOfWeek.subtract(const Duration(days: 1)))
      ).toList();
      break;
    case HistoryFilter.thisMonth:
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      filtered = filtered.where((item) => 
        item.timestamp.isAfter(startOfMonth.subtract(const Duration(days: 1)))
      ).toList();
      break;
    case HistoryFilter.lastMonth:
      final now = DateTime.now();
      final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      final endOfLastMonth = DateTime(now.year, now.month, 1);
      filtered = filtered.where((item) => 
        item.timestamp.isAfter(startOfLastMonth.subtract(const Duration(days: 1))) &&
        item.timestamp.isBefore(endOfLastMonth)
      ).toList();
      break;
    case HistoryFilter.customRange:
      if (filterState.startDate != null && filterState.endDate != null) {
        filtered = filtered.where((item) => 
          item.timestamp.isAfter(filterState.startDate!.subtract(const Duration(days: 1))) &&
          item.timestamp.isBefore(filterState.endDate!.add(const Duration(days: 1)))
        ).toList();
      }
      break;
  }
  
  // Apply search query
  if (filterState.searchQuery.isNotEmpty) {
    final query = filterState.searchQuery.toLowerCase();
    filtered = filtered.where((item) {
      return (item.name?.toLowerCase().contains(query) ?? false) ||
             item.loanAmount.toString().contains(query) ||
             item.interestRate.toString().contains(query) ||
             item.tenureYears.toString().contains(query);
    }).toList();
  }
  
  // Apply sorting
  switch (filterState.sortBy) {
    case HistorySortBy.dateNewest:
      filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      break;
    case HistorySortBy.dateOldest:
      filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      break;
    case HistorySortBy.loanAmountHigh:
      filtered.sort((a, b) => b.loanAmount.compareTo(a.loanAmount));
      break;
    case HistorySortBy.loanAmountLow:
      filtered.sort((a, b) => a.loanAmount.compareTo(b.loanAmount));
      break;
    case HistorySortBy.emiHigh:
      filtered.sort((a, b) => b.monthlyEMI.compareTo(a.monthlyEMI));
      break;
    case HistorySortBy.emiLow:
      filtered.sort((a, b) => a.monthlyEMI.compareTo(b.monthlyEMI));
      break;
    case HistorySortBy.interestRateHigh:
      filtered.sort((a, b) => b.interestRate.compareTo(a.interestRate));
      break;
    case HistorySortBy.interestRateLow:
      filtered.sort((a, b) => a.interestRate.compareTo(b.interestRate));
      break;
  }
  
  return filtered;
}

/// Grouped history items by date for display
@riverpod
Future<Map<String, List<HistoryItem>>> groupedHistoryItems(Ref ref) async {
  final items = await ref.watch(filteredHistoryItemsProvider.future);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
  
  final grouped = <String, List<HistoryItem>>{};
  
  for (final item in items) {
    final itemDate = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
    
    String groupKey;
    if (itemDate == today) {
      groupKey = 'Today';
    } else if (itemDate == yesterday) {
      groupKey = 'Yesterday';
    } else if (itemDate.isAfter(thisWeekStart.subtract(const Duration(days: 1)))) {
      groupKey = 'This Week';
    } else {
      groupKey = 'Older';
    }
    
    grouped[groupKey] = [...(grouped[groupKey] ?? []), item];
  }
  
  return grouped;
}

/// History actions provider
@riverpod
class HistoryActions extends _$HistoryActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Save a new calculation to history
  Future<void> saveCalculation({
    required LoanParameters parameters,
    required EMIResult result,
    String? name,
    bool isBookmarked = false,
  }) async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final history = CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      parameters: parameters,
      result: result,
      name: name,
      isBookmarked: isBookmarked,
      metadata: {
        'version': '1.0',
        'source': 'calculator',
      },
    );
    
    final saveResult = await repository.saveHistory(history);
    
    saveResult.fold(
      (error) => throw Exception(error),
      (_) {
        // Invalidate providers to refresh the UI
        ref.invalidate(calculationHistoryProvider);
        ref.invalidate(historyItemsProvider);
        ref.invalidate(historyStatsProvider);
      },
    );
  }

  /// Update an existing history item
  Future<void> updateHistory(CalculationHistory history) async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final updateResult = await repository.updateHistory(history);
    
    updateResult.fold(
      (error) => throw Exception(error),
      (_) {
        // Invalidate providers to refresh the UI
        ref.invalidate(calculationHistoryProvider);
        ref.invalidate(historyItemsProvider);
        ref.invalidate(historyStatsProvider);
      },
    );
  }

  /// Delete a history item
  Future<void> deleteHistory(String id) async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final deleteResult = await repository.deleteHistory(id);
    
    deleteResult.fold(
      (error) => throw Exception(error),
      (_) {
        // Invalidate providers to refresh the UI
        ref.invalidate(calculationHistoryProvider);
        ref.invalidate(historyItemsProvider);
        ref.invalidate(historyStatsProvider);
      },
    );
  }

  /// Toggle bookmark status
  Future<void> toggleBookmark(String id) async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    // Get the current history item
    final historyResult = await repository.getHistoryById(id);
    
    await historyResult.fold(
      (error) => throw Exception(error),
      (history) async {
        if (history != null) {
          final updatedHistory = history.copyWith(
            isBookmarked: !history.isBookmarked,
          );
          await updateHistory(updatedHistory);
        }
      },
    );
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final clearResult = await repository.clearAllHistory();
    
    clearResult.fold(
      (error) => throw Exception(error),
      (_) {
        // Invalidate providers to refresh the UI
        ref.invalidate(calculationHistoryProvider);
        ref.invalidate(historyItemsProvider);
        ref.invalidate(historyStatsProvider);
      },
    );
  }

  /// Get history item by ID
  Future<CalculationHistory?> getHistoryById(String id) async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final result = await repository.getHistoryById(id);
    
    return result.fold(
      (error) => throw Exception(error),
      (history) => history,
    );
  }

  /// Export history as CSV
  Future<String> exportAsCSV() async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final result = await repository.exportHistoryAsCSV();
    
    return result.fold(
      (error) => throw Exception(error),
      (csv) => csv,
    );
  }

  /// Export history as text
  Future<String> exportAsText() async {
    final repository = ref.read(calculationHistoryRepositoryProvider);
    
    final result = await repository.exportHistoryAsText();
    
    return result.fold(
      (error) => throw Exception(error),
      (text) => text,
    );
  }
}