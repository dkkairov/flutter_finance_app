// lib/features/projects/data/models/project_payload.dart
import 'package:json_annotation/json_annotation.dart';

part 'project_payload.g.dart';

@JsonSerializable()
class ProjectPayload {
  // Название проекта (обязательное)
  final String name;
  // Описание проекта (опциональное)
  final String? description;
  // ID команды (обязательное)
  @JsonKey(name: 'team_id') // Laravel ожидает team_id в snake_case
  final String teamId;

  ProjectPayload({
    required this.name,
    this.description,
    required this.teamId, // Добавлено
  });

  factory ProjectPayload.fromJson(Map<String, dynamic> json) => _$ProjectPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectPayloadToJson(this);
}