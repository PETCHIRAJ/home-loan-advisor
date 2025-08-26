// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThemeModeHash() => r'09b2f3c92b42cd1e0f9423ee40a88a7894a41294';

/// Computed provider for current theme mode
///
/// Copied from [currentThemeMode].
@ProviderFor(currentThemeMode)
final currentThemeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  currentThemeMode,
  name: r'currentThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
String _$notificationsEnabledHash() =>
    r'a651678d733c0b6692c24b3a30393a349bac694f';

/// Computed provider for notifications status
///
/// Copied from [notificationsEnabled].
@ProviderFor(notificationsEnabled)
final notificationsEnabledProvider = AutoDisposeProvider<bool>.internal(
  notificationsEnabled,
  name: r'notificationsEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsEnabledRef = AutoDisposeProviderRef<bool>;
String _$analyticsEnabledHash() => r'683f3d8c79ec1e2e64ade2d17925b4cd3f6dc039';

/// Computed provider for analytics status
///
/// Copied from [analyticsEnabled].
@ProviderFor(analyticsEnabled)
final analyticsEnabledProvider = AutoDisposeProvider<bool>.internal(
  analyticsEnabled,
  name: r'analyticsEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsEnabledRef = AutoDisposeProviderRef<bool>;
String _$advancedFeaturesEnabledHash() =>
    r'05cba2409ec995b068af8d96ff0697b5ebc61880';

/// Computed provider for advanced features status
///
/// Copied from [advancedFeaturesEnabled].
@ProviderFor(advancedFeaturesEnabled)
final advancedFeaturesEnabledProvider = AutoDisposeProvider<bool>.internal(
  advancedFeaturesEnabled,
  name: r'advancedFeaturesEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advancedFeaturesEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvancedFeaturesEnabledRef = AutoDisposeProviderRef<bool>;
String _$autoSaveEnabledHash() => r'a8d3a2f7d313aa5a2a57af9035db1a9f30cfc1bd';

/// Computed provider for auto-save status
///
/// Copied from [autoSaveEnabled].
@ProviderFor(autoSaveEnabled)
final autoSaveEnabledProvider = AutoDisposeProvider<bool>.internal(
  autoSaveEnabled,
  name: r'autoSaveEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoSaveEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AutoSaveEnabledRef = AutoDisposeProviderRef<bool>;
String _$hapticFeedbackEnabledHash() =>
    r'ce88728125c7c19346b39b86564830958a91f206';

/// Computed provider for haptic feedback status
///
/// Copied from [hapticFeedbackEnabled].
@ProviderFor(hapticFeedbackEnabled)
final hapticFeedbackEnabledProvider = AutoDisposeProvider<bool>.internal(
  hapticFeedbackEnabled,
  name: r'hapticFeedbackEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hapticFeedbackEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HapticFeedbackEnabledRef = AutoDisposeProviderRef<bool>;
String _$shouldShowOnboardingHash() =>
    r'ba806167ca8d3fbc7baec5b71f744e917f628433';

/// Computed provider for onboarding status
///
/// Copied from [shouldShowOnboarding].
@ProviderFor(shouldShowOnboarding)
final shouldShowOnboardingProvider = AutoDisposeProvider<bool>.internal(
  shouldShowOnboarding,
  name: r'shouldShowOnboardingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldShowOnboardingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldShowOnboardingRef = AutoDisposeProviderRef<bool>;
String _$settingsNotifierHash() => r'3e9ae07e3415c576a408515de52d268d31834ff0';

/// Settings provider with persistence
///
/// Copied from [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingsNotifier, AppSettings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
