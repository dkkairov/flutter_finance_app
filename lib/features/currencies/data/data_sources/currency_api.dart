import 'package:dio/dio.dart';
import '../models/currency_model.dart';

class CurrencyApi {
  final Dio dio;
  CurrencyApi(this.dio);

  Future<List<CurrencyModel>> fetchCurrencies() async {
    final response = await dio.get('/api/currencies');
    final data = response.data as List;
    return data.map((json) => CurrencyModel.fromJson(json)).toList();
  }
}
