// lib/features/auth/data/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/services/token_service.dart';

class AuthRepository {
  final Dio dio;
  final TokenService tokenService;

  AuthRepository({required this.dio, required this.tokenService});

  Future<void> saveToken(String token) async {
    await tokenService.saveToken(token);
  }

  Future<String?> getToken() async {
    return await tokenService.getToken();
  }

  Future<void> deleteToken() async {
    await tokenService.deleteToken();
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
            // 'Content-Type': 'application/json', // <-- Добавь это
          },
        ),
      );

      // Парсим токен из ответа
      final data = response.data;
      if (data != null && data['access_token'] != null && data['access_token'] is String) {
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
          message = err['message'].toString(); // Убедимся, что это строка
        } else if (err is String) {
          message = err;
        }
      }
      // Перебрасываем ошибку, чтобы она была поймана в _LoginScreenState
      throw Exception(message);
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }
}
