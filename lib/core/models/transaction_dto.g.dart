// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: (json['id'] as num).toInt(),
      userId: _toInt(json['user_id']),
      transactionType: _toTransactionType(json['transaction_type']),
      transactionCategoryId: _toInt(json['transaction_category_id']),
      amount: _toDouble(json['amount']),
      accountId: _toIntNullable(json['account_id']),
      projectId: _toIntNullable(json['project_id']),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'transaction_type': instance.transactionType,
      'transaction_category_id': instance.transactionCategoryId,
      'amount': instance.amount,
      'account_id': instance.accountId,
      'project_id': instance.projectId,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'is_active': instance.isActive,
    };
