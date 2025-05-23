// lib/core/models/user.dart

import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String? language; // Опционально, если есть в бэкенде
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt; // Для soft delete

  User({
    required this.id,
    required this.name,
    required this.email,
    this.language,
    this.emailVerifiedAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Конструктор по умолчанию для создания пустого объекта User
  factory User.empty() => User(id: '', name: 'Неизвестно', email: '', createdAt: DateTime.now());

  // Метод для десериализации JSON в объект User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      language: json['language'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  // Метод для сериализации объекта User в JSON (если нужен)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'language': language,
    'email_verified_at': emailVerifiedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

}