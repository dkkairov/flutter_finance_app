// lib/features/transactions/domain/models/transaction_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
// Убедитесь, что путь к вашему enum TransactionType правильный
import '../../presentation/screens/transaction_create_screen.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    int? id, // локальный ID Drift
    int? serverId, // серверный ID (Laravel)
    required int userId,
    // !!! ИЗМЕНЕНО: Тип поля transactionType на enum
    required TransactionType transactionType, // Изменено со String на TransactionType enum
    int? transactionCategoryId, // Категория (для expense/income)
    required double amount,
    int? accountId, // Счет (для expense/income)
    int? projectId, // Проект (для expense/income)
    String? description,
    required DateTime date,
    required bool isActive,
    // !!! ДОБАВЛЕНО: Поля для счетов перевода
    int? fromAccountId, // Счет отправителя (для transfer)
    int? toAccountId, // Счет получателя (для transfer)
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);

// Метод noSuchMethod не нужен при использовании freezed
@override
dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}