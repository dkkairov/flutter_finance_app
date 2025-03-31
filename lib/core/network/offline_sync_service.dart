import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../db/app_database.dart';
import '../providers/database_provider.dart';
import '../api/dio_provider.dart';

final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final dio = ref.watch(dioProvider);
  return OfflineSyncService(database: db, dio: dio);
});

class OfflineSyncService {
  final AppDatabase database;
  final Dio dio;

  OfflineSyncService({
    required this.database,
    required this.dio,
  });

  Future<void> syncPendingRequests() async {
    final pending = await database.getPendingRequests();
    for (final request in pending) {
      try {
        final requestData = request.data; // String?
        dynamic body;
        if (requestData != null && requestData.isNotEmpty) {
          body = jsonDecode(requestData); // теперь точно не null
        }

        late Response response;
        switch (request.method.toUpperCase()) {
          case 'POST':
            response = await dio.post(request.endpoint, data: body);
            break;
          case 'PUT':
            response = await dio.put(request.endpoint, data: body);
            break;
          case 'DELETE':
            response = await dio.delete(request.endpoint);
            break;
          default:
            throw UnsupportedError('Unsupported method: ${request.method}');
        }

        if (response.statusCode != null && response.statusCode! < 300) {
          await database.deletePendingRequest(request.id);
        }
      } catch (e) {
        print('Ошибка синхронизации запроса #${request.id}: $e');
      }
    }
  }
}
