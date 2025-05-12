// lib/features/transactions/data/data_sources/transaction_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_1/features/transactions/domain/models/transaction_dto.dart';

class TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSource({required this.dio});

  /// Получение списка транзакций
  Future<List<TransactionDto>> fetchTransactions() async {
    debugPrint('➡️ TransactionRemoteDataSource.fetchTransactions() вызван');
    try {
      final response = await dio.get('/api/transactions');
      debugPrint('⬅️ Ответ от API (статус ${response.statusCode}): ${response.data}');
      final data = response.data as List;
      return data
          .map((json) => TransactionDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Ошибка в TransactionRemoteDataSource.fetchTransactions(): $e');
      rethrow;
    }
  }

  /// Создание транзакции
  Future<TransactionDto> createTransaction(TransactionDto dto) async {
    debugPrint('➡️ Создание транзакции на сервере: ${dto.toJson()}');
    final response = await dio.post('/api/transactions', data: dto.toJson());
    debugPrint('⬅️ Ответ от сервера: ${response.data}');
    return TransactionDto.fromJson(response.data);
  }

  /// Обновление транзакции по serverId
  Future<TransactionDto> updateTransaction(int serverId, TransactionDto dto) async {
    debugPrint('➡️ Обновление транзакции serverId=$serverId: ${dto.toJson()}');
    final response = await dio.put('/api/transactions/$serverId', data: dto.toJson());
    debugPrint('⬅️ Ответ от сервера: ${response.data}');
    return TransactionDto.fromJson(response.data);
  }

  /// Удаление транзакции по serverId
  Future<void> deleteTransaction(int serverId) async {
    debugPrint('🗑️ Удаление транзакции serverId=$serverId');
    await dio.delete('/api/transactions/$serverId');
  }
}
