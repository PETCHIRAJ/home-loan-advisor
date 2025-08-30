// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculationHistory _$CalculationHistoryFromJson(Map<String, dynamic> json) =>
    CalculationHistory(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      parameters: LoanParameters.fromJson(
        json['parameters'] as Map<String, dynamic>,
      ),
      result: EMIResult.fromJson(json['result'] as Map<String, dynamic>),
      name: json['name'] as String?,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CalculationHistoryToJson(CalculationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'parameters': instance.parameters,
      'result': instance.result,
      'name': instance.name,
      'isBookmarked': instance.isBookmarked,
      'metadata': instance.metadata,
    };

HistoryItem _$HistoryItemFromJson(Map<String, dynamic> json) => HistoryItem(
  id: json['id'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  loanAmount: (json['loanAmount'] as num).toDouble(),
  monthlyEMI: (json['monthlyEMI'] as num).toDouble(),
  interestRate: (json['interestRate'] as num).toDouble(),
  tenureYears: (json['tenureYears'] as num).toInt(),
  name: json['name'] as String?,
  isBookmarked: json['isBookmarked'] as bool? ?? false,
  totalInterest: (json['totalInterest'] as num).toDouble(),
  taxSavings: (json['taxSavings'] as num).toDouble(),
  hasPMAY: json['hasPMAY'] as bool? ?? false,
);

Map<String, dynamic> _$HistoryItemToJson(HistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'loanAmount': instance.loanAmount,
      'monthlyEMI': instance.monthlyEMI,
      'interestRate': instance.interestRate,
      'tenureYears': instance.tenureYears,
      'name': instance.name,
      'isBookmarked': instance.isBookmarked,
      'totalInterest': instance.totalInterest,
      'taxSavings': instance.taxSavings,
      'hasPMAY': instance.hasPMAY,
    };

HistoryStats _$HistoryStatsFromJson(Map<String, dynamic> json) => HistoryStats(
  totalCalculations: (json['totalCalculations'] as num).toInt(),
  averageLoanAmount: (json['averageLoanAmount'] as num).toDouble(),
  averageInterestRate: (json['averageInterestRate'] as num).toDouble(),
  mostCommonTenure: (json['mostCommonTenure'] as num).toInt(),
  totalPotentialSavings: (json['totalPotentialSavings'] as num).toDouble(),
  firstCalculationDate: json['firstCalculationDate'] == null
      ? null
      : DateTime.parse(json['firstCalculationDate'] as String),
  lastCalculationDate: json['lastCalculationDate'] == null
      ? null
      : DateTime.parse(json['lastCalculationDate'] as String),
  bookmarkedCount: (json['bookmarkedCount'] as num).toInt(),
);

Map<String, dynamic> _$HistoryStatsToJson(HistoryStats instance) =>
    <String, dynamic>{
      'totalCalculations': instance.totalCalculations,
      'averageLoanAmount': instance.averageLoanAmount,
      'averageInterestRate': instance.averageInterestRate,
      'mostCommonTenure': instance.mostCommonTenure,
      'totalPotentialSavings': instance.totalPotentialSavings,
      'firstCalculationDate': instance.firstCalculationDate?.toIso8601String(),
      'lastCalculationDate': instance.lastCalculationDate?.toIso8601String(),
      'bookmarkedCount': instance.bookmarkedCount,
    };
