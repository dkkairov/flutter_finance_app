// lib/features/transactions/data/models/transfer_payload.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart'; // <--- ДОБАВЬТЕ ЭТОТ ИМПОРТ

part 'transfer_payload.g.dart';

@JsonSerializable()
class TransferPayload {
  @JsonKey(name: 'from_account_id')
  final String fromAccountId;

  @JsonKey(name: 'to_account_id')
  final String toAccountId;

  @JsonKey(name: 'amount_from')
  final double amountFrom;

  @JsonKey(name: 'amount_to', includeIfNull: false)
  final double? amountTo;

  @JsonKey(name: 'currency_from_id', includeIfNull: false)
  final String? currencyFromId;

  @JsonKey(name: 'currency_to_id', includeIfNull: false)
  final String? currencyToId;

  @JsonKey(name: 'exchange_rate', includeIfNull: false)
  final double? exchangeRate;

  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;

  TransferPayload({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amountFrom,
    this.amountTo,
    this.currencyFromId,
    this.currencyToId,
    this.exchangeRate,
    this.description,
    required this.date,
  });

  factory TransferPayload.fromJson(Map<String, dynamic> json) => _$TransferPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$TransferPayloadToJson(this);

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

  // ИЗМЕНЕНИЕ: Форматируем дату точно так, как ожидает бэкенд (без миллисекунд)
  static String _dateTimeToJson(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(date);
  }
}