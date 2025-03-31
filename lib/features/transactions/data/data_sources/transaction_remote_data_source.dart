// lib/features/transactions/data/data_sources/transaction_remote_data_source.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_service.dart';
import '../../domain/models/transaction.dart';

final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>((ref) {
  final api = ref.watch(apiServiceProvider);
  return TransactionRemoteDataSource(api);
});

class TransactionRemoteDataSource {
  final ApiService apiService;

  TransactionRemoteDataSource(this.apiService);

  Future<List<Transaction>> fetchAll() async {
    final response = await apiService.get('/transactions');
    return (response.data as List)
        .map((json) => Transaction.fromJson(json))
        .toList();
  }

  Future<void> create(Transaction transaction) async {
    await apiService.post('/transactions', transaction.toJson());
  }

  Future<void> update(Transaction transaction) async {
    await apiService.put('/transactions/${transaction.id}', transaction.toJson());
  }

  Future<void> delete(int id) async {
    await apiService.delete('/transactions/$id');
  }
}
