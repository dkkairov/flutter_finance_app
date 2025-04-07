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

 int get id;@JsonKey(name: 'userId') int get userId;@JsonKey(name: 'transactionType') String get transactionType;@JsonKey(name: 'transactionCategoryId') int? get transactionCategoryId; double get amount;@JsonKey(name: 'accountId') int? get accountId;@JsonKey(name: 'projectId') int? get projectId; String? get description; DateTime get date;@JsonKey(name: 'isActive') bool get isActive; String? get backendId;
/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDtoCopyWith<TransactionDto> get copyWith => _$TransactionDtoCopyWithImpl<TransactionDto>(this as TransactionDto, _$identity);

  /// Serializes this TransactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.backendId, backendId) || other.backendId == backendId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive,backendId);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive, backendId: $backendId)';
}


}

/// @nodoc
abstract mixin class $TransactionDtoCopyWith<$Res>  {
  factory $TransactionDtoCopyWith(TransactionDto value, $Res Function(TransactionDto) _then) = _$TransactionDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'transactionType') String transactionType,@JsonKey(name: 'transactionCategoryId') int? transactionCategoryId, double amount,@JsonKey(name: 'accountId') int? accountId,@JsonKey(name: 'projectId') int? projectId, String? description, DateTime date,@JsonKey(name: 'isActive') bool isActive, String? backendId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = freezed,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,Object? backendId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: freezed == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,backendId: freezed == backendId ? _self.backendId : backendId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TransactionDto implements TransactionDto {
  const _TransactionDto({required this.id, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'transactionType') required this.transactionType, @JsonKey(name: 'transactionCategoryId') this.transactionCategoryId, required this.amount, @JsonKey(name: 'accountId') this.accountId, @JsonKey(name: 'projectId') this.projectId, this.description, required this.date, @JsonKey(name: 'isActive') required this.isActive, this.backendId});
  factory _TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey(name: 'transactionType') final  String transactionType;
@override@JsonKey(name: 'transactionCategoryId') final  int? transactionCategoryId;
@override final  double amount;
@override@JsonKey(name: 'accountId') final  int? accountId;
@override@JsonKey(name: 'projectId') final  int? projectId;
@override final  String? description;
@override final  DateTime date;
@override@JsonKey(name: 'isActive') final  bool isActive;
@override final  String? backendId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.backendId, backendId) || other.backendId == backendId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive,backendId);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive, backendId: $backendId)';
}


}

/// @nodoc
abstract mixin class _$TransactionDtoCopyWith<$Res> implements $TransactionDtoCopyWith<$Res> {
  factory _$TransactionDtoCopyWith(_TransactionDto value, $Res Function(_TransactionDto) _then) = __$TransactionDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'transactionType') String transactionType,@JsonKey(name: 'transactionCategoryId') int? transactionCategoryId, double amount,@JsonKey(name: 'accountId') int? accountId,@JsonKey(name: 'projectId') int? projectId, String? description, DateTime date,@JsonKey(name: 'isActive') bool isActive, String? backendId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = freezed,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,Object? backendId = freezed,}) {
  return _then(_TransactionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: freezed == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,backendId: freezed == backendId ? _self.backendId : backendId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
