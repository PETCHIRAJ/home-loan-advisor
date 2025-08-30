// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanParameters _$LoanParametersFromJson(Map<String, dynamic> json) =>
    LoanParameters(
      loanAmount: (json['loanAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      tenureYears: (json['tenureYears'] as num).toInt(),
      annualIncome: (json['annualIncome'] as num).toDouble(),
      taxSlabPercentage: (json['taxSlabPercentage'] as num).toInt(),
      isSelfOccupied: json['isSelfOccupied'] as bool? ?? true,
      isFirstTimeHomeBuyer: json['isFirstTimeHomeBuyer'] as bool? ?? false,
      age: (json['age'] as num).toInt(),
      employmentType: json['employmentType'] as String? ?? 'salaried',
      gender: json['gender'] as String? ?? 'male',
    );

Map<String, dynamic> _$LoanParametersToJson(LoanParameters instance) =>
    <String, dynamic>{
      'loanAmount': instance.loanAmount,
      'interestRate': instance.interestRate,
      'tenureYears': instance.tenureYears,
      'annualIncome': instance.annualIncome,
      'taxSlabPercentage': instance.taxSlabPercentage,
      'isSelfOccupied': instance.isSelfOccupied,
      'isFirstTimeHomeBuyer': instance.isFirstTimeHomeBuyer,
      'age': instance.age,
      'employmentType': instance.employmentType,
      'gender': instance.gender,
    };
