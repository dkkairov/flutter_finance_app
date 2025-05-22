// lib/features/projects/data/models/project_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel {
  final String id; // UUID
  @JsonKey(name: 'teamId') // Соответствует teamId из ProjectResource
  final String teamId; // UUID
  final String name;
  final String? description; // Может быть null
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'deletedAt')
  final DateTime? deletedAt; // Добавлено, может быть null
  @JsonKey(name: 'updatedBy')
  final String? updatedBy; // Добавлено, может быть null (UUID пользователя)
  @JsonKey(name: 'syncedAt')
  final DateTime? syncedAt; // Добавлено, может быть null

  ProjectModel({
    required this.id,
    required this.teamId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt, // Добавлено в конструктор
    this.updatedBy, // Добавлено в конструктор
    this.syncedAt, // Добавлено в конструктор
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}