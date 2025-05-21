// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionPayload _$TransactionPayloadFromJson(Map<String, dynamic> json) =>
    TransactionPayload(
      transactionType: json['transaction_type'] as String,
      transactionCategoryId: json['transaction_category_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      accountId: json['account_id'] as String,
      projectId: json['project_id'] as String?,
      description: json['description'] as String?,
      date: TransactionPayload._dateTimeFromJson(json['date'] as String),
    );

Map<String, dynamic> _$TransactionPayloadToJson(TransactionPayload instance) =>
    <String, dynamic>{
      'transaction_type': instance.transactionType,
      'transaction_category_id': instance.transactionCategoryId,
      'amount': instance.amount,
      'account_id': instance.accountId,
      if (instance.projectId case final value?) 'project_id': value,
      if (instance.description case final value?) 'description': value,
      'date': TransactionPayload._dateTimeToJson(instance.date),
    };
