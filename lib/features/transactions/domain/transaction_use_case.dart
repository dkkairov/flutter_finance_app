// lib/features/transactions/domain/transaction_use_case.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/transaction_repository.dart';
import 'models/transaction.dart';

final transactionUseCaseProvider = Provider<TransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionUseCase(repository);
});

class TransactionUseCase {
  final TransactionRepository _repository;

  TransactionUseCase(this._repository);

  /// Получаем список транзакций из репозитория.
  /// Возвращает Future<List<Transaction>>
  Future<List<Transaction>> fetchTransactions() {
    return _repository.fetchTransactions();
  }

  /// Создаем транзакцию (репозиторий решает, где хранить — локально/сервер).
  Future<void> createTransaction(Transaction transaction) {
    return _repository.createTransaction(transaction);
  }

  /// Удаляем транзакцию по ID.
  Future<void> deleteTransaction(int id) {
    return _repository.deleteTransaction(id);
  }

  /// Получаем сумму расходов (transactionType == 'expense').
  /// Если t.amount — обычный double, оператор '+' работать будет без ошибок.
  // Future<double> getTotalExpenses(List<Transaction> list) async {
  //   return list
  //       .where((t) => t.transactionType == 'expense')
  //       .fold(0.0, (sum, t) => sum + t.amount);
  // }
  Future<double> getTotalExpenses(List<Transaction> list) async {
    double total = 0.0;
    for (final t in list) {
      final val = await t.amount; // 'amount' возвращает Future<double>?
      total += val;
    }
    return total;
  }


  /// Получаем сумму доходов (transactionType == 'income').
  // Future<double> getTotalIncome(List<Transaction> list) async {
  //   return list
  //       .where((t) => t.transactionType == 'income')
  //       .fold(0.0, (sum, t) => sum + t.amount);
  // }
  Future<double> getTotalIncome(List<Transaction> list) async {
    double total = 0.0;
    for (final t in list.where((t) => t.transactionType == 'income')) {
      // Предполагаем, что t.amount имеет тип Future<double>
      final val = await t.amount;
      total += val; // Теперь складываем double + double
    }
    return total;
  }
}
