import 'package:drift/drift.dart';

class PendingRequests extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get method => text()(); // 'POST', 'PUT', 'DELETE'
  TextColumn get endpoint => text()(); // например: '/api/transactions'
  TextColumn get body => text().nullable()(); // JSON как строка
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)(); // для очередности
}
