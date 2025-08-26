// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanModelImpl _$$LoanModelImplFromJson(Map<String, dynamic> json) =>
    _$LoanModelImpl(
      loanAmount: (json['loanAmount'] as num?)?.toDouble() ?? 3000000.0,
      annualInterestRate:
          (json['annualInterestRate'] as num?)?.toDouble() ?? 8.5,
      tenureYears: (json['tenureYears'] as num?)?.toInt() ?? 20,
      propertyValue: (json['propertyValue'] as num?)?.toDouble(),
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      processingFee: (json['processingFee'] as num?)?.toDouble() ?? 0.0,
      insurancePremium: (json['insurancePremium'] as num?)?.toDouble(),
      extraEMIAmount: (json['extraEMIAmount'] as num?)?.toDouble() ?? 0.0,
      lumpSumPayment: (json['lumpSumPayment'] as num?)?.toDouble() ?? 0.0,
      lumpSumMonth: (json['lumpSumMonth'] as num?)?.toInt() ?? 0,
      loanType: $enumDecodeNullable(_$LoanTypeEnumMap, json['loanType']) ??
          LoanType.homeLoan,
      rateType:
          $enumDecodeNullable(_$InterestRateTypeEnumMap, json['rateType']) ??
              InterestRateType.fixed,
      loanStartDate: json['loanStartDate'] == null
          ? null
          : DateTime.parse(json['loanStartDate'] as String),
      bankName: json['bankName'] as String?,
      isModified: json['isModified'] as bool? ?? false,
      lastCalculated: json['lastCalculated'] == null
          ? null
          : DateTime.parse(json['lastCalculated'] as String),
    );

Map<String, dynamic> _$$LoanModelImplToJson(_$LoanModelImpl instance) =>
    <String, dynamic>{
      'loanAmount': instance.loanAmount,
      'annualInterestRate': instance.annualInterestRate,
      'tenureYears': instance.tenureYears,
      'propertyValue': instance.propertyValue,
      'monthlyIncome': instance.monthlyIncome,
      'processingFee': instance.processingFee,
      'insurancePremium': instance.insurancePremium,
      'extraEMIAmount': instance.extraEMIAmount,
      'lumpSumPayment': instance.lumpSumPayment,
      'lumpSumMonth': instance.lumpSumMonth,
      'loanType': _$LoanTypeEnumMap[instance.loanType]!,
      'rateType': _$InterestRateTypeEnumMap[instance.rateType]!,
      'loanStartDate': instance.loanStartDate?.toIso8601String(),
      'bankName': instance.bankName,
      'isModified': instance.isModified,
      'lastCalculated': instance.lastCalculated?.toIso8601String(),
    };

const _$LoanTypeEnumMap = {
  LoanType.homeLoan: 'home_loan',
  LoanType.homeImprovement: 'home_improvement',
  LoanType.landPurchase: 'land_purchase',
  LoanType.construction: 'construction',
  LoanType.loanAgainstProperty: 'loan_against_property',
};

const _$InterestRateTypeEnumMap = {
  InterestRateType.fixed: 'fixed',
  InterestRateType.floating: 'floating',
  InterestRateType.hybrid: 'hybrid',
};
