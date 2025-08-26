// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanModel _$LoanModelFromJson(Map<String, dynamic> json) {
  return _LoanModel.fromJson(json);
}

/// @nodoc
mixin _$LoanModel {
  /// Principal loan amount in INR
  double get loanAmount => throw _privateConstructorUsedError;

  /// Annual interest rate as percentage (e.g., 8.5 for 8.5%)
  double get annualInterestRate => throw _privateConstructorUsedError;

  /// Loan tenure in years
  int get tenureYears => throw _privateConstructorUsedError;

  /// Property value for LTV calculation (optional)
  double? get propertyValue => throw _privateConstructorUsedError;

  /// Monthly income for affordability calculation (optional)
  double? get monthlyIncome => throw _privateConstructorUsedError;

  /// Processing fee and other charges
  double get processingFee => throw _privateConstructorUsedError;

  /// Insurance premium (optional)
  double? get insurancePremium => throw _privateConstructorUsedError;

  /// Extra EMI amount per month (for prepayment strategy)
  double get extraEMIAmount => throw _privateConstructorUsedError;

  /// One-time extra principal payment
  double get lumpSumPayment => throw _privateConstructorUsedError;

  /// Month when lump sum is paid (1-based index)
  int get lumpSumMonth => throw _privateConstructorUsedError;

  /// Loan type for different calculation methods
  LoanType get loanType => throw _privateConstructorUsedError;

  /// Interest rate type
  InterestRateType get rateType => throw _privateConstructorUsedError;

  /// Date when loan was/will be started
  DateTime? get loanStartDate => throw _privateConstructorUsedError;

  /// Bank or lender name (optional)
  String? get bankName => throw _privateConstructorUsedError;

  /// Whether this loan data has been modified
  bool get isModified => throw _privateConstructorUsedError;

  /// Last calculation timestamp for cache validation
  DateTime? get lastCalculated => throw _privateConstructorUsedError;

  /// Serializes this LoanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanModelCopyWith<LoanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanModelCopyWith<$Res> {
  factory $LoanModelCopyWith(LoanModel value, $Res Function(LoanModel) then) =
      _$LoanModelCopyWithImpl<$Res, LoanModel>;
  @useResult
  $Res call(
      {double loanAmount,
      double annualInterestRate,
      int tenureYears,
      double? propertyValue,
      double? monthlyIncome,
      double processingFee,
      double? insurancePremium,
      double extraEMIAmount,
      double lumpSumPayment,
      int lumpSumMonth,
      LoanType loanType,
      InterestRateType rateType,
      DateTime? loanStartDate,
      String? bankName,
      bool isModified,
      DateTime? lastCalculated});
}

/// @nodoc
class _$LoanModelCopyWithImpl<$Res, $Val extends LoanModel>
    implements $LoanModelCopyWith<$Res> {
  _$LoanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanAmount = null,
    Object? annualInterestRate = null,
    Object? tenureYears = null,
    Object? propertyValue = freezed,
    Object? monthlyIncome = freezed,
    Object? processingFee = null,
    Object? insurancePremium = freezed,
    Object? extraEMIAmount = null,
    Object? lumpSumPayment = null,
    Object? lumpSumMonth = null,
    Object? loanType = null,
    Object? rateType = null,
    Object? loanStartDate = freezed,
    Object? bankName = freezed,
    Object? isModified = null,
    Object? lastCalculated = freezed,
  }) {
    return _then(_value.copyWith(
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as double,
      annualInterestRate: null == annualInterestRate
          ? _value.annualInterestRate
          : annualInterestRate // ignore: cast_nullable_to_non_nullable
              as double,
      tenureYears: null == tenureYears
          ? _value.tenureYears
          : tenureYears // ignore: cast_nullable_to_non_nullable
              as int,
      propertyValue: freezed == propertyValue
          ? _value.propertyValue
          : propertyValue // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyIncome: freezed == monthlyIncome
          ? _value.monthlyIncome
          : monthlyIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      processingFee: null == processingFee
          ? _value.processingFee
          : processingFee // ignore: cast_nullable_to_non_nullable
              as double,
      insurancePremium: freezed == insurancePremium
          ? _value.insurancePremium
          : insurancePremium // ignore: cast_nullable_to_non_nullable
              as double?,
      extraEMIAmount: null == extraEMIAmount
          ? _value.extraEMIAmount
          : extraEMIAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lumpSumPayment: null == lumpSumPayment
          ? _value.lumpSumPayment
          : lumpSumPayment // ignore: cast_nullable_to_non_nullable
              as double,
      lumpSumMonth: null == lumpSumMonth
          ? _value.lumpSumMonth
          : lumpSumMonth // ignore: cast_nullable_to_non_nullable
              as int,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as LoanType,
      rateType: null == rateType
          ? _value.rateType
          : rateType // ignore: cast_nullable_to_non_nullable
              as InterestRateType,
      loanStartDate: freezed == loanStartDate
          ? _value.loanStartDate
          : loanStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      isModified: null == isModified
          ? _value.isModified
          : isModified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCalculated: freezed == lastCalculated
          ? _value.lastCalculated
          : lastCalculated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanModelImplCopyWith<$Res>
    implements $LoanModelCopyWith<$Res> {
  factory _$$LoanModelImplCopyWith(
          _$LoanModelImpl value, $Res Function(_$LoanModelImpl) then) =
      __$$LoanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double loanAmount,
      double annualInterestRate,
      int tenureYears,
      double? propertyValue,
      double? monthlyIncome,
      double processingFee,
      double? insurancePremium,
      double extraEMIAmount,
      double lumpSumPayment,
      int lumpSumMonth,
      LoanType loanType,
      InterestRateType rateType,
      DateTime? loanStartDate,
      String? bankName,
      bool isModified,
      DateTime? lastCalculated});
}

/// @nodoc
class __$$LoanModelImplCopyWithImpl<$Res>
    extends _$LoanModelCopyWithImpl<$Res, _$LoanModelImpl>
    implements _$$LoanModelImplCopyWith<$Res> {
  __$$LoanModelImplCopyWithImpl(
      _$LoanModelImpl _value, $Res Function(_$LoanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanAmount = null,
    Object? annualInterestRate = null,
    Object? tenureYears = null,
    Object? propertyValue = freezed,
    Object? monthlyIncome = freezed,
    Object? processingFee = null,
    Object? insurancePremium = freezed,
    Object? extraEMIAmount = null,
    Object? lumpSumPayment = null,
    Object? lumpSumMonth = null,
    Object? loanType = null,
    Object? rateType = null,
    Object? loanStartDate = freezed,
    Object? bankName = freezed,
    Object? isModified = null,
    Object? lastCalculated = freezed,
  }) {
    return _then(_$LoanModelImpl(
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as double,
      annualInterestRate: null == annualInterestRate
          ? _value.annualInterestRate
          : annualInterestRate // ignore: cast_nullable_to_non_nullable
              as double,
      tenureYears: null == tenureYears
          ? _value.tenureYears
          : tenureYears // ignore: cast_nullable_to_non_nullable
              as int,
      propertyValue: freezed == propertyValue
          ? _value.propertyValue
          : propertyValue // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyIncome: freezed == monthlyIncome
          ? _value.monthlyIncome
          : monthlyIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      processingFee: null == processingFee
          ? _value.processingFee
          : processingFee // ignore: cast_nullable_to_non_nullable
              as double,
      insurancePremium: freezed == insurancePremium
          ? _value.insurancePremium
          : insurancePremium // ignore: cast_nullable_to_non_nullable
              as double?,
      extraEMIAmount: null == extraEMIAmount
          ? _value.extraEMIAmount
          : extraEMIAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lumpSumPayment: null == lumpSumPayment
          ? _value.lumpSumPayment
          : lumpSumPayment // ignore: cast_nullable_to_non_nullable
              as double,
      lumpSumMonth: null == lumpSumMonth
          ? _value.lumpSumMonth
          : lumpSumMonth // ignore: cast_nullable_to_non_nullable
              as int,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as LoanType,
      rateType: null == rateType
          ? _value.rateType
          : rateType // ignore: cast_nullable_to_non_nullable
              as InterestRateType,
      loanStartDate: freezed == loanStartDate
          ? _value.loanStartDate
          : loanStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      isModified: null == isModified
          ? _value.isModified
          : isModified // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCalculated: freezed == lastCalculated
          ? _value.lastCalculated
          : lastCalculated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanModelImpl implements _LoanModel {
  const _$LoanModelImpl(
      {this.loanAmount = 3000000.0,
      this.annualInterestRate = 8.5,
      this.tenureYears = 20,
      this.propertyValue,
      this.monthlyIncome,
      this.processingFee = 0.0,
      this.insurancePremium,
      this.extraEMIAmount = 0.0,
      this.lumpSumPayment = 0.0,
      this.lumpSumMonth = 0,
      this.loanType = LoanType.homeLoan,
      this.rateType = InterestRateType.fixed,
      this.loanStartDate,
      this.bankName,
      this.isModified = false,
      this.lastCalculated});

  factory _$LoanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanModelImplFromJson(json);

  /// Principal loan amount in INR
  @override
  @JsonKey()
  final double loanAmount;

  /// Annual interest rate as percentage (e.g., 8.5 for 8.5%)
  @override
  @JsonKey()
  final double annualInterestRate;

  /// Loan tenure in years
  @override
  @JsonKey()
  final int tenureYears;

  /// Property value for LTV calculation (optional)
  @override
  final double? propertyValue;

  /// Monthly income for affordability calculation (optional)
  @override
  final double? monthlyIncome;

  /// Processing fee and other charges
  @override
  @JsonKey()
  final double processingFee;

  /// Insurance premium (optional)
  @override
  final double? insurancePremium;

  /// Extra EMI amount per month (for prepayment strategy)
  @override
  @JsonKey()
  final double extraEMIAmount;

  /// One-time extra principal payment
  @override
  @JsonKey()
  final double lumpSumPayment;

  /// Month when lump sum is paid (1-based index)
  @override
  @JsonKey()
  final int lumpSumMonth;

  /// Loan type for different calculation methods
  @override
  @JsonKey()
  final LoanType loanType;

  /// Interest rate type
  @override
  @JsonKey()
  final InterestRateType rateType;

  /// Date when loan was/will be started
  @override
  final DateTime? loanStartDate;

  /// Bank or lender name (optional)
  @override
  final String? bankName;

  /// Whether this loan data has been modified
  @override
  @JsonKey()
  final bool isModified;

  /// Last calculation timestamp for cache validation
  @override
  final DateTime? lastCalculated;

  @override
  String toString() {
    return 'LoanModel(loanAmount: $loanAmount, annualInterestRate: $annualInterestRate, tenureYears: $tenureYears, propertyValue: $propertyValue, monthlyIncome: $monthlyIncome, processingFee: $processingFee, insurancePremium: $insurancePremium, extraEMIAmount: $extraEMIAmount, lumpSumPayment: $lumpSumPayment, lumpSumMonth: $lumpSumMonth, loanType: $loanType, rateType: $rateType, loanStartDate: $loanStartDate, bankName: $bankName, isModified: $isModified, lastCalculated: $lastCalculated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanModelImpl &&
            (identical(other.loanAmount, loanAmount) ||
                other.loanAmount == loanAmount) &&
            (identical(other.annualInterestRate, annualInterestRate) ||
                other.annualInterestRate == annualInterestRate) &&
            (identical(other.tenureYears, tenureYears) ||
                other.tenureYears == tenureYears) &&
            (identical(other.propertyValue, propertyValue) ||
                other.propertyValue == propertyValue) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.processingFee, processingFee) ||
                other.processingFee == processingFee) &&
            (identical(other.insurancePremium, insurancePremium) ||
                other.insurancePremium == insurancePremium) &&
            (identical(other.extraEMIAmount, extraEMIAmount) ||
                other.extraEMIAmount == extraEMIAmount) &&
            (identical(other.lumpSumPayment, lumpSumPayment) ||
                other.lumpSumPayment == lumpSumPayment) &&
            (identical(other.lumpSumMonth, lumpSumMonth) ||
                other.lumpSumMonth == lumpSumMonth) &&
            (identical(other.loanType, loanType) ||
                other.loanType == loanType) &&
            (identical(other.rateType, rateType) ||
                other.rateType == rateType) &&
            (identical(other.loanStartDate, loanStartDate) ||
                other.loanStartDate == loanStartDate) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.isModified, isModified) ||
                other.isModified == isModified) &&
            (identical(other.lastCalculated, lastCalculated) ||
                other.lastCalculated == lastCalculated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      loanAmount,
      annualInterestRate,
      tenureYears,
      propertyValue,
      monthlyIncome,
      processingFee,
      insurancePremium,
      extraEMIAmount,
      lumpSumPayment,
      lumpSumMonth,
      loanType,
      rateType,
      loanStartDate,
      bankName,
      isModified,
      lastCalculated);

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      __$$LoanModelImplCopyWithImpl<_$LoanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanModelImplToJson(
      this,
    );
  }
}

abstract class _LoanModel implements LoanModel {
  const factory _LoanModel(
      {final double loanAmount,
      final double annualInterestRate,
      final int tenureYears,
      final double? propertyValue,
      final double? monthlyIncome,
      final double processingFee,
      final double? insurancePremium,
      final double extraEMIAmount,
      final double lumpSumPayment,
      final int lumpSumMonth,
      final LoanType loanType,
      final InterestRateType rateType,
      final DateTime? loanStartDate,
      final String? bankName,
      final bool isModified,
      final DateTime? lastCalculated}) = _$LoanModelImpl;

  factory _LoanModel.fromJson(Map<String, dynamic> json) =
      _$LoanModelImpl.fromJson;

  /// Principal loan amount in INR
  @override
  double get loanAmount;

  /// Annual interest rate as percentage (e.g., 8.5 for 8.5%)
  @override
  double get annualInterestRate;

  /// Loan tenure in years
  @override
  int get tenureYears;

  /// Property value for LTV calculation (optional)
  @override
  double? get propertyValue;

  /// Monthly income for affordability calculation (optional)
  @override
  double? get monthlyIncome;

  /// Processing fee and other charges
  @override
  double get processingFee;

  /// Insurance premium (optional)
  @override
  double? get insurancePremium;

  /// Extra EMI amount per month (for prepayment strategy)
  @override
  double get extraEMIAmount;

  /// One-time extra principal payment
  @override
  double get lumpSumPayment;

  /// Month when lump sum is paid (1-based index)
  @override
  int get lumpSumMonth;

  /// Loan type for different calculation methods
  @override
  LoanType get loanType;

  /// Interest rate type
  @override
  InterestRateType get rateType;

  /// Date when loan was/will be started
  @override
  DateTime? get loanStartDate;

  /// Bank or lender name (optional)
  @override
  String? get bankName;

  /// Whether this loan data has been modified
  @override
  bool get isModified;

  /// Last calculation timestamp for cache validation
  @override
  DateTime? get lastCalculated;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
