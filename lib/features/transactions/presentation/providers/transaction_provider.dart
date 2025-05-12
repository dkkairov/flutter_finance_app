import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_local_data_source.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_remote_data_source.dart';
import 'package:flutter_app_1/core/services/offline_sync_service.dart';
import 'package:flutter_app_1/features/transactions/domain/models/transaction_entity.dart';
import 'package:flutter_app_1/core/api/dio_provider.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/core/network/network_status_notifier.dart';

/// Провайдер базы данных
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

/// Временный userId (до авторизации)
final userIdProvider = Provider<int>((ref) => 1);

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
  return OfflineSyncService(dio: dio, db: db, networkStatusProvider: networkStatus);
});

/// Провайдер репозитория
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final remote = ref.watch(transactionRemoteDataSourceProvider);
  final local = ref.watch(transactionLocalDataSourceProvider);
  final sync = ref.watch(offlineSyncServiceProvider);
  final userId = ref.watch(userIdProvider);
  final db = ref.watch(appDatabaseProvider);

  return TransactionRepository(
    remote: remote,
    local: local,
    syncService: sync,
    userId: userId,
    db: db,
  );
});

/// Stream всех транзакций (локальный Drift)
final transactionStreamProvider = StreamProvider<List<TransactionEntity>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchAll();
});

/// Команда на обновление всех транзакций из API
final transactionFetchProvider = Provider<Future<List<TransactionEntity>>>((ref) async {
  debugPrint('➡️ Выполняется transactionFetchProvider');
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.fetch();
});
