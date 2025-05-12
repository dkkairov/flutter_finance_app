import 'package:drift/drift.dart';

class TransactionsTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // локальный ID
  IntColumn get serverId => integer().nullable()(); // ID на сервере
  IntColumn get userId => integer()();
  TextColumn get transactionType => text()(); // income | expense | transfer
  IntColumn get transactionCategoryId => integer().nullable()();
  RealColumn get amount => real()();
  IntColumn get accountId => integer().nullable()();
  IntColumn get projectId => integer().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get fromAccountId => integer().nullable()(); // для переводов
  IntColumn get toAccountId => integer().nullable()();

  // 🔽 Для синхронизации
  DateTimeColumn get updatedAt => dateTime().nullable()(); // локальное время изменения
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))(); // требует отправки
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))(); // удалена локально, но ещё не на сервере
}
