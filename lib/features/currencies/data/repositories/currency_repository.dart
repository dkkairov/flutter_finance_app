import 'package:dio/dio.dart';
import '../models/currency_model.dart';

class CurrencyRepository {
  final Dio dio;

  CurrencyRepository(this.dio);

  Future<List<CurrencyModel>> fetchCurrencies({required String token}) async {
    try {
      final response = await dio.get(
        '/api/currencies',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      try {
        final List<CurrencyModel> currencies = (response.data as List)
            .map((e) => CurrencyModel.fromJson(e)).toList();
        return currencies;
      } catch (e) {
        print('Ошибка парсинга: $e. Ответ: ${response.data}');
        throw Exception('Ошибка парсинга валют.');
      }
    } on DioException catch (e) {
      // Можно добавить разные типы обработки ошибок
      throw Exception(
        e.response?.data['message'] ??
            'Не удалось загрузить валюты. Проверьте соединение или повторите попытку.',
      );
    }
  }
}
