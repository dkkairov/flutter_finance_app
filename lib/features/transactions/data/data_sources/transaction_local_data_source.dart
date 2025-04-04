// lib/features/transactions/data/data_sources/transaction_local_data_source.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/features/transactions/utils/transaction_mapper.dart';
import '../../domain/models/transaction_entity.dart';

class TransactionLocalDataSource {
  final AppDatabase db;

  TransactionLocalDataSource({
    required this.db, required int userId,
  });

  /// Получение всех транзакций как потока (для StreamProvider)
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
  Future<void> insertTransaction(TransactionEntity entity, {required int userId}) async {
    final companion = TransactionMapper.toDb(entity, userId: userId);
    debugPrint('💾 Сохраняю в локальную БД транзакцию: ${entity.id}');
    await db.insertTransaction(entity, userId: userId);
  }


  /// Обновление транзакции
  Future<bool> updateTransaction(TransactionEntity entity, {required int userId}) {
    final updated = TransactionMapper.toFullDriftModel(entity, userId: userId);
    return db.updateTransaction(updated);
  }

  /// Удаление по ID
  Future<int> deleteTransaction(int id) {
    return db.deleteTransactionById(id);
  }
}
