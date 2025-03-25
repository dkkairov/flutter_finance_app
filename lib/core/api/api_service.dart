import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://example.com/api';
  static const _storage = FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  static Future<http.Response> post(String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$url'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> get(String url) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl$url'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }

  static Future<http.Response> delete(String url) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl$url'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }
}
