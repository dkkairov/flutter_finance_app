// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/token_service.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/dio_provider.dart'; // <--- НОВЫЙ ИМПОРТ

final selectedTeamIdProvider = StateProvider<String?>((ref) => null);

// Провайдер репозитория авторизации
final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(
    dio: ref.read(dioProvider), // <--- Используем централизованный dioProvider
    tokenService: ref.read(tokenServiceProvider),
  ),
);

// Провайдер состояния токена
final authTokenProvider = StateProvider<String?>((ref) => null);

// Новый FutureProvider для ИНИЦИАЛИЗАЦИИ токена при запуске приложения
// Этот провайдер будет ОДИН РАЗ читать токен из хранилища при старте
// и обновлять authTokenProvider
final authInitializationProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  final token = await repo.getToken();
  ref.read(authTokenProvider.notifier).state = token;
  print('AuthProviders: Token initialized: ${token != null ? "exists" : "null"}');
});

// Функция для выхода из системы
Future<void> performLogout(WidgetRef ref) async {
  await ref.read(authRepositoryProvider).deleteToken();
  ref.read(authTokenProvider.notifier).state = null;
}