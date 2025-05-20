// lib/features/auth/data/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository({required this.dio});

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// Реальная авторизация — отправка email и password на /api/login
  Future<String> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        '/api/login', // или /api/v1/login, если твой API с версией
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            // Возможно, потребуется: 'Content-Type': 'application/json',
          },
        ),
      );

      // Парсим токен из ответа
      final data = response.data;
      if (data['access_token'] != null && data['access_token'] is String) {
        return data['access_token'];
      } else {
        throw Exception('Ошибка авторизации: не найден токен в ответе сервера.');
      }
    } on DioException catch (e) {
      // Чтение сообщения из ошибки API
      String message = 'Ошибка сети';
      if (e.response != null && e.response?.data != null) {
        final err = e.response!.data;
        if (err is Map && err['message'] != null) {
          message = err['message'];
        } else if (err is String) {
          message = err;
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }
}
