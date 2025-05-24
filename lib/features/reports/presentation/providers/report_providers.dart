// lib/features/reports/presentation/providers/report_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart'; // Убедитесь, что путь к dioProvider правильный
import '../../../transactions/data/models/transaction_model.dart';
import '../../../transactions/data/repositories/transaction_repository.dart'; // <--- ОБНОВЛЕННЫЙ ИМПОРТ
import '../../data/repositories/report_repository.dart';
import '../../domain/models/category_report_item_model.dart';
import '../../domain/models/category_report_params.dart';
import '../../domain/models/filtered_transactions_list_params.dart';
import '../../domain/models/project_report_item_model.dart';

// Провайдер для ReportRepository
final reportRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ReportRepository(dio, ref); // Передаем Dio и Ref
});

// Провайдер для TransactionRepository
// Убедитесь, что этот провайдер определен и доступен.
// (Предполагается, что он находится в lib/features/transactions/data/repositories/transaction_repository.dart,
// и импортирован выше)


// Провайдер для CategoryReport
final categoryReportProvider = FutureProvider.family<List<CategoryReportItemModel>, CategoryReportParams>((ref, params) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getCategoryReport(
    type: params.type,
    startDate: params.startDate,
    endDate: params.endDate,
    accountId: params.accountId,
  );
});

// Провайдер для отчета по проектам
final projectReportProvider = FutureProvider.family<List<ProjectReportItemModel>, CategoryReportParams>(
      (ref, params) async {
    final reportRepository = ref.read(reportRepositoryProvider);
    return reportRepository.getProjectReport(
      type: params.type,
      startDate: params.startDate,
      endDate: params.endDate,
      accountId: params.accountId,
    );
  },
);

// <--- ИЗМЕНЕНИЕ ЭТОГО ПРОВАЙДЕРА НА УНИВЕРСАЛЬНЫЙ ---
// Переименован из categoryTransactionsListProvider в filteredTransactionsListProvider
final filteredTransactionsListProvider = FutureProvider.family<List<TransactionModel>, CategoryTransactionsListParams>((ref, params) async {
  final transactionRepository = ref.watch(transactionRepositoryProvider); // <--- Используем TransactionRepository
  return transactionRepository.fetchTransactions( // <--- ИСПРАВЛЕНО: Вызываем fetchTransactions
    categoryId: params.categoryId,
    projectId: params.projectId,
    transactionType: params.transactionType,
    startDate: params.startDate,
    endDate: params.endDate,
    accountId: params.accountId,
  );
});