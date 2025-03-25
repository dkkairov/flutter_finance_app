import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<bool> {
  static const _storage = FlutterSecureStorage();

  AuthNotifier() : super(false);

  Future<void> login(String email, String password) async {
    final response = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await ApiService.saveToken(token);
      state = true;
    } else {
      state = false;
      throw Exception('Ошибка авторизации');
    }
  }

  Future<void> logout() async {
    await ApiService.deleteToken();
    state = false;
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'token');
    state = token != null;
  }
}
