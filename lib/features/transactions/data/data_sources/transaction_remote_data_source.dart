import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_1/core/models/transaction_dto.dart';

class TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSource({required this.dio});

  /// Получение списка транзакций
  Future<List<TransactionDto>> fetchTransactions() async {
    debugPrint('➡️ TransactionRemoteDataSource.fetchTransactions() вызван');
    try {
      final response = await dio.get('/api/transactions');
      debugPrint('⬅️ Ответ от API (статус ${response.statusCode}): ${response.data}'); // <--- Добавьте эту строку
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
    final response = await dio.post('/api/transactions', data: dto.toJson());
    return TransactionDto.fromJson(response.data);
  }

  /// Обновление транзакции
  Future<TransactionDto> updateTransaction(int id, TransactionDto dto) async {
    final response = await dio.put('/api/transactions/$id', data: dto.toJson());
    return TransactionDto.fromJson(response.data);
  }

  /// Удаление транзакции
  Future<void> deleteTransaction(int id) async {
    await dio.delete('/api/transactions/$id');
  }
}
