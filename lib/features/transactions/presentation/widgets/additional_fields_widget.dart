import 'package:flutter/cupertino.dart'; // <--- Импорт Cupertino
import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';
import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/transaction_controller.dart';

// Модель для универсального представления элемента в пикере
class PickerItem<T> {
  final T id; // ID (может быть int, DateTime, etc.)
  final String displayValue; // Отображаемое значение

  PickerItem({required this.id, required this.displayValue});
}


class AdditionalFieldsWidget extends ConsumerWidget {
  const AdditionalFieldsWidget({super.key});

  // --- ЗАГЛУШКИ ДАННЫХ (замени реальными данными из Drift позже) ---
  static final Map<int, String> _accountOptions = {
    1: 'Наличные',
    2: 'Карта Банка А',
    3: 'Карта Банка Б',
    10: 'Сберегательный',
  };

  static final Map<int, String> _projectOptions = {
    1: 'Личные расходы',
    5: 'Проект "Ремонт"',
    10: 'Проект "Отпуск"',
    12: 'Работа',
  };
  // --- КОНЕЦ ЗАГЛУШЕК ---


  // Функция для показа CupertinoPicker в модальном окне
  void _showPicker<T>({
    required BuildContext context,
    required WidgetRef ref,
    required List<PickerItem<T>> items, // Универсальный список элементов
    required String title, // Заголовок для пикера
    required T currentItemId, // Текущий выбранный ID
    required Function(T selectedId) onSelectedItemChanged, // Колбэк при выборе
  }) {
    // Находим индекс текущего элемента
    int initialItemIndex = items.indexWhere((item) => item.id == currentItemId);
    if (initialItemIndex == -1) initialItemIndex = 0; // Если не найден, выбираем первый

    // Контроллер для управления прокруткой пикера
    final FixedExtentScrollController scrollController =
    FixedExtentScrollController(initialItem: initialItemIndex);

    // Временный хранитель выбранного индекса в модалке
    int tempSelectedIndex = initialItemIndex;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250, // Высота модального окна
        padding: const EdgeInsets.only(top: 6.0),
        // Добавляем фон, чтобы контент под ним не просвечивал
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Панель с кнопками "Отмена" и "Готово"
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Отмена'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // Заголовок
                  CupertinoButton(
                    child: const Text('Готово'),
                    onPressed: () {
                      // Вызываем колбэк с ID выбранного элемента
                      onSelectedItemChanged(items[tempSelectedIndex].id);
                      Navigator.pop(context); // Закрываем модалку
                    },
                  ),
                ],
              ),
            ),
            // Сам пикер
            Expanded(
              child: CupertinoPicker(
                scrollController: scrollController,
                magnification: 1.1, // Немного увеличиваем выбранный элемент
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0, // Высота каждого элемента в пикере
                // Вызывается при изменении выбранного элемента
                onSelectedItemChanged: (int selectedIndex) {
                  tempSelectedIndex = selectedIndex; // Обновляем временный индекс
                },
                // Генерируем список виджетов для пикера
                children: List<Widget>.generate(items.length, (int index) {
                  return Center(child: Text(items[index].displayValue));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательная функция для создания виджета поля с пикером
  Widget _buildPickerField<T>({
    required BuildContext context,
    required WidgetRef ref,
    // required String label, // Название поля (Счет, Проект, Дата)
    required String currentValueDisplay, // Текстовое представление текущего значения
    required VoidCallback onTap, // Действие при нажатии
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 3) - 16, // Ширина как раньше
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.mainLightGrey, // Используй свои цвета
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column( // Используем Column для метки и значения
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   // label,
            //   style: AppTextStyles.normalSmall.copyWith(color: AppColors.secondary), // Метка поля
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            const SizedBox(height: 2),
            Text(
              currentValueDisplay,
              style: AppTextStyles.normalMedium, // Текущее значение
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionControllerProvider);
    final transactionController = ref.read(transactionControllerProvider.notifier);

    // --- Подготовка данных для пикеров ---

    // 1. Счета (Account)
    final List<PickerItem<int>> accountPickerItems = _accountOptions.entries
        .map((entry) => PickerItem<int>(id: entry.key, displayValue: entry.value))
        .toList();
    final String currentAccountDisplay = _accountOptions[transactionState.accountId] ?? 'Не выбран';

    // 2. Проекты (Project)
    final List<PickerItem<int>> projectPickerItems = _projectOptions.entries
        .map((entry) => PickerItem<int>(id: entry.key, displayValue: entry.value))
        .toList();
    final String currentProjectDisplay = _projectOptions[transactionState.projectId] ?? 'Не выбран';

    // 3. Даты (Date)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dayBeforeYesterday = today.subtract(const Duration(days: 2));

    final List<PickerItem<DateTime>> datePickerItems = [
      PickerItem(id: today, displayValue: 'Сегодня'),
      PickerItem(id: yesterday, displayValue: 'Вчера'),
      PickerItem(id: dayBeforeYesterday, displayValue: 'Позавчера'),
    ];

    // Ищем отображаемое значение для текущей даты
    String currentDateDisplay;
    final currentSimpleDate = DateTime(transactionState.date.year, transactionState.date.month, transactionState.date.day);
    final matchingDateItem = datePickerItems.firstWhere((item) => item.id == currentSimpleDate, orElse: () => datePickerItems[0]); // По умолчанию "Сегодня", если дата не найдена

    if (currentSimpleDate == today) currentDateDisplay = 'Сегодня';
    else if (currentSimpleDate == yesterday) currentDateDisplay = 'Вчера';
    else if (currentSimpleDate == dayBeforeYesterday) currentDateDisplay = 'Позавчера';
    else currentDateDisplay = DateFormat('dd.MM.yyyy').format(transactionState.date); // Форматируем, если дата другая

    // --- Построение UI ---
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          // Поле выбора Счета
          _buildPickerField<int>(
            context: context,
            ref: ref,
            // label: 'Счет',
            currentValueDisplay: currentAccountDisplay,
            onTap: () => _showPicker<int>(
              context: context,
              ref: ref,
              title: 'Выберите счет',
              items: accountPickerItems,
              currentItemId: transactionState.accountId ?? 1,
              onSelectedItemChanged: (selectedAccountId) {
                transactionController.updateAccount(selectedAccountId);
              },
            ),
          ),

          // Поле выбора Проекта
          _buildPickerField<int>(
            context: context,
            ref: ref,
            // label: 'Проект',
            currentValueDisplay: currentProjectDisplay,
            onTap: () => _showPicker<int>(
              context: context,
              ref: ref,
              title: 'Выберите проект',
              items: projectPickerItems,
              currentItemId: transactionState.projectId ?? 1,
              onSelectedItemChanged: (selectedProjectId) {
                transactionController.updateProject(selectedProjectId);
              },
            ),
          ),

          // Поле выбора Даты
          _buildPickerField<DateTime>(
            context: context,
            ref: ref,
            // label: 'Дата',
            currentValueDisplay: currentDateDisplay,
            onTap: () => _showPicker<DateTime>(
              context: context,
              ref: ref,
              title: 'Выберите дату',
              items: datePickerItems,
              // Ищем ID (DateTime) текущей даты в списке для начальной позиции пикера
              currentItemId: datePickerItems.firstWhere(
                      (item) => item.id == currentSimpleDate,
                  orElse: () => datePickerItems[0] // Если не нашли, ставим "Сегодня"
              ).id,
              onSelectedItemChanged: (selectedDate) {
                // Сохраняем время из текущего состояния, меняем только дату
                final currentTime = TimeOfDay.fromDateTime(transactionState.date);
                final newDateTime = DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day,
                    currentTime.hour, currentTime.minute
                );
                transactionController.updateDate(newDateTime);
              },
            ),
          ),
        ],
      ),
    );
  }
}
