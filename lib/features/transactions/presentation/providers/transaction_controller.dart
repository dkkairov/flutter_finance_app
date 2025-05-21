// lib/features/transactions/presentation/providers/transaction_controller.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart'; // Возможно, понадобится для сообщений
import '../screens/transaction_create_screen.dart'; // Для TransactionType enum
import '../../data/repositories/transaction_repository.dart'; // <--- ИМПОРТ РЕПОЗИТОРИЯ
import '../../data/models/transaction_payload.dart'; // <--- ИМПОРТ PAYLOAD ДЛЯ ТРАНЗАКЦИИ
import '../../data/models/transfer_payload.dart'; // <--- ИМПОРТ PAYLOAD ДЛЯ ПЕРЕВОДА

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
  final DateTime date;

  TransactionCreateState({
    required this.transactionType,
    this.rawAmount = '',
    this.accountId,
    this.fromAccountId,
    this.toAccountId,
    this.categoryId,
    this.projectId,
    this.comment,
    required this.date,
  });

  TransactionCreateState copyWith({
    TransactionType? transactionType,
    String? rawAmount,
    String? accountId,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? projectId,
    String? comment,
    DateTime? date,
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
      date: date ?? this.date,
    );
  }
}

/// StateNotifier для управления состоянием создания транзакции.
class TransactionCreateController extends StateNotifier<TransactionCreateState> {
  final Ref _ref; // Добавляем Ref для доступа к репозиторию
  TransactionCreateController(this._ref) : super(_initialState());
  static TransactionCreateState _initialState() {
    print('DEBUG: TransactionCreateController instance created or re-created!'); // Добавьте эту строку
    return TransactionCreateState(
      transactionType: TransactionType.expense,
      date: DateTime.now(),
    );
  }

  // --- Методы обновления состояния ---
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

  void updateDate(DateTime newDate) {
    state = state.copyWith(date: newDate);
  }

  void resetFieldsForType(TransactionType newType) {
    // ДОБАВЬТЕ ЭТУ СТРОКУ
    print('DEBUG: resetFieldsForType called for type: $newType! Stack: ${StackTrace.current}');
    // Опционально: если хотите, чтобы приложение падало на этом месте для немедленного выявления
    // throw Exception('resetFieldsForType was called!');

    state = TransactionCreateState(
      transactionType: newType,
      rawAmount: '', // Сбрасываем сумму при смене типа
      accountId: null,
      fromAccountId: null,
      toAccountId: null,
      categoryId: null,
      projectId: null,
      comment: null,
      date: DateTime.now(),
    );
  }


  // --- НОВЫЙ МЕТОД СОЗДАНИЯ ТРАНЗАКЦИИ/ПЕРЕВОДА ---
  Future<String?> createTransaction() async {
    final repository = _ref.read(transactionRepositoryProvider);
    print('DEBUG: TransactionCreateController - rawAmount before parsing: "${state.rawAmount}"');
    final cleanedRawAmount = state.rawAmount.replaceAll(' ', '').replaceAll(',', '.');
    print('DEBUG: TransactionCreateController - cleanedRawAmount: "$cleanedRawAmount"');
    final amount = double.tryParse(cleanedRawAmount);
    print('DEBUG: TransactionCreateController - parsed amount: $amount');

    // Базовая валидация
    if (amount == null || amount <= 0) {
      return LocaleKeys.transactionAmountInvalid.tr(); // "Сумма транзакции недействительна"
    }

    try {
      if (state.transactionType == TransactionType.transfer) {
        // Логика для перевода
        if (state.fromAccountId == null) return LocaleKeys.transferFromAccountRequired.tr();
        if (state.toAccountId == null) return LocaleKeys.transferToAccountRequired.tr();
        if (state.fromAccountId == state.toAccountId) return LocaleKeys.transferSameAccountError.tr();

        final payload = TransferPayload(
          fromAccountId: state.fromAccountId!,
          toAccountId: state.toAccountId!,
          amountFrom: amount,
          description: state.comment,
          date: state.date,
        );
        await repository.createTransfer(payload);
        return null; // Успех, нет ошибки
      } else {
        // Логика для расхода/дохода
        if (state.accountId == null) return LocaleKeys.accountRequired.tr();
        if (state.categoryId == null) return LocaleKeys.categoryRequired.tr();

        final payload = TransactionPayload(
          transactionType: state.transactionType == TransactionType.expense ? 'expense' : 'income',
          transactionCategoryId: state.categoryId!,
          amount: amount,
          accountId: state.accountId!,
          projectId: state.projectId,
          description: state.comment,
          date: state.date,
        );
        await repository.createTransaction(payload);
        return null; // Успех, нет ошибки
      }
    } catch (e) {
      // Обработка ошибок, пришедших из репозитория
      print('Error creating transaction/transfer: $e');
      return e.toString(); // Возвращаем сообщение об ошибке
    }
  }

  // Метод для сброса состояния формы после успешной транзакции
  void resetForm() {
    // ДОБАВЬТЕ ЭТУ СТРОКУ
    print('DEBUG: resetForm called! Stack: ${StackTrace.current}');
    // Опционально: если хотите, чтобы приложение падало на этом месте для немедленного выявления
    // throw Exception('resetForm was called!');

    state = TransactionCreateState(
      transactionType: state.transactionType, // Сохраняем текущий тип
      date: DateTime.now(),
    );
  }
}

// Обновляем провайдер, удаляя .autoDispose
final transactionCreateControllerProvider = StateNotifierProvider<
    TransactionCreateController, TransactionCreateState>((ref) {
  return TransactionCreateController(ref);
});

final transactionTypeProvider = StateProvider<TransactionType>((ref) {
  return TransactionType.expense;
});