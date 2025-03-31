import 'package:drift/drift.dart';

class PendingRequests extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Метод запроса (POST, PUT, DELETE)
  TextColumn get method => text()();

  // К какому эндпоинту запрос
  TextColumn get endpoint => text()();

  // Данные (JSON), если есть
  TextColumn get data => text().nullable()();

  // Когда запрос был создан (чтобы знать порядок)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
