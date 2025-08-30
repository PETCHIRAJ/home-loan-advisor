import 'dart:math';
import '../../domain/entities/step_emi.dart';
import 'calculation_utils.dart';

class StepEMICalculationUtils {
  /// Calculate step EMI result based on parameters
  static StepEMIResult calculateStepEMI({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required StepEMIParameters parameters,
  }) {
    if (parameters.type == StepEMIType.none) {
      return _calculateRegularEMIAsStepResult(
        principal: principal,
        annualRate: annualRate,
        tenureYears: tenureYears,
        parameters: parameters,
      );
    }

    // Calculate regular EMI for comparison
    final regularEMI = CalculationUtils.calculateEMI(
      principal: principal,
      annualRate: annualRate,
      tenureYears: tenureYears,
    );
    final regularTotalInterest = CalculationUtils.calculateTotalInterest(
      emi: regularEMI,
      tenureYears: tenureYears,
      principal: principal,
    );

    List<StepEMIDetail> steps;
    double totalInterest;
    double totalAmount;

    switch (parameters.type) {
      case StepEMIType.stepUp:
        final result = _calculateStepUpEMI(
          principal: principal,
          annualRate: annualRate,
          tenureYears: tenureYears,
          parameters: parameters,
        );
        steps = result['steps'];
        totalInterest = result['totalInterest'];
        totalAmount = result['totalAmount'];
        break;

      case StepEMIType.stepDown:
        final result = _calculateStepDownEMI(
          principal: principal,
          annualRate: annualRate,
          tenureYears: tenureYears,
          parameters: parameters,
        );
        steps = result['steps'];
        totalInterest = result['totalInterest'];
        totalAmount = result['totalAmount'];
        break;

      default:
        steps = [];
        totalInterest = 0;
        totalAmount = 0;
    }

    final averageEMI = steps.isNotEmpty
        ? steps
                  .map((s) => s.emiAmount * s.durationMonths)
                  .reduce((a, b) => a + b) /
              (tenureYears * 12).toDouble()
        : 0.0;

    final interestSavedVsRegular = regularTotalInterest - totalInterest;
    final isMoreExpensive = totalInterest > regularTotalInterest;

    return StepEMIResult(
      parameters: parameters,
      steps: steps,
      totalInterest: totalInterest,
      totalAmount: totalAmount,
      averageEMI: averageEMI,
      interestSavedVsRegular: interestSavedVsRegular,
      isMoreExpensive: isMoreExpensive,
    );
  }

  /// Calculate step-up EMI (EMI increases over time)
  static Map<String, dynamic> _calculateStepUpEMI({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required StepEMIParameters parameters,
  }) {
    final totalMonths = tenureYears * 12;
    final monthlyRate = annualRate / 100 / 12;
    final stepInterval = parameters.frequency.monthsInterval;
    final stepPercentage = parameters.stepPercentage / 100;

    // Calculate initial EMI (lower than regular to accommodate future increases)
    double initialEMI = _calculateInitialStepUpEMI(
      principal: principal,
      monthlyRate: monthlyRate,
      totalMonths: totalMonths,
      stepPercentage: stepPercentage,
      stepInterval: stepInterval,
      maxSteps: parameters.maxSteps,
    );

    List<StepEMIDetail> steps = [];
    double remainingPrincipal = principal;
    int currentMonth = 1;
    int stepNumber = 1;
    double currentEMI = initialEMI;
    double totalInterestPaid = 0;

    while (currentMonth <= totalMonths && remainingPrincipal > 0.01) {
      final endMonth = min(currentMonth + stepInterval - 1, totalMonths);
      final stepMonths = endMonth - currentMonth + 1;

      double stepPrincipalPaid = 0;
      double stepInterestPaid = 0;
      double stepRemainingPrincipal = remainingPrincipal;

      // Calculate payments for this step period
      for (
        int month = 0;
        month < stepMonths && stepRemainingPrincipal > 0.01;
        month++
      ) {
        final interestPayment = stepRemainingPrincipal * monthlyRate;
        final principalPayment = (currentEMI - interestPayment).clamp(
          0,
          stepRemainingPrincipal,
        );

        stepPrincipalPaid += principalPayment;
        stepInterestPaid += interestPayment;
        stepRemainingPrincipal -= principalPayment;
      }

      steps.add(
        StepEMIDetail(
          stepNumber: stepNumber,
          startMonth: currentMonth,
          endMonth: endMonth,
          emiAmount: currentEMI,
          principalPaid: stepPrincipalPaid,
          interestPaid: stepInterestPaid,
          outstandingBalance: stepRemainingPrincipal,
        ),
      );

      totalInterestPaid += stepInterestPaid;
      remainingPrincipal = stepRemainingPrincipal;
      currentMonth = endMonth + 1;
      stepNumber++;

      // Increase EMI for next step (if not the last step and within maxSteps)
      if (stepNumber <= parameters.maxSteps && currentMonth <= totalMonths) {
        currentEMI *= (1 + stepPercentage);
      }
    }

    return {
      'steps': steps,
      'totalInterest': totalInterestPaid,
      'totalAmount': principal + totalInterestPaid,
    };
  }

  /// Calculate step-down EMI (EMI decreases over time)
  static Map<String, dynamic> _calculateStepDownEMI({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required StepEMIParameters parameters,
  }) {
    final totalMonths = tenureYears * 12;
    final monthlyRate = annualRate / 100 / 12;
    final stepInterval = parameters.frequency.monthsInterval;
    final stepPercentage = parameters.stepPercentage / 100;

    // Calculate initial EMI (higher than regular to accommodate future decreases)
    double initialEMI = _calculateInitialStepDownEMI(
      principal: principal,
      monthlyRate: monthlyRate,
      totalMonths: totalMonths,
      stepPercentage: stepPercentage,
      stepInterval: stepInterval,
      maxSteps: parameters.maxSteps,
    );

    List<StepEMIDetail> steps = [];
    double remainingPrincipal = principal;
    int currentMonth = 1;
    int stepNumber = 1;
    double currentEMI = initialEMI;
    double totalInterestPaid = 0;

    while (currentMonth <= totalMonths && remainingPrincipal > 0.01) {
      final endMonth = min(currentMonth + stepInterval - 1, totalMonths);
      final stepMonths = endMonth - currentMonth + 1;

      double stepPrincipalPaid = 0;
      double stepInterestPaid = 0;
      double stepRemainingPrincipal = remainingPrincipal;

      // Calculate payments for this step period
      for (
        int month = 0;
        month < stepMonths && stepRemainingPrincipal > 0.01;
        month++
      ) {
        final interestPayment = stepRemainingPrincipal * monthlyRate;
        final principalPayment = (currentEMI - interestPayment).clamp(
          0,
          stepRemainingPrincipal,
        );

        stepPrincipalPaid += principalPayment;
        stepInterestPaid += interestPayment;
        stepRemainingPrincipal -= principalPayment;
      }

      steps.add(
        StepEMIDetail(
          stepNumber: stepNumber,
          startMonth: currentMonth,
          endMonth: endMonth,
          emiAmount: currentEMI,
          principalPaid: stepPrincipalPaid,
          interestPaid: stepInterestPaid,
          outstandingBalance: stepRemainingPrincipal,
        ),
      );

      totalInterestPaid += stepInterestPaid;
      remainingPrincipal = stepRemainingPrincipal;
      currentMonth = endMonth + 1;
      stepNumber++;

      // Decrease EMI for next step (if not the last step and within maxSteps)
      if (stepNumber <= parameters.maxSteps && currentMonth <= totalMonths) {
        currentEMI *= (1 - stepPercentage);
      }
    }

    return {
      'steps': steps,
      'totalInterest': totalInterestPaid,
      'totalAmount': principal + totalInterestPaid,
    };
  }

  /// Calculate initial EMI for step-up loans using numerical approximation
  static double _calculateInitialStepUpEMI({
    required double principal,
    required double monthlyRate,
    required int totalMonths,
    required double stepPercentage,
    required int stepInterval,
    required int maxSteps,
  }) {
    // Use iterative approach to find initial EMI
    double low = principal * monthlyRate * 0.5; // Lower bound
    double high = principal * monthlyRate * 2; // Upper bound
    double tolerance = 0.01;

    for (int iteration = 0; iteration < 100; iteration++) {
      double mid = (low + high) / 2;
      double result = _simulateLoanWithStepUp(
        principal: principal,
        initialEMI: mid,
        monthlyRate: monthlyRate,
        totalMonths: totalMonths,
        stepPercentage: stepPercentage,
        stepInterval: stepInterval,
        maxSteps: maxSteps,
      );

      if ((result - principal).abs() < tolerance) {
        return mid;
      } else if (result > principal) {
        high = mid;
      } else {
        low = mid;
      }
    }

    return (low + high) / 2;
  }

  /// Calculate initial EMI for step-down loans using numerical approximation
  static double _calculateInitialStepDownEMI({
    required double principal,
    required double monthlyRate,
    required int totalMonths,
    required double stepPercentage,
    required int stepInterval,
    required int maxSteps,
  }) {
    // Use iterative approach to find initial EMI
    double low = principal * monthlyRate * 0.8; // Lower bound
    double high = principal * monthlyRate * 3; // Upper bound
    double tolerance = 0.01;

    for (int iteration = 0; iteration < 100; iteration++) {
      double mid = (low + high) / 2;
      double result = _simulateLoanWithStepDown(
        principal: principal,
        initialEMI: mid,
        monthlyRate: monthlyRate,
        totalMonths: totalMonths,
        stepPercentage: stepPercentage,
        stepInterval: stepInterval,
        maxSteps: maxSteps,
      );

      if ((result - principal).abs() < tolerance) {
        return mid;
      } else if (result > principal) {
        low = mid;
      } else {
        high = mid;
      }
    }

    return (low + high) / 2;
  }

  /// Simulate loan repayment with step-up EMI to find total principal paid
  static double _simulateLoanWithStepUp({
    required double principal,
    required double initialEMI,
    required double monthlyRate,
    required int totalMonths,
    required double stepPercentage,
    required int stepInterval,
    required int maxSteps,
  }) {
    double remainingPrincipal = principal;
    double currentEMI = initialEMI;
    int stepNumber = 1;

    for (
      int month = 1;
      month <= totalMonths && remainingPrincipal > 0.01;
      month++
    ) {
      final interestPayment = remainingPrincipal * monthlyRate;
      final principalPayment = (currentEMI - interestPayment).clamp(
        0,
        remainingPrincipal,
      );

      remainingPrincipal -= principalPayment;

      // Check if we need to step up EMI
      if (month % stepInterval == 0 && stepNumber < maxSteps) {
        currentEMI *= (1 + stepPercentage);
        stepNumber++;
      }
    }

    return principal - remainingPrincipal; // Total principal paid
  }

  /// Simulate loan repayment with step-down EMI to find total principal paid
  static double _simulateLoanWithStepDown({
    required double principal,
    required double initialEMI,
    required double monthlyRate,
    required int totalMonths,
    required double stepPercentage,
    required int stepInterval,
    required int maxSteps,
  }) {
    double remainingPrincipal = principal;
    double currentEMI = initialEMI;
    int stepNumber = 1;

    for (
      int month = 1;
      month <= totalMonths && remainingPrincipal > 0.01;
      month++
    ) {
      final interestPayment = remainingPrincipal * monthlyRate;
      final principalPayment = (currentEMI - interestPayment).clamp(
        0,
        remainingPrincipal,
      );

      remainingPrincipal -= principalPayment;

      // Check if we need to step down EMI
      if (month % stepInterval == 0 && stepNumber < maxSteps) {
        currentEMI *= (1 - stepPercentage);
        stepNumber++;
      }
    }

    return principal - remainingPrincipal; // Total principal paid
  }

  /// Convert regular EMI calculation to step EMI result format
  static StepEMIResult _calculateRegularEMIAsStepResult({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required StepEMIParameters parameters,
  }) {
    final regularEMI = CalculationUtils.calculateEMI(
      principal: principal,
      annualRate: annualRate,
      tenureYears: tenureYears,
    );

    final totalInterest = CalculationUtils.calculateTotalInterest(
      emi: regularEMI,
      tenureYears: tenureYears,
      principal: principal,
    );

    final totalAmount = principal + totalInterest;
    final totalMonths = tenureYears * 12;

    // Create a single step representing the entire loan tenure
    final step = StepEMIDetail(
      stepNumber: 1,
      startMonth: 1,
      endMonth: totalMonths,
      emiAmount: regularEMI,
      principalPaid: principal,
      interestPaid: totalInterest,
      outstandingBalance: 0,
    );

    return StepEMIResult(
      parameters: parameters,
      steps: [step],
      totalInterest: totalInterest,
      totalAmount: totalAmount,
      averageEMI: regularEMI,
      interestSavedVsRegular: 0, // No savings compared to itself
      isMoreExpensive: false,
    );
  }

  /// Get suggested step percentages based on loan parameters
  static List<double> getSuggestedStepPercentages() {
    return [5.0, 7.5, 10.0, 12.5, 15.0, 20.0];
  }

  /// Validate step EMI parameters
  static Map<String, String?> validateStepEMIParameters({
    required StepEMIParameters parameters,
    required double loanAmount,
    required int tenureYears,
  }) {
    Map<String, String?> errors = {};

    if (parameters.type == StepEMIType.none) {
      return errors; // No validation needed for regular EMI
    }

    if (parameters.stepPercentage < 5 || parameters.stepPercentage > 25) {
      errors['stepPercentage'] = 'Step percentage should be between 5% and 25%';
    }

    if (parameters.maxSteps < 1 || parameters.maxSteps > tenureYears) {
      errors['maxSteps'] = 'Maximum steps should be between 1 and $tenureYears';
    }

    // Check if step interval is reasonable for loan tenure
    final totalSteps = (tenureYears * 12) / parameters.frequency.monthsInterval;
    if (totalSteps < 2) {
      errors['frequency'] =
          'Step frequency is too low for the given loan tenure';
    }

    return errors;
  }

  /// Calculate EMI progression for visualization
  static List<Map<String, dynamic>> getEMIProgression({
    required double principal,
    required double annualRate,
    required int tenureYears,
    required StepEMIParameters parameters,
  }) {
    final result = calculateStepEMI(
      principal: principal,
      annualRate: annualRate,
      tenureYears: tenureYears,
      parameters: parameters,
    );

    return result.yearlyBreakdown
        .map(
          (yearly) => {
            'year': yearly.year,
            'emi': yearly.emiAmount,
            'principal': yearly.principalPaid,
            'interest': yearly.interestPaid,
            'balance': yearly.outstandingBalance,
          },
        )
        .toList();
  }
}
