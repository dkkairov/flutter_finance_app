import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../data/models/currency_model.dart';
import '../../data/repositories/currency_repository.dart';

final dioProvider = Provider((ref) => Dio(BaseOptions(
  baseUrl: 'http://10.0.2.2:8000',
  headers: {'Accept': 'application/json'},
)));

final currencyRepositoryProvider = Provider(
      (ref) => CurrencyRepository(ref.watch(dioProvider)),
);

// Возвращает Future<List<CurrencyModel>>
final currenciesProvider = FutureProvider<List<CurrencyModel>>((ref) async {
  final repo = ref.watch(currencyRepositoryProvider);
  final token = '5|LtIGydW2tWqSPgzSLzX55nZoZOyMG2qbrJ8gl2sod001f56e'; // Лучше получать из secure storage/authProvider
  return await repo.fetchCurrencies(token: token);
});
