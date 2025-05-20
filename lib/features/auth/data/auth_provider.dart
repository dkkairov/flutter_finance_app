import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../presentation/providers/auth_providers.dart';
import 'auth_repository.dart';

final authProvider = Provider<AuthService>((ref) {
  final api = ref.read(apiServiceProvider);          // Экземпляр ApiService
  final authRepo = ref.read(authRepositoryProvider); // Экземпляр AuthRepository
  return AuthService(api, authRepo);
});

class AuthService {
  final ApiService apiService;
  final AuthRepository authRepository;

  AuthService(this.apiService, this.authRepository);

  Future<bool> login(String email, String password) async {
    try {
      // 1. Отправляем запрос через экземпляр apiService
      final response = await apiService.post('/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // 2. Извлекаем token из response.data
        final token = response.data['token'] as String?;
        if (token != null && token.isNotEmpty) {
          // 3. Сохраняем token в SecureStorage через authRepository
          await authRepository.saveToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // 1. Отправляем запрос на logout (если нужно)
      await apiService.post('/logout', {});
    } catch (e) {
      // пропускаем
    } finally {
      // 2. Удаляем локальный токен
      await authRepository.deleteToken();
    }
  }
}
