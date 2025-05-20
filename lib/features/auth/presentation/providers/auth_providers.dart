// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

// Провайдер Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000')); // или твой реальный baseUrl
});

// Провайдер репозитория авторизации
final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(dio: ref.read(dioProvider)),
);

// Провайдер состояния токена
final authTokenProvider = StateProvider<String?>((ref) => null);

// FutureProvider для инициализации токена при старте
final authInitProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  final token = await repo.getToken();
  ref.read(authTokenProvider.notifier).state = token;
});

// Logout-функция (вызывается из Notifier)
Future<void> performLogout(WidgetRef ref) async {
  await ref.read(authRepositoryProvider).deleteToken();
  ref.read(authTokenProvider.notifier).state = null;
}
