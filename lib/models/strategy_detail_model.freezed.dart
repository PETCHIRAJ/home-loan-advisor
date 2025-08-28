// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'strategy_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StrategyDetailModel _$StrategyDetailModelFromJson(Map<String, dynamic> json) {
  return _StrategyDetailModel.fromJson(json);
}

/// @nodoc
mixin _$StrategyDetailModel {
  StrategyType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  StrategyCategory get category => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData? get icon => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? get accentColor => throw _privateConstructorUsedError;
  List<String> get implementationSteps => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  List<String> get considerations => throw _privateConstructorUsedError;
  int get difficultyLevel => throw _privateConstructorUsedError; // 1-5 scale
  Duration get estimatedTime =>
      throw _privateConstructorUsedError; // Time to implement
  bool get requiresCalculation => throw _privateConstructorUsedError;
  bool get hasVisualComponent => throw _privateConstructorUsedError;
  String? get calculatorHint => throw _privateConstructorUsedError;

  /// Serializes this StrategyDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StrategyDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrategyDetailModelCopyWith<StrategyDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyDetailModelCopyWith<$Res> {
  factory $StrategyDetailModelCopyWith(
          StrategyDetailModel value, $Res Function(StrategyDetailModel) then) =
      _$StrategyDetailModelCopyWithImpl<$Res, StrategyDetailModel>;
  @useResult
  $Res call(
      {StrategyType type,
      String title,
      String description,
      StrategyCategory category,
      @JsonKey(includeFromJson: false, includeToJson: false) IconData? icon,
      @JsonKey(includeFromJson: false, includeToJson: false) Color? accentColor,
      List<String> implementationSteps,
      List<String> tips,
      List<String> considerations,
      int difficultyLevel,
      Duration estimatedTime,
      bool requiresCalculation,
      bool hasVisualComponent,
      String? calculatorHint});
}

/// @nodoc
class _$StrategyDetailModelCopyWithImpl<$Res, $Val extends StrategyDetailModel>
    implements $StrategyDetailModelCopyWith<$Res> {
  _$StrategyDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrategyDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? icon = freezed,
    Object? accentColor = freezed,
    Object? implementationSteps = null,
    Object? tips = null,
    Object? considerations = null,
    Object? difficultyLevel = null,
    Object? estimatedTime = null,
    Object? requiresCalculation = null,
    Object? hasVisualComponent = null,
    Object? calculatorHint = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StrategyType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as StrategyCategory,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      implementationSteps: null == implementationSteps
          ? _value.implementationSteps
          : implementationSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tips: null == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      considerations: null == considerations
          ? _value.considerations
          : considerations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      requiresCalculation: null == requiresCalculation
          ? _value.requiresCalculation
          : requiresCalculation // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVisualComponent: null == hasVisualComponent
          ? _value.hasVisualComponent
          : hasVisualComponent // ignore: cast_nullable_to_non_nullable
              as bool,
      calculatorHint: freezed == calculatorHint
          ? _value.calculatorHint
          : calculatorHint // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrategyDetailModelImplCopyWith<$Res>
    implements $StrategyDetailModelCopyWith<$Res> {
  factory _$$StrategyDetailModelImplCopyWith(_$StrategyDetailModelImpl value,
          $Res Function(_$StrategyDetailModelImpl) then) =
      __$$StrategyDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StrategyType type,
      String title,
      String description,
      StrategyCategory category,
      @JsonKey(includeFromJson: false, includeToJson: false) IconData? icon,
      @JsonKey(includeFromJson: false, includeToJson: false) Color? accentColor,
      List<String> implementationSteps,
      List<String> tips,
      List<String> considerations,
      int difficultyLevel,
      Duration estimatedTime,
      bool requiresCalculation,
      bool hasVisualComponent,
      String? calculatorHint});
}

/// @nodoc
class __$$StrategyDetailModelImplCopyWithImpl<$Res>
    extends _$StrategyDetailModelCopyWithImpl<$Res, _$StrategyDetailModelImpl>
    implements _$$StrategyDetailModelImplCopyWith<$Res> {
  __$$StrategyDetailModelImplCopyWithImpl(_$StrategyDetailModelImpl _value,
      $Res Function(_$StrategyDetailModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrategyDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? icon = freezed,
    Object? accentColor = freezed,
    Object? implementationSteps = null,
    Object? tips = null,
    Object? considerations = null,
    Object? difficultyLevel = null,
    Object? estimatedTime = null,
    Object? requiresCalculation = null,
    Object? hasVisualComponent = null,
    Object? calculatorHint = freezed,
  }) {
    return _then(_$StrategyDetailModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StrategyType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as StrategyCategory,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      implementationSteps: null == implementationSteps
          ? _value._implementationSteps
          : implementationSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tips: null == tips
          ? _value._tips
          : tips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      considerations: null == considerations
          ? _value._considerations
          : considerations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      requiresCalculation: null == requiresCalculation
          ? _value.requiresCalculation
          : requiresCalculation // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVisualComponent: null == hasVisualComponent
          ? _value.hasVisualComponent
          : hasVisualComponent // ignore: cast_nullable_to_non_nullable
              as bool,
      calculatorHint: freezed == calculatorHint
          ? _value.calculatorHint
          : calculatorHint // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategyDetailModelImpl implements _StrategyDetailModel {
  const _$StrategyDetailModelImpl(
      {required this.type,
      required this.title,
      required this.description,
      required this.category,
      @JsonKey(includeFromJson: false, includeToJson: false) this.icon,
      @JsonKey(includeFromJson: false, includeToJson: false) this.accentColor,
      required final List<String> implementationSteps,
      required final List<String> tips,
      required final List<String> considerations,
      required this.difficultyLevel,
      required this.estimatedTime,
      this.requiresCalculation = false,
      this.hasVisualComponent = false,
      this.calculatorHint})
      : _implementationSteps = implementationSteps,
        _tips = tips,
        _considerations = considerations;

  factory _$StrategyDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategyDetailModelImplFromJson(json);

  @override
  final StrategyType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final StrategyCategory category;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final IconData? icon;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color? accentColor;
  final List<String> _implementationSteps;
  @override
  List<String> get implementationSteps {
    if (_implementationSteps is EqualUnmodifiableListView)
      return _implementationSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_implementationSteps);
  }

  final List<String> _tips;
  @override
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  final List<String> _considerations;
  @override
  List<String> get considerations {
    if (_considerations is EqualUnmodifiableListView) return _considerations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_considerations);
  }

  @override
  final int difficultyLevel;
// 1-5 scale
  @override
  final Duration estimatedTime;
// Time to implement
  @override
  @JsonKey()
  final bool requiresCalculation;
  @override
  @JsonKey()
  final bool hasVisualComponent;
  @override
  final String? calculatorHint;

  @override
  String toString() {
    return 'StrategyDetailModel(type: $type, title: $title, description: $description, category: $category, icon: $icon, accentColor: $accentColor, implementationSteps: $implementationSteps, tips: $tips, considerations: $considerations, difficultyLevel: $difficultyLevel, estimatedTime: $estimatedTime, requiresCalculation: $requiresCalculation, hasVisualComponent: $hasVisualComponent, calculatorHint: $calculatorHint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategyDetailModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            const DeepCollectionEquality()
                .equals(other._implementationSteps, _implementationSteps) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            const DeepCollectionEquality()
                .equals(other._considerations, _considerations) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.requiresCalculation, requiresCalculation) ||
                other.requiresCalculation == requiresCalculation) &&
            (identical(other.hasVisualComponent, hasVisualComponent) ||
                other.hasVisualComponent == hasVisualComponent) &&
            (identical(other.calculatorHint, calculatorHint) ||
                other.calculatorHint == calculatorHint));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      title,
      description,
      category,
      icon,
      accentColor,
      const DeepCollectionEquality().hash(_implementationSteps),
      const DeepCollectionEquality().hash(_tips),
      const DeepCollectionEquality().hash(_considerations),
      difficultyLevel,
      estimatedTime,
      requiresCalculation,
      hasVisualComponent,
      calculatorHint);

  /// Create a copy of StrategyDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategyDetailModelImplCopyWith<_$StrategyDetailModelImpl> get copyWith =>
      __$$StrategyDetailModelImplCopyWithImpl<_$StrategyDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategyDetailModelImplToJson(
      this,
    );
  }
}

abstract class _StrategyDetailModel implements StrategyDetailModel {
  const factory _StrategyDetailModel(
      {required final StrategyType type,
      required final String title,
      required final String description,
      required final StrategyCategory category,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final IconData? icon,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Color? accentColor,
      required final List<String> implementationSteps,
      required final List<String> tips,
      required final List<String> considerations,
      required final int difficultyLevel,
      required final Duration estimatedTime,
      final bool requiresCalculation,
      final bool hasVisualComponent,
      final String? calculatorHint}) = _$StrategyDetailModelImpl;

  factory _StrategyDetailModel.fromJson(Map<String, dynamic> json) =
      _$StrategyDetailModelImpl.fromJson;

  @override
  StrategyType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  StrategyCategory get category;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData? get icon;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? get accentColor;
  @override
  List<String> get implementationSteps;
  @override
  List<String> get tips;
  @override
  List<String> get considerations;
  @override
  int get difficultyLevel; // 1-5 scale
  @override
  Duration get estimatedTime; // Time to implement
  @override
  bool get requiresCalculation;
  @override
  bool get hasVisualComponent;
  @override
  String? get calculatorHint;

  /// Create a copy of StrategyDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrategyDetailModelImplCopyWith<_$StrategyDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StrategyImpact _$StrategyImpactFromJson(Map<String, dynamic> json) {
  return _StrategyImpact.fromJson(json);
}

/// @nodoc
mixin _$StrategyImpact {
  MetricData get primaryMetric => throw _privateConstructorUsedError;
  List<MetricData> get secondaryMetrics => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  StrategyActionability get actionability => throw _privateConstructorUsedError;

  /// Serializes this StrategyImpact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrategyImpactCopyWith<StrategyImpact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyImpactCopyWith<$Res> {
  factory $StrategyImpactCopyWith(
          StrategyImpact value, $Res Function(StrategyImpact) then) =
      _$StrategyImpactCopyWithImpl<$Res, StrategyImpact>;
  @useResult
  $Res call(
      {MetricData primaryMetric,
      List<MetricData> secondaryMetrics,
      String description,
      StrategyActionability actionability});

  $MetricDataCopyWith<$Res> get primaryMetric;
}

/// @nodoc
class _$StrategyImpactCopyWithImpl<$Res, $Val extends StrategyImpact>
    implements $StrategyImpactCopyWith<$Res> {
  _$StrategyImpactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryMetric = null,
    Object? secondaryMetrics = null,
    Object? description = null,
    Object? actionability = null,
  }) {
    return _then(_value.copyWith(
      primaryMetric: null == primaryMetric
          ? _value.primaryMetric
          : primaryMetric // ignore: cast_nullable_to_non_nullable
              as MetricData,
      secondaryMetrics: null == secondaryMetrics
          ? _value.secondaryMetrics
          : secondaryMetrics // ignore: cast_nullable_to_non_nullable
              as List<MetricData>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      actionability: null == actionability
          ? _value.actionability
          : actionability // ignore: cast_nullable_to_non_nullable
              as StrategyActionability,
    ) as $Val);
  }

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricDataCopyWith<$Res> get primaryMetric {
    return $MetricDataCopyWith<$Res>(_value.primaryMetric, (value) {
      return _then(_value.copyWith(primaryMetric: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StrategyImpactImplCopyWith<$Res>
    implements $StrategyImpactCopyWith<$Res> {
  factory _$$StrategyImpactImplCopyWith(_$StrategyImpactImpl value,
          $Res Function(_$StrategyImpactImpl) then) =
      __$$StrategyImpactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MetricData primaryMetric,
      List<MetricData> secondaryMetrics,
      String description,
      StrategyActionability actionability});

  @override
  $MetricDataCopyWith<$Res> get primaryMetric;
}

/// @nodoc
class __$$StrategyImpactImplCopyWithImpl<$Res>
    extends _$StrategyImpactCopyWithImpl<$Res, _$StrategyImpactImpl>
    implements _$$StrategyImpactImplCopyWith<$Res> {
  __$$StrategyImpactImplCopyWithImpl(
      _$StrategyImpactImpl _value, $Res Function(_$StrategyImpactImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryMetric = null,
    Object? secondaryMetrics = null,
    Object? description = null,
    Object? actionability = null,
  }) {
    return _then(_$StrategyImpactImpl(
      primaryMetric: null == primaryMetric
          ? _value.primaryMetric
          : primaryMetric // ignore: cast_nullable_to_non_nullable
              as MetricData,
      secondaryMetrics: null == secondaryMetrics
          ? _value._secondaryMetrics
          : secondaryMetrics // ignore: cast_nullable_to_non_nullable
              as List<MetricData>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      actionability: null == actionability
          ? _value.actionability
          : actionability // ignore: cast_nullable_to_non_nullable
              as StrategyActionability,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategyImpactImpl implements _StrategyImpact {
  const _$StrategyImpactImpl(
      {required this.primaryMetric,
      required final List<MetricData> secondaryMetrics,
      required this.description,
      required this.actionability})
      : _secondaryMetrics = secondaryMetrics;

  factory _$StrategyImpactImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategyImpactImplFromJson(json);

  @override
  final MetricData primaryMetric;
  final List<MetricData> _secondaryMetrics;
  @override
  List<MetricData> get secondaryMetrics {
    if (_secondaryMetrics is EqualUnmodifiableListView)
      return _secondaryMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMetrics);
  }

  @override
  final String description;
  @override
  final StrategyActionability actionability;

  @override
  String toString() {
    return 'StrategyImpact(primaryMetric: $primaryMetric, secondaryMetrics: $secondaryMetrics, description: $description, actionability: $actionability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategyImpactImpl &&
            (identical(other.primaryMetric, primaryMetric) ||
                other.primaryMetric == primaryMetric) &&
            const DeepCollectionEquality()
                .equals(other._secondaryMetrics, _secondaryMetrics) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.actionability, actionability) ||
                other.actionability == actionability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      primaryMetric,
      const DeepCollectionEquality().hash(_secondaryMetrics),
      description,
      actionability);

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategyImpactImplCopyWith<_$StrategyImpactImpl> get copyWith =>
      __$$StrategyImpactImplCopyWithImpl<_$StrategyImpactImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategyImpactImplToJson(
      this,
    );
  }
}

abstract class _StrategyImpact implements StrategyImpact {
  const factory _StrategyImpact(
          {required final MetricData primaryMetric,
          required final List<MetricData> secondaryMetrics,
          required final String description,
          required final StrategyActionability actionability}) =
      _$StrategyImpactImpl;

  factory _StrategyImpact.fromJson(Map<String, dynamic> json) =
      _$StrategyImpactImpl.fromJson;

  @override
  MetricData get primaryMetric;
  @override
  List<MetricData> get secondaryMetrics;
  @override
  String get description;
  @override
  StrategyActionability get actionability;

  /// Create a copy of StrategyImpact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrategyImpactImplCopyWith<_$StrategyImpactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetricData _$MetricDataFromJson(Map<String, dynamic> json) {
  return _MetricData.fromJson(json);
}

/// @nodoc
mixin _$MetricData {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  MetricFormat get format => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  /// Serializes this MetricData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetricData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricDataCopyWith<MetricData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricDataCopyWith<$Res> {
  factory $MetricDataCopyWith(
          MetricData value, $Res Function(MetricData) then) =
      _$MetricDataCopyWithImpl<$Res, MetricData>;
  @useResult
  $Res call({String label, double value, MetricFormat format, String? unit});
}

/// @nodoc
class _$MetricDataCopyWithImpl<$Res, $Val extends MetricData>
    implements $MetricDataCopyWith<$Res> {
  _$MetricDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? format = null,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as MetricFormat,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetricDataImplCopyWith<$Res>
    implements $MetricDataCopyWith<$Res> {
  factory _$$MetricDataImplCopyWith(
          _$MetricDataImpl value, $Res Function(_$MetricDataImpl) then) =
      __$$MetricDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value, MetricFormat format, String? unit});
}

/// @nodoc
class __$$MetricDataImplCopyWithImpl<$Res>
    extends _$MetricDataCopyWithImpl<$Res, _$MetricDataImpl>
    implements _$$MetricDataImplCopyWith<$Res> {
  __$$MetricDataImplCopyWithImpl(
      _$MetricDataImpl _value, $Res Function(_$MetricDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetricData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? format = null,
    Object? unit = freezed,
  }) {
    return _then(_$MetricDataImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as MetricFormat,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetricDataImpl implements _MetricData {
  const _$MetricDataImpl(
      {required this.label,
      required this.value,
      required this.format,
      this.unit});

  factory _$MetricDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricDataImplFromJson(json);

  @override
  final String label;
  @override
  final double value;
  @override
  final MetricFormat format;
  @override
  final String? unit;

  @override
  String toString() {
    return 'MetricData(label: $label, value: $value, format: $format, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, format, unit);

  /// Create a copy of MetricData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricDataImplCopyWith<_$MetricDataImpl> get copyWith =>
      __$$MetricDataImplCopyWithImpl<_$MetricDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricDataImplToJson(
      this,
    );
  }
}

abstract class _MetricData implements MetricData {
  const factory _MetricData(
      {required final String label,
      required final double value,
      required final MetricFormat format,
      final String? unit}) = _$MetricDataImpl;

  factory _MetricData.fromJson(Map<String, dynamic> json) =
      _$MetricDataImpl.fromJson;

  @override
  String get label;
  @override
  double get value;
  @override
  MetricFormat get format;
  @override
  String? get unit;

  /// Create a copy of MetricData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricDataImplCopyWith<_$MetricDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
