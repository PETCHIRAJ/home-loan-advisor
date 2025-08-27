import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/loan_model.dart';
import 'loan_provider.dart';

part 'chart_data_provider.g.dart';

/// Data models for chart visualization
class LoanChartData {
  final double principalAmount;
  final double interestAmount;
  final double totalAmount;
  final double principalPercentage;
  final double interestPercentage;

  const LoanChartData({
    required this.principalAmount,
    required this.interestAmount,
    required this.totalAmount,
    required this.principalPercentage,
    required this.interestPercentage,
  });
}

class TimelinePoint {
  final int month;
  final double remainingBalance;
  final double principalPaid;
  final double interestPaid;
  final double cumulativePrincipal;
  final double cumulativeInterest;

  const TimelinePoint({
    required this.month,
    required this.remainingBalance,
    required this.principalPaid,
    required this.interestPaid,
    required this.cumulativePrincipal,
    required this.cumulativeInterest,
  });
}

/// Provider for pie chart data showing principal vs interest breakdown
@riverpod
LoanChartData? pieChartData(PieChartDataRef ref) {
  final loanAsync = ref.watch(loanNotifierProvider);
  
  return loanAsync.whenOrNull(
    data: (loan) {
      final principal = loan.loanAmount;
      final interest = loan.totalInterest;
      final total = loan.totalAmount;
      
      if (total <= 0) return null;
      
      final principalPercentage = (principal / total) * 100;
      final interestPercentage = (interest / total) * 100;
      
      return LoanChartData(
        principalAmount: principal,
        interestAmount: interest,
        totalAmount: total,
        principalPercentage: principalPercentage,
        interestPercentage: interestPercentage,
      );
    },
  );
}

/// Provider for pie chart sections with proper styling
@riverpod
List<PieChartSectionData> pieChartSections(PieChartSectionsRef ref) {
  final chartData = ref.watch(pieChartDataProvider);
  
  if (chartData == null) return [];
  
  return [
    PieChartSectionData(
      color: const Color(0xFF1565C0), // Trust blue for principal
      value: chartData.principalAmount,
      title: '${chartData.principalPercentage.toStringAsFixed(1)}%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: const Color(0xFFFF6B35), // Warning orange for interest
      value: chartData.interestAmount,
      title: '${chartData.interestPercentage.toStringAsFixed(1)}%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];
}

/// Provider for timeline chart data showing loan balance over time
@riverpod
List<TimelinePoint> timelineData(TimelineDataRef ref) {
  final loanAsync = ref.watch(loanNotifierProvider);
  
  return loanAsync.whenOrNull(
    data: (loan) => _calculateTimelineData(loan),
  ) ?? [];
}

/// Provider for FL_Chart line chart data
@riverpod
List<FlSpot> timelineChartSpots(TimelineChartSpotsRef ref) {
  final timelinePoints = ref.watch(timelineDataProvider);
  
  return timelinePoints.asMap().entries.map((entry) {
    final month = entry.value.month;
    final balance = entry.value.remainingBalance;
    return FlSpot(month.toDouble(), balance);
  }).toList();
}

/// Provider for EMI breakdown chart data
@riverpod
Map<String, double> emiBreakdownData(EmiBreakdownDataRef ref) {
  final loanAsync = ref.watch(loanNotifierProvider);
  
  return loanAsync.whenOrNull(
    data: (loan) {
      if (loan.totalMonths <= 0) return {};
      
      // Calculate first month's breakdown
      final monthlyRate = loan.annualInterestRate / 12 / 100;
      final interestComponent = loan.loanAmount * monthlyRate;
      final principalComponent = loan.monthlyEMI - interestComponent;
      
      return {
        'Principal': principalComponent,
        'Interest': interestComponent,
        'Extra EMI': loan.extraEMIAmount,
      };
    },
  ) ?? {};
}

/// Provider for amortization schedule data (first 12 months for detailed view)
@riverpod
List<TimelinePoint> amortizationSchedule(AmortizationScheduleRef ref) {
  final timelinePoints = ref.watch(timelineDataProvider);
  
  // Return first 12 months for detailed monthly view
  return timelinePoints.take(12).toList();
}

/// Private function to calculate timeline data
List<TimelinePoint> _calculateTimelineData(LoanModel loan) {
  final List<TimelinePoint> points = [];
  
  if (loan.loanAmount <= 0 || loan.monthlyEMI <= 0) {
    return points;
  }
  
  double remainingBalance = loan.loanAmount;
  double cumulativePrincipal = 0.0;
  double cumulativeInterest = 0.0;
  final monthlyRate = loan.annualInterestRate / 12 / 100;
  
  for (int month = 0; month <= loan.totalMonths && remainingBalance > 0; month++) {
    if (month == 0) {
      // Initial state
      points.add(TimelinePoint(
        month: month,
        remainingBalance: remainingBalance,
        principalPaid: 0,
        interestPaid: 0,
        cumulativePrincipal: 0,
        cumulativeInterest: 0,
      ));
      continue;
    }
    
    final interestPayment = remainingBalance * monthlyRate;
    double principalPayment = loan.monthlyEMI - interestPayment;
    
    // Handle extra EMI payment
    if (loan.extraEMIAmount > 0) {
      principalPayment += loan.extraEMIAmount;
    }
    
    // Handle lump sum payment
    if (loan.lumpSumMonth == month && loan.lumpSumPayment > 0) {
      principalPayment += loan.lumpSumPayment;
    }
    
    // Ensure we don't overpay
    if (principalPayment > remainingBalance) {
      principalPayment = remainingBalance;
    }
    
    remainingBalance -= principalPayment;
    cumulativePrincipal += principalPayment;
    cumulativeInterest += interestPayment;
    
    points.add(TimelinePoint(
      month: month,
      remainingBalance: remainingBalance,
      principalPaid: principalPayment,
      interestPaid: interestPayment,
      cumulativePrincipal: cumulativePrincipal,
      cumulativeInterest: cumulativeInterest,
    ));
    
    // Stop if loan is fully paid
    if (remainingBalance <= 0) break;
  }
  
  return points;
}

/// Provider for break-even point (when principal payment > interest payment)
@riverpod
int? breakEvenMonth(BreakEvenMonthRef ref) {
  final timelinePoints = ref.watch(timelineDataProvider);
  
  for (final point in timelinePoints) {
    if (point.month > 0 && point.principalPaid > point.interestPaid) {
      return point.month;
    }
  }
  
  return null;
}

/// Provider for total savings with extra payments
@riverpod
double totalSavingsWithExtraPayments(TotalSavingsWithExtraPaymentsRef ref) {
  final loanAsync = ref.watch(loanNotifierProvider);
  
  return loanAsync.whenOrNull(
    data: (loan) {
      if (loan.extraEMIAmount <= 0 && loan.lumpSumPayment <= 0) {
        return 0.0;
      }
      
      // Calculate timeline with and without extra payments
      final normalLoan = loan.copyWith(
        extraEMIAmount: 0.0,
        lumpSumPayment: 0.0,
      );
      
      final normalInterest = normalLoan.totalInterest;
      final currentInterest = loan.totalInterest;
      
      return normalInterest - currentInterest;
    },
  ) ?? 0.0;
}