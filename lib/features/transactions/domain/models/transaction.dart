// lib/features/transactions/domain/models/transaction.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int userId,
    required String transactionType,      // 'income' / 'expense'
    required int transactionCategoryId,
    required double amount,
    required int accountId,
    int? projectId,
    String? description,
    required DateTime date,
    required bool isActive,
  }) = _Transaction;



  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

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
