// lib/features/transactions/data/repositories/transaction_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Предполагается, что у вас есть dio_provider
import '../../../auth/presentation/providers/auth_providers.dart'; // Для selectedTeamIdProvider
import '../models/transaction_payload.dart';
import '../models/transfer_payload.dart';

class TransactionRepository {
  final Dio _dio;
  final Ref _ref; // Используем Ref для чтения других провайдеров, например teamId

  TransactionRepository(this._dio, this._ref);

  // Метод для создания расхода или дохода
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
      // Обработка ошибок Dio
      print('Dio error creating transaction: ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response != null && e.response!.statusCode == 422) {
        // Ошибки валидации
        throw Exception('Validation error: ${e.response!.data['message']} - ${e.response!.data['errors']}');
      }
      throw Exception('Failed to create transaction: ${e.message}');
    } catch (e) {
      print('Unknown error creating transaction: $e');
      rethrow;
    }
  }

  // Метод для создания перевода
  Future<void> createTransfer(TransferPayload payload) async {
    final teamId = _ref.read(selectedTeamIdProvider);
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot create transfer.');
    }

    try {
      final response = await _dio.post(
        '/api/teams/$teamId/transfers', // Эндпоинт для переводов
        data: payload.toJson(),
      );
      if (response.statusCode == 201) {
        print('Transfer created successfully!');
      } else {
        throw Exception('Failed to create transfer: ${response.statusCode} ${response.data}');
      }
    } on DioException catch (e) {
      // Обработка ошибок Dio
      print('Dio error creating transfer: ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response != null && e.response!.statusCode == 422) {
        // Ошибки валидации
        throw Exception('Validation error: ${e.response!.data['message']} - ${e.response!.data['errors']}');
      }
      throw Exception('Failed to create transfer: ${e.message}');
    } catch (e) {
      print('Unknown error creating transfer: $e');
      rethrow;
    }
  }
}

// Провайдер для TransactionRepository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dio = ref.watch(dioProvider); // Используем Dio из dioProvider
  return TransactionRepository(dio, ref);
});