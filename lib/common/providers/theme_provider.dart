import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/user_settings_service.dart';

/// Провайдер, стримит текущий режим темы из базы Drift
final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  final service = ref.watch(userSettingsServiceProvider);
  return service.watchThemeMode();
});

/// Провайдер контроллера, который управляет установкой темы
final themeModeControllerProvider = Provider<ThemeModeController>((ref) {
  final service = ref.watch(userSettingsServiceProvider);
  return ThemeModeController(service);
});

class ThemeModeController {
  final UserSettingsService _service;

  ThemeModeController(this._service);

  Future<void> setTheme(ThemeMode mode) => _service.saveThemeMode(mode);
}
