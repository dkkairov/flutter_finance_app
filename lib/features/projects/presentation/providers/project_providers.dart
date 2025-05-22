// lib/features/projects/presentation/providers/project_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Для доступа к Dio
import '../../../auth/presentation/providers/auth_providers.dart'; // Для доступа к selectedTeamIdProvider
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

// Провайдер для ProjectRepository
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRepository(dio);
});

// FutureProvider для получения списка проектов
// Он зависит от selectedTeamIdProvider, чтобы автоматически перезапускаться при смене команды
final projectsProvider = FutureProvider.autoDispose<List<ProjectModel>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  final teamId = ref.watch(selectedTeamIdProvider); // Получаем ID выбранной команды

  if (teamId == null) {
    // Если команда не выбрана, возвращаем пустой список или выбрасываем ошибку
    print('DEBUG: projectsProvider: teamId is null, returning empty list.');
    return [];
  }

  print('DEBUG: projectsProvider: Fetching projects for teamId = $teamId');
  return repository.fetchProjects(teamId: teamId);
});