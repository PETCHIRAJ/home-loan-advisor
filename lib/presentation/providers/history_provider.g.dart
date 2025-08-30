// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'dc403fbb1d968c7d5ab4ae1721a29ffe173701c7';

/// SharedPreferences provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
      sharedPreferences,
      name: r'sharedPreferencesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sharedPreferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$calculationHistoryRepositoryHash() =>
    r'2d55416ee0eb4e5f81e840222aafb6ee805ddbb0';

/// Calculation history repository provider
///
/// Copied from [calculationHistoryRepository].
@ProviderFor(calculationHistoryRepository)
final calculationHistoryRepositoryProvider =
    AutoDisposeProvider<CalculationHistoryRepository>.internal(
      calculationHistoryRepository,
      name: r'calculationHistoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calculationHistoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculationHistoryRepositoryRef =
    AutoDisposeProviderRef<CalculationHistoryRepository>;
String _$calculationHistoryHash() =>
    r'0673f3c2d35684baf966acc604247ae4232c007d';

/// All calculation history provider
///
/// Copied from [calculationHistory].
@ProviderFor(calculationHistory)
final calculationHistoryProvider =
    AutoDisposeFutureProvider<List<CalculationHistory>>.internal(
      calculationHistory,
      name: r'calculationHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calculationHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculationHistoryRef =
    AutoDisposeFutureProviderRef<List<CalculationHistory>>;
String _$historyItemsHash() => r'2ad2041172bd99d4847a116ada5af8cca74f014e';

/// History items provider (lighter weight for list display)
///
/// Copied from [historyItems].
@ProviderFor(historyItems)
final historyItemsProvider =
    AutoDisposeFutureProvider<List<HistoryItem>>.internal(
      historyItems,
      name: r'historyItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoryItemsRef = AutoDisposeFutureProviderRef<List<HistoryItem>>;
String _$bookmarkedHistoryHash() => r'3513e21ecbe5bb9f6cf2a56c2c75d447df25a3c0';

/// Bookmarked history provider
///
/// Copied from [bookmarkedHistory].
@ProviderFor(bookmarkedHistory)
final bookmarkedHistoryProvider =
    AutoDisposeFutureProvider<List<CalculationHistory>>.internal(
      bookmarkedHistory,
      name: r'bookmarkedHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookmarkedHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookmarkedHistoryRef =
    AutoDisposeFutureProviderRef<List<CalculationHistory>>;
String _$historyStatsHash() => r'9d2ab0b722850cc828951ed5cbd5a1b28c9f2965';

/// History statistics provider
///
/// Copied from [historyStats].
@ProviderFor(historyStats)
final historyStatsProvider = AutoDisposeFutureProvider<HistoryStats>.internal(
  historyStats,
  name: r'historyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$historyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoryStatsRef = AutoDisposeFutureProviderRef<HistoryStats>;
String _$filteredHistoryItemsHash() =>
    r'd136fcff0e221b40c4a96b7437ef95ceeb64ad8c';

/// Filtered and sorted history provider
///
/// Copied from [filteredHistoryItems].
@ProviderFor(filteredHistoryItems)
final filteredHistoryItemsProvider =
    AutoDisposeFutureProvider<List<HistoryItem>>.internal(
      filteredHistoryItems,
      name: r'filteredHistoryItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredHistoryItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredHistoryItemsRef =
    AutoDisposeFutureProviderRef<List<HistoryItem>>;
String _$groupedHistoryItemsHash() =>
    r'395cd3e71d1176aa91eba57d2d4a9ef6e6c35407';

/// Grouped history items by date for display
///
/// Copied from [groupedHistoryItems].
@ProviderFor(groupedHistoryItems)
final groupedHistoryItemsProvider =
    AutoDisposeFutureProvider<Map<String, List<HistoryItem>>>.internal(
      groupedHistoryItems,
      name: r'groupedHistoryItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupedHistoryItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedHistoryItemsRef =
    AutoDisposeFutureProviderRef<Map<String, List<HistoryItem>>>;
String _$historyFilterNotifierHash() =>
    r'20f0069fae9bbf04ac5059b1b231821a149e3701';

/// History filter state provider
///
/// Copied from [HistoryFilterNotifier].
@ProviderFor(HistoryFilterNotifier)
final historyFilterNotifierProvider =
    AutoDisposeNotifierProvider<
      HistoryFilterNotifier,
      HistoryFilterState
    >.internal(
      HistoryFilterNotifier.new,
      name: r'historyFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HistoryFilterNotifier = AutoDisposeNotifier<HistoryFilterState>;
String _$historyActionsHash() => r'ed99e9eeb526a67b4fd659757ea281ad9e32abc0';

/// History actions provider
///
/// Copied from [HistoryActions].
@ProviderFor(HistoryActions)
final historyActionsProvider =
    AutoDisposeNotifierProvider<HistoryActions, void>.internal(
      HistoryActions.new,
      name: r'historyActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HistoryActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
