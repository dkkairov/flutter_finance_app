// lib/features/transaction_categories/presentation/providers/transaction_category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/transaction_category_repository.dart'; // Путь к transactionCategoryRepositoryProvider
import '../../data/models/transaction_category_model.dart'; // Путь к модели TransactionCategoryModel

/// Провайдер, который предоставляет список категорий транзакций.
/// Использует `Family`, чтобы можно было отфильтровать по типу ('expense' или 'income').
final transactionCategoriesProvider = FutureProvider.family
    .autoDispose<List<TransactionCategoryModel>, String?>((ref, type) async {
  // Смотрим за изменением selectedTeamIdProvider, так как категории зависят от команды.
  final teamId = ref.watch(selectedTeamIdProvider); // from auth_providers.dart

  if (teamId == null) {
    // Если teamId null, возвращаем пустой список
    return [];
  }

  final categoryRepository = ref.watch(transactionCategoryRepositoryProvider);
  // Передаем тип для фильтрации категорий (expense, income, или null для всех)
  return categoryRepository.fetchTransactionCategories(type: type);
});