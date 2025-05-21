// lib/features/teams/presentation/providers/team_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../data/models/team_model.dart';
import '../../data/repositories/team_repository.dart';
import '../../../../core/network/dio_provider.dart'; // <--- НОВЫЙ ИМПОРТ


// Провайдер TeamRepository (ВАЖНО!)
final teamRepositoryProvider = Provider<TeamRepository>(
      (ref) => TeamRepository(
    dio: ref.watch(dioProvider), // <--- Используем централизованный dioProvider
  ),
);

// teamsProvider (список по API)
final teamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  // Используем .future для teamsProvider, чтобы избежать рекурсивной зависимости с selectedTeamInitProvider,
  // который также watch'ит teamsProvider
  // В данном случае, watch() здесь правилен, так как он ждет изменений в teamsProvider
  return ref.watch(teamRepositoryProvider).fetchTeams();
});

// StateProvider выбранной команды
final selectedTeamProvider = StateProvider<TeamModel?>((ref) => null);

// AsyncNotifier, который инициализирует выбранную команду при старте
final selectedTeamInitProvider = FutureProvider<void>((ref) async {
  // ВНИМАНИЕ: здесь очень важно использовать .future,
  // чтобы дождаться ЗАВЕРШЕНИЯ загрузки команд
  final teams = await ref.watch(teamsProvider.future);
  final storedTeamId = await LocalStorageService.loadSelectedTeamId();

  if (teams.isEmpty) {
    ref.read(selectedTeamProvider.notifier).state = null;
    return;
  }

  // Сначала ищем сохранённую
  if (storedTeamId != null) {
    final selected = teams.firstWhere(
          (t) => t.id == storedTeamId,
      orElse: () => teams.firstWhere((t) => t.isActive, orElse: () => teams.first),
    );
    ref.read(selectedTeamProvider.notifier).state = selected;
    return;
  }

  // Если не было сохранено — по дефолту первая активная
  final selected = teams.firstWhere((t) => t.isActive, orElse: () => teams.first);
  ref.read(selectedTeamProvider.notifier).state = selected;
});