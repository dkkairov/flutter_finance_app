// lib/features/transaction_categories/data/repositories/transaction_category_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Путь к твоему dioProvider
import '../../../auth/presentation/providers/auth_providers.dart';
import '../models/transaction_category_model.dart'; // Путь к твоей модели TransactionCategoryModel

class TransactionCategoryRepository {
  final Dio _dio;
  final Ref _ref; // Добавляем Ref для доступа к другим провайдерам

  TransactionCategoryRepository(this._dio, this._ref);

  /// Получает список категорий транзакций для текущей выбранной команды.
  /// Можно отфильтровать по типу ('income' или 'expense').
  Future<List<TransactionCategoryModel>> fetchTransactionCategories({String? type}) async {
    try {
      final teamId = _ref.read(selectedTeamIdProvider); // Получаем ID выбранной команды
      print('DEBUG: fetchTransactionCategories: teamId = $teamId'); // <--- ДОБАВЬ ЭТО

      if (teamId == null) {
        throw Exception('Team ID is not selected. Cannot fetch transaction categories.');
      }

      // Добавляем параметр `type` в запрос, если он передан
      final Map<String, dynamic> queryParams = {};
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _dio.get(
        '/api/teams/$teamId/transaction-categories',
        queryParameters: queryParams, // Передаем параметры запроса
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
}

// Провайдер для TransactionCategoryRepository
final transactionCategoryRepositoryProvider = Provider<TransactionCategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionCategoryRepository(dio, ref);
});