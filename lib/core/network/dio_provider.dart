// lib/core/network/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/token_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    headers: {'Accept': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final tokenService = ref.read(tokenServiceProvider);
        final access_token = await tokenService.getToken();
        print('🟢 Токен для запроса: $access_token'); // Добавь для отладки!
        if (access_token != null && access_token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $access_token';
        }
        handler.next(options);
      },
    ),
  );
  return dio;
});
