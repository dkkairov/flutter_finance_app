// lib/features/transactions/data/repositories/transaction_repository.dart

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart'; // Понадобится для DateFormat
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../transactions/data/models/transaction_payload.dart';
import '../../../transactions/data/models/transfer_payload.dart';
import '../models/transaction_model.dart';
// import '../../reports/data/models/filtered_transactions_list_params.dart'; // Этот импорт больше не нужен здесь, т.к. fetchTransactions принимает примитивы

class TransactionRepository {
  final Dio _dio;
  final Ref _ref;

  TransactionRepository(this._dio, this._ref);

  // Метод для создания расхода или дохода (остается без изменений)
  Future<void> createTransaction(TransactionPayload payload) async {
    final teamId = _ref.read(selectedTeamIdProvider);
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot create transaction.');
    }

    try {
      final response = await _dio.post(
        '/api/teams/$teamId/transactions',
        data: payload.toJson(),
      );
      if (response.statusCode == 201) {
        print('Transaction created successfully!');
      } else {
        throw Exception('Failed to create transaction: ${response.statusCode} ${response.data}');
      }
    } on DioException catch (e) {
      print('Dio error creating transaction: ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response != null && e.response!.statusCode == 422) {
        throw Exception('Validation error: ${e.response!.data['message']} - ${e.response!.data['errors']}');
      }
      throw Exception('Failed to create transaction: ${e.message}');
    } catch (e) {
      print('Unknown error creating transaction: $e');
      rethrow;
    }
  }

  // Метод для создания перевода (остается без изменений)
  Future<void> createTransfer(TransferPayload payload) async {
    final teamId = _ref.read(selectedTeamIdProvider);
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot create transfer.');
    }

    try {
      final response = await _dio.post(
        '/api/teams/$teamId/transfers',
        data: payload.toJson(),
      );
      if (response.statusCode == 201) {
        print('Transfer created successfully!');
      } else {
        throw Exception('Failed to create transfer: ${response.statusCode} ${response.data}');
      }
    } on DioException catch (e) {
      print('Dio error creating transfer: ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response != null && e.response!.statusCode == 422) {
        throw Exception('Validation error: ${e.response!.data['message']} - ${e.response!.data['errors']}');
      }
      throw Exception('Failed to create transfer: ${e.message}');
    } catch (e) {
      print('Unknown error creating transfer: $e');
      rethrow;
    }
  }

  // МЕТОД ИЗМЕНЕН: fetchTransactions теперь может принимать projectId
  Future<List<TransactionModel>> fetchTransactions({
    // teamId больше не нужен как отдельный параметр, так как он берется из _ref
    String? accountId,
    String? categoryId, // Название параметра для бэкенда может быть 'transaction_category_id'
    String? projectId,  // <--- ДОБАВЛЕН НОВЫЙ ПАРАМЕТР
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final teamId = _ref.read(selectedTeamIdProvider); // <--- ПОЛУЧАЕМ teamId ЗДЕСЬ
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot fetch transactions.');
    }

    try {
      final queryParameters = <String, dynamic>{};
      if (accountId != null) {
        queryParameters['account_id'] = accountId;
      }
      if (categoryId != null) {
        queryParameters['transaction_category_id'] = categoryId; // Или 'category_id' в зависимости от API
      }
      if (projectId != null) { // <--- ДОБАВЛЕНА ЛОГИКА ДЛЯ projectId
        queryParameters['project_id'] = projectId;
      }
      if (transactionType != null) {
        queryParameters['transaction_type'] = transactionType;
      }
      if (startDate != null) {
        queryParameters['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      }
      if (endDate != null) {
        queryParameters['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final response = await _dio.get(
        '/api/teams/$teamId/transactions',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load transactions: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to load transactions: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

// МЕТОД УДАЛЕН: getTransactionsByCategory теперь избыточен, используем fetchTransactions напрямую
/*
  Future<List<TransactionModel>> getTransactionsByCategory({
    required String categoryId,
    required String type, // 'expense' или 'income'
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  }) async {
    final teamId = _ref.read(selectedTeamIdProvider);
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot fetch category transactions.');
    }

    // Переиспользуем существующий метод fetchTransactions
    return fetchTransactions(
      teamId: teamId, // teamId теперь не нужен здесь, он внутри fetchTransactions
      categoryId: categoryId,
      transactionType: type,
      startDate: startDate,
      endDate: endDate,
      accountId: accountId,
    );
  }
  */
}

// Провайдер для TransactionRepository (ОН ПРАВИЛЬНЫЙ, ОСТАЕТСЯ БЕЗ ИЗМЕНЕНИЙ)
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionRepository(dio, ref);
});