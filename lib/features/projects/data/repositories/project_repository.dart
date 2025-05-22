// lib/features/projects/data/repositories/project_repository.dart
import 'package:dio/dio.dart';
import '../models/project_model.dart';

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
}