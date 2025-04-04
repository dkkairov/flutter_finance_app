import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/transactions/presentation/providers/transaction_provider.dart';
import '../db/app_database.dart';

final userSettingsServiceProvider = Provider<UserSettingsService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserSettingsService(db);
});

class UserSettingsService {
  final AppDatabase _db;

  static const _themeKey = 'theme_mode';

  UserSettingsService(this._db);

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _db.into(_db.userSettings).insertOnConflictUpdate(
      UserSetting(
        key: _themeKey,
        value: mode.name,
      ),
    );
  }

  Stream<ThemeMode> watchThemeMode() {
    return (_db.select(_db.userSettings)
      ..where((tbl) => tbl.key.equals(_themeKey)))
        .watchSingleOrNull()
        .map((row) {
      if (row == null) return ThemeMode.system;
      return ThemeMode.values.byName(row.value);
    });
  }
}