import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/common/widgets/custom_picker_fields/custom_primary_picker_field.dart';
import 'package:flutter_app_1/common/widgets/custom_buttons/custom_primary_button.dart';
import 'package:flutter_app_1/common/widgets/custom_text_form_field.dart';
import 'package:flutter_app_1/common/widgets/custom_picker_fields/picker_item.dart';
// Убедитесь, что пути к темам правильные
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../accounts/presentation/account_screen.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../widgets/transaction_list_widget.dart';

// !!! ИМПОРТИРУЕМ ОБЩУЮ МОДЕЛЬ ТРАНЗАКЦИИ (ЗАГЛУШКА), которую мы создали ранее
// Убедитесь, что путь правильный.



// !!! Удаляем локальные заглушки моделей транзакций из этого файла
// class _DummyAccountTransaction { ... }
// final Map<String, List<_DummyAccountTransaction>> _currentAccountTransactions = { ... }


// Экран деталей транзакции (С РЕДАКТИРУЕМЫМИ ПОЛЯМИ - ЗАГЛУШКА UI)
// !!! Превращаем из StatelessWidget в StatefulWidget
class TransactionDetailScreen extends StatefulWidget {
  // Принимает объект транзакции (типа DummyTransaction)
  final DummyAccountTransaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  // !!! Переменные состояния для хранения редактируемых значений полей
  // Используем TextEditingController для полей ввода текста (Amount, Comment)
  late TextEditingController _amountController;
  late TextEditingController _commentController;

  // Для полей, которые выбираются (Категория, Счет, Дата), храним выбранные значения
  late String _selectedCategoryName; // Пока храним только имя категории
  late String _selectedAccountName; // Пока храним только имя счета
  late String _selectedProjectName; // Пока храним только имя проекта
  late DateTime _selectedDate; // Храним выбранную дату

  @override
  void initState() {
    super.initState();
    // !!! Инициализация переменных состояния и контроллеров
    // Берем начальные значения из объекта transaction, переданного в виджет
    _amountController = TextEditingController(text: widget.transaction.amount.toStringAsFixed(0)); // Инициализируем с текущей суммой
    // TODO: Если в DummyTransaction появится поле comment, инициализировать оттуда
    _commentController = TextEditingController(text: ''); // Пока заглушка комментария

    _selectedCategoryName = widget.transaction.categoryName; // Инициализируем с текущей категорией
    // TODO: Использовать реальное название счета или объект Account, если будет доступен
    _selectedAccountName = 'Счет Kaspi bank'; // Пока заглушка

    // TODO: Использовать реальную дату транзакции, если она появится в DummyTransaction
    _selectedDate = DateTime.now(); // Пока заглушка текущей даты
  }

  @override
  void dispose() {
    // !!! Важно: Освобождаем контроллеры, когда виджет удаляется, чтобы избежать утечек памяти
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }


  // Функция показа пикера даты при нажатии на поле "Дата"
  Future<void> _selectDate(BuildContext context) async {
    // Показываем стандартный пикер даты
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Изначально выбранная дата
      firstDate: DateTime(2000), // Самая ранняя доступная дата
      lastDate: DateTime(2101), // Самая поздняя доступная дата
    );
    // Если дата выбрана (picked не null) и она отличается от текущей выбранной даты
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Обновляем выбранную дату и перестраиваем виджет
      });
    }
  }

  // TODO: Реализовать функцию сохранения изменений при нажатии кнопки "Save"
  void _saveTransaction() {
    // !!! Собираем текущие значения из контроллеров и переменных состояния
    final editedAmount = num.tryParse(_amountController.text) ?? widget.transaction.amount; // Парсим сумму, используем старую, если не удалось
    final editedComment = _commentController.text;
    final editedCategory = _selectedCategoryName;
    final editedAccount = _selectedAccountName; // TODO: Использовать реальный ID/объект счета
    final editedDate = _selectedDate;

    print('Сохранение транзакции ID: ${widget.transaction.id}');
    print('Отредактированная Сумма: $editedAmount');
    print('Отредактированная Категория: $editedCategory');
    print('Отредактированный Счет: $editedAccount');
    print('Отредактированная Дата: $editedDate');
    print('Отредактированный Комментарий: $editedComment');

    // TODO: Здесь должна быть логика вызова сервиса/репозитория/провайдера для обновления транзакции в базе данных.
    // Передайте собранные редактированные данные.

    // Navigator.pop(context); // Обычно после успешного сохранения возвращаются назад
  }

  @override
  Widget build(BuildContext context) {
    // !!! Форматируем выбранную дату для отображения в поле "Дата"
    final formattedDate = '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}';
    final List<PickerItem<num>> transactionCategories = [
      PickerItem(id: 1, displayValue: 'Category 1'),
      PickerItem(id: 2, displayValue: 'Category 2'),
      PickerItem(id: 3, displayValue: 'Category 3'),
    ];

    final List<PickerItem<int>> accountPickerItems = [
      PickerItem(id: 1, displayValue: 'Account 1'),
      PickerItem(id: 2, displayValue: 'Account 2'),
      PickerItem(id: 3, displayValue: 'Account 3'),
    ]; // Заглушка для списка счетов
    return Scaffold(
      appBar: AppBar(
        // Кнопка "назад" автоматически добавляется
        title: Text(
          LocaleKeys.transaction.tr(), // Заголовок как на скриншоте
          style: CustomTextStyles.normalMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: CustomColors.onPrimary,
          ),
        ),
        actions: [
          // Иконка корзины для удаления
          IconButton(
            icon: const Icon(Icons.delete_outline, color: CustomColors.onPrimary),
            onPressed: () {
              // TODO: Реализовать действие удаления транзакции
              print('Удалить транзакцию ID: ${widget.transaction.id}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Общие отступы для содержимого body
        child: ListView( // Используем ListView, чтобы форма была прокручиваемой, если не помещается на экране
          children: [
            // !!! Поле для Суммы (TextFormField)
            CustomTextFormField(
              labelText: LocaleKeys.amount.tr(),
              controller: _amountController, // Привязываем контроллер
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Клавиатура для чисел с десятичной точкой
              suffixText: '\$', // Символ валюты как суффикс (пример)
            ),
            const SizedBox(height: 16), // Отступ между полями

            CustomPrimaryPickerField(
              icon: Icons.category, // Иконка для поля "Категория"
              currentValueDisplay: _selectedCategoryName, // Отображаем выбранную категорию
              onTap: () async {
                // Вызываем функцию выбора категории
                final selected = await customShowModalBottomSheet(
                    context: context,
                    title: LocaleKeys.selectCategory.tr(),
                    items: transactionCategories,
                    type: 'icon'
                );
                if (selected != null) {
                  setState(() {
                    _selectedCategoryName = selected.displayValue; // Обновляем выбранную категорию
                  });
                }
              },
              context: context,
            ),
            const SizedBox(height: 16),
            CustomPrimaryPickerField(
              icon: Icons.wallet, // Иконка для поля "Счет"
              currentValueDisplay: _selectedAccountName, // Отображаем выбранный счет
              onTap: () async {
                final selected = await customShowModalBottomSheet(
                  context: context,
                  title: LocaleKeys.selectAccount.tr(),
                  items: accountPickerItems,
                  type: 'line',
                );
                if (selected != null) {
                  setState(() {
                    _selectedAccountName = selected.displayValue; // Обновляем выбранный счет
                  });
                }
              },
              context: context,
            ),
            const SizedBox(height: 16),
            CustomPrimaryPickerField(
              icon: Icons.calendar_today, // Иконка для поля "Дата"
              currentValueDisplay: '${LocaleKeys.today.tr()} ($formattedDate)',
              onTap: () => _selectDate(context),
              context: context,
            ),
            // _TappableFormRow(
            //   label: 'Date',
            //   value: 'Today ($formattedDate)', // Отображаем выбранную дату
            //   onTap: () => _selectDate(context), // При нажатии вызываем пикер даты
            // ),
            // Разделителя после даты на скриншоте нет

            // !!! Поле для Комментария (TextFormField)
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController, // Привязываем контроллер
              maxLines: 3, // Позволяем вводить несколько строк
              decoration: InputDecoration(
                labelText: LocaleKeys.addComment.tr(), // Метка поля
                fillColor: CustomColors.mainLightGrey, filled: true, // Пример декорации
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none // Убираем границу
                ), // Пример границы
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0), // Пример padding
              ),
              // style: AppTextStyles.normalMedium, // Стиль текста ввода
              // TODO: Возможно, добавить onChanged, если нужно сразу реагировать на ввод
            ),

            // TODO: Добавить секцию "Add Photo"

            const SizedBox(height: 32), // Отступ перед кнопкой сохранения

            // !!! Кнопка "Save"
            Center( // Центрируем кнопку
              child: CustomPrimaryButton(
                onPressed: _saveTransaction, // При нажатии вызываем функцию сохранения
                text: LocaleKeys.save.tr(),
              ),
            ),
            const SizedBox(height: 32), // Отступ внизу

          ],
        ),
      ),
    );
  }
}