// lib/features/transactions/data/models/transaction_payload.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart'; // <--- ДОБАВЬТЕ ЭТОТ ИМПОРТ

part 'transaction_payload.g.dart';

@JsonSerializable()
class TransactionPayload {
  @JsonKey(name: 'transaction_type')
  final String transactionType;

  @JsonKey(name: 'transaction_category_id')
  final String transactionCategoryId;

  final double amount;

  @JsonKey(name: 'account_id')
  final String accountId;

  @JsonKey(name: 'project_id', includeIfNull: false)
  final String? projectId;

  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;

  // Дата и время в формате ISO 8601
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;

  TransactionPayload({
    required this.transactionType,
    required this.transactionCategoryId,
    required this.amount,
    required this.accountId,
    this.projectId,
    this.description,
    required this.date,
  });

  factory TransactionPayload.fromJson(Map<String, dynamic> json) => _$TransactionPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionPayloadToJson(this);

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

  // ИЗМЕНЕНИЕ: Форматируем дату точно так, как ожидает бэкенд (без миллисекунд)
  static String _dateTimeToJson(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(date);
  }
}