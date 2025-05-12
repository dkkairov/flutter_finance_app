import 'package:drift/drift.dart';

class PendingRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get method => text()(); // 'POST', 'PUT', 'DELETE'
  TextColumn get endpoint => text()(); // API-эндпоинт
  TextColumn get data => text()(); // JSON-данные запроса
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
