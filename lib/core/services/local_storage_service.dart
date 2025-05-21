// lib/core/services/local_storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _selectedTeamIdKey = 'selected_team_id';

  static Future<void> saveSelectedTeamId(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedTeamIdKey, teamId);
  }

  static Future<String?> loadSelectedTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedTeamIdKey);
  }
}
