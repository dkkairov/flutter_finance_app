// lib/core/models/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String? language;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.language,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    language: json['language'],
  );
}