import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    int? id, // локальный ID Drift
    int? serverId, // серверный ID (Laravel)
    required int userId,
    required String transactionType,
    int? transactionCategoryId,
    required double amount,
    int? accountId,
    int? projectId,
    String? description,
    required DateTime date,
    required bool isActive,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
