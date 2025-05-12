// lib/core/services/offline_sync_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_app_1/core/db/app_database.dart';
import '../network/network_status_notifier.dart';

class OfflineSyncService {
  final Dio dio;
  final AppDatabase db;
  final NetworkStatus networkStatusProvider;

  OfflineSyncService({
    required this.dio,
    required this.db,
    required this.networkStatusProvider,
  });

  Future<void> enqueueRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final request = PendingRequestsCompanion.insert(
      method: method,
      endpoint: endpoint,
      body: Value(body != null ? jsonEncode(body) : null),
    );

    await db.insertPendingRequest(request);
  }

  Future<void> syncPendingRequests() async {
    final isOnline = await networkStatusProvider.isConnected();
    if (!isOnline) return;

    final pending = await db.getAllPendingRequests();

    for (final req in pending) {
      try {
        final data = req.body != null ? jsonDecode(req.body!) : null;

        switch (req.method.toUpperCase()) {
          case 'POST':
            await dio.post(req.endpoint, data: data);
            break;
          case 'PUT':
            await dio.put(req.endpoint, data: data);
            break;
          case 'DELETE':
            await dio.delete(req.endpoint);
            break;
          default:
            continue;
        }

        await db.deletePendingRequestById(req.id);
      } catch (e) {
        continue;
      }
    }
  }
}
