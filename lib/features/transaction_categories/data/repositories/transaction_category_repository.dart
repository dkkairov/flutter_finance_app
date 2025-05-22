// lib/features/transaction_categories/data/repositories/transaction_category_repository.dart

import 'package:dio/dio.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_category_payload.dart';

class TransactionCategoryRepository {
  final Dio _dio;

  TransactionCategoryRepository(this._dio);

  Future<List<TransactionCategoryModel>> fetchTransactionCategories({
    required String teamId,
    String? type,
  }) async {
    try {
      final response = await _dio.get(
        '/api/teams/$teamId/transaction-categories',
        queryParameters: type != null ? {'type': type} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TransactionCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transaction categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load transaction categories: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to load transaction categories: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionCategoryModel> createTransactionCategory({
    required TransactionCategoryPayload payload,
    required String teamId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/teams/$teamId/transaction-categories',
        data: payload.toJson(),
      );

      if (response.statusCode == 201) {
        return TransactionCategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create transaction category: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while creating category.');
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionCategoryModel> updateTransactionCategory({
    required String categoryId,
    required String teamId,
    required TransactionCategoryPayload payload,
  }) async {
    try {
      final response = await _dio.put(
        '/api/teams/$teamId/transaction-categories/$categoryId',
        data: payload.toJson(),
      );

      if (response.statusCode == 200) {
        return TransactionCategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update transaction category: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while updating category.');
    } catch (e) {
      rethrow;
    }
  }

  // НОВЫЙ МЕТОД: Удаление категории
  Future<void> deleteTransactionCategory({
    required String categoryId,
    required String teamId,
  }) async {
    try {
      final response = await _dio.delete(
        '/api/teams/$teamId/transaction-categories/$categoryId', // URL для удаления
      );

      if (response.statusCode == 200) {
        // Успешное удаление, ничего не возвращаем
        return;
      } else {
        throw Exception('Failed to delete transaction category: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while deleting category.');
    } catch (e) {
      rethrow;
    }
  }
}