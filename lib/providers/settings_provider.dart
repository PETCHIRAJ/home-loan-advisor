import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'loan_provider.dart';

part 'settings_provider.g.dart';

/// Settings model for app preferences
class AppSettings {
  final ThemeMode themeMode;
  final bool enableNotifications;
  final bool enableAnalytics;
  final bool showAdvancedFeatures;
  final String preferredCurrency;
  final bool enableAutoSave;
  final double textScaleFactor;
  final bool enableHapticFeedback;
  final bool showOnboarding;
  
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.enableNotifications = true,
    this.enableAnalytics = false,
    this.showAdvancedFeatures = false,
    this.preferredCurrency = 'INR',
    this.enableAutoSave = true,
    this.textScaleFactor = 1.0,
    this.enableHapticFeedback = true,
    this.showOnboarding = true,
  });
  
  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? enableNotifications,
    bool? enableAnalytics,
    bool? showAdvancedFeatures,
    String? preferredCurrency,
    bool? enableAutoSave,
    double? textScaleFactor,
    bool? enableHapticFeedback,
    bool? showOnboarding,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      showAdvancedFeatures: showAdvancedFeatures ?? this.showAdvancedFeatures,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      enableAutoSave: enableAutoSave ?? this.enableAutoSave,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'enableNotifications': enableNotifications,
      'enableAnalytics': enableAnalytics,
      'showAdvancedFeatures': showAdvancedFeatures,
      'preferredCurrency': preferredCurrency,
      'enableAutoSave': enableAutoSave,
      'textScaleFactor': textScaleFactor,
      'enableHapticFeedback': enableHapticFeedback,
      'showOnboarding': showOnboarding,
    };
  }
  
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
      enableNotifications: json['enableNotifications'] ?? true,
      enableAnalytics: json['enableAnalytics'] ?? false,
      showAdvancedFeatures: json['showAdvancedFeatures'] ?? false,
      preferredCurrency: json['preferredCurrency'] ?? 'INR',
      enableAutoSave: json['enableAutoSave'] ?? true,
      textScaleFactor: (json['textScaleFactor'] ?? 1.0).toDouble(),
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      showOnboarding: json['showOnboarding'] ?? true,
    );
  }
}

/// Settings provider with persistence
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const String _storageKey = 'app_settings';
  
  @override
  Future<AppSettings> build() async {
    // Load saved settings or use defaults
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final savedData = prefs.getString(_storageKey);
    
    if (savedData != null) {
      try {
        final json = Map<String, dynamic>.from(
          await compute(_parseJson, savedData)
        );
        return AppSettings.fromJson(json);
      } catch (e) {
        // If loading fails, fall back to defaults
        return const AppSettings();
      }
    }
    
    return const AppSettings();
  }
  
  /// Updates theme mode
  Future<void> updateThemeMode(ThemeMode mode) async {
    final current = await future;
    final updated = current.copyWith(themeMode: mode);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Toggles notifications
  Future<void> toggleNotifications(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(enableNotifications: enabled);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Toggles analytics
  Future<void> toggleAnalytics(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(enableAnalytics: enabled);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Toggles advanced features
  Future<void> toggleAdvancedFeatures(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(showAdvancedFeatures: enabled);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Updates currency preference
  Future<void> updateCurrency(String currency) async {
    final current = await future;
    final updated = current.copyWith(preferredCurrency: currency);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Toggles auto-save
  Future<void> toggleAutoSave(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(enableAutoSave: enabled);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Updates text scale factor for accessibility
  Future<void> updateTextScaleFactor(double factor) async {
    final current = await future;
    final updated = current.copyWith(textScaleFactor: factor);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Toggles haptic feedback
  Future<void> toggleHapticFeedback(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(enableHapticFeedback: enabled);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Marks onboarding as completed
  Future<void> completeOnboarding() async {
    final current = await future;
    final updated = current.copyWith(showOnboarding: false);
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
  
  /// Resets all settings to defaults
  Future<void> resetSettings() async {
    const defaultSettings = AppSettings();
    state = const AsyncData(defaultSettings);
    await _saveToStorage(defaultSettings);
  }
  
  /// Saves settings to local storage
  Future<void> _saveToStorage(AppSettings settings) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final json = await compute(_encodeJson, settings.toJson());
      await prefs.setString(_storageKey, json);
    } catch (e) {
      print('Failed to save settings: $e');
    }
  }
}

/// Helper functions for JSON parsing in isolate
Map<String, dynamic> _parseJson(String jsonString) {
  return Map<String, dynamic>.from(
    const JsonDecoder().convert(jsonString) as Map
  );
}

String _encodeJson(Map<String, dynamic> json) {
  return const JsonEncoder().convert(json);
}

/// Computed provider for current theme mode
@riverpod
ThemeMode currentThemeMode(CurrentThemeModeRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.themeMode,
  ) ?? ThemeMode.system;
}

/// Computed provider for notifications status
@riverpod
bool notificationsEnabled(NotificationsEnabledRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.enableNotifications,
  ) ?? true;
}

/// Computed provider for analytics status
@riverpod
bool analyticsEnabled(AnalyticsEnabledRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.enableAnalytics,
  ) ?? false;
}

/// Computed provider for advanced features status
@riverpod
bool advancedFeaturesEnabled(AdvancedFeaturesEnabledRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.showAdvancedFeatures,
  ) ?? false;
}

/// Computed provider for auto-save status
@riverpod
bool autoSaveEnabled(AutoSaveEnabledRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.enableAutoSave,
  ) ?? true;
}

/// Computed provider for haptic feedback status
@riverpod
bool hapticFeedbackEnabled(HapticFeedbackEnabledRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.enableHapticFeedback,
  ) ?? true;
}

/// Computed provider for onboarding status
@riverpod
bool shouldShowOnboarding(ShouldShowOnboardingRef ref) {
  return ref.watch(settingsNotifierProvider).whenOrNull(
    data: (settings) => settings.showOnboarding,
  ) ?? true;
}