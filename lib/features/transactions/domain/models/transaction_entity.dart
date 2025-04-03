class TransactionEntity {
  final int id;
  final String type;
  final double amount;
  final DateTime date;
  final String? description;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
  });
}
