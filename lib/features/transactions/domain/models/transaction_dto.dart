// lib/features/transactions/domain/models/transaction_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    // id из DTO может быть локальным или серверным,
    // в зависимости от того, как вы его используете.
    // Если это серверный ID, он может быть nullable при создании на клиенте.
    // Если это локальный ID, он не null после сохранения в локальную базу.
    // В вашем текущем коде DTO используется для маппинга Entity <-> DTO (API),
    // и в toDto вы присваиваете entity.id ?? 0, что предполагает, что API ожидает id.
    // Оставим как required int id, как было.
    required int id,
    @JsonKey(name: 'serverId') int? serverId,
    @JsonKey(name: 'userId') required int userId,
    // Мы договорились, что в DTO тип - String
    @JsonKey(name: 'transactionType') required String transactionType,
    @JsonKey(name: 'transactionCategoryId') int? transactionCategoryId,
    required double amount,
    @JsonKey(name: 'accountId') int? accountId, // Счет для расхода/дохода
    @JsonKey(name: 'projectId') int? projectId,
    String? description,
    required DateTime date,
    @JsonKey(name: 'isActive') required bool isActive,
    // !!! ДОБАВЛЕНО: Поля для счетов перевода
    // Добавляем эти поля как nullable, так как они используются только для переводов
    @JsonKey(name: 'fromAccountId') int? fromAccountId, // Соответствует from_account_id на бэкенде?
    @JsonKey(name: 'toAccountId') int? toAccountId, // Соответствует to_account_id на бэкенде?

  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

// Метод noSuchMethod не нужен при использовании freezed
@override
dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}