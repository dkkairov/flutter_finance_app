// lib/features/teams/data/repositories/team_repository.dart
import 'package:dio/dio.dart';
import '../models/team_model.dart';

class TeamRepository {
  final Dio dio;

  TeamRepository({required this.dio});

  Future<List<TeamModel>> fetchTeams() async {
    try {
      final response = await dio.get('/api/teams');
      print('TEAM API RESPONSE: ${response.data}');
      final data = response.data;
      final List list = data is List ? data : (data['data'] ?? []);
      return list.map((json) => TeamModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      String message = 'Ошибка при получении команд';
      if (e.response != null && e.response?.data != null) {
        final err = e.response!.data;
        if (err is Map && err['message'] != null) {
          message = err['message'].toString();
        } else if (err is String) {
          message = err;
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при получении команд: $e');
    }
  }

  // Создание новой команды
  Future<TeamModel> createTeam(String name) async {
    try {
      final response = await dio.post('/api/teams', data: {'name': name});
      return TeamModel.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Ошибка при создании команды';
      if (e.response != null && e.response?.data != null && e.response!.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при создании команды: $e');
    }
  }

  // Редактирование существующей команды
  Future<TeamModel> updateTeam(String id, String name) async {
    try {
      final response = await dio.put('/api/teams/$id', data: {'name': name});
      return TeamModel.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Ошибка при обновлении команды';
      if (e.response != null && e.response?.data != null && e.response!.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при обновлении команды: $e');
    }
  }

  // НОВЫЙ МЕТОД: Удаление команды
  Future<void> deleteTeam(String id) async {
    try {
      final response = await dio.delete('/api/teams/$id');
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete team: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = 'Ошибка при удалении команды';
      if (e.response != null && e.response?.data != null && e.response!.data is Map && e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при удалении команды: $e');
    }
  }
}