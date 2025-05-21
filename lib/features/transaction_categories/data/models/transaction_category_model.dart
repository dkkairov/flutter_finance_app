// lib/features/transaction_categories/data/models/transaction_category_model.dart

class TransactionCategoryModel {
  final String id;
  final String teamId;
  final String name;
  final String icon;
  final String type; // 'income' или 'expense'
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? updatedBy;
  final DateTime syncedAt;

  TransactionCategoryModel({
    required this.id,
    required this.teamId,
    required this.name,
    required this.icon,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.updatedBy,
    required this.syncedAt,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    print('DEBUG: Parsing category JSON: $json'); // <--- ДОБАВЬ ЭТО
    try {
      return TransactionCategoryModel(
        id: json['id'] as String,
        teamId: json['teamId'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        type: json['type'] as String,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
        updatedBy: json['updatedBy'] as String?,
        syncedAt: DateTime.parse(json['syncedAt']),
      );
    } catch (e) {
      print('ERROR: Failed to parse TransactionCategoryModel: $e, JSON: $json'); // <--- И ЭТО
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teamId': teamId,
    'name': name,
    'icon': icon,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'updatedBy': updatedBy,
    'syncedAt': syncedAt.toIso8601String(),
  };
}
