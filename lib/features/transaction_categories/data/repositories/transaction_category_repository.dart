// lib/features/transaction_categories/data/repositories/transaction_category_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../models/transaction_category_model.dart';
import '../models/transaction_category_payload.dart'; // <--- НОВЫЙ ИМПОРТ

class TransactionCategoryRepository {
  final Dio _dio;
  final Ref _ref;

  TransactionCategoryRepository(this._dio, this._ref);

  /// Получает список категорий транзакций для текущей выбранной команды.
  /// Можно отфильтровать по типу ('income' или 'expense').
  Future<List<TransactionCategoryModel>> fetchTransactionCategories({String? type}) async {
    try {
      final teamId = _ref.read(selectedTeamIdProvider);
      print('DEBUG: fetchTransactionCategories: teamId = $teamId');

      if (teamId == null) {
        throw Exception('Team ID is not selected. Cannot fetch transaction categories.');
      }

      final Map<String, dynamic> queryParams = {};
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _dio.get(
        '/api/teams/$teamId/transaction-categories',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('Categories API response: $data');
        return data.map((json) => TransactionCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transaction categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error fetching categories: ${e.response?.statusCode} ${e.response?.data}');
        throw Exception('Failed to load transaction categories: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        print('Dio error fetching categories: ${e.message}');
        throw Exception('Failed to load transaction categories: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error fetching categories: $e');
      rethrow;
    }
  }

  /// Создает новую категорию транзакций.
  Future<TransactionCategoryModel> createTransactionCategory({
    required String teamId,
    required TransactionCategoryPayload payload, // <--- ИСПОЛЬЗУЕМ PAYLOAD
  }) async {
    try {
      print('DEBUG: createTransactionCategory: teamId = $teamId, payload = ${payload.toJson()}');
      final response = await _dio.post(
        '/api/teams/$teamId/transaction-categories',
        data: payload.toJson(), // Отправляем JSON-тело
      );

      if (response.statusCode == 201) { // 201 Created для успешного создания
        print('Category created successfully: ${response.data}');
        return TransactionCategoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create transaction category: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error creating category: ${e.response?.statusCode} ${e.response?.data}');
        final errorMessage = e.response?.data['message'] ?? 'Unknown error';
        final errors = e.response?.data['errors'] ?? {};
        throw Exception('Failed to create transaction category: $errorMessage - $errors');
      } else {
        print('Dio error creating category: ${e.message}');
        throw Exception('Failed to create transaction category: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error creating category: $e');
      rethrow;
    }
  }
}

// Провайдер для TransactionCategoryRepository
final transactionCategoryRepositoryProvider = Provider<TransactionCategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionCategoryRepository(dio, ref);
});