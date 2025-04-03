import 'package:drift/drift.dart';

class UserSettings extends Table {
  TextColumn get key => text()();      // Пример: "theme_mode"
  TextColumn get value => text()();    // Пример: "light", "dark", "system"

  @override
  Set<Column> get primaryKey => {key};
}
