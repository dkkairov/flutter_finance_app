// lib/features/teams/presentation/providers/current_team_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/team_model.dart';

final currentTeamIdProvider = StateProvider<String?>((ref) => null);

// Пример: список всех team пользователя
final userTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  // Запроси через API команды пользователя (или из профиля)
  // ...
  throw UnimplementedError();
});
