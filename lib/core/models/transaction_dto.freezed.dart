// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionDto {

 int get id;@JsonKey(name: 'user_id', fromJson: _toInt) int get userId;@JsonKey(name: 'transaction_type', fromJson: _toTransactionType) String get transactionType;@JsonKey(name: 'transaction_category_id', fromJson: _toInt) int get transactionCategoryId;@JsonKey(fromJson: _toDouble) double get amount;@JsonKey(name: 'account_id', fromJson: _toIntNullable) int? get accountId;@JsonKey(name: 'project_id', fromJson: _toIntNullable) int? get projectId; String? get description; DateTime get date;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDtoCopyWith<TransactionDto> get copyWith => _$TransactionDtoCopyWithImpl<TransactionDto>(this as TransactionDto, _$identity);

  /// Serializes this TransactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $TransactionDtoCopyWith<$Res>  {
  factory $TransactionDtoCopyWith(TransactionDto value, $Res Function(TransactionDto) _then) = _$TransactionDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id', fromJson: _toInt) int userId,@JsonKey(name: 'transaction_type', fromJson: _toTransactionType) String transactionType,@JsonKey(name: 'transaction_category_id', fromJson: _toInt) int transactionCategoryId,@JsonKey(fromJson: _toDouble) double amount,@JsonKey(name: 'account_id', fromJson: _toIntNullable) int? accountId,@JsonKey(name: 'project_id', fromJson: _toIntNullable) int? projectId, String? description, DateTime date,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$TransactionDtoCopyWithImpl<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  _$TransactionDtoCopyWithImpl(this._self, this._then);

  final TransactionDto _self;
  final $Res Function(TransactionDto) _then;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = null,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: null == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TransactionDto implements TransactionDto {
  const _TransactionDto({required this.id, @JsonKey(name: 'user_id', fromJson: _toInt) required this.userId, @JsonKey(name: 'transaction_type', fromJson: _toTransactionType) required this.transactionType, @JsonKey(name: 'transaction_category_id', fromJson: _toInt) required this.transactionCategoryId, @JsonKey(fromJson: _toDouble) required this.amount, @JsonKey(name: 'account_id', fromJson: _toIntNullable) this.accountId, @JsonKey(name: 'project_id', fromJson: _toIntNullable) this.projectId, this.description, required this.date, @JsonKey(name: 'is_active') required this.isActive});
  factory _TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id', fromJson: _toInt) final  int userId;
@override@JsonKey(name: 'transaction_type', fromJson: _toTransactionType) final  String transactionType;
@override@JsonKey(name: 'transaction_category_id', fromJson: _toInt) final  int transactionCategoryId;
@override@JsonKey(fromJson: _toDouble) final  double amount;
@override@JsonKey(name: 'account_id', fromJson: _toIntNullable) final  int? accountId;
@override@JsonKey(name: 'project_id', fromJson: _toIntNullable) final  int? projectId;
@override final  String? description;
@override final  DateTime date;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDtoCopyWith<_TransactionDto> get copyWith => __$TransactionDtoCopyWithImpl<_TransactionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TransactionDtoCopyWith<$Res> implements $TransactionDtoCopyWith<$Res> {
  factory _$TransactionDtoCopyWith(_TransactionDto value, $Res Function(_TransactionDto) _then) = __$TransactionDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id', fromJson: _toInt) int userId,@JsonKey(name: 'transaction_type', fromJson: _toTransactionType) String transactionType,@JsonKey(name: 'transaction_category_id', fromJson: _toInt) int transactionCategoryId,@JsonKey(fromJson: _toDouble) double amount,@JsonKey(name: 'account_id', fromJson: _toIntNullable) int? accountId,@JsonKey(name: 'project_id', fromJson: _toIntNullable) int? projectId, String? description, DateTime date,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$TransactionDtoCopyWithImpl<$Res>
    implements _$TransactionDtoCopyWith<$Res> {
  __$TransactionDtoCopyWithImpl(this._self, this._then);

  final _TransactionDto _self;
  final $Res Function(_TransactionDto) _then;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = null,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,}) {
  return _then(_TransactionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: null == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
