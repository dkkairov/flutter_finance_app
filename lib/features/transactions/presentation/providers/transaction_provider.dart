import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart';

import '../../domain/models/transaction_entity.dart';

/// Провайдер стрима транзакций (обновляется из локальной базы)
final transactionStreamProvider = StreamProvider<List<TransactionEntity>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchAll();
});

/// Провайдер репозитория
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  // Здесь должны быть провайдеры для remote, local и syncService
  // Временные заглушки — заменить на реальные провайдеры
  final remote = ref.watch(transactionRemoteDataSourceProvider);
  final local = ref.watch(transactionLocalDataSourceProvider);
  final sync = ref.watch(offlineSyncServiceProvider);

  return TransactionRepository(
    remote: remote,
    local: local,
    syncService: sync,
  );
});
