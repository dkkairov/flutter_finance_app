// lib/features/transactions/data/models/transaction_category_model.dart

class TransactionCategoryModel {
  final String id;
  final String teamId;
  final String name;
  final String icon; // Предполагается, что 'icon' - это строка. Убедитесь, что это так.
  final String type; // Например, 'expense' или 'income'
  final DateTime createdAt;
  final DateTime? updatedAt;  // <--- СДЕЛАНО NULLABLE
  final DateTime? deletedAt;  // <--- СДЕЛАНО NULLABLE
  final String? updatedBy;    // <--- СДЕЛАНО NULLABLE
  final DateTime? syncedAt;   // <--- СДЕЛАНО NULLABLE

  TransactionCategoryModel({
    required this.id,
    required this.teamId,
    required this.name,
    required this.icon,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.updatedBy,
    this.syncedAt,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    print('--- Parsing TransactionCategoryModel JSON: $json'); // <--- ДОБАВЬТЕ ЭТО
    return TransactionCategoryModel(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      // ОБРАБОТКА NULL ДЛЯ ПОЛЕЙ DateTime?
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
      // ОБРАБОТКА NULL ДЛЯ ПОЛЯ String?
      updatedBy: json['updatedBy'] as String?, // Использование 'as String?' позволяет присвоить null
    );
  }

  // Если у вас есть метод copyWith, его тоже нужно обновить
  TransactionCategoryModel copyWith({
    String? id,
    String? teamId,
    String? name,
    String? icon,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? updatedBy,
    DateTime? syncedAt,
  }) {
    return TransactionCategoryModel(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}