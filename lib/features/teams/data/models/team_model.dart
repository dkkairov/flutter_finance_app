// lib/features/teams/data/models/team_model.dart

class TeamModel {
  final String id;
  final String name;
  final bool isActive;
  final String ownerId;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? updatedBy;
  final DateTime syncedAt;

  TeamModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.ownerId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.updatedBy,
    required this.syncedAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      ownerId: json['ownerId'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
      updatedBy: json['updatedBy'] as String?,
      syncedAt: DateTime.parse(json['syncedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isActive': isActive,
    'ownerId': ownerId,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
    'updatedBy': updatedBy,
    'syncedAt': syncedAt.toIso8601String(),
  };
}
