import 'package:drift/drift.dart';

// part 'user_settings_table.g.dart';

class UserSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
