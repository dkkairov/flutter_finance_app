class TransactionEntity {
  final int id;
  final int userId;
  final String transactionType;
  final int? transactionCategoryId;
  final double amount;
  final int? accountId;
  final int? projectId;
  final String? description;
  final DateTime date;
  final bool isActive;
  final String? backendId; // Добавляем это поле

  TransactionEntity({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.transactionCategoryId,
    required this.amount,
    required this.accountId,
    required this.projectId,
    required this.description,
    required this.date,
    required this.isActive,
    this.backendId, // Добавляем в конструктор
  });
}
