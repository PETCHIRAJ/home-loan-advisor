// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strategy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StrategyModel _$StrategyModelFromJson(Map<String, dynamic> json) {
  return _StrategyModel.fromJson(json);
}

/// @nodoc
mixin _$StrategyModel {
  /// Unique identifier for the strategy
  String get id => throw _privateConstructorUsedError;

  /// Strategy title (e.g., "Extra EMI Payment")
  String get title => throw _privateConstructorUsedError;

  /// Brief description of the strategy
  String get description => throw _privateConstructorUsedError;

  /// Detailed explanation of how the strategy works
  String get explanation => throw _privateConstructorUsedError;

  /// Strategy category for grouping
  StrategyCategory get category => throw _privateConstructorUsedError;

  /// Difficulty level for implementation
  StrategyDifficulty get difficulty => throw _privateConstructorUsedError;

  /// Potential savings range (for display)
  String get savingsRange => throw _privateConstructorUsedError;

  /// Implementation time required
  String get timeToImplement => throw _privateConstructorUsedError;

  /// Whether this strategy is recommended for most users
  bool get isRecommended => throw _privateConstructorUsedError;

  /// Whether this strategy is suitable for beginners
  bool get isBeginner => throw _privateConstructorUsedError;

  /// List of pros for this strategy
  List<String> get pros => throw _privateConstructorUsedError;

  /// List of cons for this strategy
  List<String> get cons => throw _privateConstructorUsedError;

  /// Requirements to implement this strategy
  List<String> get requirements => throw _privateConstructorUsedError;

  /// Step-by-step implementation guide
  List<String> get implementationSteps => throw _privateConstructorUsedError;

  /// Related strategy IDs that work well together
  List<String> get relatedStrategies => throw _privateConstructorUsedError;

  /// Tags for search and filtering
  List<String> get tags => throw _privateConstructorUsedError;

  /// When strategy was last updated
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Whether strategy is currently active/enabled
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this StrategyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StrategyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrategyModelCopyWith<StrategyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyModelCopyWith<$Res> {
  factory $StrategyModelCopyWith(
          StrategyModel value, $Res Function(StrategyModel) then) =
      _$StrategyModelCopyWithImpl<$Res, StrategyModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String explanation,
      StrategyCategory category,
      StrategyDifficulty difficulty,
      String savingsRange,
      String timeToImplement,
      bool isRecommended,
      bool isBeginner,
      List<String> pros,
      List<String> cons,
      List<String> requirements,
      List<String> implementationSteps,
      List<String> relatedStrategies,
      List<String> tags,
      DateTime? lastUpdated,
      bool isActive});
}

/// @nodoc
class _$StrategyModelCopyWithImpl<$Res, $Val extends StrategyModel>
    implements $StrategyModelCopyWith<$Res> {
  _$StrategyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrategyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? explanation = null,
    Object? category = null,
    Object? difficulty = null,
    Object? savingsRange = null,
    Object? timeToImplement = null,
    Object? isRecommended = null,
    Object? isBeginner = null,
    Object? pros = null,
    Object? cons = null,
    Object? requirements = null,
    Object? implementationSteps = null,
    Object? relatedStrategies = null,
    Object? tags = null,
    Object? lastUpdated = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as StrategyCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as StrategyDifficulty,
      savingsRange: null == savingsRange
          ? _value.savingsRange
          : savingsRange // ignore: cast_nullable_to_non_nullable
              as String,
      timeToImplement: null == timeToImplement
          ? _value.timeToImplement
          : timeToImplement // ignore: cast_nullable_to_non_nullable
              as String,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      isBeginner: null == isBeginner
          ? _value.isBeginner
          : isBeginner // ignore: cast_nullable_to_non_nullable
              as bool,
      pros: null == pros
          ? _value.pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value.cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requirements: null == requirements
          ? _value.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      implementationSteps: null == implementationSteps
          ? _value.implementationSteps
          : implementationSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedStrategies: null == relatedStrategies
          ? _value.relatedStrategies
          : relatedStrategies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrategyModelImplCopyWith<$Res>
    implements $StrategyModelCopyWith<$Res> {
  factory _$$StrategyModelImplCopyWith(
          _$StrategyModelImpl value, $Res Function(_$StrategyModelImpl) then) =
      __$$StrategyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String explanation,
      StrategyCategory category,
      StrategyDifficulty difficulty,
      String savingsRange,
      String timeToImplement,
      bool isRecommended,
      bool isBeginner,
      List<String> pros,
      List<String> cons,
      List<String> requirements,
      List<String> implementationSteps,
      List<String> relatedStrategies,
      List<String> tags,
      DateTime? lastUpdated,
      bool isActive});
}

/// @nodoc
class __$$StrategyModelImplCopyWithImpl<$Res>
    extends _$StrategyModelCopyWithImpl<$Res, _$StrategyModelImpl>
    implements _$$StrategyModelImplCopyWith<$Res> {
  __$$StrategyModelImplCopyWithImpl(
      _$StrategyModelImpl _value, $Res Function(_$StrategyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrategyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? explanation = null,
    Object? category = null,
    Object? difficulty = null,
    Object? savingsRange = null,
    Object? timeToImplement = null,
    Object? isRecommended = null,
    Object? isBeginner = null,
    Object? pros = null,
    Object? cons = null,
    Object? requirements = null,
    Object? implementationSteps = null,
    Object? relatedStrategies = null,
    Object? tags = null,
    Object? lastUpdated = freezed,
    Object? isActive = null,
  }) {
    return _then(_$StrategyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as StrategyCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as StrategyDifficulty,
      savingsRange: null == savingsRange
          ? _value.savingsRange
          : savingsRange // ignore: cast_nullable_to_non_nullable
              as String,
      timeToImplement: null == timeToImplement
          ? _value.timeToImplement
          : timeToImplement // ignore: cast_nullable_to_non_nullable
              as String,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      isBeginner: null == isBeginner
          ? _value.isBeginner
          : isBeginner // ignore: cast_nullable_to_non_nullable
              as bool,
      pros: null == pros
          ? _value._pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value._cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requirements: null == requirements
          ? _value._requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      implementationSteps: null == implementationSteps
          ? _value._implementationSteps
          : implementationSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedStrategies: null == relatedStrategies
          ? _value._relatedStrategies
          : relatedStrategies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategyModelImpl implements _StrategyModel {
  const _$StrategyModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.explanation,
      required this.category,
      required this.difficulty,
      required this.savingsRange,
      required this.timeToImplement,
      this.isRecommended = false,
      this.isBeginner = true,
      required final List<String> pros,
      required final List<String> cons,
      required final List<String> requirements,
      required final List<String> implementationSteps,
      final List<String> relatedStrategies = const [],
      final List<String> tags = const [],
      this.lastUpdated,
      this.isActive = false})
      : _pros = pros,
        _cons = cons,
        _requirements = requirements,
        _implementationSteps = implementationSteps,
        _relatedStrategies = relatedStrategies,
        _tags = tags;

  factory _$StrategyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategyModelImplFromJson(json);

  /// Unique identifier for the strategy
  @override
  final String id;

  /// Strategy title (e.g., "Extra EMI Payment")
  @override
  final String title;

  /// Brief description of the strategy
  @override
  final String description;

  /// Detailed explanation of how the strategy works
  @override
  final String explanation;

  /// Strategy category for grouping
  @override
  final StrategyCategory category;

  /// Difficulty level for implementation
  @override
  final StrategyDifficulty difficulty;

  /// Potential savings range (for display)
  @override
  final String savingsRange;

  /// Implementation time required
  @override
  final String timeToImplement;

  /// Whether this strategy is recommended for most users
  @override
  @JsonKey()
  final bool isRecommended;

  /// Whether this strategy is suitable for beginners
  @override
  @JsonKey()
  final bool isBeginner;

  /// List of pros for this strategy
  final List<String> _pros;

  /// List of pros for this strategy
  @override
  List<String> get pros {
    if (_pros is EqualUnmodifiableListView) return _pros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pros);
  }

  /// List of cons for this strategy
  final List<String> _cons;

  /// List of cons for this strategy
  @override
  List<String> get cons {
    if (_cons is EqualUnmodifiableListView) return _cons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cons);
  }

  /// Requirements to implement this strategy
  final List<String> _requirements;

  /// Requirements to implement this strategy
  @override
  List<String> get requirements {
    if (_requirements is EqualUnmodifiableListView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requirements);
  }

  /// Step-by-step implementation guide
  final List<String> _implementationSteps;

  /// Step-by-step implementation guide
  @override
  List<String> get implementationSteps {
    if (_implementationSteps is EqualUnmodifiableListView)
      return _implementationSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_implementationSteps);
  }

  /// Related strategy IDs that work well together
  final List<String> _relatedStrategies;

  /// Related strategy IDs that work well together
  @override
  @JsonKey()
  List<String> get relatedStrategies {
    if (_relatedStrategies is EqualUnmodifiableListView)
      return _relatedStrategies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedStrategies);
  }

  /// Tags for search and filtering
  final List<String> _tags;

  /// Tags for search and filtering
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// When strategy was last updated
  @override
  final DateTime? lastUpdated;

  /// Whether strategy is currently active/enabled
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'StrategyModel(id: $id, title: $title, description: $description, explanation: $explanation, category: $category, difficulty: $difficulty, savingsRange: $savingsRange, timeToImplement: $timeToImplement, isRecommended: $isRecommended, isBeginner: $isBeginner, pros: $pros, cons: $cons, requirements: $requirements, implementationSteps: $implementationSteps, relatedStrategies: $relatedStrategies, tags: $tags, lastUpdated: $lastUpdated, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.savingsRange, savingsRange) ||
                other.savingsRange == savingsRange) &&
            (identical(other.timeToImplement, timeToImplement) ||
                other.timeToImplement == timeToImplement) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.isBeginner, isBeginner) ||
                other.isBeginner == isBeginner) &&
            const DeepCollectionEquality().equals(other._pros, _pros) &&
            const DeepCollectionEquality().equals(other._cons, _cons) &&
            const DeepCollectionEquality()
                .equals(other._requirements, _requirements) &&
            const DeepCollectionEquality()
                .equals(other._implementationSteps, _implementationSteps) &&
            const DeepCollectionEquality()
                .equals(other._relatedStrategies, _relatedStrategies) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      explanation,
      category,
      difficulty,
      savingsRange,
      timeToImplement,
      isRecommended,
      isBeginner,
      const DeepCollectionEquality().hash(_pros),
      const DeepCollectionEquality().hash(_cons),
      const DeepCollectionEquality().hash(_requirements),
      const DeepCollectionEquality().hash(_implementationSteps),
      const DeepCollectionEquality().hash(_relatedStrategies),
      const DeepCollectionEquality().hash(_tags),
      lastUpdated,
      isActive);

  /// Create a copy of StrategyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategyModelImplCopyWith<_$StrategyModelImpl> get copyWith =>
      __$$StrategyModelImplCopyWithImpl<_$StrategyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategyModelImplToJson(
      this,
    );
  }
}

abstract class _StrategyModel implements StrategyModel {
  const factory _StrategyModel(
      {required final String id,
      required final String title,
      required final String description,
      required final String explanation,
      required final StrategyCategory category,
      required final StrategyDifficulty difficulty,
      required final String savingsRange,
      required final String timeToImplement,
      final bool isRecommended,
      final bool isBeginner,
      required final List<String> pros,
      required final List<String> cons,
      required final List<String> requirements,
      required final List<String> implementationSteps,
      final List<String> relatedStrategies,
      final List<String> tags,
      final DateTime? lastUpdated,
      final bool isActive}) = _$StrategyModelImpl;

  factory _StrategyModel.fromJson(Map<String, dynamic> json) =
      _$StrategyModelImpl.fromJson;

  /// Unique identifier for the strategy
  @override
  String get id;

  /// Strategy title (e.g., "Extra EMI Payment")
  @override
  String get title;

  /// Brief description of the strategy
  @override
  String get description;

  /// Detailed explanation of how the strategy works
  @override
  String get explanation;

  /// Strategy category for grouping
  @override
  StrategyCategory get category;

  /// Difficulty level for implementation
  @override
  StrategyDifficulty get difficulty;

  /// Potential savings range (for display)
  @override
  String get savingsRange;

  /// Implementation time required
  @override
  String get timeToImplement;

  /// Whether this strategy is recommended for most users
  @override
  bool get isRecommended;

  /// Whether this strategy is suitable for beginners
  @override
  bool get isBeginner;

  /// List of pros for this strategy
  @override
  List<String> get pros;

  /// List of cons for this strategy
  @override
  List<String> get cons;

  /// Requirements to implement this strategy
  @override
  List<String> get requirements;

  /// Step-by-step implementation guide
  @override
  List<String> get implementationSteps;

  /// Related strategy IDs that work well together
  @override
  List<String> get relatedStrategies;

  /// Tags for search and filtering
  @override
  List<String> get tags;

  /// When strategy was last updated
  @override
  DateTime? get lastUpdated;

  /// Whether strategy is currently active/enabled
  @override
  bool get isActive;

  /// Create a copy of StrategyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrategyModelImplCopyWith<_$StrategyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StrategyResult _$StrategyResultFromJson(Map<String, dynamic> json) {
  return _StrategyResult.fromJson(json);
}

/// @nodoc
mixin _$StrategyResult {
  /// Strategy that was applied
  StrategyModel get strategy => throw _privateConstructorUsedError;

  /// Original loan details
  Map<String, dynamic> get originalLoan => throw _privateConstructorUsedError;

  /// Modified loan details after strategy
  Map<String, dynamic> get modifiedLoan => throw _privateConstructorUsedError;

  /// Total interest saved
  double get interestSaved => throw _privateConstructorUsedError;

  /// Time saved in years
  double get timeSaved => throw _privateConstructorUsedError;

  /// Monthly payment change (positive = increase, negative = decrease)
  double get monthlyPaymentChange => throw _privateConstructorUsedError;

  /// Total cost of implementing strategy
  double get implementationCost => throw _privateConstructorUsedError;

  /// Net savings (interest saved - implementation cost)
  double get netSavings => throw _privateConstructorUsedError;

  /// Break-even point in months
  double? get breakEvenMonths => throw _privateConstructorUsedError;

  /// Whether this strategy is recommended for this loan
  bool get isRecommended => throw _privateConstructorUsedError;

  /// Recommendation reason/explanation
  String? get recommendationReason => throw _privateConstructorUsedError;

  /// Risk level of implementing this strategy
  StrategyRisk get riskLevel => throw _privateConstructorUsedError;

  /// Additional parameters specific to strategy
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  /// When this result was calculated
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this StrategyResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrategyResultCopyWith<StrategyResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyResultCopyWith<$Res> {
  factory $StrategyResultCopyWith(
          StrategyResult value, $Res Function(StrategyResult) then) =
      _$StrategyResultCopyWithImpl<$Res, StrategyResult>;
  @useResult
  $Res call(
      {StrategyModel strategy,
      Map<String, dynamic> originalLoan,
      Map<String, dynamic> modifiedLoan,
      double interestSaved,
      double timeSaved,
      double monthlyPaymentChange,
      double implementationCost,
      double netSavings,
      double? breakEvenMonths,
      bool isRecommended,
      String? recommendationReason,
      StrategyRisk riskLevel,
      Map<String, dynamic> parameters,
      DateTime calculatedAt});

  $StrategyModelCopyWith<$Res> get strategy;
}

/// @nodoc
class _$StrategyResultCopyWithImpl<$Res, $Val extends StrategyResult>
    implements $StrategyResultCopyWith<$Res> {
  _$StrategyResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strategy = null,
    Object? originalLoan = null,
    Object? modifiedLoan = null,
    Object? interestSaved = null,
    Object? timeSaved = null,
    Object? monthlyPaymentChange = null,
    Object? implementationCost = null,
    Object? netSavings = null,
    Object? breakEvenMonths = freezed,
    Object? isRecommended = null,
    Object? recommendationReason = freezed,
    Object? riskLevel = null,
    Object? parameters = null,
    Object? calculatedAt = null,
  }) {
    return _then(_value.copyWith(
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as StrategyModel,
      originalLoan: null == originalLoan
          ? _value.originalLoan
          : originalLoan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      modifiedLoan: null == modifiedLoan
          ? _value.modifiedLoan
          : modifiedLoan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      interestSaved: null == interestSaved
          ? _value.interestSaved
          : interestSaved // ignore: cast_nullable_to_non_nullable
              as double,
      timeSaved: null == timeSaved
          ? _value.timeSaved
          : timeSaved // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyPaymentChange: null == monthlyPaymentChange
          ? _value.monthlyPaymentChange
          : monthlyPaymentChange // ignore: cast_nullable_to_non_nullable
              as double,
      implementationCost: null == implementationCost
          ? _value.implementationCost
          : implementationCost // ignore: cast_nullable_to_non_nullable
              as double,
      netSavings: null == netSavings
          ? _value.netSavings
          : netSavings // ignore: cast_nullable_to_non_nullable
              as double,
      breakEvenMonths: freezed == breakEvenMonths
          ? _value.breakEvenMonths
          : breakEvenMonths // ignore: cast_nullable_to_non_nullable
              as double?,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      recommendationReason: freezed == recommendationReason
          ? _value.recommendationReason
          : recommendationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as StrategyRisk,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StrategyModelCopyWith<$Res> get strategy {
    return $StrategyModelCopyWith<$Res>(_value.strategy, (value) {
      return _then(_value.copyWith(strategy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StrategyResultImplCopyWith<$Res>
    implements $StrategyResultCopyWith<$Res> {
  factory _$$StrategyResultImplCopyWith(_$StrategyResultImpl value,
          $Res Function(_$StrategyResultImpl) then) =
      __$$StrategyResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StrategyModel strategy,
      Map<String, dynamic> originalLoan,
      Map<String, dynamic> modifiedLoan,
      double interestSaved,
      double timeSaved,
      double monthlyPaymentChange,
      double implementationCost,
      double netSavings,
      double? breakEvenMonths,
      bool isRecommended,
      String? recommendationReason,
      StrategyRisk riskLevel,
      Map<String, dynamic> parameters,
      DateTime calculatedAt});

  @override
  $StrategyModelCopyWith<$Res> get strategy;
}

/// @nodoc
class __$$StrategyResultImplCopyWithImpl<$Res>
    extends _$StrategyResultCopyWithImpl<$Res, _$StrategyResultImpl>
    implements _$$StrategyResultImplCopyWith<$Res> {
  __$$StrategyResultImplCopyWithImpl(
      _$StrategyResultImpl _value, $Res Function(_$StrategyResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? strategy = null,
    Object? originalLoan = null,
    Object? modifiedLoan = null,
    Object? interestSaved = null,
    Object? timeSaved = null,
    Object? monthlyPaymentChange = null,
    Object? implementationCost = null,
    Object? netSavings = null,
    Object? breakEvenMonths = freezed,
    Object? isRecommended = null,
    Object? recommendationReason = freezed,
    Object? riskLevel = null,
    Object? parameters = null,
    Object? calculatedAt = null,
  }) {
    return _then(_$StrategyResultImpl(
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as StrategyModel,
      originalLoan: null == originalLoan
          ? _value._originalLoan
          : originalLoan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      modifiedLoan: null == modifiedLoan
          ? _value._modifiedLoan
          : modifiedLoan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      interestSaved: null == interestSaved
          ? _value.interestSaved
          : interestSaved // ignore: cast_nullable_to_non_nullable
              as double,
      timeSaved: null == timeSaved
          ? _value.timeSaved
          : timeSaved // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyPaymentChange: null == monthlyPaymentChange
          ? _value.monthlyPaymentChange
          : monthlyPaymentChange // ignore: cast_nullable_to_non_nullable
              as double,
      implementationCost: null == implementationCost
          ? _value.implementationCost
          : implementationCost // ignore: cast_nullable_to_non_nullable
              as double,
      netSavings: null == netSavings
          ? _value.netSavings
          : netSavings // ignore: cast_nullable_to_non_nullable
              as double,
      breakEvenMonths: freezed == breakEvenMonths
          ? _value.breakEvenMonths
          : breakEvenMonths // ignore: cast_nullable_to_non_nullable
              as double?,
      isRecommended: null == isRecommended
          ? _value.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      recommendationReason: freezed == recommendationReason
          ? _value.recommendationReason
          : recommendationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as StrategyRisk,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategyResultImpl implements _StrategyResult {
  const _$StrategyResultImpl(
      {required this.strategy,
      required final Map<String, dynamic> originalLoan,
      required final Map<String, dynamic> modifiedLoan,
      required this.interestSaved,
      required this.timeSaved,
      required this.monthlyPaymentChange,
      this.implementationCost = 0.0,
      required this.netSavings,
      this.breakEvenMonths,
      required this.isRecommended,
      this.recommendationReason,
      required this.riskLevel,
      final Map<String, dynamic> parameters = const {},
      required this.calculatedAt})
      : _originalLoan = originalLoan,
        _modifiedLoan = modifiedLoan,
        _parameters = parameters;

  factory _$StrategyResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategyResultImplFromJson(json);

  /// Strategy that was applied
  @override
  final StrategyModel strategy;

  /// Original loan details
  final Map<String, dynamic> _originalLoan;

  /// Original loan details
  @override
  Map<String, dynamic> get originalLoan {
    if (_originalLoan is EqualUnmodifiableMapView) return _originalLoan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_originalLoan);
  }

  /// Modified loan details after strategy
  final Map<String, dynamic> _modifiedLoan;

  /// Modified loan details after strategy
  @override
  Map<String, dynamic> get modifiedLoan {
    if (_modifiedLoan is EqualUnmodifiableMapView) return _modifiedLoan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_modifiedLoan);
  }

  /// Total interest saved
  @override
  final double interestSaved;

  /// Time saved in years
  @override
  final double timeSaved;

  /// Monthly payment change (positive = increase, negative = decrease)
  @override
  final double monthlyPaymentChange;

  /// Total cost of implementing strategy
  @override
  @JsonKey()
  final double implementationCost;

  /// Net savings (interest saved - implementation cost)
  @override
  final double netSavings;

  /// Break-even point in months
  @override
  final double? breakEvenMonths;

  /// Whether this strategy is recommended for this loan
  @override
  final bool isRecommended;

  /// Recommendation reason/explanation
  @override
  final String? recommendationReason;

  /// Risk level of implementing this strategy
  @override
  final StrategyRisk riskLevel;

  /// Additional parameters specific to strategy
  final Map<String, dynamic> _parameters;

  /// Additional parameters specific to strategy
  @override
  @JsonKey()
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  /// When this result was calculated
  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'StrategyResult(strategy: $strategy, originalLoan: $originalLoan, modifiedLoan: $modifiedLoan, interestSaved: $interestSaved, timeSaved: $timeSaved, monthlyPaymentChange: $monthlyPaymentChange, implementationCost: $implementationCost, netSavings: $netSavings, breakEvenMonths: $breakEvenMonths, isRecommended: $isRecommended, recommendationReason: $recommendationReason, riskLevel: $riskLevel, parameters: $parameters, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategyResultImpl &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            const DeepCollectionEquality()
                .equals(other._originalLoan, _originalLoan) &&
            const DeepCollectionEquality()
                .equals(other._modifiedLoan, _modifiedLoan) &&
            (identical(other.interestSaved, interestSaved) ||
                other.interestSaved == interestSaved) &&
            (identical(other.timeSaved, timeSaved) ||
                other.timeSaved == timeSaved) &&
            (identical(other.monthlyPaymentChange, monthlyPaymentChange) ||
                other.monthlyPaymentChange == monthlyPaymentChange) &&
            (identical(other.implementationCost, implementationCost) ||
                other.implementationCost == implementationCost) &&
            (identical(other.netSavings, netSavings) ||
                other.netSavings == netSavings) &&
            (identical(other.breakEvenMonths, breakEvenMonths) ||
                other.breakEvenMonths == breakEvenMonths) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.recommendationReason, recommendationReason) ||
                other.recommendationReason == recommendationReason) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      strategy,
      const DeepCollectionEquality().hash(_originalLoan),
      const DeepCollectionEquality().hash(_modifiedLoan),
      interestSaved,
      timeSaved,
      monthlyPaymentChange,
      implementationCost,
      netSavings,
      breakEvenMonths,
      isRecommended,
      recommendationReason,
      riskLevel,
      const DeepCollectionEquality().hash(_parameters),
      calculatedAt);

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategyResultImplCopyWith<_$StrategyResultImpl> get copyWith =>
      __$$StrategyResultImplCopyWithImpl<_$StrategyResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategyResultImplToJson(
      this,
    );
  }
}

abstract class _StrategyResult implements StrategyResult {
  const factory _StrategyResult(
      {required final StrategyModel strategy,
      required final Map<String, dynamic> originalLoan,
      required final Map<String, dynamic> modifiedLoan,
      required final double interestSaved,
      required final double timeSaved,
      required final double monthlyPaymentChange,
      final double implementationCost,
      required final double netSavings,
      final double? breakEvenMonths,
      required final bool isRecommended,
      final String? recommendationReason,
      required final StrategyRisk riskLevel,
      final Map<String, dynamic> parameters,
      required final DateTime calculatedAt}) = _$StrategyResultImpl;

  factory _StrategyResult.fromJson(Map<String, dynamic> json) =
      _$StrategyResultImpl.fromJson;

  /// Strategy that was applied
  @override
  StrategyModel get strategy;

  /// Original loan details
  @override
  Map<String, dynamic> get originalLoan;

  /// Modified loan details after strategy
  @override
  Map<String, dynamic> get modifiedLoan;

  /// Total interest saved
  @override
  double get interestSaved;

  /// Time saved in years
  @override
  double get timeSaved;

  /// Monthly payment change (positive = increase, negative = decrease)
  @override
  double get monthlyPaymentChange;

  /// Total cost of implementing strategy
  @override
  double get implementationCost;

  /// Net savings (interest saved - implementation cost)
  @override
  double get netSavings;

  /// Break-even point in months
  @override
  double? get breakEvenMonths;

  /// Whether this strategy is recommended for this loan
  @override
  bool get isRecommended;

  /// Recommendation reason/explanation
  @override
  String? get recommendationReason;

  /// Risk level of implementing this strategy
  @override
  StrategyRisk get riskLevel;

  /// Additional parameters specific to strategy
  @override
  Map<String, dynamic> get parameters;

  /// When this result was calculated
  @override
  DateTime get calculatedAt;

  /// Create a copy of StrategyResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrategyResultImplCopyWith<_$StrategyResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
