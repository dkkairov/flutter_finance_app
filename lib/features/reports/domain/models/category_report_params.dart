// lib/features/reports/data/models/category_report_params.dart

/// Параметры для запроса отчета по категориям.
class CategoryReportParams {
  final String type; // 'expense' или 'income'
  final DateTime startDate;
  final DateTime endDate;
  final String? accountId; // Опциональный ID счета для фильтрации

  CategoryReportParams({
    required this.type,
    required this.startDate,
    required this.endDate,
    this.accountId,
  });

  // Важно: Переопределение операторов == и hashCode для корректной работы Family-провайдеров Riverpod.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryReportParams &&
        other.type == type &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.accountId == accountId;
  }

  @override
  int get hashCode => Object.hash(type, startDate, endDate, accountId);
}