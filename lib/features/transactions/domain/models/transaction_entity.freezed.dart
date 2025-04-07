// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionEntity {

 int? get id;// локальный ID Drift
 int? get serverId;// серверный ID (Laravel)
 int get userId; String get transactionType; int? get transactionCategoryId; double get amount; int? get accountId; int? get projectId; String? get description; DateTime get date; bool get isActive;
/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionEntityCopyWith<TransactionEntity> get copyWith => _$TransactionEntityCopyWithImpl<TransactionEntity>(this as TransactionEntity, _$identity);

  /// Serializes this TransactionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive);

@override
String toString() {
  return 'TransactionEntity(id: $id, serverId: $serverId, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $TransactionEntityCopyWith<$Res>  {
  factory $TransactionEntityCopyWith(TransactionEntity value, $Res Function(TransactionEntity) _then) = _$TransactionEntityCopyWithImpl;
@useResult
$Res call({
 int? id, int? serverId, int userId, String transactionType, int? transactionCategoryId, double amount, int? accountId, int? projectId, String? description, DateTime date, bool isActive
});




}
/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._self, this._then);

  final TransactionEntity _self;
  final $Res Function(TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? serverId = freezed,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = freezed,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as int?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: freezed == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
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

class _TransactionEntity implements TransactionEntity {
  const _TransactionEntity({this.id, this.serverId, required this.userId, required this.transactionType, this.transactionCategoryId, required this.amount, this.accountId, this.projectId, this.description, required this.date, required this.isActive});
  factory _TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);

@override final  int? id;
// локальный ID Drift
@override final  int? serverId;
// серверный ID (Laravel)
@override final  int userId;
@override final  String transactionType;
@override final  int? transactionCategoryId;
@override final  double amount;
@override final  int? accountId;
@override final  int? projectId;
@override final  String? description;
@override final  DateTime date;
@override final  bool isActive;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionEntityCopyWith<_TransactionEntity> get copyWith => __$TransactionEntityCopyWithImpl<_TransactionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.transactionCategoryId, transactionCategoryId) || other.transactionCategoryId == transactionCategoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,userId,transactionType,transactionCategoryId,amount,accountId,projectId,description,date,isActive);

@override
String toString() {
  return 'TransactionEntity(id: $id, serverId: $serverId, userId: $userId, transactionType: $transactionType, transactionCategoryId: $transactionCategoryId, amount: $amount, accountId: $accountId, projectId: $projectId, description: $description, date: $date, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TransactionEntityCopyWith<$Res> implements $TransactionEntityCopyWith<$Res> {
  factory _$TransactionEntityCopyWith(_TransactionEntity value, $Res Function(_TransactionEntity) _then) = __$TransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? serverId, int userId, String transactionType, int? transactionCategoryId, double amount, int? accountId, int? projectId, String? description, DateTime date, bool isActive
});




}
/// @nodoc
class __$TransactionEntityCopyWithImpl<$Res>
    implements _$TransactionEntityCopyWith<$Res> {
  __$TransactionEntityCopyWithImpl(this._self, this._then);

  final _TransactionEntity _self;
  final $Res Function(_TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? serverId = freezed,Object? userId = null,Object? transactionType = null,Object? transactionCategoryId = freezed,Object? amount = null,Object? accountId = freezed,Object? projectId = freezed,Object? description = freezed,Object? date = null,Object? isActive = null,}) {
  return _then(_TransactionEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as int?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,transactionCategoryId: freezed == transactionCategoryId ? _self.transactionCategoryId : transactionCategoryId // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
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
