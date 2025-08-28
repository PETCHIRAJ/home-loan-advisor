// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrategyDetailModelImpl _$$StrategyDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StrategyDetailModelImpl(
      type: $enumDecode(_$StrategyTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$StrategyCategoryEnumMap, json['category']),
      implementationSteps: (json['implementationSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tips: (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
      considerations: (json['considerations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      difficultyLevel: (json['difficultyLevel'] as num).toInt(),
      estimatedTime:
          Duration(microseconds: (json['estimatedTime'] as num).toInt()),
      requiresCalculation: json['requiresCalculation'] as bool? ?? false,
      hasVisualComponent: json['hasVisualComponent'] as bool? ?? false,
      calculatorHint: json['calculatorHint'] as String?,
    );

Map<String, dynamic> _$$StrategyDetailModelImplToJson(
        _$StrategyDetailModelImpl instance) =>
    <String, dynamic>{
      'type': _$StrategyTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'category': _$StrategyCategoryEnumMap[instance.category]!,
      'implementationSteps': instance.implementationSteps,
      'tips': instance.tips,
      'considerations': instance.considerations,
      'difficultyLevel': instance.difficultyLevel,
      'estimatedTime': instance.estimatedTime.inMicroseconds,
      'requiresCalculation': instance.requiresCalculation,
      'hasVisualComponent': instance.hasVisualComponent,
      'calculatorHint': instance.calculatorHint,
    };

const _$StrategyTypeEnumMap = {
  StrategyType.dailyInterestBurn: 'daily_interest_burn',
  StrategyType.rule78Revealer: 'rule_78_revealer',
  StrategyType.totalInterestShock: 'total_interest_shock',
  StrategyType.breakEvenTracker: 'break_even_tracker',
  StrategyType.extraEMIStrategy: 'extra_emi_strategy',
  StrategyType.roundUpOptimizer: 'round_up_optimizer',
  StrategyType.prepaymentCalculator: 'prepayment_calculator',
  StrategyType.partPaymentTiming: 'part_payment_timing',
  StrategyType.taxArbitrage: 'tax_arbitrage',
  StrategyType.prepayVsInvestment: 'prepay_vs_investment',
  StrategyType.ppfVsPrepay: 'ppf_vs_prepay',
  StrategyType.tenureReduction: 'tenure_reduction',
  StrategyType.coffeeToEMI: 'coffee_to_emi',
  StrategyType.incrementAllocator: 'increment_allocator',
  StrategyType.fixedVsFloating: 'fixed_vs_floating',
  StrategyType.marriageStrategy: 'marriage_strategy',
  StrategyType.jobChangeEMI: 'job_change_emi',
  StrategyType.childrenPlanning: 'children_planning',
  StrategyType.taxMaximizer: 'tax_maximizer',
  StrategyType.emiRentCrossover: 'emi_rent_crossover',
};

const _$StrategyCategoryEnumMap = {
  StrategyCategory.instantEyeOpeners: 'instant_eye_openers',
  StrategyCategory.coreSavings: 'core_savings',
  StrategyCategory.taxInvestment: 'tax_investment',
  StrategyCategory.behavioralMotivation: 'behavioral_motivation',
  StrategyCategory.lifeEventPlanning: 'life_event_planning',
};

_$StrategyImpactImpl _$$StrategyImpactImplFromJson(Map<String, dynamic> json) =>
    _$StrategyImpactImpl(
      primaryMetric:
          MetricData.fromJson(json['primaryMetric'] as Map<String, dynamic>),
      secondaryMetrics: (json['secondaryMetrics'] as List<dynamic>)
          .map((e) => MetricData.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      actionability:
          $enumDecode(_$StrategyActionabilityEnumMap, json['actionability']),
    );

Map<String, dynamic> _$$StrategyImpactImplToJson(
        _$StrategyImpactImpl instance) =>
    <String, dynamic>{
      'primaryMetric': instance.primaryMetric,
      'secondaryMetrics': instance.secondaryMetrics,
      'description': instance.description,
      'actionability': _$StrategyActionabilityEnumMap[instance.actionability]!,
    };

const _$StrategyActionabilityEnumMap = {
  StrategyActionability.awareness: 'awareness',
  StrategyActionability.educational: 'educational',
  StrategyActionability.motivational: 'motivational',
  StrategyActionability.milestone: 'milestone',
  StrategyActionability.actionable: 'actionable',
  StrategyActionability.tactical: 'tactical',
  StrategyActionability.analytical: 'analytical',
  StrategyActionability.behavioral: 'behavioral',
  StrategyActionability.lifestage: 'lifestage',
  StrategyActionability.compliance: 'compliance',
};

_$MetricDataImpl _$$MetricDataImplFromJson(Map<String, dynamic> json) =>
    _$MetricDataImpl(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      format: $enumDecode(_$MetricFormatEnumMap, json['format']),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$MetricDataImplToJson(_$MetricDataImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'format': _$MetricFormatEnumMap[instance.format]!,
      'unit': instance.unit,
    };

const _$MetricFormatEnumMap = {
  MetricFormat.currency: 'currency',
  MetricFormat.percentage: 'percentage',
  MetricFormat.years: 'years',
  MetricFormat.months: 'months',
  MetricFormat.multiplier: 'multiplier',
  MetricFormat.text: 'text',
  MetricFormat.month: 'month',
};
