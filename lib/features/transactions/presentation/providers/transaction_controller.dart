// lib/features/transactions/presentation/providers/transaction_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/transaction_create_screen.dart'; // Для TransactionType enum

/// Состояние для TransactionCreateController.
/// Содержит все данные, необходимые для создания транзакции.
class TransactionCreateState {
  final TransactionType transactionType;
  final String rawAmount; // Сырое значение суммы, как вводится на клавиатуре
  final String? accountId; // ID счета для Expense/Income (UUID String)
  final String? fromAccountId; // ID счета "откуда" для Transfer (UUID String)
  final String? toAccountId; // ID счета "куда" для Transfer (UUID String)
  final String? categoryId; // ID категории (UUID String)
  final String? projectId; // ID проекта (UUID String)
  final String? comment; // Комментарий к транзакции
  final DateTime date; // <--- ДОБАВЛЕНО ПОЛЕ ДАТЫ

  TransactionCreateState({
    required this.transactionType,
    this.rawAmount = '',
    this.accountId,
    this.fromAccountId,
    this.toAccountId,
    this.categoryId,
    this.projectId,
    this.comment,
    required this.date, // <--- СДЕЛАЛИ required
  });

  // Метод copyWith для удобного создания нового состояния с измененными полями
  TransactionCreateState copyWith({
    TransactionType? transactionType,
    String? rawAmount,
    String? accountId,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? projectId,
    String? comment,
    DateTime? date, // <--- ДОБАВЛЕНО В copyWith
  }) {
    return TransactionCreateState(
      transactionType: transactionType ?? this.transactionType,
      rawAmount: rawAmount ?? this.rawAmount,
      accountId: accountId ?? this.accountId,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      projectId: projectId ?? this.projectId,
      comment: comment ?? this.comment,
      date: date ?? this.date, // <--- ОБНОВЛЯЕМ ДАТУ
    );
  }
}

/// StateNotifier для управления состоянием создания транзакции.
class TransactionCreateController extends StateNotifier<TransactionCreateState> {
  TransactionCreateController() : super(_initialState());

  static TransactionCreateState _initialState() {
    return TransactionCreateState(
      transactionType: TransactionType.expense,
      date: DateTime.now(), // <--- ИНИЦИАЛИЗИРУЕМ ДАТУ СЕГОДНЯШНИМ ДНЕМ
    );
  }

  String get rawAmount => state.rawAmount;

  void updateRawAmount(String newAmount) {
    state = state.copyWith(rawAmount: newAmount);
  }

  void deleteLastDigit() {
    if (state.rawAmount.isNotEmpty) {
      state = state.copyWith(
        rawAmount: state.rawAmount.substring(0, state.rawAmount.length - 1),
      );
    }
  }

  void updateAccount(String? newAccountId) {
    state = state.copyWith(accountId: newAccountId);
  }

  void updateFromAccount(String? newFromAccountId) {
    state = state.copyWith(fromAccountId: newFromAccountId);
  }

  void updateToAccount(String? newToAccountId) {
    state = state.copyWith(toAccountId: newToAccountId);
  }

  void updateTransactionCategory(String? newCategoryId) {
    state = state.copyWith(categoryId: newCategoryId);
  }

  void updateProject(String? newProjectId) {
    state = state.copyWith(projectId: newProjectId);
  }

  void updateComment(String? newComment) {
    state = state.copyWith(comment: newComment);
  }

  // <--- НОВЫЙ МЕТОД ДЛЯ ОБНОВЛЕНИЯ ДАТЫ
  void updateDate(DateTime newDate) {
    state = state.copyWith(date: newDate);
  }

  void resetFieldsForType(TransactionType newType) {
    state = TransactionCreateState(
      transactionType: newType,
      rawAmount: state.rawAmount,
      accountId: null,
      fromAccountId: null,
      toAccountId: null,
      categoryId: null,
      projectId: null,
      comment: null,
      date: DateTime.now(), // Сбрасываем дату на текущую при смене типа
    );
  }
}

final transactionCreateControllerProvider = StateNotifierProvider.autoDispose<
    TransactionCreateController, TransactionCreateState>((ref) {
  return TransactionCreateController();
});

final transactionTypeProvider = StateProvider<TransactionType>((ref) {
  return TransactionType.expense;
});