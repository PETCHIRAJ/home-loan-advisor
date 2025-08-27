// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pieChartDataHash() => r'4175eb6c53d2b9092fa7bfbeb9ad5e201c38d741';

/// Provider for pie chart data showing principal vs interest breakdown
///
/// Copied from [pieChartData].
@ProviderFor(pieChartData)
final pieChartDataProvider = AutoDisposeProvider<LoanChartData?>.internal(
  pieChartData,
  name: r'pieChartDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pieChartDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PieChartDataRef = AutoDisposeProviderRef<LoanChartData?>;
String _$pieChartSectionsHash() => r'30b1a908abeddc97a1a3adc7fd5fa10419be42f1';

/// Provider for pie chart sections with proper styling
///
/// Copied from [pieChartSections].
@ProviderFor(pieChartSections)
final pieChartSectionsProvider =
    AutoDisposeProvider<List<PieChartSectionData>>.internal(
  pieChartSections,
  name: r'pieChartSectionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pieChartSectionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PieChartSectionsRef = AutoDisposeProviderRef<List<PieChartSectionData>>;
String _$timelineDataHash() => r'11107b19c17acd64515bb58e7cca8dcaacd48f72';

/// Provider for timeline chart data showing loan balance over time
///
/// Copied from [timelineData].
@ProviderFor(timelineData)
final timelineDataProvider = AutoDisposeProvider<List<TimelinePoint>>.internal(
  timelineData,
  name: r'timelineDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timelineDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimelineDataRef = AutoDisposeProviderRef<List<TimelinePoint>>;
String _$timelineChartSpotsHash() =>
    r'73a91e006e635251bc86041d77fcaa7b14516354';

/// Provider for FL_Chart line chart data
///
/// Copied from [timelineChartSpots].
@ProviderFor(timelineChartSpots)
final timelineChartSpotsProvider = AutoDisposeProvider<List<FlSpot>>.internal(
  timelineChartSpots,
  name: r'timelineChartSpotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineChartSpotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimelineChartSpotsRef = AutoDisposeProviderRef<List<FlSpot>>;
String _$emiBreakdownDataHash() => r'1a5ed1fb151749c427896382903ad57b7f59bb41';

/// Provider for EMI breakdown chart data
///
/// Copied from [emiBreakdownData].
@ProviderFor(emiBreakdownData)
final emiBreakdownDataProvider =
    AutoDisposeProvider<Map<String, double>>.internal(
  emiBreakdownData,
  name: r'emiBreakdownDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emiBreakdownDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmiBreakdownDataRef = AutoDisposeProviderRef<Map<String, double>>;
String _$amortizationScheduleHash() =>
    r'151b83b8e25f91fadbf1070ee5a17c75d4a353e6';

/// Provider for amortization schedule data (first 12 months for detailed view)
///
/// Copied from [amortizationSchedule].
@ProviderFor(amortizationSchedule)
final amortizationScheduleProvider =
    AutoDisposeProvider<List<TimelinePoint>>.internal(
  amortizationSchedule,
  name: r'amortizationScheduleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$amortizationScheduleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AmortizationScheduleRef = AutoDisposeProviderRef<List<TimelinePoint>>;
String _$breakEvenMonthHash() => r'9e2fdb260851f1586ad543d799e8151952237a43';

/// Provider for break-even point (when principal payment > interest payment)
///
/// Copied from [breakEvenMonth].
@ProviderFor(breakEvenMonth)
final breakEvenMonthProvider = AutoDisposeProvider<int?>.internal(
  breakEvenMonth,
  name: r'breakEvenMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$breakEvenMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BreakEvenMonthRef = AutoDisposeProviderRef<int?>;
String _$totalSavingsWithExtraPaymentsHash() =>
    r'6011a2e1c912384298c89be1520e39b6bfeae282';

/// Provider for total savings with extra payments
///
/// Copied from [totalSavingsWithExtraPayments].
@ProviderFor(totalSavingsWithExtraPayments)
final totalSavingsWithExtraPaymentsProvider =
    AutoDisposeProvider<double>.internal(
  totalSavingsWithExtraPayments,
  name: r'totalSavingsWithExtraPaymentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalSavingsWithExtraPaymentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalSavingsWithExtraPaymentsRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
