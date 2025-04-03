// lib/core/models/transaction_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required int id,
    required int userId,
    required String transactionType,
    required int transactionCategoryId,
    required double amount,
    required int accountId,
    int? projectId,
    String? description,
    required DateTime date,
    required bool isActive,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  @override
  // TODO: implement accountId
  int get accountId => throw UnimplementedError();

  @override
  // TODO: implement amount
  double get amount => throw UnimplementedError();

  @override
  // TODO: implement date
  DateTime get date => throw UnimplementedError();

  @override
  // TODO: implement description
  String? get description => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  // TODO: implement isActive
  bool get isActive => throw UnimplementedError();

  @override
  // TODO: implement projectId
  int? get projectId => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement transactionCategoryId
  int get transactionCategoryId => throw UnimplementedError();

  @override
  // TODO: implement transactionType
  String get transactionType => throw UnimplementedError();

  @override
  // TODO: implement userId
  int get userId => throw UnimplementedError();
}
