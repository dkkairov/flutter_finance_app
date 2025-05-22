// lib/features/projects/data/repositories/project_repository.dart
import 'package:dio/dio.dart';
import '../models/project_model.dart';
import '../models/project_payload.dart';

class ProjectRepository {
  final Dio _dio;

  ProjectRepository(this._dio);

  Future<List<ProjectModel>> fetchProjects({required String teamId}) async {
    try {
      final response = await _dio.get('/api/teams/$teamId/projects');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('Projects API response: $data'); // Для отладки
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error fetching projects: ${e.response?.statusCode} ${e.response?.data}');
        throw Exception('Failed to load projects: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        print('Dio error fetching projects: ${e.message}');
        throw Exception('Failed to load projects: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error fetching projects: $e');
      rethrow;
    }
  }

  // МЕТОД: Создание проекта
  Future<ProjectModel> createProject({
    required String teamId,
    required ProjectPayload payload,
  }) async {
    try {
      final response = await _dio.post(
        '/api/teams/$teamId/projects', // URL из ProjectController@store
        data: payload.toJson(),
      );

      if (response.statusCode == 201) { // HTTP_CREATED
        return ProjectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create project: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error creating project: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while creating project.');
    } catch (e) {
      print('Unexpected error creating project: $e');
      rethrow;
    }
  }

  // МЕТОД: Обновление проекта
  Future<ProjectModel> updateProject({
    required String teamId,
    required String projectId,
    required ProjectPayload payload,
  }) async {
    try {
      final response = await _dio.put(
        '/api/teams/$teamId/projects/$projectId',
        data: payload.toJson(),
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update project: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error updating project: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while updating project.');
    } catch (e) {
      print('Unexpected error updating project: $e');
      rethrow;
    }
  }

  // НОВЫЙ МЕТОД: Удаление проекта
  Future<void> deleteProject({
    required String teamId,
    required String projectId,
  }) async {
    try {
      final response = await _dio.delete(
        '/api/teams/$teamId/projects/$projectId', // URL для удаления проекта
      );

      if (response.statusCode == 200) {
        return; // Успешное удаление, ничего не возвращаем
      } else {
        throw Exception('Failed to delete project: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error deleting project: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        throw Exception(e.response!.data['message'] ?? 'Validation failed.');
      }
      throw Exception(e.response?.data['message'] ?? 'Unknown error occurred while deleting project.');
    } catch (e) {
      print('Unexpected error deleting project: $e');
      rethrow;
    }
  }
}