// lib/features/teams/data/models/team_model.dart

class TeamModel {
  final String id;
  final String name;
  final bool isActive;
  final String ownerId;
  final String type;
  final DateTime createdAt;
  final DateTime? updatedAt;  // <--- СДЕЛАНО NULLABLE
  final DateTime? deletedAt;  // <--- СДЕЛАНО NULLABLE
  final String? updatedBy;    // <--- СДЕЛАНО NULLABLE
  final DateTime? syncedAt;   // <--- СДЕЛАНО NULLABLE

  TeamModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.ownerId,
    required this.type,
    required this.createdAt,
    this.updatedAt,  // <--- Убрано 'required'
    this.deletedAt,  // <--- Убрано 'required'
    this.updatedBy,  // <--- Убрано 'required'
    this.syncedAt,   // <--- Убрано 'required'
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? false, // Безопасное чтение bool, если может быть null
      ownerId: json['ownerId'] as String,
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
  TeamModel copyWith({
    String? id,
    String? name,
    bool? isActive,
    String? ownerId,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt, // Nullable
    DateTime? deletedAt, // Nullable
    String? updatedBy,   // Nullable
    DateTime? syncedAt,  // Nullable
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}