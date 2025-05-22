// lib/features/transaction_categories/data/models/transaction_category_payload.dart

import 'package:json_annotation/json_annotation.dart';

part 'transaction_category_payload.g.dart'; // Добавьте это, если используете json_serializable

@JsonSerializable() // Добавьте эту аннотацию, если используете json_serializable
class TransactionCategoryPayload {
  final String name;
  @JsonKey(name: 'team_id') // Указываем имя поля для JSON в snake_case
  final String teamId; // Добавлено поле teamId
  final String type;
  final String? icon; // Сделал nullable, так как в бэкенде 'nullable'

  TransactionCategoryPayload({
    required this.name,
    required this.teamId, // Добавьте в конструктор
    required this.type,
    this.icon, // icon теперь nullable
  });

  // Методы для сериализации/десериализации, если не используете json_serializable
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'team_id': teamId, // Включаем teamId в JSON
      'type': type,
      'icon': icon,
    };
  }

// Если используете json_serializable, раскомментируйте следующие строки:
// factory TransactionCategoryPayload.fromJson(Map<String, dynamic> json) => _$TransactionCategoryPayloadFromJson(json);
// Map<String, dynamic> toJson() => _$TransactionCategoryPayloadToJson(this);
}