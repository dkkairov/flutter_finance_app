// lib/features/currencies/data/repositories/currency_repository.dart

import 'package:dio/dio.dart';
import '../models/currency_model.dart';

class CurrencyRepository {
  final Dio _dio;

  CurrencyRepository(this._dio);

  // ИЗМЕНИТЕ СИГНАТУРУ МЕТОДА:
  Future<List<CurrencyModel>> fetchCurrencies() async { // <--- УДАЛЕН ПАРАМЕТР token
    try {
      final response = await _dio.get('/api/currencies'); // Токен добавляется через Interceptor
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CurrencyModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load currencies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error fetching currencies: ${e.response?.statusCode} ${e.response?.data}');
        throw Exception('Failed to load currencies: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        print('Dio error fetching currencies: ${e.message}');
        throw Exception('Failed to load currencies: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error fetching currencies: $e');
      rethrow;
    }
  }
}