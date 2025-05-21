import 'package:dio/dio.dart';
import '../../../../core/models/user.dart';

class TeamUsersRepository {
  final Dio dio;
  TeamUsersRepository(this.dio);

  Future<List<User>> fetchUsersForTeam(String teamId) async {
    final response = await dio.get('/api/teams/$teamId/users');
    final data = response.data is List ? response.data : (response.data['data'] ?? []);
    return data.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<User> fetchUser(String teamId, String userId) async {
    final response = await dio.get('/api/teams/$teamId/users/$userId');
    return User.fromJson(response.data);
  }

  Future<User> createUser(String teamId, Map<String, dynamic> payload) async {
    final response = await dio.post('/api/teams/$teamId/users', data: payload);
    return User.fromJson(response.data);
  }

  Future<User> updateUser(String teamId, String userId, Map<String, dynamic> payload) async {
    final response = await dio.put('/api/teams/$teamId/users/$userId', data: payload);
    return User.fromJson(response.data);
  }

  Future<void> deleteUser(String teamId, String userId) async {
    await dio.delete('/api/teams/$teamId/users/$userId');
  }
}
