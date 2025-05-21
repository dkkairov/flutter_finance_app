// // lib/features/transaction_categories/presentation/providers/transaction_category_providers.dart
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';
// import '../../data/models/transaction_category_model.dart';
// import '../../data/repositories/transaction_category_repository.dart';
//
// // Провайдер Dio
// final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(
//   baseUrl: 'http://10.0.2.2:8000',
//   headers: {'Accept': 'application/json'},
// )));
//
// final transactionCategoryRepositoryProvider = Provider(
//       (ref) => TransactionCategoryRepository(ref.watch(dioProvider)),
// );
//
// final expenseTransactionCategoriesProvider = FutureProvider.family<List<TransactionCategoryModel>, String>(
//       (ref, teamId) async {
//     return ref
//         .watch(transactionCategoryRepositoryProvider)
//         .fetchTransactionCategories(teamId: teamId, type: 'expense');
//   },
// );
//
// final incomeTransactionCategoriesProvider = FutureProvider.family<List<TransactionCategoryModel>, String>(
//       (ref, teamId) async {
//     return ref
//         .watch(transactionCategoryRepositoryProvider)
//         .fetchTransactionCategories(teamId: teamId, type: 'income');
//   },
// );
