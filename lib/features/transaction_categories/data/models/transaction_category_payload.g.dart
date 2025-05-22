// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_category_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategoryPayload _$TransactionCategoryPayloadFromJson(
  Map<String, dynamic> json,
) => TransactionCategoryPayload(
  name: json['name'] as String,
  teamId: json['team_id'] as String,
  type: json['type'] as String,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$TransactionCategoryPayloadToJson(
  TransactionCategoryPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'team_id': instance.teamId,
  'type': instance.type,
  'icon': instance.icon,
};
