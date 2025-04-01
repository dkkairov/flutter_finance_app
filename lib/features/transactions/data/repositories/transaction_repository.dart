// lib/features/transactions/data/repositories/transaction_repository.dart

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_service.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';
import '../../domain/models/transaction.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  final db = ref.watch(databaseProvider);
  return TransactionRepository(apiService: api, database: db);
});

class TransactionRepository {
  final ApiService apiService;
  final AppDatabase database;

  TransactionRepository({
    required this.apiService,
    required this.database,
  });

  Future<List<Transaction>> fetchTransactions() async {
    // try {
    //   final response = await apiService.get('/transactions');
    //   final transactions = (response.data as List)
    //       .map((json) => Transaction.fromJson(json))
    //       .toList();
    //
    //   // Сохраняем в локальную базу
    //   for (final t in transactions) {
    //     await database.insertTransaction(TransactionsCompanion(
    //       id: Value(t.id),
    //       userId: Value(t.userId),
    //       transactionType: Value(t.transactionType),
    //       transactionCategoryId: Value(t.transactionCategoryId),
    //       amount: Value(t.amount),
    //       accountId: Value(t.accountId),
    //       projectId: Value(t.projectId),
    //       description: Value(t.description),
    //       date: Value(t.date),
    //       isActive: Value(t.isActive),
    //     ));
    //   }
    //
    //   return transactions;
    // } catch (e) {
    //   // Если нет сети или ошибка запроса, берем локальные данные
    //   final local = await database.getAllTransactions();
    //   // Нужно сконвертировать TransactionData -> Transaction (Freezed)
    //   return local.map((data) {
    //     return Transaction(
    //       id: data.id,
    //       userId: data.userId,
    //       transactionType: data.transactionType,
    //       transactionCategoryId: data.transactionCategoryId,
    //       amount: data.amount,
    //       accountId: data.accountId,
    //       projectId: data.projectId,
    //       description: data.description,
    //       date: data.date,
    //       isActive: data.isActive,
    //     );
    //   }).toList();
    // }
    return [
      Transaction(
        transactionType: 'expense',
        transactionCategoryId: 1,
        accountId: 1,
        id: 1,
        amount: 500.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        userId: 1,
        isActive: true,
      ),
      Transaction(
        transactionType: 'expense',
        transactionCategoryId: 1,
        accountId: 1,
        id: 1,
        amount: 30000.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        userId: 1,
        isActive: true,
      ),
    ];
  }

  Future<void> createTransaction(Transaction transaction) async {
    try {
      await apiService.post('/transactions', transaction.toJson());
    } catch (e) {
      // Если запрос не прошел, записываем в pending_requests
      await database.addPendingRequest(PendingRequestsCompanion(
        method: const Value('POST'),
        endpoint: const Value('/transactions'),
        data: Value(transaction.toJson().toString()),
      ));
    }

    // В любом случае сохраняем транзакцию в локальную базу
    await database.insertTransaction(TransactionsCompanion(
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

  Future<void> deleteTransaction(int id) async {
    try {
      await apiService.delete('/transactions/$id');
    } catch (e) {
      // Оффлайн - в таблицу pending_requests
      await database.addPendingRequest(PendingRequestsCompanion(
        method: const Value('DELETE'),
        endpoint: Value('/transactions/$id'),
        data: const Value(''),
      ));
    }

    await database.deleteTransaction(id);
  }
}
