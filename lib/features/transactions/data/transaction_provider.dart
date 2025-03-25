import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
      (ref) => TransactionsNotifier(),
);

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({required this.id, required this.title, required this.amount, required this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier() : super([]);

  Future<void> fetchTransactions() async {
    final response = await ApiService.get('/transactions');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      state = jsonData.map((item) => Transaction.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка загрузки транзакций');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final response = await ApiService.post('/transactions', {
      'title': transaction.title,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
    });

    if (response.statusCode == 201) {
      fetchTransactions();
    } else {
      throw Exception('Ошибка добавления транзакции');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final response = await ApiService.delete('/transactions/$id');

    if (response.statusCode == 200) {
      fetchTransactions();
    } else {
      throw Exception('Ошибка удаления транзакции');
    }
  }
}
