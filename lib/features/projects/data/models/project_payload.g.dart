// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectPayload _$ProjectPayloadFromJson(Map<String, dynamic> json) =>
    ProjectPayload(
      name: json['name'] as String,
      description: json['description'] as String?,
      teamId: json['team_id'] as String,
    );

Map<String, dynamic> _$ProjectPayloadToJson(ProjectPayload instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'team_id': instance.teamId,
    };
