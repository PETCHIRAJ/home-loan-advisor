import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> loadMarketData();
  Future<void> saveCalculationHistory(Map<String, dynamic> calculation);
  Future<List<Map<String, dynamic>>> getCalculationHistory();
  Future<void> cacheMarketData(String data);
  Future<String?> getCachedMarketData();
  Future<bool> isCacheValid();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _prefs;
  static const String _marketDataKey = 'market_data';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _calculationHistoryKey = 'calculation_history';
  static const int _cacheValidityHours = 24; // Cache valid for 24 hours

  LocalDataSourceImpl(this._prefs);

  @override
  Future<String> loadMarketData() async {
    try {
      // Try to get cached data first
      final cachedData = await getCachedMarketData();
      final isCacheValidResult = await isCacheValid();

      if (cachedData != null && isCacheValidResult) {
        return cachedData;
      }

      // Load from assets if cache is invalid or empty
      final String jsonString = await rootBundle.loadString(
        'data/current-market-data.json',
      );

      // Cache the fresh data
      await cacheMarketData(jsonString);

      return jsonString;
    } catch (e) {
      throw Exception('Failed to load market data: $e');
    }
  }

  @override
  Future<void> saveCalculationHistory(Map<String, dynamic> calculation) async {
    try {
      final history = await getCalculationHistory();

      // Add timestamp
      calculation['timestamp'] = DateTime.now().toIso8601String();

      // Add to beginning of list (latest first)
      history.insert(0, calculation);

      // Keep only last 50 calculations
      if (history.length > 50) {
        history.removeRange(50, history.length);
      }

      final jsonString = jsonEncode(history);
      await _prefs.setString(_calculationHistoryKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save calculation history: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCalculationHistory() async {
    try {
      final historyString = _prefs.getString(_calculationHistoryKey);

      if (historyString == null) {
        return [];
      }

      final List<dynamic> historyList = jsonDecode(historyString);
      return historyList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      // Return empty list if there's an error reading history
      return [];
    }
  }

  @override
  Future<void> cacheMarketData(String data) async {
    try {
      await _prefs.setString(_marketDataKey, data);
      await _prefs.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Failed to cache market data: $e');
    }
  }

  @override
  Future<String?> getCachedMarketData() async {
    try {
      return _prefs.getString(_marketDataKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _prefs.getInt(_cacheTimestampKey);

      if (timestamp == null) {
        return false;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference.inHours < _cacheValidityHours;
    } catch (e) {
      return false;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      await _prefs.remove(_marketDataKey);
      await _prefs.remove(_cacheTimestampKey);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  /// Clear calculation history
  Future<void> clearCalculationHistory() async {
    try {
      await _prefs.remove(_calculationHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear calculation history: $e');
    }
  }
}
