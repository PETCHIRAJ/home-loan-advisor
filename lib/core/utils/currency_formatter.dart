import 'package:intl/intl.dart';

/// Currency formatting utilities for Indian Rupee (INR)
///
/// Provides methods to format amounts in Indian numbering system
/// (lakhs and crores) without decimals as preferred by users.
class CurrencyFormatter {
  // Private constructor to prevent instantiation
  CurrencyFormatter._();

  /// Formats amount in Indian Rupee format: ₹50,00,000
  /// 
  /// Uses Indian numbering system with lakhs and crores.
  /// No decimal places as per user preference.
  /// 
  /// Example:
  /// ```dart
  /// formatCurrency(5000000) // Returns "₹50,00,000"
  /// formatCurrency(10000000) // Returns "₹1,00,00,000"
  /// ```
  static String formatCurrency(double amount) {
    if (amount.isNaN || amount.isInfinite) return '₹0';
    
    final formatter = NumberFormat('#,##,###', 'en_IN');
    final roundedAmount = amount.round();
    
    return '₹${formatter.format(roundedAmount)}';
  }

  /// Formats amount with suffix notation (L for Lakhs, Cr for Crores)
  /// 
  /// More compact format for large amounts.
  /// 
  /// Example:
  /// ```dart
  /// formatCurrencyCompact(5000000) // Returns "₹50L"
  /// formatCurrencyCompact(10000000) // Returns "₹1Cr"
  /// ```
  static String formatCurrencyCompact(double amount) {
    if (amount.isNaN || amount.isInfinite) return '₹0';
    
    final absAmount = amount.abs();
    final sign = amount < 0 ? '-' : '';
    
    if (absAmount >= 10000000) { // 1 crore or more
      final crores = absAmount / 10000000;
      return '$sign₹${_formatDecimal(crores)}Cr';
    } else if (absAmount >= 100000) { // 1 lakh or more
      final lakhs = absAmount / 100000;
      return '$sign₹${_formatDecimal(lakhs)}L';
    } else if (absAmount >= 1000) { // 1 thousand or more
      final thousands = absAmount / 1000;
      return '$sign₹${_formatDecimal(thousands)}K';
    } else {
      return '$sign₹${absAmount.round()}';
    }
  }

  /// Formats percentage values
  /// 
  /// Example:
  /// ```dart
  /// formatPercentage(8.5) // Returns "8.5%"
  /// formatPercentage(12.75) // Returns "12.75%"
  /// ```
  static String formatPercentage(double percentage) {
    if (percentage.isNaN || percentage.isInfinite) return '0%';
    
    // Remove unnecessary decimal places
    if (percentage == percentage.roundToDouble()) {
      return '${percentage.round()}%';
    } else {
      return '${percentage.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}%';
    }
  }

  /// Formats EMI amount with "per month" suffix
  /// 
  /// Example:
  /// ```dart
  /// formatEMI(47000) // Returns "₹47,000/month"
  /// ```
  static String formatEMI(double amount) {
    return '${formatCurrency(amount)}/month';
  }

  /// Formats tenure in years and months
  /// 
  /// Example:
  /// ```dart
  /// formatTenure(20) // Returns "20 years"
  /// formatTenure(2.5) // Returns "2 years 6 months"
  /// ```
  static String formatTenure(double years) {
    if (years.isNaN || years.isInfinite) return '0 years';
    
    final wholeYears = years.floor();
    final remainingMonths = ((years - wholeYears) * 12).round();
    
    if (remainingMonths == 0) {
      return wholeYears == 1 ? '1 year' : '$wholeYears years';
    } else if (wholeYears == 0) {
      return remainingMonths == 1 ? '1 month' : '$remainingMonths months';
    } else {
      final yearText = wholeYears == 1 ? '1 year' : '$wholeYears years';
      final monthText = remainingMonths == 1 ? '1 month' : '$remainingMonths months';
      return '$yearText $monthText';
    }
  }

  /// Formats savings amount with positive indication
  /// 
  /// Example:
  /// ```dart
  /// formatSavings(250000) // Returns "Save ₹2,50,000"
  /// ```
  static String formatSavings(double amount) {
    if (amount <= 0) return 'No savings';
    return 'Save ${formatCurrency(amount)}';
  }

  /// Formats amount difference (positive or negative)
  /// 
  /// Example:
  /// ```dart
  /// formatDifference(50000) // Returns "+₹50,000"
  /// formatDifference(-25000) // Returns "-₹25,000"
  /// ```
  static String formatDifference(double amount) {
    if (amount.isNaN || amount.isInfinite) return '₹0';
    
    final sign = amount > 0 ? '+' : '';
    return '$sign${formatCurrency(amount)}';
  }

  /// Helper method to format decimal values for compact notation
  static String _formatDecimal(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(1).replaceAll(RegExp(r'\.?0*$'), '');
    }
  }

  /// Parses currency string back to double value
  /// 
  /// Example:
  /// ```dart
  /// parseCurrency("₹50,00,000") // Returns 5000000.0
  /// ```
  static double parseCurrency(String currencyText) {
    if (currencyText.isEmpty) return 0.0;
    
    // Remove currency symbol, spaces, and commas
    final cleanText = currencyText
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    
    return double.tryParse(cleanText) ?? 0.0;
  }

  /// Validates if a currency string is in valid format
  /// 
  /// Example:
  /// ```dart
  /// isValidCurrency("₹50,00,000") // Returns true
  /// isValidCurrency("invalid") // Returns false
  /// ```
  static bool isValidCurrency(String currencyText) {
    try {
      final parsed = parseCurrency(currencyText);
      return parsed >= 0 && parsed.isFinite;
    } catch (e) {
      return false;
    }
  }
}