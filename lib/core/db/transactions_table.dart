import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get transactionType => text()();
  IntColumn get transactionCategoryId => integer().nullable()();
  RealColumn get amount => real()();
  IntColumn get accountId => integer().nullable()();
  IntColumn get projectId => integer().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
