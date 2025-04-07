import 'package:flutter/foundation.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import 'package:flutter_app_1/core/services/offline_sync_service.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_local_data_source.dart';
import 'package:flutter_app_1/features/transactions/data/data_sources/transaction_remote_data_source.dart';
import 'package:flutter_app_1/features/transactions/utils/transaction_mapper.dart';
import '../../domain/models/transaction_entity.dart';

class TransactionRepository {
  final TransactionRemoteDataSource remote;
  final TransactionLocalDataSource local;
  final OfflineSyncService syncService;
  final AppDatabase db;
  final int userId;

  TransactionRepository({
    required this.remote,
    required this.local,
    required this.syncService,
    required this.userId,
    required this.db,
  });

  /// Подписка на все транзакции из локальной базы
  Stream<List<TransactionEntity>> watchAll() {
    return local.watchAllTransactions();
  }

  /// Получение и кэширование всех транзакций с сервера
  Future<List<TransactionEntity>> fetch() async {
    debugPrint('➡️ TransactionRepository.fetch() вызван');
    try {
      final dtos = await remote.fetchTransactions();
      debugPrint('⬅️ Получен ответ от API: ${dtos.length} элементов');
      final entities = dtos.map(TransactionMapper.fromDto).toList();

      for (final entity in entities) {
        try {
          await local.insertTransaction(entity);
          await db.printAllTransactions();
        } catch (e) {
          debugPrint('Ошибка при вставке: $e');
        }
      }

      return entities;
    } catch (e) {
      debugPrint('❌ Ошибка в TransactionRepository.fetch(): $e');
      return local.getAllTransactions();
    }
  }

  /// Создание транзакции
  Future<void> create(TransactionEntity entity) async {
    final dto = TransactionMapper.toDto(entity, userId: userId);

    try {
      await remote.createTransaction(dto);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'POST',
        endpoint: '/api/transactions',
        body: dto.toJson(),
      );
    }

    try {
      await db.insertTransaction(entity, userId: userId);
      await db.printAllTransactions();
    } catch (e) {
      debugPrint('Ошибка при локальной вставке: $e');
    }
  }

  /// Обновление транзакции
  Future<void> update(TransactionEntity entity) async {
    if (entity.serverId == null) {
      debugPrint('⛔ Нельзя обновить: serverId отсутствует');
      return;
    }

    final dto = TransactionMapper.toDto(entity, userId: userId);

    try {
      await remote.updateTransaction(entity.serverId!, dto);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'PUT',
        endpoint: '/api/transactions/${entity.serverId}',
        body: dto.toJson(),
      );
    }

    await db.updateTransaction(
      TransactionMapper.toFullDriftModel(entity, userId: userId), userId: userId,
    );
  }

  /// Удаление транзакции
  Future<void> delete(TransactionEntity entity) async {
    if (entity.serverId == null) {
      debugPrint('⛔ Нельзя удалить: serverId отсутствует');
      return;
    }

    try {
      await remote.deleteTransaction(entity.serverId!);
    } catch (_) {
      await syncService.enqueueRequest(
        method: 'DELETE',
        endpoint: '/api/transactions/${entity.serverId}',
      );
    }

    await local.deleteTransaction(entity.id!);
  }
}
