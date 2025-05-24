// lib/features/reports/data/repositories/report_repository.dart

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart'; // Для DateFormat
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart'; // Путь к selectedTeamIdProvider
import '../../domain/models/category_report_item_model.dart'; // Путь к вашей модели

class ReportRepository {
  final Dio _dio;
  final Ref _ref; // Ref нужен для доступа к другим провайдерам, например, selectedTeamIdProvider

  // Конструктор теперь ожидает Dio и Ref
  ReportRepository(this._dio, this._ref);

  // Метод для получения отчета по категориям (для ошибки "The method 'getCategoryReport' isn't defined")
  Future<List<CategoryReportItemModel>> getCategoryReport({
    required String type, // 'expense' или 'income'
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  }) async {
    final teamId = _ref.read(selectedTeamIdProvider);
    if (teamId == null) {
      throw Exception('Team ID is not selected. Cannot fetch category report.');
    }

    try {
      final queryParameters = <String, dynamic>{
        'type': type, // Параметр для бэкенда, указывающий тип отчета (расходы/доходы)
        'start_date': DateFormat('yyyy-MM-dd').format(startDate),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      };
      if (accountId != null) {
        queryParameters['account_id'] = accountId;
      }

      // Адаптируйте этот эндпоинт к вашему API
      // Пример: /api/teams/{teamId}/reports/categories
      final response = await _dio.get(
        '/api/teams/$teamId/reports/categories',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Преобразуем JSON данные в список CategoryReportItemModel
        return data.map((json) => CategoryReportItemModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category report: ${response.statusCode} ${response.data}');
      }
    } on DioException catch (e) {
      print('Dio error fetching category report: ${e.message}');
      print('Response data: ${e.response?.data}');
      if (e.response != null && e.response!.statusCode == 422) {
        throw Exception('Validation error: ${e.response!.data['message']} - ${e.response!.data['errors']}');
      }
      throw Exception('Failed to fetch category report: ${e.message}');
    } catch (e) {
      print('Unknown error fetching category report: $e');
      rethrow;
    }
  }
}