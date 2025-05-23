// lib/features/accounts/data/repositories/account_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Предполагаем, что dioProvider определен здесь
import '../../../auth/presentation/providers/auth_providers.dart'; // Для selectedTeamIdProvider
import '../../domain/models/account.dart'; // Ваша модель Account

// Провайдер для Dio, который уже должен быть настроен с интерсепторами для токена.
// final dioProvider = Provider<Dio>((ref) => Dio()); // Убедитесь, что этот провайдер у вас где-то есть и настроен!

class AccountRepository {
  final Dio _dio;
  final Ref _ref; // Добавляем Ref для доступа к другим провайдерам, например selectedTeamIdProvider

  AccountRepository(this._dio, this._ref);

  String? get _teamId => _ref.read(selectedTeamIdProvider);

  /// Получить список всех счетов для текущей команды
  Future<List<Account>> fetchAccounts() async {
    if (_teamId == null) {
      throw Exception('Team ID is not selected.');
    }
    try {
      final response = await _dio.get('/api/teams/$_teamId/accounts');
      if (response.data is! List) {
        throw Exception('Invalid response format for accounts: ${response.data}');
      }
      return (response.data as List).map((json) => Account.fromJson(json)).toList();
    } on DioException catch (e) {
      String message = 'Failed to fetch accounts.';
      if (e.response?.data != null && e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unknown error occurred while fetching accounts: $e');
    }
  }

  /// Создать новый счет
  Future<Account> createAccount({
    required String name,
    required double balance,
    required String currencyId, // Валюта обязательна при создании счета на бэкенде
  }) async {
    if (_teamId == null) {
      throw Exception('Team ID is not selected.');
    }
    try {
      final response = await _dio.post(
        '/api/teams/$_teamId/accounts',
        data: {
          'name': name,
          'balance': balance,
          'currency_id': currencyId,
          'team_id': _teamId, // Хотя бэкенд добавляет team_id сам, можно отправить для ясности
        },
      );
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Failed to create account.';
      if (e.response?.data != null && e.response?.data is Map) {
        // Попытка извлечь сообщения валидации или общие ошибки
        final errorData = e.response!.data;
        if (errorData['errors'] != null) {
          message = (errorData['errors'] as Map).values.map((e) => (e as List).join(', ')).join('; ');
        } else if (errorData['message'] != null) {
          message = errorData['message'].toString();
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unknown error occurred while creating account: $e');
    }
  }

  /// Обновить существующий счет
  Future<Account> updateAccount(String accountId, {
    String? name,
    double? balance,
    String? currencyId,
  }) async {
    if (_teamId == null) {
      throw Exception('Team ID is not selected.');
    }
    try {
      final response = await _dio.put(
        '/api/teams/$_teamId/accounts/$accountId',
        data: {
          if (name != null) 'name': name,
          if (balance != null) 'balance': balance,
          if (currencyId != null) 'currency_id': currencyId,
        },
      );
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Failed to update account.';
      if (e.response?.data != null && e.response?.data is Map) {
        final errorData = e.response!.data;
        if (errorData['errors'] != null) {
          message = (errorData['errors'] as Map).values.map((e) => (e as List).join(', ')).join('; ');
        } else if (errorData['message'] != null) {
          message = errorData['message'].toString();
        }
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unknown error occurred while updating account: $e');
    }
  }

  /// Удалить счет
  Future<void> deleteAccount(String accountId) async {
    if (_teamId == null) {
      throw Exception('Team ID is not selected.');
    }
    try {
      await _dio.delete('/api/teams/$_teamId/accounts/$accountId');
    } on DioException catch (e) {
      String message = 'Failed to delete account.';
      if (e.response?.data != null && e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('An unknown error occurred while deleting account: $e');
    }
  }
}

// Провайдер для AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>(
      (ref) => AccountRepository(ref.read(dioProvider), ref),
);