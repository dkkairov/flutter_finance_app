// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/api/api_service.dart';
//
// final reportProvider = FutureProvider<Map<String, dynamic>>((ref) async {
//   final response = await ApiService.get('/reports/summary');
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Ошибка получения отчётов');
//   }
// });
