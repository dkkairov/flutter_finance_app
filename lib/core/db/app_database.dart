import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart'; // только для debugPrint
import 'package:flutter_app_1/core/db/transactions_table.dart';
import 'package:flutter_app_1/core/db/pending_requests_table.dart';
import 'package:flutter_app_1/core/db/user_settings_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/transactions/domain/models/transaction_entity.dart';
import '../../features/transactions/utils/transaction_mapper.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, PendingRequests, UserSettings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // 🚨 увеличил версию с 1 на 2

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.createTable(userSettings); // добавили новую таблицу
      }
    },
    beforeOpen: (details) async {
      // при необходимости можно сюда добавить seed-данные
    },
  );

  // ▸ Transactions
  Future<void> insertTransaction(TransactionEntity entity, {required int userId}) async {
    final companion = TransactionMapper.toDb(entity, userId: userId);
    debugPrint('💾 Сохраняю в локальную БД транзакцию: ${entity.id}');
    await into(transactions).insertOnConflictUpdate(companion); // <-- именно insertOnConflictUpdate
  }


  Future<List<Transaction>> getAllTransactions() =>
      select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<bool> updateTransaction(Transaction txn) =>
      update(transactions).replace(txn);

  Future<int> deleteTransactionById(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  // ▸ Pending Requests
  Future<int> insertPendingRequest(PendingRequestsCompanion req) =>
      into(pendingRequests).insert(req);

  Future<List<PendingRequest>> getAllPendingRequests() =>
      select(pendingRequests).get();

  Future<void> deletePendingRequestById(int id) =>
      (delete(pendingRequests)..where((r) => r.id.equals(id))).go();

  Future<void> clearPendingRequests() =>
      delete(pendingRequests).go();

  // ▸ User Settings
  Future<void> saveUserSetting(String key, String value) =>
      into(userSettings).insertOnConflictUpdate(UserSetting(key: key, value: value));

  Stream<String?> watchUserSetting(String key) =>
      (select(userSettings)..where((tbl) => tbl.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'app.db');
    return NativeDatabase(File(dbPath));
  });
}
