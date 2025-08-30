import 'dart:math';
import '../../domain/entities/prepayment_result.dart';
import '../../domain/entities/loan_parameters.dart';
import '../../domain/entities/emi_result.dart';
import 'calculation_utils.dart';

/// Comprehensive prepayment calculation utilities
class PrepaymentCalculationUtils {
  /// Calculate prepayment scenario result
  static PrepaymentResult calculatePrepaymentResult({
    required PrepaymentScenario scenario,
    required LoanParameters loanParams,
    required EMIResult originalEMI,
  }) {
    // Generate prepayment schedule based on scenario type
    final schedule = _generatePrepaymentSchedule(scenario, loanParams);

    // Calculate loan comparison
    final comparison = _calculateLoanComparison(
      scenario,
      loanParams,
      originalEMI,
      schedule,
    );

    // Generate balance progression
    final balanceProgression = _calculateBalanceProgression(
      loanParams,
      originalEMI,
      schedule,
      comparison.newTenureMonths,
    );

    // Calculate breakdown
    final breakdown = PrepaymentBreakdown(
      totalPrepaymentAmount: schedule.fold(0.0, (sum, p) => sum + p.amount),
      schedule: schedule,
      balanceProgression: balanceProgression,
    );

    // Calculate benefits and ROI
    final benefits = _calculatePrepaymentBenefits(
      scenario,
      comparison,
      breakdown,
      loanParams,
    );

    return PrepaymentResult(
      scenario: scenario,
      comparison: comparison,
      breakdown: breakdown,
      benefits: benefits,
    );
  }

  /// Generate prepayment schedule based on scenario type
  static List<PrepaymentSchedule> _generatePrepaymentSchedule(
    PrepaymentScenario scenario,
    LoanParameters loanParams,
  ) {
    final List<PrepaymentSchedule> schedule = [];
    final totalMonths = loanParams.tenureYears * 12;
    final monthlyEMI = CalculationUtils.calculateEMI(
      principal: loanParams.loanAmount,
      annualRate: loanParams.interestRate,
      tenureYears: loanParams.tenureYears,
    );

    double outstandingBalance = loanParams.loanAmount;
    final monthlyRate = loanParams.interestRate / 100 / 12;

    switch (scenario.type) {
      case PrepaymentType.oneTime:
        // Single prepayment at specified month
        final prepaymentMonth =
            (scenario.startYear - 1) * 12 + scenario.startMonth;

        for (
          int month = 1;
          month <= min(prepaymentMonth, totalMonths);
          month++
        ) {
          final interestPayment = outstandingBalance * monthlyRate;
          final principalPayment = monthlyEMI - interestPayment;
          outstandingBalance -= principalPayment;

          if (month == prepaymentMonth && outstandingBalance > 0) {
            final prepaymentAmount = min(scenario.amount, outstandingBalance);
            schedule.add(
              PrepaymentSchedule(
                month: month,
                amount: prepaymentAmount,
                outstandingBeforePrepayment: outstandingBalance,
                outstandingAfterPrepayment:
                    outstandingBalance - prepaymentAmount,
              ),
            );
            outstandingBalance -= prepaymentAmount;
          }
        }
        break;

      case PrepaymentType.recurring:
        final startMonth = (scenario.startYear - 1) * 12 + scenario.startMonth;
        int frequencyMonths;

        switch (scenario.frequency) {
          case PrepaymentFrequency.monthly:
            frequencyMonths = 1;
            break;
          case PrepaymentFrequency.quarterly:
            frequencyMonths = 3;
            break;
          case PrepaymentFrequency.yearly:
            frequencyMonths = 12;
            break;
        }

        for (int month = 1; month <= totalMonths; month++) {
          final interestPayment = outstandingBalance * monthlyRate;
          final principalPayment = monthlyEMI - interestPayment;
          outstandingBalance -= principalPayment;

          if (month >= startMonth &&
              (month - startMonth) % frequencyMonths == 0 &&
              outstandingBalance > 0) {
            final prepaymentAmount = min(scenario.amount, outstandingBalance);
            schedule.add(
              PrepaymentSchedule(
                month: month,
                amount: prepaymentAmount,
                outstandingBeforePrepayment: outstandingBalance,
                outstandingAfterPrepayment:
                    outstandingBalance - prepaymentAmount,
              ),
            );
            outstandingBalance -= prepaymentAmount;
          }
        }
        break;

      case PrepaymentType.extraEMI:
        final extraEMIsPerYear = scenario.extraEMIsPerYear ?? 1;
        final monthsPerExtraEMI = 12 ~/ extraEMIsPerYear;

        for (int month = 1; month <= totalMonths; month++) {
          final interestPayment = outstandingBalance * monthlyRate;
          final principalPayment = monthlyEMI - interestPayment;
          outstandingBalance -= principalPayment;

          if (month % monthsPerExtraEMI == 0 && outstandingBalance > 0) {
            final prepaymentAmount = min(monthlyEMI, outstandingBalance);
            schedule.add(
              PrepaymentSchedule(
                month: month,
                amount: prepaymentAmount,
                outstandingBeforePrepayment: outstandingBalance,
                outstandingAfterPrepayment:
                    outstandingBalance - prepaymentAmount,
              ),
            );
            outstandingBalance -= prepaymentAmount;
          }
        }
        break;
    }

    return schedule;
  }

  /// Calculate comparison between original and prepayment scenarios
  static LoanComparison _calculateLoanComparison(
    PrepaymentScenario scenario,
    LoanParameters loanParams,
    EMIResult originalEMI,
    List<PrepaymentSchedule> schedule,
  ) {
    final originalTenureMonths = loanParams.tenureYears * 12;
    final monthlyEMI = originalEMI.monthlyEMI;

    // Calculate new tenure and total amounts with prepayments
    final newTenureMonths = _calculateNewTenure(
      loanParams,
      monthlyEMI,
      schedule,
    );

    final totalPrepaymentAmount = schedule.fold(
      0.0,
      (sum, p) => sum + p.amount,
    );

    // New total amount = EMI * new tenure + total prepayments
    final newTotalAmount = monthlyEMI * newTenureMonths + totalPrepaymentAmount;
    final newTotalInterest =
        newTotalAmount - loanParams.loanAmount - totalPrepaymentAmount;

    return LoanComparison(
      originalEMI: originalEMI.monthlyEMI,
      newEMI: originalEMI.monthlyEMI, // EMI stays same, tenure reduces
      originalTenureMonths: originalTenureMonths,
      newTenureMonths: newTenureMonths,
      originalTotalInterest: originalEMI.totalInterest,
      newTotalInterest: newTotalInterest,
      originalTotalAmount: originalEMI.totalAmount,
      newTotalAmount: newTotalAmount,
    );
  }

  /// Calculate new tenure with prepayments
  static int _calculateNewTenure(
    LoanParameters loanParams,
    double monthlyEMI,
    List<PrepaymentSchedule> schedule,
  ) {
    double outstandingBalance = loanParams.loanAmount;
    final monthlyRate = loanParams.interestRate / 100 / 12;
    final totalMonths = loanParams.tenureYears * 12;

    // Create a map of prepayments by month for easy lookup
    final prepaymentMap = <int, double>{};
    for (final prepayment in schedule) {
      prepaymentMap[prepayment.month] = prepayment.amount;
    }

    for (int month = 1; month <= totalMonths; month++) {
      if (outstandingBalance <= 0) return month - 1;

      final interestPayment = outstandingBalance * monthlyRate;
      final principalPayment = monthlyEMI - interestPayment;
      outstandingBalance -= principalPayment;

      // Apply prepayment if exists for this month
      if (prepaymentMap.containsKey(month)) {
        outstandingBalance -= prepaymentMap[month]!;
      }
    }

    return totalMonths;
  }

  /// Calculate balance progression for visualization
  static List<MonthlyBalance> _calculateBalanceProgression(
    LoanParameters loanParams,
    EMIResult originalEMI,
    List<PrepaymentSchedule> schedule,
    int newTenureMonths,
  ) {
    final List<MonthlyBalance> progression = [];
    final monthlyRate = loanParams.interestRate / 100 / 12;
    final monthlyEMI = originalEMI.monthlyEMI;

    double originalBalance = loanParams.loanAmount;
    double newBalance = loanParams.loanAmount;
    double cumulativeSavings = 0;

    // Create a map of prepayments by month
    final prepaymentMap = <int, double>{};
    for (final prepayment in schedule) {
      prepaymentMap[prepayment.month] = prepayment.amount;
    }

    final maxMonths = max(loanParams.tenureYears * 12, newTenureMonths);

    for (int month = 1; month <= maxMonths; month++) {
      // Original loan progression
      if (originalBalance > 0) {
        final originalInterest = originalBalance * monthlyRate;
        final originalPrincipal = monthlyEMI - originalInterest;
        originalBalance -= originalPrincipal;
      }

      // New loan progression with prepayments
      if (newBalance > 0 && month <= newTenureMonths) {
        final newInterest = newBalance * monthlyRate;
        final newPrincipal = monthlyEMI - newInterest;
        newBalance -= newPrincipal;

        // Apply prepayment if exists
        if (prepaymentMap.containsKey(month)) {
          newBalance -= prepaymentMap[month]!;
        }
      } else if (month > newTenureMonths) {
        newBalance = 0;
      }

      // Calculate cumulative interest savings
      final originalInterestThisMonth = originalBalance > 0
          ? originalBalance * monthlyRate
          : 0;
      final newInterestThisMonth = newBalance > 0
          ? newBalance * monthlyRate
          : 0;
      cumulativeSavings += originalInterestThisMonth - newInterestThisMonth;

      progression.add(
        MonthlyBalance(
          month: month,
          originalBalance: max(0.0, originalBalance),
          newBalance: max(0.0, newBalance),
          cumulativeSavings: cumulativeSavings,
        ),
      );

      if (originalBalance <= 0 && newBalance <= 0) break;
    }

    return progression;
  }

  /// Calculate prepayment benefits and ROI
  static PrepaymentBenefits _calculatePrepaymentBenefits(
    PrepaymentScenario scenario,
    LoanComparison comparison,
    PrepaymentBreakdown breakdown,
    LoanParameters loanParams,
  ) {
    final totalPrepaymentAmount = breakdown.totalPrepaymentAmount;
    final totalInterestSaved = comparison.interestSaved;
    final totalAmountSaved = comparison.totalSavings;
    final tenureReducedMonths = comparison.tenureReducedMonths;

    // Calculate ROI percentage
    final roiPercentage = totalPrepaymentAmount > 0
        ? (totalInterestSaved / totalPrepaymentAmount) * 100
        : 0.0;

    // Calculate break-even point (simplified)
    final monthlyInterestSavings =
        totalInterestSaved / comparison.originalTenureMonths;
    final breakEvenMonths =
        totalPrepaymentAmount > 0 && monthlyInterestSavings > 0
        ? totalPrepaymentAmount / monthlyInterestSavings
        : 0.0;

    // Estimate tax savings lost (simplified)
    final annualInterestSaved = totalInterestSaved / (loanParams.tenureYears);
    final monthlyTaxSavingsLost =
        (annualInterestSaved * loanParams.taxSlabPercentage / 100) / 12;

    // Net benefit after tax implications
    final totalTaxSavingsLost =
        monthlyTaxSavingsLost * comparison.originalTenureMonths;
    final netBenefit = totalInterestSaved - totalTaxSavingsLost;

    return PrepaymentBenefits(
      totalPrepaymentAmount: totalPrepaymentAmount,
      totalInterestSaved: totalInterestSaved,
      totalAmountSaved: totalAmountSaved,
      tenureReducedMonths: tenureReducedMonths,
      roiPercentage: roiPercentage,
      breakEvenMonths: breakEvenMonths,
      monthlyTaxSavingsLost: monthlyTaxSavingsLost,
      netBenefit: netBenefit,
    );
  }

  /// Compare multiple prepayment scenarios
  static PrepaymentComparison compareScenarios({
    required List<PrepaymentScenario> scenarios,
    required LoanParameters loanParams,
    required EMIResult originalEMI,
  }) {
    final results = scenarios
        .map(
          (scenario) => calculatePrepaymentResult(
            scenario: scenario,
            loanParams: loanParams,
            originalEMI: originalEMI,
          ),
        )
        .toList();

    // Find recommended scenario (highest ROI with reasonable prepayment)
    PrepaymentResult? recommended;
    double bestScore = 0;

    for (final result in results) {
      final benefits = result.benefits;
      // Score based on ROI and reasonable prepayment amount (< 30% of loan)
      final prepaymentRatio =
          benefits.totalPrepaymentAmount / loanParams.loanAmount;
      if (prepaymentRatio <= 0.3) {
        // Reasonable prepayment limit
        final score = benefits.roiPercentage * (1 - prepaymentRatio);
        if (score > bestScore) {
          bestScore = score;
          recommended = result;
        }
      }
    }

    return PrepaymentComparison(
      scenarios: results,
      recommendedScenario: recommended,
    );
  }

  /// Calculate optimal prepayment amount based on available funds
  static double calculateOptimalPrepaymentAmount({
    required double availableFunds,
    required double outstandingBalance,
    required double currentInterestRate,
    required double
    alternativeInvestmentRate, // Expected returns from other investments
  }) {
    // If loan interest rate > investment rate, prepay more
    if (currentInterestRate > alternativeInvestmentRate) {
      return min(
        availableFunds * 0.8,
        outstandingBalance,
      ); // Keep 20% as emergency fund
    } else {
      return min(
        availableFunds * 0.3,
        outstandingBalance,
      ); // Invest more, prepay less
    }
  }

  /// Calculate tax-adjusted prepayment benefit
  static double calculateTaxAdjustedBenefit({
    required double interestSaved,
    required double taxSlabPercentage,
    required bool isSelfOccupied,
  }) {
    // Account for lost tax benefits
    final taxBenefitLost = isSelfOccupied
        ? min(interestSaved, 200000) *
              taxSlabPercentage /
              100 // Section 24B limit
        : interestSaved *
              taxSlabPercentage /
              100; // No limit for let-out property

    return interestSaved - taxBenefitLost;
  }
}
