import 'package:drift/drift.dart';
import 'package:flutter_app_1/core/models/transaction_dto.dart';
import 'package:flutter_app_1/core/db/app_database.dart';

import '../domain/models/transaction_entity.dart';

class TransactionMapper {
  static TransactionEntity fromDto(TransactionDto dto) => TransactionEntity(
    id: dto.id,
    type: dto.transactionType,
    amount: dto.amount,
    date: dto.date,
    description: dto.description,
  );

  static TransactionDto toDto(TransactionEntity entity, int userId) => TransactionDto(
    id: entity.id,
    userId: userId,
    transactionType: entity.type,
    transactionCategoryId: 1, // или null / из UI
    amount: entity.amount,
    accountId: 1,              // или null / из UI
    projectId: null,
    description: entity.description,
    date: entity.date,
    isActive: true,
  );

  static TransactionEntity fromDb(Transaction row) => TransactionEntity(
    id: row.id,
    type: row.transactionType,
    amount: row.amount,
    date: row.date,
    description: row.description,
  );

  static TransactionsCompanion toDb(TransactionEntity entity, {required int userId}) {
    return TransactionsCompanion(
      id: Value(entity.id),
      userId: Value(userId),
      transactionType: Value(entity.type),
      transactionCategoryId: const Value(null),
      amount: Value(entity.amount),
      accountId: const Value(null),
      projectId: const Value(null),
      description: Value(entity.description),
      date: Value(entity.date),
      isActive: const Value(true),
    );
  }
}