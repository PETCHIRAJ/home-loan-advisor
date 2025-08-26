// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrategyModelImpl _$$StrategyModelImplFromJson(Map<String, dynamic> json) =>
    _$StrategyModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      explanation: json['explanation'] as String,
      category: $enumDecode(_$StrategyCategoryEnumMap, json['category']),
      difficulty: $enumDecode(_$StrategyDifficultyEnumMap, json['difficulty']),
      savingsRange: json['savingsRange'] as String,
      timeToImplement: json['timeToImplement'] as String,
      isRecommended: json['isRecommended'] as bool? ?? false,
      isBeginner: json['isBeginner'] as bool? ?? true,
      pros: (json['pros'] as List<dynamic>).map((e) => e as String).toList(),
      cons: (json['cons'] as List<dynamic>).map((e) => e as String).toList(),
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      implementationSteps: (json['implementationSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relatedStrategies: (json['relatedStrategies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$StrategyModelImplToJson(_$StrategyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'explanation': instance.explanation,
      'category': _$StrategyCategoryEnumMap[instance.category]!,
      'difficulty': _$StrategyDifficultyEnumMap[instance.difficulty]!,
      'savingsRange': instance.savingsRange,
      'timeToImplement': instance.timeToImplement,
      'isRecommended': instance.isRecommended,
      'isBeginner': instance.isBeginner,
      'pros': instance.pros,
      'cons': instance.cons,
      'requirements': instance.requirements,
      'implementationSteps': instance.implementationSteps,
      'relatedStrategies': instance.relatedStrategies,
      'tags': instance.tags,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$StrategyCategoryEnumMap = {
  StrategyCategory.prepayment: 'prepayment',
  StrategyCategory.refinancing: 'refinancing',
  StrategyCategory.structureOptimization: 'structure_optimization',
  StrategyCategory.taxPlanning: 'tax_planning',
  StrategyCategory.alternativeApproach: 'alternative_approach',
  StrategyCategory.negotiation: 'negotiation',
};

const _$StrategyDifficultyEnumMap = {
  StrategyDifficulty.easy: 'easy',
  StrategyDifficulty.medium: 'medium',
  StrategyDifficulty.hard: 'hard',
};

_$StrategyResultImpl _$$StrategyResultImplFromJson(Map<String, dynamic> json) =>
    _$StrategyResultImpl(
      strategy:
          StrategyModel.fromJson(json['strategy'] as Map<String, dynamic>),
      originalLoan: json['originalLoan'] as Map<String, dynamic>,
      modifiedLoan: json['modifiedLoan'] as Map<String, dynamic>,
      interestSaved: (json['interestSaved'] as num).toDouble(),
      timeSaved: (json['timeSaved'] as num).toDouble(),
      monthlyPaymentChange: (json['monthlyPaymentChange'] as num).toDouble(),
      implementationCost:
          (json['implementationCost'] as num?)?.toDouble() ?? 0.0,
      netSavings: (json['netSavings'] as num).toDouble(),
      breakEvenMonths: (json['breakEvenMonths'] as num?)?.toDouble(),
      isRecommended: json['isRecommended'] as bool,
      recommendationReason: json['recommendationReason'] as String?,
      riskLevel: $enumDecode(_$StrategyRiskEnumMap, json['riskLevel']),
      parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$StrategyResultImplToJson(
        _$StrategyResultImpl instance) =>
    <String, dynamic>{
      'strategy': instance.strategy,
      'originalLoan': instance.originalLoan,
      'modifiedLoan': instance.modifiedLoan,
      'interestSaved': instance.interestSaved,
      'timeSaved': instance.timeSaved,
      'monthlyPaymentChange': instance.monthlyPaymentChange,
      'implementationCost': instance.implementationCost,
      'netSavings': instance.netSavings,
      'breakEvenMonths': instance.breakEvenMonths,
      'isRecommended': instance.isRecommended,
      'recommendationReason': instance.recommendationReason,
      'riskLevel': _$StrategyRiskEnumMap[instance.riskLevel]!,
      'parameters': instance.parameters,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };

const _$StrategyRiskEnumMap = {
  StrategyRisk.low: 'low',
  StrategyRisk.medium: 'medium',
  StrategyRisk.high: 'high',
};
