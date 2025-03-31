import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<String>>(
      (ref) => CategoriesNotifier(ref.watch(apiServiceProvider)),
);

class CategoriesNotifier extends StateNotifier<List<String>> {
  CategoriesNotifier(this.apiService) : super([]);

  final ApiService apiService;

  Future<void> fetchCategories() async {
    final response = await apiService.get('/categories');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.data);
      state = List<String>.from(jsonData.map((item) => item['name']));
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  Future<void> addCategory(String name) async {
    final response = await apiService.post('/categories', {'name': name});

    if (response.statusCode == 201) {
      fetchCategories();
    } else {
      throw Exception('Ошибка добавления категории');
    }
  }

  Future<void> deleteCategory(String name) async {
    final response = await apiService.delete('/categories/$name');

    if (response.statusCode == 200) {
      fetchCategories();
    } else {
      throw Exception('Ошибка удаления категории');
    }
  }
}
