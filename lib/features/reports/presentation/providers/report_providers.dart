// lib/features/reports/presentation/providers/report_providers.dart

// ... существующие импорты ...
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Убедитесь, что путь к dioProvider правильный
import '../../../transactions/data/models/transaction_model.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../data/repositories/report_repository.dart'; // Убедитесь, что путь к ReportRepository правильный
import '../../domain/models/category_report_item_model.dart';
import '../../domain/models/category_report_params.dart';
import '../../domain/models/category_transactions_list_params.dart'; // И другие модели


// ... Definition of CategoryReportParams ...
// ... Definition of CategoryTransactionsListParams ...


// Провайдер для ReportRepository
// ИЗМЕНЕНО: теперь правильно передаются Dio и Ref
final reportRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ReportRepository(dio, ref); // Передаем Dio и Ref
});

// Провайдер для CategoryReport
// ОСТАЕТСЯ БЕЗ ИЗМЕНЕНИЙ, так как он уже корректно использовал reportRepositoryProvider
final categoryReportProvider = FutureProvider.family<List<CategoryReportItemModel>, CategoryReportParams>((ref, params) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getCategoryReport(
    type: params.type,
    startDate: params.startDate,
    endDate: params.endDate,
    accountId: params.accountId,
  );
});

// Провайдер для TransactionRepository (если он здесь)
// Если он определен в другом месте (что предпочтительно), просто убедитесь, что он импортирован.
// Если он находится в этом файле, его определение должно быть таким:
// final transactionRepositoryProvider = Provider((ref) {
//   final dio = ref.watch(dioProvider);
//   return TransactionRepository(dio, ref);
// });


// Провайдер для списка транзакций по категории
// ОСТАЕТСЯ БЕЗ ИЗМЕНЕНИЙ, так как он уже корректно использовал transactionRepositoryProvider
final categoryTransactionsListProvider = FutureProvider.family<List<TransactionModel>, CategoryTransactionsListParams>((ref, params) async {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return transactionRepository.getTransactionsByCategory(
    categoryId: params.categoryId,
    type: params.transactionType,
    startDate: params.startDate,
    endDate: params.endDate,
    accountId: params.accountId,
  );
});