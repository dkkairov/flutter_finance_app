import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'transaction_model.g.dart';

// Категория транзакции
@JsonSerializable()
class TransactionCategoryModel {
  final String id;
  final String name;
  final String? icon;
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

// Счёт
@JsonSerializable()
class AccountModel {
  final String id;
  final String name;
  final double balance;
  final String currencyCode;
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

// Проект
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

// Транзакция
@JsonSerializable()
class TransactionModel {
  final String id;
  final String userId;
  final String transactionType;
  final String transactionCategoryId;
  final double amount;
  final String accountId;
  final String? projectId;
  final String? description;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? updatedAt;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? deletedAt;

  // Вложенные объекты (nullable, если API их не возвращает)
  final TransactionCategoryModel? category;
  final AccountModel? account;
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
    print('Parsing TransactionModel from JSON: $json');
    return _$TransactionModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  static DateTime _dateTimeFromJson(dynamic date) {
    if (date is String) return DateTime.parse(date);
    if (date is DateTime) return date;
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
