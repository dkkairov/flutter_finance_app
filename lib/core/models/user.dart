import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._(); // <- приватный конструктор

  const factory User({
    required int id,
    required String name,
    required String email,
    String? token,
  }) = _User;

  // Кастомный геттер:
  String get domain => email.split('@').last;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  // TODO: implement email
  String get email => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement token
  String? get token => throw UnimplementedError();
}
