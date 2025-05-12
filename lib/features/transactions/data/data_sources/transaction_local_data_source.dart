// lib/features/transactions/data/data_sources/transaction_local_data_source.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/features/transactions/utils/transaction_mapper.dart';
import '../../domain/models/transaction_entity.dart';

class TransactionLocalDataSource {
  final AppDatabase db;
  final int userId;

  TransactionLocalDataSource({
    required this.db,
    required this.userId,
  });

  /// Поток всех транзакций из локальной базы (для StreamProvider)
  Stream<List<TransactionEntity>> watchAllTransactions() {
    return db.watchAllTransactions().map((rows) {
      debugPrint('📦 Из базы пришло ${rows.length} записей');
      return rows.map(TransactionMapper.fromDb).toList();
    });
  }

  /// Получение всех транзакций единоразово
  Future<List<TransactionEntity>> getAllTransactions() async {
    final rows = await db.getAllTransactions();
    return rows.map(TransactionMapper.fromDb).toList();
  }

  /// Вставка или обновление транзакции
  Future<void> insertTransaction(TransactionEntity entity) async {
    debugPrint('💾 Сохраняю в локальную БД транзакцию: ${entity.id}');
    final model = TransactionMapper.toFullDriftModel(entity, userId: userId);
    await db.into(db.transactionsTable).insertOnConflictUpdate(model);
  }

  /// Обновление транзакции
  Future<bool> updateTransaction(TransactionEntity entity) {
    final model = TransactionMapper.toFullDriftModel(entity, userId: userId);
    return db.updateTransaction(model, userId: userId);
  }

  /// Удаление транзакции по ID
  Future<int> deleteTransaction(int id) {
    return db.deleteTransactionById(id);
  }
}