// lib/features/transactions/data/data_sources/transaction_local_data_source.dart

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';
import '../../domain/models/transaction.dart';

final transactionLocalDataSourceProvider =
Provider<TransactionLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionLocalDataSource(db);
});

class TransactionLocalDataSource {
  final AppDatabase database;

  TransactionLocalDataSource(this.database);

  Future<List<Transaction>> getAll() async {
    final records = await database.getAllTransactions();
    return records.map((e) => Transaction(
      id: e.id,
      userId: e.userId,
      transactionType: e.transactionType,
      transactionCategoryId: e.transactionCategoryId,
      amount: e.amount,
      accountId: e.accountId,
      projectId: e.projectId,
      description: e.description,
      date: e.date,
      isActive: e.isActive,
    )).toList();
  }

  Future<void> save(Transaction transaction) async {
    await database.insertTransaction(TransactionsCompanion(
      id: Value(transaction.id),
      userId: Value(transaction.userId),
      transactionType: Value(transaction.transactionType),
      transactionCategoryId: Value(transaction.transactionCategoryId),
      amount: Value(transaction.amount),
      accountId: Value(transaction.accountId),
      projectId: Value(transaction.projectId),
      description: Value(transaction.description),
      date: Value(transaction.date),
      isActive: Value(transaction.isActive),
    ));
  }

  Future<void> delete(int id) async {
    await database.deleteTransaction(id);
  }
}
