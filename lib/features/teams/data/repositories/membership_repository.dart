// lib/features/teams/data/repositories/membership_repository.dart

import 'package:dio/dio.dart';
import '../models/membership_model.dart'; // Импорт новой модели
// import '../../../../core/models/user.dart'; // User модель не нужна здесь напрямую, так как работаем с MembershipModel

class MembershipRepository {
  final Dio dio;

  MembershipRepository({required this.dio});

  // Получить список всех членств для команды
  Future<List<MembershipModel>> fetchMembershipsForTeam(String teamId) async {
    print('Fetching memberships for team: $teamId');
    try {
      final response = await dio.get('/api/teams/$teamId/memberships');
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List;
      } else if (response.data is Map<String, dynamic> && response.data['data'] is List) {
        data = response.data['data'] as List;
      } else {
        throw Exception('Некорректный формат данных: ${response.data}');
      }
      print('data type: ${data.runtimeType}');
      return data.map((json) => MembershipModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Неизвестная ошибка при получении участников команды: $e');
    }
  }


  // **ВНИМАНИЕ**: Этот метод соответствует MembershipController@store, который ожидает user_id
  // Для "Добавить пользователя по email" потребуется либо найти существующего пользователя по email
  // на клиенте и передать его user_id, либо изменить бэкенд, чтобы он принимал email
  // и сам искал/создавал пользователя, а затем создавал Membership.
  // Пока оставляем его как есть, принимающим user_id и role.
  Future<MembershipModel> createMembership(String teamId, String userId, String role) async {
    try {
      final response = await dio.post(
        '/api/teams/$teamId/memberships',
        data: {
          'user_id': userId,
          'role': role,
        },
      );
      // Бэкенд возвращает одиночный MembershipResource, который может быть обернут в 'data'
      return MembershipModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      String message = 'Ошибка при приглашении участника';
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
      throw Exception('Неизвестная ошибка при приглашении участника: $e');
    }
  }

  // Обновить роль участника
  Future<MembershipModel> updateMembershipRole(String teamId, String membershipId, String newRole) async {
    try {
      final response = await dio.put(
        '/api/teams/$teamId/memberships/$membershipId',
        data: {'role': newRole},
      );
      // Бэкенд возвращает одиночный MembershipResource, который может быть обернут в 'data'
      return MembershipModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      String message = 'Ошибка при обновлении роли участника';
      if (e.response != null && e.response?.data != null) {
        final err = e.response!.data;
        if (err is Map && err['message'] != null) {
          message = err.toString();
        } else if (err is String) {
          message = err;
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при обновлении роли участника: $e');
    }
  }

  // НОВЫЙ МЕТОД: Пригласить пользователя в команду по email
  Future<MembershipModel> inviteMemberByEmail(String teamId, String email, {String? role}) async {
    try {
      final response = await dio.post(
        '/api/teams/$teamId/memberships/invite-by-email', // <--- НОВЫЙ ЭНДПОИНТ
        data: {
          'email': email,
          'role': role, // null, если не указано, бэкенд возьмет 'member'
        },
      );
      // Бэкенд возвращает одиночный MembershipResource, который может быть обернут в 'data'
      return MembershipModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      String message = 'Ошибка при приглашении участника';
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
      throw Exception('Неизвестная ошибка при приглашении участника: $e');
    }
  }

  // Удалить участника из команды
  Future<void> removeMembership(String teamId, String membershipId) async {
    try {
      await dio.delete('/api/teams/$teamId/memberships/$membershipId');
    } on DioException catch (e) {
      String message = 'Ошибка при удалении участника';
      if (e.response != null && e.response?.data != null) {
        final err = e.response!.data;
        if (err is Map && err['message'] != null) {
          message = err.toString();
        } else if (err is String) {
          message = err;
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Неизвестная ошибка при удалении участника: $e');
    }
  }
}