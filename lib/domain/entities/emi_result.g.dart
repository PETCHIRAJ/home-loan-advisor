// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emi_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EMIResult _$EMIResultFromJson(Map<String, dynamic> json) => EMIResult(
  monthlyEMI: (json['monthlyEMI'] as num).toDouble(),
  totalInterest: (json['totalInterest'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  principalAmount: (json['principalAmount'] as num).toDouble(),
  taxBenefits: TaxBenefits.fromJson(
    json['taxBenefits'] as Map<String, dynamic>,
  ),
  pmayBenefit: json['pmayBenefit'] == null
      ? null
      : PMAYBenefit.fromJson(json['pmayBenefit'] as Map<String, dynamic>),
  breakdown: LoanBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
  stepEMIResult: json['stepEMIResult'] == null
      ? null
      : StepEMIResult.fromJson(json['stepEMIResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EMIResultToJson(EMIResult instance) => <String, dynamic>{
  'monthlyEMI': instance.monthlyEMI,
  'totalInterest': instance.totalInterest,
  'totalAmount': instance.totalAmount,
  'principalAmount': instance.principalAmount,
  'taxBenefits': instance.taxBenefits,
  'pmayBenefit': instance.pmayBenefit,
  'breakdown': instance.breakdown,
  'stepEMIResult': instance.stepEMIResult,
};

TaxBenefits _$TaxBenefitsFromJson(Map<String, dynamic> json) => TaxBenefits(
  section80C: (json['section80C'] as num).toDouble(),
  section24B: (json['section24B'] as num).toDouble(),
  section80EEA: (json['section80EEA'] as num).toDouble(),
  totalAnnualSavings: (json['totalAnnualSavings'] as num).toDouble(),
);

Map<String, dynamic> _$TaxBenefitsToJson(TaxBenefits instance) =>
    <String, dynamic>{
      'section80C': instance.section80C,
      'section24B': instance.section24B,
      'section80EEA': instance.section80EEA,
      'totalAnnualSavings': instance.totalAnnualSavings,
    };

PMAYBenefit _$PMAYBenefitFromJson(Map<String, dynamic> json) => PMAYBenefit(
  category: json['category'] as String,
  subsidyAmount: (json['subsidyAmount'] as num).toDouble(),
  subsidyRate: (json['subsidyRate'] as num).toDouble(),
  maxSubsidy: (json['maxSubsidy'] as num).toDouble(),
  isEligible: json['isEligible'] as bool,
);

Map<String, dynamic> _$PMAYBenefitToJson(PMAYBenefit instance) =>
    <String, dynamic>{
      'category': instance.category,
      'subsidyAmount': instance.subsidyAmount,
      'subsidyRate': instance.subsidyRate,
      'maxSubsidy': instance.maxSubsidy,
      'isEligible': instance.isEligible,
    };

LoanBreakdown _$LoanBreakdownFromJson(Map<String, dynamic> json) =>
    LoanBreakdown(
      yearlyBreakdown: (json['yearlyBreakdown'] as List<dynamic>)
          .map((e) => YearlyBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrincipalPaid: (json['totalPrincipalPaid'] as num).toDouble(),
      totalInterestPaid: (json['totalInterestPaid'] as num).toDouble(),
    );

Map<String, dynamic> _$LoanBreakdownToJson(LoanBreakdown instance) =>
    <String, dynamic>{
      'yearlyBreakdown': instance.yearlyBreakdown,
      'totalPrincipalPaid': instance.totalPrincipalPaid,
      'totalInterestPaid': instance.totalInterestPaid,
    };

YearlyBreakdown _$YearlyBreakdownFromJson(Map<String, dynamic> json) =>
    YearlyBreakdown(
      year: (json['year'] as num).toInt(),
      principalPaid: (json['principalPaid'] as num).toDouble(),
      interestPaid: (json['interestPaid'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
      taxSavings: (json['taxSavings'] as num).toDouble(),
    );

Map<String, dynamic> _$YearlyBreakdownToJson(YearlyBreakdown instance) =>
    <String, dynamic>{
      'year': instance.year,
      'principalPaid': instance.principalPaid,
      'interestPaid': instance.interestPaid,
      'outstandingBalance': instance.outstandingBalance,
      'taxSavings': instance.taxSavings,
    };
