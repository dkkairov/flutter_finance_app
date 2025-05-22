// lib/features/transaction_categories/presentation/providers/transaction_category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/transaction_category_repository.dart'; // Путь к TransactionCategoryRepository
import '../../data/models/transaction_category_model.dart'; // Путь к модели TransactionCategoryModel
import '../../../../core/network/dio_provider.dart'; // <--- ДОБАВЛЕН ИМПОРТ ДЛЯ dioProvider

/// Провайдер для TransactionCategoryRepository
final transactionCategoryRepositoryProvider = Provider<TransactionCategoryRepository>((ref) {
  final dio = ref.watch(dioProvider); // Используем dioProvider
  return TransactionCategoryRepository(dio);
});

/// Провайдер, который предоставляет список категорий транзакций.
/// Использует `Family`, чтобы можно было отфильтровать по типу ('expense' или 'income').
final transactionCategoriesProvider = FutureProvider.family
    .autoDispose<List<TransactionCategoryModel>, String?>((ref, type) async {
  final teamId = ref.watch(selectedTeamIdProvider);
  print('DEBUG: transactionCategoriesProvider: teamId=$teamId, type=$type');

  if (teamId == null) {
    print('DEBUG: transactionCategoriesProvider: teamId is null, returning empty list.');
    return [];
  }

  final categoryRepository = ref.watch(transactionCategoryRepositoryProvider);
  try {
    // ИЗМЕНЕНО: Передаем teamId в fetchTransactionCategories
    final categories = await categoryRepository.fetchTransactionCategories(teamId: teamId, type: type);
    print('DEBUG: Fetched ${categories.length} categories for type $type');
    return categories;
  } catch (e) {
    print('ERROR: Failed to fetch categories in provider: $e');
    rethrow;
  }
});