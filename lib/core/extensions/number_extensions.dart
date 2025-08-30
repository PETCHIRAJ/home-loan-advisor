import 'package:intl/intl.dart';

extension NumberExtensions on double {
  /// Formats number in Indian format with lakhs and crores
  String toIndianFormat() {
    if (this >= 10000000) {
      return '₹${(this / 10000000).toStringAsFixed(2)} Cr';
    } else if (this >= 100000) {
      return '₹${(this / 100000).toStringAsFixed(2)} L';
    } else {
      final formatter = NumberFormat('#,##,###', 'hi_IN');
      return '₹${formatter.format(this)}';
    }
  }

  /// Formats as percentage
  String toPercentage({int decimals = 2}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Formats as EMI amount
  String toEMIFormat() {
    final formatter = NumberFormat('#,##,###', 'hi_IN');
    return '₹${formatter.format(this)}';
  }

  /// Formats as compact currency (for chart labels)
  String toCompactFormat() {
    if (this >= 10000000) {
      return '₹${(this / 10000000).toStringAsFixed(1)}Cr';
    } else if (this >= 100000) {
      return '₹${(this / 100000).toStringAsFixed(1)}L';
    } else if (this >= 1000) {
      return '₹${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${toStringAsFixed(0)}';
    }
  }

  /// Checks if number is in valid range
  bool isInRange(double min, double max) {
    return this >= min && this <= max;
  }
}

extension IntExtensions on int {
  /// Formats number in Indian format
  String toIndianFormat() {
    return toDouble().toIndianFormat();
  }

  /// Checks if age is valid for home loan
  bool isValidAge() {
    return this >= 18 && this <= 75;
  }

  /// Checks if tenure is valid
  bool isValidTenure() {
    return this >= 5 && this <= 30;
  }
}
