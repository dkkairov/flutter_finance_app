// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

// Провайдер репозитория авторизации
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

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
