import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/core/api/dio_provider.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/core/services/offline_sync_service.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_local_data_source.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_remote_data_source.dart';

import '../../../../core/network/network_status_notifier.dart';

/// Провайдер базы данных (AppDatabase)
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

/// Провайдер userId — заглушка, пока нет авторизации
final userIdProvider = Provider<int>((ref) => 1); // заменить на реального пользователя

/// Провайдер локального источника данных
final transactionLocalDataSourceProvider = Provider<TransactionLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(userIdProvider);
  return TransactionLocalDataSource(db: db, userId: userId);
});

/// Провайдер удалённого источника данных
final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionRemoteDataSource(dio: dio);
});

/// Провайдер OfflineSyncService
final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  final dio = ref.watch(dioProvider);
  final db = ref.watch(appDatabaseProvider);
  final networkStatus = ref.watch(networkStatusProvider);
  return OfflineSyncService(
    dio: dio,
    db: db,
    networkStatusProvider: networkStatus,
  );
});
