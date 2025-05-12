// lib/features/projects/presentation/providers/project_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/project.dart';

class ProjectNotifier extends StateNotifier<List<Project>> {
  ProjectNotifier() : super([]);

  int _nextProjectId = 1;

  void addProject(String name, String description) {
    final newProject = Project(id: _nextProjectId++, name: name, description: description);
    state = [...state, newProject];
  }

  void updateProject(int id, String name, String description) {
    state = [
      for (final project in state)
        if (project.id == id)
          project.copyWith(name: name, description: description)
        else
          project,
    ];
  }

  void deleteProject(int id) {
    state = state.where((project) => project.id != id).toList();
  }
}

final projectsProvider = StateNotifierProvider<ProjectNotifier, List<Project>>((ref) {
  return ProjectNotifier();
});