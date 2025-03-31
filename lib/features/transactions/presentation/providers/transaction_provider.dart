// lib/features/transactions/domain/transaction_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_service.dart';


// Если Transaction – твоя модель
// (Можно вынести в отдельный файл models/transaction.dart)
class Transaction {
  final String id;
  final String title;
  final String type;
  final String categoryName;
  final String projectName;
  final double amount;
  final DateTime date;

  Transaction(
      this.type,
      this.categoryName,
      this.projectName, {
        required this.id,
        required this.title,
        required this.amount,
        required this.date,
      });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      // Если в JSON есть поля "type", "categoryName", "projectName",
      // нужно распарсить их (здесь заглушки)
      json['type'] ?? 'expense',
      json['categoryName'] ?? 'Без категории',
      json['projectName'] ?? 'Без проекта',
      id: json['id'].toString(),
      title: json['title'] ?? 'Без названия',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
      (ref) => TransactionsNotifier(ref.watch(apiServiceProvider)),
);

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier(this.apiService) : super([]);
  final ApiService apiService;

  Future<void> fetchTransactions() async {
    final response = await apiService.get('/transactions'); // Возвращает Dio Response

    if (response.statusCode == 200) {
      // Предполагаем, что response.data – это List<dynamic>
      final data = response.data as List;
      state = data.map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Ошибка загрузки транзакций');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final response = await apiService.post('/transactions', {
      'title': transaction.title,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
      // Можно добавить 'type', 'categoryName', 'projectName' при необходимости
    });

    if (response.statusCode == 201) {
      // После добавления обновляем список
      await fetchTransactions();
    } else {
      throw Exception('Ошибка добавления транзакции');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final response = await apiService.delete('/transactions/$id');

    if (response.statusCode == 200) {
      // Успешно удалили, обновим список
      await fetchTransactions();
    } else {
      throw Exception('Ошибка удаления транзакции');
    }
  }
}
