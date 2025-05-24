import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/common/theme/custom_colors.dart';
import '../../../../features/common/theme/custom_text_styles.dart';
import '../../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_picker_fields/custom_primary_picker_field.dart';
import '../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../common/widgets/custom_text_form_field.dart';
// import '../widgets/transaction_list_widget.dart'; // Этот импорт, скорее всего, не нужен здесь

// !!! ИМПОРТИРУЕМ ОБЩУЮ МОДЕЛЬ ТРАНЗАКЦИИ
import '../../data/models/transaction_model.dart'; // <--- ДОБАВЛЕНО
import '../../data/models/transaction_payload.dart'; // <--- ДОБАВЛЕНО (для сохранения)

// !!! Удаляем локальные заглушки моделей транзакций из этого файла
// class _DummyAccountTransaction { ... } // УДАЛИТЕ эту строку
// final Map<String, List<_DummyAccountTransaction>> _currentAccountTransactions = { ... } // УДАЛИТЕ эту строку


// Экран деталей транзакции (С РЕДАКТИРУЕМЫМИ ПОЛЯМИ)
class TransactionDetailScreen extends StatefulWidget {
  // Принимает объект транзакции (теперь типа TransactionModel)
  final TransactionModel transaction; // <--- ИЗМЕНЕНО: Используем TransactionModel

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TextEditingController _amountController;
  late TextEditingController _commentController;

  late String _selectedCategoryName;
  late String _selectedAccountName;
  late String _selectedProjectName;
  late DateTime _selectedDate;

  // Дополнительно можно хранить ID для отправки на бэкенд
  String? _selectedCategoryId;
  String? _selectedAccountId;
  String? _selectedProjectId;


  @override
  void initState() {
    super.initState();
    // !!! Инициализация переменных состояния и контроллеров
    // Берем начальные значения из объекта transaction (TransactionModel)
    _amountController = TextEditingController(text: widget.transaction.amount.toStringAsFixed(0));
    _commentController = TextEditingController(text: widget.transaction.description ?? ''); // Инициализируем с описанием

    // Инициализируем из вложенных объектов (если они есть)
    _selectedCategoryName = widget.transaction.category?.name ?? LocaleKeys.selectCategory.tr();
    _selectedAccountId = widget.transaction.accountId; // Храним ID
    _selectedAccountName = widget.transaction.account?.name ?? LocaleKeys.selectAccount.tr();
    _selectedProjectId = widget.transaction.projectId; // Храним ID
    _selectedProjectName = widget.transaction.project?.name ?? LocaleKeys.no_project.tr(); // Если нет проекта

    _selectedDate = widget.transaction.date; // Используем реальную дату транзакции
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }


  // Функция показа пикера даты при нажатии на поле "Дата"
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // TODO: Реализовать функцию сохранения изменений при нажатии кнопки "Save"
  void _saveTransaction() {
    // !!! Собираем текущие значения из контроллеров и переменных состояния
    final editedAmount = num.tryParse(_amountController.text) ?? widget.transaction.amount;
    final editedDescription = _commentController.text;

    // Для отправки на бэкенд используем ID
    final editedCategoryId = _selectedCategoryId ?? widget.transaction.transactionCategoryId;
    final editedAccountId = _selectedAccountId ?? widget.transaction.accountId;
    final editedProjectId = _selectedProjectId ?? widget.transaction.projectId;
    final editedDate = _selectedDate;

    print('Сохранение транзакции ID: ${widget.transaction.id}');
    print('Отредактированная Сумма: $editedAmount');
    print('Отредактированная Категория ID: $editedCategoryId');
    print('Отредактированный Счет ID: $editedAccountId');
    print('Отредактированный Проект ID: $editedProjectId');
    print('Отредактированная Дата: $editedDate');
    print('Отредактированный Комментарий: $editedDescription');

    // !!! Создаем TransactionPayload для отправки данных на бэкенд
    final updatedPayload = TransactionPayload(
      // Поскольку это UPDATE, вам нужно передать ID существующей транзакции
      // Но TransactionPayload не имеет поля ID, так как оно для создания.
      // Для обновления обычно используется метод PUT/PATCH на /api/transactions/{id}
      // Таким образом, вам нужно будет передать widget.transaction.id в метод репозитория.
      transactionType: widget.transaction.transactionType, // Тип транзакции, скорее всего, не меняется
      transactionCategoryId: editedCategoryId,
      amount: editedAmount.toDouble(), // Приводим к double
      accountId: editedAccountId,
      projectId: editedProjectId,
      description: editedDescription.isEmpty ? null : editedDescription, // Если пусто, отправляем null
      date: editedDate,
    );

    // TODO: Здесь должна быть логика вызова сервиса/репозитория/провайдера для обновления транзакции в базе данных.
    // Пример (вам понадобится TransactionRepository и, возможно, Riverpod):
    // ref.read(transactionRepositoryProvider).updateTransaction(
    //   teamId: 'your_team_id', // Получить teamId из провайдера
    //   transactionId: widget.transaction.id,
    //   payload: updatedPayload,
    // );

    // Navigator.pop(context); // Обычно после успешного сохранения возвращаются назад
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}';

    // TODO: Замените эти заглушки реальными данными из провайдеров/репозиториев
    final List<PickerItem<String>> transactionCategories = [
      PickerItem(value: 'cat-exp-001', displayValue: 'Products'),
      PickerItem(value: 'cat-exp-002', displayValue: 'Transport'),
      PickerItem(value: 'cat-inc-001', displayValue: 'Salary'),
      // ... другие категории
    ];

    final List<PickerItem<String>> accountPickerItems = [
      PickerItem(value: 'acc-001', displayValue: 'Kaspi Bank'),
      PickerItem(value: 'acc-002', displayValue: 'Halyk Bank'),
      // ... другие счета
    ];

    final List<PickerItem<String>> projectPickerItems = [
      PickerItem(value: 'proj-001', displayValue: 'Work Project A'),
      PickerItem(value: 'proj-002', displayValue: 'Personal Project B'),
      PickerItem(value: 'no-project', displayValue: LocaleKeys.no_project.tr()), // Для выбора "без проекта"
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.transaction.tr(),
          style: CustomTextStyles.normalMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: CustomColors.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: CustomColors.onPrimary),
            onPressed: () {
              print('Удалить транзакцию ID: ${widget.transaction.id}');
              // TODO: Реализовать логику удаления транзакции через репозиторий/провайдер
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextFormField(
              labelText: LocaleKeys.amount.tr(),
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              suffixText: widget.transaction.account?.currencySymbol ?? LocaleKeys.tenge_short.tr(), // Используем символ валюты из счета
            ),
            const SizedBox(height: 16),

            CustomPrimaryPickerField(
              icon: Icons.category,
              currentValueDisplay: _selectedCategoryName,
              onTap: () async {
                final selected = await customShowModalBottomSheet<String>( // Укажите тип value для PickerItem
                    context: context,
                    title: LocaleKeys.selectCategory.tr(),
                    items: transactionCategories,
                    type: 'icon'
                );
                if (selected != null) {
                  setState(() {
                    _selectedCategoryId = selected.value; // Сохраняем ID категории
                    _selectedCategoryName = selected.displayValue; // Обновляем отображаемое имя
                  });
                }
              },
              context: context,
            ),
            const SizedBox(height: 16),
            CustomPrimaryPickerField(
              icon: Icons.wallet,
              currentValueDisplay: _selectedAccountName,
              onTap: () async {
                final selected = await customShowModalBottomSheet<String>( // Укажите тип value для PickerItem
                  context: context,
                  title: LocaleKeys.selectAccount.tr(),
                  items: accountPickerItems,
                  type: 'line',
                );
                if (selected != null) {
                  setState(() {
                    _selectedAccountId = selected.value; // Сохраняем ID счета
                    _selectedAccountName = selected.displayValue; // Обновляем отображаемое имя
                  });
                }
              },
              context: context,
            ),
            const SizedBox(height: 16),
            CustomPrimaryPickerField(
              icon: Icons.business_center, // Иконка для поля "Проект"
              currentValueDisplay: _selectedProjectName,
              onTap: () async {
                final selected = await customShowModalBottomSheet<String>( // Укажите тип value для PickerItem
                  context: context,
                  title: LocaleKeys.select_project.tr(), // TODO: Добавить LocaleKeys.select_project
                  items: projectPickerItems,
                  type: 'line',
                );
                if (selected != null) {
                  setState(() {
                    _selectedProjectId = selected.value == 'no-project' ? null : selected.value; // Сохраняем ID проекта (null если "без проекта")
                    _selectedProjectName = selected.displayValue; // Обновляем отображаемое имя
                  });
                }
              },
              context: context,
            ),
            const SizedBox(height: 16),
            CustomPrimaryPickerField(
              icon: Icons.calendar_today,
              currentValueDisplay: '${LocaleKeys.today.tr()} (${DateFormat('dd.MM.yyyy').format(_selectedDate)})', // Форматируем дату для отображения
              onTap: () => _selectDate(context),
              context: context,
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: LocaleKeys.addComment.tr(),
                fillColor: CustomColors.mainLightGrey, filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: CustomPrimaryButton(
                onPressed: _saveTransaction,
                text: LocaleKeys.save.tr(),
              ),
            ),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}