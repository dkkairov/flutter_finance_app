// lib/core/services/token_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const String _key = 'access_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _key);
  }
}

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService();
});
