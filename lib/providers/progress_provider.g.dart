// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loanCompletionPercentageHash() =>
    r'80846169f336eb99e30b40330a1a301b9fef8adf';

/// Computed provider for loan completion percentage
///
/// Copied from [loanCompletionPercentage].
@ProviderFor(loanCompletionPercentage)
final loanCompletionPercentageProvider = AutoDisposeProvider<double>.internal(
  loanCompletionPercentage,
  name: r'loanCompletionPercentageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loanCompletionPercentageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoanCompletionPercentageRef = AutoDisposeProviderRef<double>;
String _$monthsPaidHash() => r'12d9978b2a561f15dd46cd37cccf3fe81bf4a5d7';

/// Computed provider for months paid
///
/// Copied from [monthsPaid].
@ProviderFor(monthsPaid)
final monthsPaidProvider = AutoDisposeProvider<int>.internal(
  monthsPaid,
  name: r'monthsPaidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$monthsPaidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthsPaidRef = AutoDisposeProviderRef<int>;
String _$remainingBalanceHash() => r'e307ac8ac259c3c0f5239db5dfc97e01cfce0aec';

/// Computed provider for remaining balance
///
/// Copied from [remainingBalance].
@ProviderFor(remainingBalance)
final remainingBalanceProvider = AutoDisposeProvider<double>.internal(
  remainingBalance,
  name: r'remainingBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remainingBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemainingBalanceRef = AutoDisposeProviderRef<double>;
String _$totalInterestPaidHash() => r'248c15341528f171eba79f8046474f2612648b07';

/// Computed provider for total interest paid
///
/// Copied from [totalInterestPaid].
@ProviderFor(totalInterestPaid)
final totalInterestPaidProvider = AutoDisposeProvider<double>.internal(
  totalInterestPaid,
  name: r'totalInterestPaidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalInterestPaidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalInterestPaidRef = AutoDisposeProviderRef<double>;
String _$activeStrategyHash() => r'a97386266e5e828a5eb9ac40c665e721ea37ce3b';

/// Computed provider for active strategy
///
/// Copied from [activeStrategy].
@ProviderFor(activeStrategy)
final activeStrategyProvider = AutoDisposeProvider<StrategyModel?>.internal(
  activeStrategy,
  name: r'activeStrategyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeStrategyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveStrategyRef = AutoDisposeProviderRef<StrategyModel?>;
String _$totalExtraPaymentsHash() =>
    r'a74887c7527073dfb2cddea664791e8a8e993846';

/// Computed provider for total extra payments
///
/// Copied from [totalExtraPayments].
@ProviderFor(totalExtraPayments)
final totalExtraPaymentsProvider = AutoDisposeProvider<double>.internal(
  totalExtraPayments,
  name: r'totalExtraPaymentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalExtraPaymentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalExtraPaymentsRef = AutoDisposeProviderRef<double>;
String _$estimatedRemainingMonthsHash() =>
    r'22f75e63822f65c82997a1081b3fa3aeaa460f7b';

/// Computed provider for estimated remaining months
///
/// Copied from [estimatedRemainingMonths].
@ProviderFor(estimatedRemainingMonths)
final estimatedRemainingMonthsProvider = AutoDisposeProvider<int>.internal(
  estimatedRemainingMonths,
  name: r'estimatedRemainingMonthsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$estimatedRemainingMonthsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EstimatedRemainingMonthsRef = AutoDisposeProviderRef<int>;
String _$isProgressTrackingActiveHash() =>
    r'1ec81a18c9504dadc9ff5d9200f483ee7fe8f709';

/// Provider for checking if progress tracking is active
///
/// Copied from [isProgressTrackingActive].
@ProviderFor(isProgressTrackingActive)
final isProgressTrackingActiveProvider = AutoDisposeProvider<bool>.internal(
  isProgressTrackingActive,
  name: r'isProgressTrackingActiveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProgressTrackingActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProgressTrackingActiveRef = AutoDisposeProviderRef<bool>;
String _$progressNotifierHash() => r'abc49ab5d971d4be0a7a6d392010d349363bf096';

/// Progress provider with loan tracking capabilities
///
/// Copied from [ProgressNotifier].
@ProviderFor(ProgressNotifier)
final progressNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProgressNotifier, LoanProgress?>.internal(
  ProgressNotifier.new,
  name: r'progressNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$progressNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgressNotifier = AutoDisposeAsyncNotifier<LoanProgress?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
