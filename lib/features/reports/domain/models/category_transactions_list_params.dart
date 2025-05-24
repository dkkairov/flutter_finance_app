// lib/features/reports/data/models/category_transactions_list_params.dart

/// Параметры для запроса списка транзакций по категории.
class CategoryTransactionsListParams {
  final String categoryId;
  final String transactionType; // 'expense' или 'income'
  final DateTime startDate;
  final DateTime endDate;
  final String? accountId; // Опциональный ID счета для фильтрации

  const CategoryTransactionsListParams({
    required this.categoryId,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    this.accountId,
  });

  // Важно: Переопределение операторов == и hashCode для корректной работы Family-провайдеров Riverpod.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryTransactionsListParams &&
        other.categoryId == categoryId &&
        other.transactionType == transactionType &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.accountId == accountId;
  }

  @override
  int get hashCode => Object.hash(categoryId, transactionType, startDate, endDate, accountId);
}