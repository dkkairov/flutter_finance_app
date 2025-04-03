import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/features/transactions/utils/transaction_mapper.dart';
import '../../domain/models/transaction_entity.dart';

class TransactionLocalDataSource {
  final AppDatabase db;
  final int userId;

  TransactionLocalDataSource({required this.db, required this.userId});

  /// Получение всех транзакций как потока (для StreamProvider)
  Stream<List<TransactionEntity>> watchAllTransactions() {
    return db.watchAllTransactions().map(
          (rows) => rows.map(TransactionMapper.fromDb).toList(),
    );
  }

  /// Получение всех транзакций единоразово
  Future<List<TransactionEntity>> getAllTransactions() async {
    final rows = await db.getAllTransactions();
    return rows.map(TransactionMapper.fromDb).toList();
  }

  /// Создание новой транзакции
  Future<int> insertTransaction(TransactionEntity entity) {
    final data = TransactionMapper.toDb(entity, userId: userId);
    return db.insertTransaction(data);
  }

  /// Обновление
  Future<bool> updateTransaction(TransactionEntity entity) {
    final txn = Transaction(
      id: entity.id,
      userId: userId,
      transactionType: entity.type,
      transactionCategoryId: null,
      amount: entity.amount,
      accountId: null,
      projectId: null,
      description: entity.description,
      date: entity.date,
      isActive: true,
    );
    return db.updateTransaction(txn);
  }


  /// Удаление
  Future<int> deleteTransaction(int id) {
    return db.deleteTransactionById(id);
  }
}
