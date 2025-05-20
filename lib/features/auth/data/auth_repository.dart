// lib/features/auth/data/auth_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String> login({required String email, required String password}) async {
    // Тут вызов к API через Dio, возвращающий токен
    // Для MVP-заглушки:
    await Future.delayed(const Duration(seconds: 1));
    return 'mocked_token';
  }
}
