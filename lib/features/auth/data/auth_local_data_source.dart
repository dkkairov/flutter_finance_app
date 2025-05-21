// lib/features/auth/data/auth_local_data_source.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
  }
}
