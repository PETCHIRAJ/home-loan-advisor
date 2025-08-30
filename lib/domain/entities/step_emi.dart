import 'package:equatable/equatable.dart';

/// Types of step EMI options
enum StepEMIType {
  none,
  stepUp,
  stepDown,
}

extension StepEMITypeExtension on StepEMIType {
  String get displayName {
    switch (this) {
      case StepEMIType.none:
        return 'Regular EMI';
      case StepEMIType.stepUp:
        return 'Step-up EMI';
      case StepEMIType.stepDown:
        return 'Step-down EMI';
    }
  }

  String get description {
    switch (this) {
      case StepEMIType.none:
        return 'Fixed EMI throughout loan tenure';
      case StepEMIType.stepUp:
        return 'EMI increases periodically - ideal for growing income';
      case StepEMIType.stepDown:
        return 'EMI decreases periodically - ideal for retirement planning';
    }
  }
}

/// Frequency of step changes
enum StepFrequency {
  yearly,
  biYearly,
}

extension StepFrequencyExtension on StepFrequency {
  String get displayName {
    switch (this) {
      case StepFrequency.yearly:
        return 'Every Year';
      case StepFrequency.biYearly:
        return 'Every 2 Years';
    }
  }

  int get monthsInterval {
    switch (this) {
      case StepFrequency.yearly:
        return 12;
      case StepFrequency.biYearly:
        return 24;
    }
  }
}

/// Parameters for step EMI calculation
class StepEMIParameters extends Equatable {
  final StepEMIType type;
  final double stepPercentage; // Percentage by which EMI changes
  final StepFrequency frequency;
  final int maxSteps; // Maximum number of steps allowed

  const StepEMIParameters({
    required this.type,
    required this.stepPercentage,
    required this.frequency,
    this.maxSteps = 10, // Default to 10 steps
  });

  /// Factory constructor for no step EMI
  factory StepEMIParameters.none() => const StepEMIParameters(
    type: StepEMIType.none,
    stepPercentage: 0,
    frequency: StepFrequency.yearly,
    maxSteps: 0,
  );

  /// Factory constructor for step-up EMI
  factory StepEMIParameters.stepUp({
    required double stepPercentage,
    required StepFrequency frequency,
    int maxSteps = 10,
  }) => StepEMIParameters(
    type: StepEMIType.stepUp,
    stepPercentage: stepPercentage,
    frequency: frequency,
    maxSteps: maxSteps,
  );

  /// Factory constructor for step-down EMI
  factory StepEMIParameters.stepDown({
    required double stepPercentage,
    required StepFrequency frequency,
    int maxSteps = 10,
  }) => StepEMIParameters(
    type: StepEMIType.stepDown,
    stepPercentage: stepPercentage,
    frequency: frequency,
    maxSteps: maxSteps,
  );

  /// Copy with method for immutable updates
  StepEMIParameters copyWith({
    StepEMIType? type,
    double? stepPercentage,
    StepFrequency? frequency,
    int? maxSteps,
  }) {
    return StepEMIParameters(
      type: type ?? this.type,
      stepPercentage: stepPercentage ?? this.stepPercentage,
      frequency: frequency ?? this.frequency,
      maxSteps: maxSteps ?? this.maxSteps,
    );
  }

  @override
  List<Object?> get props => [type, stepPercentage, frequency, maxSteps];
}

/// Individual step EMI details for a specific period
class StepEMIDetail extends Equatable {
  final int stepNumber;
  final int startMonth;
  final int endMonth;
  final double emiAmount;
  final double principalPaid;
  final double interestPaid;
  final double outstandingBalance;

  const StepEMIDetail({
    required this.stepNumber,
    required this.startMonth,
    required this.endMonth,
    required this.emiAmount,
    required this.principalPaid,
    required this.interestPaid,
    required this.outstandingBalance,
  });

  /// Duration in months for this step
  int get durationMonths => endMonth - startMonth + 1;

  /// Year range for display purposes
  String get yearRange {
    final startYear = ((startMonth - 1) ~/ 12) + 1;
    final endYear = ((endMonth - 1) ~/ 12) + 1;
    
    if (startYear == endYear) {
      return 'Year $startYear';
    } else {
      return 'Year $startYear - $endYear';
    }
  }

  @override
  List<Object?> get props => [
    stepNumber,
    startMonth,
    endMonth,
    emiAmount,
    principalPaid,
    interestPaid,
    outstandingBalance,
  ];
}

/// Complete result of step EMI calculation
class StepEMIResult extends Equatable {
  final StepEMIParameters parameters;
  final List<StepEMIDetail> steps;
  final double totalInterest;
  final double totalAmount;
  final double averageEMI;
  final double interestSavedVsRegular; // Compared to regular EMI
  final bool isMoreExpensive; // Whether step EMI costs more than regular

  const StepEMIResult({
    required this.parameters,
    required this.steps,
    required this.totalInterest,
    required this.totalAmount,
    required this.averageEMI,
    required this.interestSavedVsRegular,
    required this.isMoreExpensive,
  });

  /// Get EMI for a specific year
  double getEMIForYear(int year) {
    final month = (year - 1) * 12 + 1;
    for (final step in steps) {
      if (month >= step.startMonth && month <= step.endMonth) {
        return step.emiAmount;
      }
    }
    return steps.isNotEmpty ? steps.first.emiAmount : 0;
  }

  /// Get yearly breakdown for chart visualization
  List<YearlyStepEMI> get yearlyBreakdown {
    final Map<int, YearlyStepEMI> yearlyMap = {};
    
    for (final step in steps) {
      final startYear = ((step.startMonth - 1) ~/ 12) + 1;
      final endYear = ((step.endMonth - 1) ~/ 12) + 1;
      
      for (int year = startYear; year <= endYear; year++) {
        if (yearlyMap.containsKey(year)) {
          // Update existing year data
          final existing = yearlyMap[year]!;
          yearlyMap[year] = existing.copyWith(
            principalPaid: existing.principalPaid + step.principalPaid,
            interestPaid: existing.interestPaid + step.interestPaid,
          );
        } else {
          // Create new year entry
          yearlyMap[year] = YearlyStepEMI(
            year: year,
            emiAmount: step.emiAmount,
            principalPaid: step.principalPaid,
            interestPaid: step.interestPaid,
            outstandingBalance: step.outstandingBalance,
          );
        }
      }
    }
    
    return yearlyMap.values.toList()..sort((a, b) => a.year.compareTo(b.year));
  }

  /// Total number of EMI steps
  int get totalSteps => steps.length;

  /// First EMI amount
  double get firstEMI => steps.isNotEmpty ? steps.first.emiAmount : 0;

  /// Last EMI amount
  double get lastEMI => steps.isNotEmpty ? steps.last.emiAmount : 0;

  @override
  List<Object?> get props => [
    parameters,
    steps,
    totalInterest,
    totalAmount,
    averageEMI,
    interestSavedVsRegular,
    isMoreExpensive,
  ];
}

/// Yearly breakdown for step EMI
class YearlyStepEMI extends Equatable {
  final int year;
  final double emiAmount;
  final double principalPaid;
  final double interestPaid;
  final double outstandingBalance;

  const YearlyStepEMI({
    required this.year,
    required this.emiAmount,
    required this.principalPaid,
    required this.interestPaid,
    required this.outstandingBalance,
  });

  YearlyStepEMI copyWith({
    int? year,
    double? emiAmount,
    double? principalPaid,
    double? interestPaid,
    double? outstandingBalance,
  }) {
    return YearlyStepEMI(
      year: year ?? this.year,
      emiAmount: emiAmount ?? this.emiAmount,
      principalPaid: principalPaid ?? this.principalPaid,
      interestPaid: interestPaid ?? this.interestPaid,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
    );
  }

  @override
  List<Object?> get props => [
    year,
    emiAmount,
    principalPaid,
    interestPaid,
    outstandingBalance,
  ];
}