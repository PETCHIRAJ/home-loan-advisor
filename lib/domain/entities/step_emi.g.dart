// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_emi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepEMIParameters _$StepEMIParametersFromJson(Map<String, dynamic> json) =>
    StepEMIParameters(
      type: $enumDecode(_$StepEMITypeEnumMap, json['type']),
      stepPercentage: (json['stepPercentage'] as num).toDouble(),
      frequency: $enumDecode(_$StepFrequencyEnumMap, json['frequency']),
      maxSteps: (json['maxSteps'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$StepEMIParametersToJson(StepEMIParameters instance) =>
    <String, dynamic>{
      'type': _$StepEMITypeEnumMap[instance.type]!,
      'stepPercentage': instance.stepPercentage,
      'frequency': _$StepFrequencyEnumMap[instance.frequency]!,
      'maxSteps': instance.maxSteps,
    };

const _$StepEMITypeEnumMap = {
  StepEMIType.none: 'none',
  StepEMIType.stepUp: 'stepUp',
  StepEMIType.stepDown: 'stepDown',
};

const _$StepFrequencyEnumMap = {
  StepFrequency.yearly: 'yearly',
  StepFrequency.biYearly: 'biYearly',
};

StepEMIDetail _$StepEMIDetailFromJson(Map<String, dynamic> json) =>
    StepEMIDetail(
      stepNumber: (json['stepNumber'] as num).toInt(),
      startMonth: (json['startMonth'] as num).toInt(),
      endMonth: (json['endMonth'] as num).toInt(),
      emiAmount: (json['emiAmount'] as num).toDouble(),
      principalPaid: (json['principalPaid'] as num).toDouble(),
      interestPaid: (json['interestPaid'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$StepEMIDetailToJson(StepEMIDetail instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'startMonth': instance.startMonth,
      'endMonth': instance.endMonth,
      'emiAmount': instance.emiAmount,
      'principalPaid': instance.principalPaid,
      'interestPaid': instance.interestPaid,
      'outstandingBalance': instance.outstandingBalance,
    };

StepEMIResult _$StepEMIResultFromJson(Map<String, dynamic> json) =>
    StepEMIResult(
      parameters: StepEMIParameters.fromJson(
        json['parameters'] as Map<String, dynamic>,
      ),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => StepEMIDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalInterest: (json['totalInterest'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      averageEMI: (json['averageEMI'] as num).toDouble(),
      interestSavedVsRegular: (json['interestSavedVsRegular'] as num)
          .toDouble(),
      isMoreExpensive: json['isMoreExpensive'] as bool,
    );

Map<String, dynamic> _$StepEMIResultToJson(StepEMIResult instance) =>
    <String, dynamic>{
      'parameters': instance.parameters,
      'steps': instance.steps,
      'totalInterest': instance.totalInterest,
      'totalAmount': instance.totalAmount,
      'averageEMI': instance.averageEMI,
      'interestSavedVsRegular': instance.interestSavedVsRegular,
      'isMoreExpensive': instance.isMoreExpensive,
    };

YearlyStepEMI _$YearlyStepEMIFromJson(Map<String, dynamic> json) =>
    YearlyStepEMI(
      year: (json['year'] as num).toInt(),
      emiAmount: (json['emiAmount'] as num).toDouble(),
      principalPaid: (json['principalPaid'] as num).toDouble(),
      interestPaid: (json['interestPaid'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
    );

Map<String, dynamic> _$YearlyStepEMIToJson(YearlyStepEMI instance) =>
    <String, dynamic>{
      'year': instance.year,
      'emiAmount': instance.emiAmount,
      'principalPaid': instance.principalPaid,
      'interestPaid': instance.interestPaid,
      'outstandingBalance': instance.outstandingBalance,
    };
