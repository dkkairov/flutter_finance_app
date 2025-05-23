// lib/features/teams/data/models/membership_model.dart

import '../../../../core/models/user.dart'; // Убедитесь, что это правильный путь к вашей User модели

class MembershipModel {
  final String id;
  final String userId;
  final String teamId;
  final String role; // owner, admin, member
  final String? invitedBy;
  final User user; // Вложенный объект пользователя
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt; // Если Membership может быть soft-deleted

  MembershipModel({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.role,
    this.invitedBy,
    required this.user,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return MembershipModel(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? json['user_id'] as String,
      teamId: json['teamId'] as String? ?? json['team_id'] as String,
      role: json['role'] as String,
      invitedBy: json['invitedBy'] as String? ?? json['invited_by'] as String?,
      user: userJson != null && userJson is Map<String, dynamic> && userJson.isNotEmpty
          ? User.fromJson(userJson)
          : User.empty(),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      updatedAt: (json['updatedAt'] ?? json['updated_at']) != null
          ? DateTime.tryParse(json['updatedAt'] ?? json['updated_at'])
          : null,
      deletedAt: (json['deletedAt'] ?? json['deleted_at']) != null
          ? DateTime.tryParse(json['deletedAt'] ?? json['deleted_at'])
          : null,
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'team_id': teamId,
    'role': role,
    'invited_by': invitedBy,
    'user': user.toJson(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  // Метод для создания копии с обновленной ролью (может понадобиться для UI)
  MembershipModel copyWith({String? role}) {
    return MembershipModel(
      id: id,
      userId: userId,
      teamId: teamId,
      role: role ?? this.role,
      invitedBy: invitedBy,
      user: user, // user не меняется при смене роли членства
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }


}

