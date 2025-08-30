import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loan_parameters.g.dart';

/// Represents the input parameters for home loan calculation
@JsonSerializable()
class LoanParameters extends Equatable {
  final double loanAmount;
  final double interestRate;
  final int tenureYears;
  final double annualIncome;
  final int taxSlabPercentage;
  final bool isSelfOccupied;
  final bool isFirstTimeHomeBuyer;
  final int age;
  final String employmentType; // 'salaried' or 'self_employed'
  final String gender; // 'male' or 'female'

  const LoanParameters({
    required this.loanAmount,
    required this.interestRate,
    required this.tenureYears,
    required this.annualIncome,
    required this.taxSlabPercentage,
    this.isSelfOccupied = true,
    this.isFirstTimeHomeBuyer = false,
    required this.age,
    this.employmentType = 'salaried',
    this.gender = 'male',
  });

  LoanParameters copyWith({
    double? loanAmount,
    double? interestRate,
    int? tenureYears,
    double? annualIncome,
    int? taxSlabPercentage,
    bool? isSelfOccupied,
    bool? isFirstTimeHomeBuyer,
    int? age,
    String? employmentType,
    String? gender,
  }) {
    return LoanParameters(
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      tenureYears: tenureYears ?? this.tenureYears,
      annualIncome: annualIncome ?? this.annualIncome,
      taxSlabPercentage: taxSlabPercentage ?? this.taxSlabPercentage,
      isSelfOccupied: isSelfOccupied ?? this.isSelfOccupied,
      isFirstTimeHomeBuyer: isFirstTimeHomeBuyer ?? this.isFirstTimeHomeBuyer,
      age: age ?? this.age,
      employmentType: employmentType ?? this.employmentType,
      gender: gender ?? this.gender,
    );
  }

  /// Factory for creating from JSON
  factory LoanParameters.fromJson(Map<String, dynamic> json) =>
      _$LoanParametersFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$LoanParametersToJson(this);

  @override
  List<Object?> get props => [
    loanAmount,
    interestRate,
    tenureYears,
    annualIncome,
    taxSlabPercentage,
    isSelfOccupied,
    isFirstTimeHomeBuyer,
    age,
    employmentType,
    gender,
  ];
}
