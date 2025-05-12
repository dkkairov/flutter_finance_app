import 'package:flutter/material.dart'; // Для debugPrint
import 'package:drift/drift.dart';
// Убедитесь, что пути к этим файлам правильные относительно TransactionMapper
import 'package:flutter_app_1/core/db/app_database.dart'; // Для TransactionsTableData и TransactionsTableCompanion
import 'package:flutter_app_1/features/transactions/domain/models/transaction_dto.dart'; // Убедитесь, что в этом DTO есть поля fromAccountId и toAccountId типа int? и transactionType типа String
import '../domain/models/transaction_entity.dart'; // Путь к вашей ОБНОВЛЕННОЙ TransactionEntity
// Убедитесь, что путь к TransactionType правильный
import '../presentation/screens/transaction_create_screen.dart'; // Путь к вашему enum TransactionType


class TransactionMapper {

  // Helper to convert enum to string (matching the enum value name)
  static String _enumToString(TransactionType type) {
    // Мы берем часть после точки, которая соответствует имени значения enum
    return type.toString().split('.').last; // Например: 'expense', 'income', 'transfer'
  }

  // Helper to convert string to enum
  static TransactionType _stringToEnum(String typeString) {
    switch (typeString) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
      case 'transfer':
        return TransactionType.transfer;
      default:
      // Обработка неожиданных строк. Залогировать ошибку и вернуть значение по умолчанию или выбросить исключение.
        debugPrint('Warning: Unknown transaction type string received: $typeString. Defaulting to Expense.'); // Используем debugPrint для логирования
        return TransactionType.expense; // Или выбросить ошибку, в зависимости от желаемого поведения
    }
  }


  /// DTO → Entity
  static TransactionEntity fromDto(TransactionDto dto) => TransactionEntity(
    id: dto.id,
    serverId: dto.serverId,
    userId: dto.userId,
    // !!! ИЗМЕНЕНО: Преобразование String из DTO в TransactionType enum
    transactionType: _stringToEnum(dto.transactionType),
    transactionCategoryId: dto.transactionCategoryId,
    amount: dto.amount,
    accountId: dto.accountId,
    projectId: dto.projectId,
    description: dto.description,
    date: dto.date,
    isActive: dto.isActive,
    // !!! ДОБАВЛЕНО: Маппинг полей перевода из DTO в Entity
    fromAccountId: dto.fromAccountId,
    toAccountId: dto.toAccountId,
  );

  /// Entity → DTO (userId можно переопределить)
  static TransactionDto toDto(TransactionEntity entity, {required int userId}) => TransactionDto(
    id: entity.id ?? 0, // API требует id, даже если временный
    serverId: entity.serverId,
    userId: userId,
    // !!! ИЗМЕНЕНО: Преобразование TransactionType enum в String для DTO
    transactionType: _enumToString(entity.transactionType),
    transactionCategoryId: entity.transactionCategoryId,
    amount: entity.amount,
    accountId: entity.accountId,
    projectId: entity.projectId,
    description: entity.description,
    date: entity.date,
    isActive: entity.isActive,
    // !!! ДОБАВЛЕНО: Маппинг полей перевода из Entity в DTO
    fromAccountId: entity.fromAccountId,
    toAccountId: entity.toAccountId,
  );

  /// DB row → Entity
  static TransactionEntity fromDb(TransactionsTableData row) => TransactionEntity(
    id: row.id,
    serverId: row.serverId,
    userId: row.userId,
    // !!! ИЗМЕНЕНО: Преобразование String из DB row в TransactionType enum
    transactionType: _stringToEnum(row.transactionType),
    transactionCategoryId: row.transactionCategoryId,
    amount: row.amount,
    accountId: row.accountId,
    projectId: row.projectId,
    description: row.description,
    date: row.date,
    isActive: row.isActive,
    // !!! ДОБАВЛЕНО: Маппинг полей перевода из DB row в Entity
    fromAccountId: row.fromAccountId,
    toAccountId: row.toAccountId,
  );

  /// Entity → Drift Companion (для insert)
  static TransactionsTableCompanion toDb(TransactionEntity entity, {required int userId}) {
    return TransactionsTableCompanion(
      id: entity.id != null ? Value(entity.id!) : const Value.absent(),
      serverId: entity.serverId != null ? Value(entity.serverId!) : const Value.absent(),
      userId: Value(userId),
      // !!! ИЗМЕНЕНО: Преобразование TransactionType enum в Value<String> для Companion
      transactionType: Value(_enumToString(entity.transactionType)),
      transactionCategoryId: entity.transactionCategoryId != null
          ? Value(entity.transactionCategoryId!)
          : const Value.absent(),
      amount: Value(entity.amount),
      accountId: entity.accountId != null ? Value(entity.accountId!) : const Value.absent(),
      projectId: entity.projectId != null ? Value(entity.projectId!) : const Value.absent(),
      description: entity.description != null ? Value(entity.description!) : const Value.absent(),
      date: Value(entity.date),
      isActive: Value(entity.isActive),
      // !!! ДОБАВЛЕНО: Маппинг полей перевода из Entity в Value для Companion
      fromAccountId: entity.fromAccountId != null ? Value(entity.fromAccountId!) : const Value.absent(),
      toAccountId: entity.toAccountId != null ? Value(entity.toAccountId!) : const Value.absent(),
    );
  }

  /// Entity → Drift Data Model (для update)
  static TransactionsTableData toFullDriftModel(TransactionEntity entity, {required int userId}) {
    // Этот маппинг требует, чтобы entity.id не был null, так как он используется для обновления
    assert(entity.id != null, 'Entity must have an id for toFullDriftModel mapping');
    return TransactionsTableData(
      id: entity.id!, // Требуется не-null id
      serverId: entity.serverId,
      userId: userId,
      // !!! ИЗМЕНЕНО: Преобразование TransactionType enum в String для Drift Data Model
      transactionType: _enumToString(entity.transactionType),
      transactionCategoryId: entity.transactionCategoryId,
      amount: entity.amount,
      accountId: entity.accountId,
      projectId: entity.projectId,
      description: entity.description,
      date: entity.date,
      isActive: entity.isActive,
      // !!! ДОБАВЛЕНО: Маппинг полей перевода из Entity в Drift Data Model
      fromAccountId: entity.fromAccountId,
      toAccountId: entity.toAccountId,
    );
  }
}