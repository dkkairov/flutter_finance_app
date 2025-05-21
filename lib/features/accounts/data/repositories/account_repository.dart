// lib/features/accounts/data/repositories/account_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/account.dart'; // Путь к твоему dioProvider

class AccountRepository {
  final Dio _dio;
  final Ref _ref; // Добавляем Ref для доступа к другим провайдерам

  AccountRepository(this._dio, this._ref);

  /// Получает список счетов для текущей выбранной команды.
  Future<List<Account>> fetchAccounts() async {
    try {
      final teamId = _ref.read(selectedTeamIdProvider); // Получаем ID выбранной команды из провайдера

      if (teamId == null) {
        throw Exception('Team ID is not selected. Cannot fetch accounts.');
      }

      final response = await _dio.get('/api/teams/$teamId/accounts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load accounts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Обработка ошибок Dio (например, нет сети, 401, 404 и т.д.)
      if (e.response != null) {
        print('Dio error fetching accounts: ${e.response?.statusCode} ${e.response?.data}');
        throw Exception('Failed to load accounts: ${e.response?.data['message'] ?? 'Unknown error'}');
      } else {
        print('Dio error fetching accounts: ${e.message}');
        throw Exception('Failed to load accounts: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error fetching accounts: $e');
      rethrow; // Перевыбрасываем для дальнейшей обработки
    }
  }
}

// Провайдер для AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dio = ref.watch(dioProvider); // Получаем экземпляр Dio
  return AccountRepository(dio, ref); // Передаем Dio и Ref
});