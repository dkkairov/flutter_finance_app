// lib/features/reports/data/models/filtered_transactions_list_params.dart

/// Параметры для запроса списка транзакций по категории или проекту.
class CategoryTransactionsListParams {
  final String? categoryId; // <--- СДЕЛАНО NULLABLE
  final String? projectId;  // <--- ДОБАВЛЕНО
  final String transactionType; // 'expense' или 'income'
  final DateTime startDate;
  final DateTime endDate;
  final String? accountId; // Опциональный ID счета для фильтрации

  const CategoryTransactionsListParams({
    this.categoryId,
    this.projectId,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    this.accountId,
  }) : assert(categoryId != null || projectId != null, 'Either categoryId or projectId must be provided for filtering transactions.');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryTransactionsListParams &&
        other.categoryId == categoryId &&
        other.projectId == projectId &&
        other.transactionType == transactionType &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.accountId == accountId;
  }

  @override
  int get hashCode => Object.hash(categoryId, projectId, transactionType, startDate, endDate, accountId);
}