// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: (json['id'] as num).toInt(),
      serverId: (json['serverId'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      transactionType: json['transactionType'] as String,
      transactionCategoryId: (json['transactionCategoryId'] as num?)?.toInt(),
      amount: (json['amount'] as num).toDouble(),
      accountId: (json['accountId'] as num?)?.toInt(),
      projectId: (json['projectId'] as num?)?.toInt(),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'userId': instance.userId,
      'transactionType': instance.transactionType,
      'transactionCategoryId': instance.transactionCategoryId,
      'amount': instance.amount,
      'accountId': instance.accountId,
      'projectId': instance.projectId,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'isActive': instance.isActive,
    };
