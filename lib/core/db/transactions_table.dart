// lib/core/db/transactions_table.dart

import 'package:drift/drift.dart';


@DataClassName('TransactionDb')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get transactionType => text()(); // 'income' или 'expense'
  IntColumn get transactionCategoryId => integer()();
  RealColumn get amount => real()();
  IntColumn get accountId => integer()();
  IntColumn get projectId => integer().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
