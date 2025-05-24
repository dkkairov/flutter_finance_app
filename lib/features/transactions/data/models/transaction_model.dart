// lib/features/transactions/data/models/transaction_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'transaction_model.g.dart';

// Если вы также получаете детали категории
@JsonSerializable()
class TransactionCategoryModel {
  final String id;
  final String name;
  final String? icon;
  @JsonKey(name: 'category_type')
  final String categoryType; // 'income' or 'expense'

  TransactionCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.categoryType,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) => _$TransactionCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionCategoryModelToJson(this);
}

// Если вы также получаете детали счета (включая валюту)
@JsonSerializable()
class AccountModel {
  final String id;
  final String name;
  final double balance;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;

  AccountModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.currencyCode,
    required this.currencySymbol,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}

// Если вы также получаете детали проекта
@JsonSerializable()
class ProjectModel {
  final String id;
  final String name;

  ProjectModel({
    required this.id,
    required this.name,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}


@JsonSerializable()
class TransactionModel {
  final String id; // Из бэкенда
  @JsonKey(name: 'user_id')
  final String userId; // Из бэкенда
  @JsonKey(name: 'transaction_type')
  final String transactionType;
  @JsonKey(name: 'transaction_category_id')
  final String transactionCategoryId;
  final double amount;
  @JsonKey(name: 'account_id')
  final String accountId;
  @JsonKey(name: 'project_id')
  final String? projectId;
  final String? description;

  // Дата и время в формате ISO 8601
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;

  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? deletedAt;

  // Вложенные объекты для отображения
  @JsonKey(name: 'transaction_category') // Название, как возвращается в Laravel Resource
  final TransactionCategoryModel? category;
  @JsonKey(name: 'account') // Название, как возвращается в Laravel Resource
  final AccountModel? account;
  @JsonKey(name: 'project') // Название, как возвращается в Laravel Resource
  final ProjectModel? project;


  TransactionModel({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.transactionCategoryId,
    required this.amount,
    required this.accountId,
    this.projectId,
    this.description,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
    this.account,
    this.project,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    print('Parsing TransactionModel from JSON: $json'); // <--- ДОБАВЬТЕ ЭТО
    return _$TransactionModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  static DateTime _dateTimeFromJson(dynamic date) {
    if (date is String) {
      return DateTime.parse(date);
    } else if (date is DateTime) {
      return date;
    }
    throw FormatException('Invalid date format: $date');
  }

  static String _dateTimeToJson(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(date);
  }

  static DateTime? _nullableDateTimeFromJson(dynamic date) {
    if (date == null) return null;
    return _dateTimeFromJson(date);
  }

  static String? _nullableDateTimeToJson(DateTime? date) {
    if (date == null) return null;
    return _dateTimeToJson(date);
  }
}