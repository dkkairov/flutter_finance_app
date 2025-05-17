import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/currency_api.dart';
import '../../data/models/currency_model.dart';
import '../../../../core/api/dio_provider.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/currency_repository.dart'; // Провайдер Dio

final currencyApiProvider = Provider((ref) => CurrencyApi(ref.read(dioProvider)));
final currencyRepositoryProvider = Provider<CurrencyRepository>(
      (ref) => CurrencyRepositoryImpl(ref.read(currencyApiProvider)),
);

final currenciesProvider = FutureProvider<List<CurrencyModel>>((ref) async {
  return ref.read(currencyRepositoryProvider).getCurrencies();
});
