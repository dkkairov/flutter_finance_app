import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>(
      (ref) => ProjectsNotifier(),
);

class Project {
  final String id;
  final String name;
  final String description;

  Project({required this.id, required this.name, required this.description});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class ProjectsNotifier extends StateNotifier<List<Project>> {
  ProjectsNotifier() : super([]);

  Future<void> fetchProjects() async {
    final response = await ApiService.get('/projects');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      state = jsonData.map((item) => Project.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка загрузки проектов');
    }
  }

  Future<void> addProject(Project project) async {
    final response = await ApiService.post('/projects', {
      'name': project.name,
      'description': project.description,
    });

    if (response.statusCode == 201) {
      fetchProjects();
    } else {
      throw Exception('Ошибка добавления проекта');
    }
  }

  Future<void> deleteProject(String id) async {
    final response = await ApiService.delete('/projects/$id');
    if (response.statusCode == 200) {
      fetchProjects();
    } else {
      throw Exception('Ошибка удаления проекта');
    }
  }
}
