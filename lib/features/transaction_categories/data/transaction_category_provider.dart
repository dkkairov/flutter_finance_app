import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';

final transactionCategoriesProvider = StateNotifierProvider<TransactionCategoriesNotifier, List<String>>(
      (ref) => TransactionCategoriesNotifier(ref.watch(apiServiceProvider)),
);

class TransactionCategoriesNotifier extends StateNotifier<List<String>> {
  TransactionCategoriesNotifier(this.apiService) : super([]);

  final ApiService apiService;

  Future<void> fetchTransactionCategories() async {
    final response = await apiService.get('/transaction_categories');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.data);
      state = List<String>.from(jsonData.map((item) => item['name']));
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  Future<void> addTransactionCategory(String name) async {
    final response = await apiService.post('/transaction_categories', {'name': name});

    if (response.statusCode == 201) {
      fetchTransactionCategories();
    } else {
      throw Exception('Ошибка добавления категории');
    }
  }

  Future<void> deleteTransactionCategory(String name) async {
    final response = await apiService.delete('/transaction_categories/$name');

    if (response.statusCode == 200) {
      fetchTransactionCategories();
    } else {
      throw Exception('Ошибка удаления категории');
    }
  }
}
