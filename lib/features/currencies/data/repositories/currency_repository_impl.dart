import '../../domain/currency_repository.dart';
import '../data_sources/currency_api.dart';
import '../models/currency_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyApi api;
  CurrencyRepositoryImpl(this.api);

  @override
  Future<List<CurrencyModel>> getCurrencies() => api.fetchCurrencies();
}