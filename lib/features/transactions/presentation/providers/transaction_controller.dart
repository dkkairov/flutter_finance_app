import 'package:flutter/material.dart'; // Для debugPrint
import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/features/transactions/domain/models/transaction_entity.dart'; // Путь к вашей модели
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart'; // Путь к вашему репозиторию

// --- Провайдер для TransactionCreateController ---
// Он предоставляет экземпляр TransactionCreateController и его состояние (TransactionEntity)
final transactionCreateControllerProvider =
StateNotifierProvider<TransactionCreateController, TransactionEntity>((ref) {
  // Получаем зависимость - репозиторий транзакций
  final repository = ref.read(transactionRepositoryProvider);
  // Создаем и возвращаем экземпляр контроллера
  return TransactionCreateController(repository: repository);
});

// --- Контроллер управления состоянием транзакции ---
class TransactionCreateController extends StateNotifier<TransactionEntity> {
  // Зависимость: репозиторий для сохранения данных
  final TransactionRepository repository;

  // Временное хранилище для введенной суммы в виде строки (с запятой)
  // Это не часть основного состояния TransactionEntity, т.к. нужно для UI
  String rawAmount = '';

  // --- Конструктор ---
  TransactionCreateController({required this.repository})
  // Инициализация начального состояния (пустая транзакция)
      : super(TransactionEntity(
    id: null, // ID будет присвоен базой данных при создании
    serverId: null, // ID с сервера (если есть синхронизация)
    userId: 1, // ID текущего пользователя (заменить на реальный)
    transactionType: 'expense', // Тип по умолчанию (расход)
    transactionCategoryId: null, // Категория не выбрана
    amount: 0, // Сумма по умолчанию
    accountId: 1, // Счет по умолчанию (заменить на реальный ID)
    projectId: 1, // Проект по умолчанию (заменить на реальный ID)
    description: null, // Описание отсутствует
    date: DateTime.now(), // Дата по умолчанию - сейчас
    isActive: true, // Флаг активности (для мягкого удаления)
  ));

  // --- Методы для обновления состояния ---

  /// Обновляет строковое представление суммы (`rawAmount`) и
  /// парсит его в `double` для основного состояния (`amount`).
  void updateRawAmount(String value) {
    rawAmount = value; // Сохраняем строку как есть (например, "123,45")

    // Пытаемся преобразовать строку в double, заменяя запятую на точку
    // Если не получается, используем 0
    final parsed = double.tryParse(value.replaceAll(',', '.')) ?? 0;

    // Обновляем только поле amount в состоянии
    state = state.copyWith(amount: parsed);
    debugPrint('State updated - Amount: ${state.amount}, Raw: $rawAmount'); // Для отладки
  }

  /// Удаляет последний символ из `rawAmount`.
  void deleteLastDigit() {
    if (rawAmount.isNotEmpty) {
      // Обрезаем строку и вызываем updateRawAmount для обновления состояния
      updateRawAmount(rawAmount.substring(0, rawAmount.length - 1));
    }
  }

  /// Обновляет ID категории транзакции.
  /// Если сумма уже введена (> 0), пытается создать транзакцию.
  void updateCategory(int categoryId) {
    state = state.copyWith(transactionCategoryId: categoryId);
    debugPrint('State updated - Category ID: ${state.transactionCategoryId}'); // Для отладки
    // Проверяем, есть ли сумма, прежде чем сохранять
    if (state.amount > 0) {
      _createTransaction(); // Вызываем приватный метод сохранения
    } else {
      // Можно показать уведомление пользователю, если нужно
      debugPrint('⛔ Укажите сумму перед выбором категории');
    }
  }

  /// Обновляет ID счета.
  void updateAccount(int accountId) {
    state = state.copyWith(accountId: accountId);
    debugPrint('State updated - Account ID: ${state.accountId}'); // Для отладки
  }

  /// Обновляет ID проекта.
  void updateProject(int projectId) {
    state = state.copyWith(projectId: projectId);
    debugPrint('State updated - Project ID: ${state.projectId}'); // Для отладки
  }

  /// Обновляет дату транзакции.
  void updateDate(DateTime date) {
    // Чтобы сохранить только дату без времени (если нужно)
    // final dateOnly = DateTime(date.year, date.month, date.day);
    // state = state.copyWith(date: dateOnly);
    state = state.copyWith(date: date);
    debugPrint('State updated - Date: ${state.date}'); // Для отладки
  }

  /// Обновляет описание транзакции.
  void updateDescription(String? description) {
    // Проверяем, чтобы пустая строка сохранялась как null (если нужно)
    final newDescription = (description != null && description.trim().isEmpty) ? null : description;
    state = state.copyWith(description: newDescription);
    debugPrint('State updated - Description: ${state.description}'); // Для отладки
  }

  /// Обновляет тип транзакции ('expense' или 'income').
  void updateTransactionType(String type) {
    if (type == 'expense' || type == 'income') { // Простая валидация
      state = state.copyWith(transactionType: type);
      debugPrint('State updated - Type: ${state.transactionType}'); // Для отладки
    } else {
      debugPrint('⛔ Неверный тип транзакции: $type');
    }
  }


  // --- Приватные методы ---

  /// Асинхронно создает (сохраняет) транзакцию через репозиторий.
  /// После успешного сохранения сбрасывает состояние контроллера.
  Future<void> _createTransaction() async {
    // Проверка на наличие категории (опционально, можно добавить другие проверки)
    if (state.transactionCategoryId == null) {
      debugPrint('⛔ Категория не выбрана, транзакция не создана');
      // Возможно, стоит показать пользователю сообщение
      return;
    }

    try {
      debugPrint('💾 Попытка создания транзакции: ${state.toString()}'); // Для отладки
      // Вызываем метод репозитория для сохранения текущего состояния
      await repository.create(state);
      debugPrint('✅ Транзакция успешно создана');
      // Сбрасываем состояние контроллера к начальному после сохранения
      reset();
    } catch (e) {
      // Обработка ошибок сохранения (логирование, показ сообщения пользователю)
      debugPrint('❌ Ошибка при создании транзакции: $e');
      // Можно добавить здесь логику для отображения ошибки пользователю
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
      userId: 1, // Восстанавливаем ID пользователя
      transactionType: state.transactionType, // Сохраняем выбранный тип (или сбросить?)
      transactionCategoryId: null,
      amount: 0,
      accountId: state.accountId, // Сохраняем выбранный счет (или сбросить?)
      projectId: state.projectId, // Сохраняем выбранный проект (или сбросить?)
      description: null,
      date: DateTime.now(), // Сбрасываем дату на текущую
      isActive: true,
    );
    debugPrint('🔄 Состояние контроллера сброшено');
  }
}