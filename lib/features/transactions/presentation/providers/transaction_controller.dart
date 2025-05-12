import 'package:flutter/material.dart'; // Для debugPrint
import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// !!! Убедитесь, что импорты моделей и репозитория правильные
import 'package:flutter_app_1/features/transactions/domain/models/transaction_entity.dart'; // Путь к вашей ОБНОВЛЕННОЙ модели
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart'; // Путь к вашему репозиторию
// !!! Убедитесь, что импорт TransactionType правильный
import '../screens/transaction_create_screen.dart'; // Путь к вашему enum TransactionType


// --- Провайдер для TransactionCreateController ---
// Указываем обновленный тип состояния: TransactionEntity
final transactionCreateControllerProvider =
StateNotifierProvider<TransactionCreateController, TransactionEntity>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  // Убедитесь, что TransactionType enum доступен здесь
  return TransactionCreateController(repository: repository);
});

// --- Контроллер управления состоянием транзакции ---
// Указываем обновленный тип состояния: TransactionEntity
class TransactionCreateController extends StateNotifier<TransactionEntity> {
  final TransactionRepository repository;

  String rawAmount = '';

  // --- Конструктор ---
  TransactionCreateController({required this.repository})
  // Инициализация начального состояния (пустая транзакция)
      : super(TransactionEntity(
    id: null,
    serverId: null,
    userId: 1, // Заменить на реальный ID пользователя
    // !!! ИЗМЕНЕНО: Инициализация типа TransactionType enum
    transactionType: TransactionType.expense, // Тип по умолчанию (расход)
    transactionCategoryId: null,
    amount: 0,
    accountId: 1, // Счет по умолчанию для расхода/дохода (заменить на реальный ID)
    projectId: 1, // Проект по умолчанию для расхода/дохода (заменить на реальный ID)
    description: null,
    date: DateTime.now(),
    isActive: true,
    // !!! ДОБАВЛЕНО: Инициализация полей перевода
    fromAccountId: null, // Счета перевода по умолчанию не выбраны
    toAccountId: null,
  ));

  // --- Методы для обновления состояния ---

  /// Обновляет строковое представление суммы (`rawAmount`) и
  /// парсит его в `double` для основного состояния (`amount`).
  void updateRawAmount(String value) {
    rawAmount = value; // Сохраняем строку как есть

    final parsed = double.tryParse(value.replaceAll(',', '.')) ?? 0;

    state = state.copyWith(amount: parsed);
    debugPrint('State updated - Amount: ${state.amount}, Raw: $rawAmount');
    // Возможно, при вводе суммы для перевода тоже нужно триггерить сохранение?
    // if (state.transactionType == TransactionType.transfer && state.amount > 0 && state.fromAccountId != null && state.toAccountId != null) {
    //   _createTransaction();
    // }
  }

  /// Удаляет последний символ из `rawAmount`.
  void deleteLastDigit() {
    if (rawAmount.isNotEmpty) {
      updateRawAmount(rawAmount.substring(0, rawAmount.length - 1));
    }
  }

  /// Обновляет ID категории транзакции. Используется для Расхода/Дохода.
  void updateTransactionCategory(int categoryId) {
    // Убедимся, что этот метод вызывается только для Расхода/Дохода
    if (state.transactionType == TransactionType.expense || state.transactionType == TransactionType.income) {
      state = state.copyWith(transactionCategoryId: categoryId);
      debugPrint('State updated - Category ID: ${state.transactionCategoryId}');
      // Проверяем, есть ли сумма, прежде чем сохранять (логика сохранения может зависеть от типа)
      if (state.amount > 0) {
        _createTransaction(); // Вызываем приватный метод сохранения
      } else {
        debugPrint('⛔ Укажите сумму перед выбором категории');
      }
    } else {
      debugPrint('⚠️ Попытка установить категорию для типа ${state.transactionType}');
    }
  }

  /// Обновляет ID счета. Используется для Расхода/Дохода.
  void updateAccount(int accountId) {
    // Убедимся, что этот метод вызывается только для Расхода/Дохода
    if (state.transactionType == TransactionType.expense || state.transactionType == TransactionType.income) {
      state = state.copyWith(accountId: accountId);
      debugPrint('State updated - Account ID (Expense/Income): ${state.accountId}');
    } else {
      debugPrint('⚠️ Попытка установить accountId для типа ${state.transactionType}');
    }
  }

  /// Обновляет ID проекта. Используется для Расхода/Дохода.
  void updateProject(int projectId) {
    // Убедимся, что этот метод вызывается только для Расхода/Дохода
    if (state.transactionType == TransactionType.expense || state.transactionType == TransactionType.income) {
      state = state.copyWith(projectId: projectId);
      debugPrint('State updated - Project ID: ${state.projectId}');
    } else {
      debugPrint('⚠️ Попытка установить projectId для типа ${state.transactionType}');
    }
  }


  /// Обновляет дату транзакции.
  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
    debugPrint('State updated - Date: ${state.date}');
  }

  /// Обновляет описание транзакции.
  void updateDescription(String? description) {
    final newDescription = (description != null && description.trim().isEmpty) ? null : description;
    state = state.copyWith(description: newDescription);
    debugPrint('State updated - Description: ${state.description}');
  }

  /// Обновляет тип транзакции (expense, income, transfer).
  /// !!! ИЗМЕНЕНО: Принимает TransactionType enum
  void updateTransactionType(TransactionType type) {
    // Нет необходимости в валидации, т.к. приходит enum
    state = state.copyWith(transactionType: type);
    debugPrint('State updated - Type: ${state.transactionType}');
    // Вызов resetFieldsForType происходит в UI при смене типа
  }

  // !!! ДОБАВЛЕНО: Метод для обновления счета ОТКУДА (для Перевода)
  void updateFromAccount(int accountId) {
    // Убедимся, что этот метод вызывается только для Перевода
    if (state.transactionType == TransactionType.transfer) {
      state = state.copyWith(fromAccountId: accountId);
      debugPrint('State updated - From Account ID: ${state.fromAccountId}');
      // Проверяем, можно ли создать перевод после выбора счета ОТКУДА
      if (state.amount > 0 && state.toAccountId != null && state.fromAccountId != state.toAccountId) {
        _createTransaction(); // Триггер сохранения перевода
      }
    } else {
      debugPrint('⚠️ Попытка установить fromAccountId для типа ${state.transactionType}');
    }
  }

  // !!! ДОБАВЛЕНО: Метод для обновления счета КУДА (для Перевода)
  void updateToAccount(int accountId) {
    // Убедимся, что этот метод вызывается только для Перевода
    if (state.transactionType == TransactionType.transfer) {
      state = state.copyWith(toAccountId: accountId);
      debugPrint('State updated - To Account ID: ${state.toAccountId}');
      // Проверяем, можно ли создать перевод после выбора счета КУДА
      if (state.amount > 0 && state.fromAccountId != null && state.fromAccountId != state.toAccountId) {
        _createTransaction(); // Триггер сохранения перевода
      }
    } else {
      debugPrint('⚠️ Попытка установить toAccountId для типа ${state.transactionType}');
    }
  }


  // !!! ДОБАВЛЕНО: Метод для сброса полей при смене типа транзакции
  /// Resets fields based on the new transaction type.
  void resetFieldsForType(TransactionType newType) {
    // Получаем текущее состояние
    final currentState = state;

    // Определяем, какие поля нужно сбросить
    int? newCategoryId = currentState.transactionCategoryId;
    int? newAccountId = currentState.accountId; // Для расхода/дохода
    int? newProjectId = currentState.projectId;
    int? newFromAccountId = currentState.fromAccountId; // Для перевода
    int? newToAccountId = currentState.toAccountId; // Для перевода

    if (newType == TransactionType.transfer) {
      // Если переходим на "Перевод", сбрасываем категорию, счет (для расхода/дохода) и проект
      newCategoryId = null;
      newAccountId = null;
      newProjectId = null;

      // TODO: В БУДУЩЕМ - при первом выборе типа Перевод, установить fromAccountId на счет по умолчанию
      // Этот блок кода выполняется при *каждой* смене типа на Перевод.
      // Если нужно установить дефолтный счет только при ПЕРВОМ переходе на Перевод,
      // добавьте флаг в состояние или используйте другую логику.
      // Пример установки счета по умолчанию (замените 1 на реальный ID)
      if (currentState.transactionType != TransactionType.transfer) { // Если предыдущий тип не был переводом
        // Здесь может быть логика получения ID счета по умолчанию
        // final int defaultAccountId = ...;
        // newFromAccountId = defaultAccountId; // Устанавливаем дефолтный "откуда"
        // newToAccountId = null; // Очищаем "куда" при смене типа
      }


    } else { // Если переходим на "Расход" или "Доход"
      // Сбрасываем счета перевода
      newFromAccountId = null;
      newToAccountId = null;
      // Оставляем категорию, счет (для расхода/дохода) и проект, если они уже были установлены
    }

    // Обновляем состояние с учетом сброшенных/сохраненных полей и нового типа
    state = currentState.copyWith(
      transactionType: newType, // Обновляем тип
      transactionCategoryId: newCategoryId,
      accountId: newAccountId, // Поле accountId используется только для расхода/дохода
      projectId: newProjectId,
      fromAccountId: newFromAccountId,
      toAccountId: newToAccountId,
      // Сумма, дата, описание и флаг активности обычно остаются без изменений
    );
    debugPrint('🔄 Поля контроллера сброшены для типа: $newType');
  }


  // --- Приватные методы ---

  /// Асинхронно создает (сохраняет) транзакцию через репозиторий.
  /// После успешного сохранения сбрасывает состояние контроллера.
  Future<void> _createTransaction() async {
    // !!! ЛОГИКА СОХРАНЕНИЯ ЗАВИСИТ ОТ ТИПА ТРАНЗАКЦИИ !!!
    // Вам нужно будет реализовать соответствующую логику в репозитории
    // или подготовить TransactionEntity по-разному в зависимости от state.transactionType

    bool canCreate = false;
    String? reason;

    if (state.transactionType == TransactionType.expense || state.transactionType == TransactionType.income) {
      // Для расхода/дохода: нужна сумма и категория
      if (state.amount > 0 && state.transactionCategoryId != null) {
        canCreate = true;
      } else {
        reason = state.amount <= 0 ? 'Сумма > 0' : 'Категория выбрана';
      }
    } else if (state.transactionType == TransactionType.transfer) {
      // Для перевода: нужна сумма, счет откуда и счет куда, и они не должны совпадать
      if (state.amount > 0 && state.fromAccountId != null && state.toAccountId != null && state.fromAccountId != state.toAccountId) {
        canCreate = true;
      } else {
        reason = state.amount <= 0 ? 'Сумма > 0' : (state.fromAccountId == null ? 'Счет "Откуда" выбран' : (state.toAccountId == null ? 'Счет "Куда" выбран' : 'Счета не совпадают'));
      }
    }

    if (!canCreate) {
      debugPrint('⛔ Не все условия для создания транзакции (${state.transactionType}) выполнены. Требование: $reason');
      // Возможно, стоит показать пользователю сообщение, чего не хватает
      return;
    }

    try {
      debugPrint('💾 Попытка создания транзакции типа ${state.transactionType}: ${state.toString()}');
      // Вызываем метод репозитория для сохранения текущего состояния
      // Репозиторий должен правильно обработать TransactionEntity в зависимости от state.transactionType
      await repository.create(state); // Вам нужно будет убедиться, что repository.create может принимать TransactionEntity с заполненными полями transfer
      debugPrint('✅ Транзакция типа ${state.transactionType} успешно создана');
      // Сбрасываем состояние контроллера к начальному после сохранения
      reset(); // Полный сброс состояния
    } catch (e) {
      debugPrint('❌ Ошибка при создании транзакции типа ${state.transactionType}: $e');
      // Обработка ошибок
    }
  }

  // --- Публичные методы управления ---

  /// Сбрасывает состояние контроллера к начальным значениям.
  /// Используется после успешного сохранения транзакции или при отмене.
  void reset() {
    rawAmount = ''; // Очищаем временное хранилище суммы
    // Создаем новый объект TransactionEntity с дефолтными значениями
    state = TransactionEntity(
      id: null,
      serverId: null,
      userId: 1, // Восстанавливаем ID пользователя (заменить на реальный)
      transactionType: TransactionType.expense, // Сбрасываем тип на дефолтный расход
      transactionCategoryId: null, // Категория не выбрана
      amount: 0, // Сумма 0
      accountId: 1, // Счет по умолчанию (заменить на реальный ID)
      projectId: 1, // Проект по умолчанию (заменить на реальный ID)
      description: null,
      date: DateTime.now(), // Текущая дата
      isActive: true,
      fromAccountId: null, // Счета перевода сброшены
      toAccountId: null,
    );
    debugPrint('🔄 Состояние контроллера полностью сброшено');
    // При полном сбросе, возможно, нужно также обновить TransactionTypeProvider в UI
    // ref.read(transactionTypeProvider.notifier).state = TransactionType.expense; // Это делается в UI
  }

// TODO: В БУДУЩЕМ - Возможно, понадобится метод для загрузки существующей транзакции для редактирования
// Future<void> loadTransaction(int id) async { ... }
}