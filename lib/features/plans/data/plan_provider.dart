import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';

final plansProvider = StateNotifierProvider<PlansNotifier, Map<String, double>>(
      (ref) => PlansNotifier(),
);

class PlansNotifier extends StateNotifier<Map<String, double>> {
  PlansNotifier() : super({'incomePlan': 0.0, 'expensePlan': 0.0});

  Future<void> fetchPlans(int year, int month) async {
    final response = await ApiService.get('/plans/$year/$month');
    if (response.statusCode == 200) {
      state = Map<String, double>.from(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки плана');
    }
  }

  Future<void> savePlan(double incomePlan, double expensePlan) async {
    final response = await ApiService.post('/plans', {
      'income_plan': incomePlan,
      'expense_plan': expensePlan,
    });

    if (response.statusCode == 201) {
      state = {'incomePlan': incomePlan, 'expensePlan': expensePlan};
    } else {
      throw Exception('Ошибка сохранения плана');
    }
  }
}
