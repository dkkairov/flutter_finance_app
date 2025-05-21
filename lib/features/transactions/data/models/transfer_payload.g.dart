// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferPayload _$TransferPayloadFromJson(Map<String, dynamic> json) =>
    TransferPayload(
      fromAccountId: json['from_account_id'] as String,
      toAccountId: json['to_account_id'] as String,
      amountFrom: (json['amount_from'] as num).toDouble(),
      amountTo: (json['amount_to'] as num?)?.toDouble(),
      currencyFromId: json['currency_from_id'] as String?,
      currencyToId: json['currency_to_id'] as String?,
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble(),
      description: json['description'] as String?,
      date: TransferPayload._dateTimeFromJson(json['date'] as String),
    );

Map<String, dynamic> _$TransferPayloadToJson(TransferPayload instance) =>
    <String, dynamic>{
      'from_account_id': instance.fromAccountId,
      'to_account_id': instance.toAccountId,
      'amount_from': instance.amountFrom,
      if (instance.amountTo case final value?) 'amount_to': value,
      if (instance.currencyFromId case final value?) 'currency_from_id': value,
      if (instance.currencyToId case final value?) 'currency_to_id': value,
      if (instance.exchangeRate case final value?) 'exchange_rate': value,
      if (instance.description case final value?) 'description': value,
      'date': TransferPayload._dateTimeToJson(instance.date),
    };
