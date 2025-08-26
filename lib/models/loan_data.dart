class LoanData {
  final double loanAmount;
  final double interestRate;
  final int tenureYears;

  LoanData({
    required this.loanAmount,
    required this.interestRate,
    required this.tenureYears,
  });

  // Calculate monthly EMI
  double get monthlyEMI {
    final double monthlyRate = interestRate / (12 * 100);
    final int totalMonths = tenureYears * 12;
    
    if (monthlyRate == 0) return loanAmount / totalMonths;
    
    final double emi = (loanAmount * monthlyRate * 
        pow(1 + monthlyRate, totalMonths)) / 
        (pow(1 + monthlyRate, totalMonths) - 1);
    
    return emi;
  }

  // Calculate total interest
  double get totalInterest {
    return (monthlyEMI * tenureYears * 12) - loanAmount;
  }

  // Calculate daily interest burn
  double get dailyInterestBurn {
    return totalInterest / (tenureYears * 365);
  }

  // Calculate bi-weekly savings
  double get biWeeklySavings {
    final double biWeeklyPayment = monthlyEMI / 2;
    final double monthlyRate = interestRate / (12 * 100);
    
    // Simplified calculation for demonstration
    final double originalTotal = monthlyEMI * tenureYears * 12;
    final double biWeeklyTotal = biWeeklyPayment * 26 * tenureYears * 0.85; // Approximate reduction
    
    return originalTotal - biWeeklyTotal;
  }

  // Calculate extra EMI savings (one additional EMI per year)
  double get extraEMISavings {
    final double additionalPrincipal = monthlyEMI * tenureYears;
    final double interestSaved = additionalPrincipal * (interestRate / 100) * 0.6;
    return interestSaved;
  }

  // Calculate round-up savings
  double get roundUpSavings {
    final double roundedEMI = (monthlyEMI / 1000).ceil() * 1000;
    final double extraAmount = roundedEMI - monthlyEMI;
    final double totalExtra = extraAmount * tenureYears * 12;
    return totalExtra * 0.7; // Approximate interest savings
  }

  // Calculate loan completion percentage
  double getLoanCompletionPercentage(int monthsPaid) {
    final int totalMonths = tenureYears * 12;
    return (monthsPaid / totalMonths).clamp(0.0, 1.0);
  }

  // Get break-even point (when principal > outstanding)
  int get breakEvenMonth {
    return (tenureYears * 12 * 0.78).round(); // Based on 78% rule
  }
}

// Extension for currency formatting
extension CurrencyFormatter on double {
  String get toIndianCurrency {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String get toIndianCurrencyCompact {
    if (this >= 10000000) {
      return '₹${(this / 10000000).toStringAsFixed(1)}Cr';
    } else if (this >= 100000) {
      return '₹${(this / 100000).toStringAsFixed(1)}L';
    } else if (this >= 1000) {
      return '₹${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${this.toStringAsFixed(0)}';
    }
  }
}

import 'dart:math';
import 'package:intl/intl.dart';