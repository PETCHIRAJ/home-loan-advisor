// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'87f7c0811db991852c74d72376df550977c6d6db';

/// SharedPreferences instance provider for dependency injection
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
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
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$monthlyEMIHash() => r'7c48e3c218386176b879e3ebf9c0df7c4483ead5';

/// Computed provider for EMI calculation
///
/// Copied from [monthlyEMI].
@ProviderFor(monthlyEMI)
final monthlyEMIProvider = AutoDisposeProvider<double>.internal(
  monthlyEMI,
  name: r'monthlyEMIProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$monthlyEMIHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyEMIRef = AutoDisposeProviderRef<double>;
String _$totalAmountHash() => r'ab9c4041a637289a97a1bb10ea525b5e29baaaf0';

/// Computed provider for total amount
///
/// Copied from [totalAmount].
@ProviderFor(totalAmount)
final totalAmountProvider = AutoDisposeProvider<double>.internal(
  totalAmount,
  name: r'totalAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalAmountRef = AutoDisposeProviderRef<double>;
String _$totalInterestHash() => r'2d678fb8e69d071248f3c6c5bcd559ee07664a66';

/// Computed provider for total interest
///
/// Copied from [totalInterest].
@ProviderFor(totalInterest)
final totalInterestProvider = AutoDisposeProvider<double>.internal(
  totalInterest,
  name: r'totalInterestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalInterestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalInterestRef = AutoDisposeProviderRef<double>;
String _$isLoanAffordableHash() => r'd1ef26aaba68d23bf153717fc208b5b6060c7ac1';

/// Computed provider for loan affordability check
///
/// Copied from [isLoanAffordable].
@ProviderFor(isLoanAffordable)
final isLoanAffordableProvider = AutoDisposeProvider<bool>.internal(
  isLoanAffordable,
  name: r'isLoanAffordableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLoanAffordableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoanAffordableRef = AutoDisposeProviderRef<bool>;
String _$loanRiskLevelHash() => r'a9ece2b2ecb7700da6b60622f12feb31ff283d49';

/// Computed provider for loan risk level
///
/// Copied from [loanRiskLevel].
@ProviderFor(loanRiskLevel)
final loanRiskLevelProvider = AutoDisposeProvider<LoanRiskLevel>.internal(
  loanRiskLevel,
  name: r'loanRiskLevelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loanRiskLevelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoanRiskLevelRef = AutoDisposeProviderRef<LoanRiskLevel>;
String _$ltvRatioHash() => r'b9e80411fcb3d071c047e3a177d5ec9c6e8493e5';

/// Computed provider for LTV ratio
///
/// Copied from [ltvRatio].
@ProviderFor(ltvRatio)
final ltvRatioProvider = AutoDisposeProvider<double?>.internal(
  ltvRatio,
  name: r'ltvRatioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ltvRatioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LtvRatioRef = AutoDisposeProviderRef<double?>;
String _$emiToIncomeRatioHash() => r'907ae2ad87b2ac5cd1e75409e3d61852deb63ea7';

/// Computed provider for EMI-to-income ratio
///
/// Copied from [emiToIncomeRatio].
@ProviderFor(emiToIncomeRatio)
final emiToIncomeRatioProvider = AutoDisposeProvider<double?>.internal(
  emiToIncomeRatio,
  name: r'emiToIncomeRatioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emiToIncomeRatioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmiToIncomeRatioRef = AutoDisposeProviderRef<double?>;
String _$dailyInterestHash() => r'b5448e54586b0110257c112df6545c087e45f60e';

/// Computed provider for daily interest amount
///
/// Copied from [dailyInterest].
@ProviderFor(dailyInterest)
final dailyInterestProvider = AutoDisposeProvider<double>.internal(
  dailyInterest,
  name: r'dailyInterestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyInterestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyInterestRef = AutoDisposeProviderRef<double>;
String _$monthlyEMIWithExtraHash() =>
    r'1d56b735bf973665ed9c6e91fd8442eb25af1222';

/// Computed provider for EMI with extra payments
///
/// Copied from [monthlyEMIWithExtra].
@ProviderFor(monthlyEMIWithExtra)
final monthlyEMIWithExtraProvider = AutoDisposeProvider<double>.internal(
  monthlyEMIWithExtra,
  name: r'monthlyEMIWithExtraProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyEMIWithExtraHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyEMIWithExtraRef = AutoDisposeProviderRef<double>;
String _$isLoanValidHash() => r'10ae1562249a65af5fda512853556a8ad7d55387';

/// Provider for loan validation status
///
/// Copied from [isLoanValid].
@ProviderFor(isLoanValid)
final isLoanValidProvider = AutoDisposeProvider<bool>.internal(
  isLoanValid,
  name: r'isLoanValidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoanValidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoanValidRef = AutoDisposeProviderRef<bool>;
String _$loanNotifierHash() => r'2b27f5b9efd1a3b12eaa110ddef8c1ce76d3c1a2';

/// Core loan state provider with persistence
///
/// This provider manages the entire loan state including:
/// - Loan parameters (amount, rate, tenure)
/// - Calculated values (EMI, total interest, etc.)
/// - User preferences and settings
/// - Automatic persistence to local storage
///
/// Copied from [LoanNotifier].
@ProviderFor(LoanNotifier)
final loanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LoanNotifier, LoanModel>.internal(
  LoanNotifier.new,
  name: r'loanNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoanNotifier = AutoDisposeAsyncNotifier<LoanModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
