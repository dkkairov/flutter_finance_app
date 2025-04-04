import 'package:drift/drift.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/core/models/transaction_dto.dart';
import '../domain/models/transaction_entity.dart';

class TransactionMapper {
  /// DTO → Entity
  static TransactionEntity fromDto(TransactionDto dto) => TransactionEntity(
    id: dto.id,
    userId: dto.userId,
    transactionType: dto.transactionType,
    transactionCategoryId: dto.transactionCategoryId,
    amount: dto.amount,
    accountId: dto.accountId,
    projectId: dto.projectId,
    description: dto.description,
    date: dto.date,
    isActive: dto.isActive,
  );

  /// Entity → DTO (userId можно передать, если нужно переопределить)
  static TransactionDto toDto(TransactionEntity entity, int userId) => TransactionDto(
    id: entity.id,
    userId: userId ?? entity.userId,
    transactionType: entity.transactionType,
    transactionCategoryId: entity.transactionCategoryId!,
    amount: entity.amount,
    accountId: entity.accountId,
    projectId: entity.projectId,
    description: entity.description,
    date: entity.date,
    isActive: entity.isActive,
  );

  /// DB row → Entity
  static TransactionEntity fromDb(Transaction row) => TransactionEntity(
    id: row.id,
    userId: row.userId,
    transactionType: row.transactionType,
    transactionCategoryId: row.transactionCategoryId,
    amount: row.amount,
    accountId: row.accountId,
    projectId: row.projectId,
    description: row.description,
    date: row.date,
    isActive: row.isActive,
  );

  /// Entity → Drift Companion
  static TransactionsCompanion toDb(TransactionEntity entity, {required int userId}) {
    return TransactionsCompanion(
      id: Value(entity.id),
      userId: Value(userId),
      transactionType: Value(entity.transactionType),
      transactionCategoryId: entity.transactionCategoryId != null
          ? Value(entity.transactionCategoryId!)
          : const Value.absent(),
      amount: Value(entity.amount),
      accountId: entity.accountId != null
          ? Value(entity.accountId!)
          : const Value.absent(),
      projectId: entity.projectId != null
          ? Value(entity.projectId!)
          : const Value.absent(),
      description: entity.description != null
          ? Value(entity.description!)
          : const Value.absent(),
      date: Value(entity.date),
      isActive: Value(entity.isActive),
    );
  }
}
