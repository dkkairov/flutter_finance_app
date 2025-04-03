import 'package:flutter_app_1/core/services/offline_sync_service.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_local_data_source.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_remote_data_source.dart';
import 'package:flutter_app_1/features/transactions/utils/transaction_mapper.dart';

import '../../domain/models/transaction_entity.dart';

class TransactionRepository {
  final TransactionRemoteDataSource remote;
  final TransactionLocalDataSource local;
  final OfflineSyncService syncService;

  TransactionRepository({
    required this.remote,
    required this.local,
    required this.syncService,
  });

  /// Подписка на все транзакции из локальной базы
  Stream<List<TransactionEntity>> watchAll() {
    return local.watchAllTransactions();
  }

  /// Получение и кэширование всех транзакций с сервера
  Future<List<TransactionEntity>> fetch() async {
    try {
      final dtos = await remote.fetchTransactions();
      final List<TransactionEntity> entities = dtos
          .map((dto) => TransactionMapper.fromDto(dto))
          .toList();

      for (final entity in entities) {
        await local.insertTransaction(entity); // upsert можно улучшить позже
      }

      return entities;
    } catch (_) {
      return local.getAllTransactions();
    }
  }

  /// Создание транзакции (и офлайн-поддержка)
  Future<void> create(TransactionEntity entity) async {
    try {
      final dto = TransactionMapper.toDto(entity, local.userId);
      await remote.createTransaction(dto);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'POST',
        endpoint: '/api/transactions',
        body: TransactionMapper.toDto(entity, local.userId).toJson(),
      );
    }

    await local.insertTransaction(entity);
  }

  /// Обновление транзакции
  Future<void> update(TransactionEntity entity) async {
    try {
      final dto = TransactionMapper.toDto(entity, local.userId);
      await remote.updateTransaction(entity.id, dto);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'PUT',
        endpoint: '/api/transactions/${entity.id}',
        body: TransactionMapper.toDto(entity, local.userId).toJson(),
      );
    }

    await local.updateTransaction(entity);
  }

  /// Удаление транзакции
  Future<void> delete(int id) async {
    try {
      await remote.deleteTransaction(id);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'DELETE',
        endpoint: '/api/transactions/$id',
      );
    }

    await local.deleteTransaction(id);
  }
}
