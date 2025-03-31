import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'transactions_table.dart';
import 'pending_requests_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Transactions, PendingRequests])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ========== Транзакции ==========
  Future<List<TransactionDb>> getAllTransactions() =>
      select(transactions).get();

  Future<int> insertTransaction(TransactionsCompanion entity) =>
      into(transactions).insert(entity);

  Future<bool> updateTransaction(TransactionsCompanion entity) =>
      update(transactions).replace(entity);

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  // ========== Pending Requests ==========
  // Метод, которого не хватало
  Future<List<PendingRequest>> getPendingRequests() =>
      select(pendingRequests).get();

  Future<int> addPendingRequest(PendingRequestsCompanion request) =>
      into(pendingRequests).insert(request);

  Future<int> deletePendingRequest(int id) =>
      (delete(pendingRequests)..where((r) => r.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
