import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/common/widgets/custom_picker_fields/custom_secondary_picker_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../accounts/domain/models/account.dart';
import '../../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../providers/transaction_controller.dart';

class AdditionalFieldsWidget extends ConsumerWidget {
  // Принимаем список счетов
  final List<Account> accounts;

  const AdditionalFieldsWidget({super.key, required this.accounts}); // Добавляем accounts в конструктор

  // Исходные данные для проектов (остаются здесь, так как используются только в этом виджете)
  static final Map<int, String> _projectOptions = {
    1: 'Личные расходы',
    5: 'Проект \"Ремонт\"',
    10: 'Проект \"Отпуск\"',
    12: 'Работа',
    15: 'Проект \"Курсы\"',
    20: 'Проект \"Путешествие\"',
    25: 'Проект \"Покупка\"',
    30: 'Проект \"Учеба\"',
    35: 'Проект \"Спорт\"',
    40: 'Проект \"Хобби\"',
    50: 'Проект \"Здоровье\"',
    60: 'Проект \"Книги\"',
    70: 'Проект \"Техника\"',
    80: 'Проект \"Авто\"',
    90: 'Проект \"Недвижимость\"',
    100: 'Проект \"Долги\"',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionCreateControllerProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);

    // --- Подготовка данных для пикеров ---

    // Подготовка данных для пикера Счетов из переданного списка accounts
    final List<PickerItem<int>> accountPickerItems = accounts
        .map((account) => PickerItem<int>(id: account.id, displayValue: account.name))
        .toList();
    // Ищем текущее название счета в переданном списке accounts
    final String currentAccountDisplay = accounts
        .firstWhere(
          (account) => account.id == transactionState.accountId,
      orElse: () => Account(id: -1, name: LocaleKeys.notSelected.tr()), // Замените на ваш класс Account
    ).name;


    // Подготовка данных для пикера Проектов
    final List<PickerItem<int>> projectPickerItems = _projectOptions.entries
        .map((entry) => PickerItem<int>(id: entry.key, displayValue: entry.value))
        .toList();
    final String currentProjectDisplay = _projectOptions[transactionState.projectId] ?? LocaleKeys.notSelected.tr();

    // Подготовка данных для пикера Даты (остается без изменений)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dayBeforeYesterday = today.subtract(const Duration(days: 2));

    final List<PickerItem<DateTime>> datePickerItems = [
      PickerItem(id: today, displayValue: LocaleKeys.today.tr()),
      PickerItem(id: yesterday, displayValue: LocaleKeys.yesterday.tr()),
      PickerItem(id: dayBeforeYesterday, displayValue: LocaleKeys.theDayBeforeYesterday.tr()),
    ];

    final currentSimpleDate = DateTime(transactionState.date.year, transactionState.date.month, transactionState.date.day);
    String currentDateDisplay;
    if (currentSimpleDate == today) {
      currentDateDisplay = LocaleKeys.today.tr();
    } else if (currentSimpleDate == yesterday) {
      currentDateDisplay = LocaleKeys.yesterday.tr();
    } else if (currentSimpleDate == dayBeforeYesterday) {
      currentDateDisplay = LocaleKeys.theDayBeforeYesterday.tr();
    } else {
      currentDateDisplay = DateFormat('dd.MM.yyyy').format(transactionState.date);
    }

    // --- Построение UI ---
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          // Поле выбора Счета
          CustomSecondaryPickerField(
            context: context,
            icon: Icons.account_balance_wallet, // Метка для поля "Счет"
            currentValueDisplay: currentAccountDisplay,
            width: (MediaQuery.of(context).size.width / 3) - 16,
            onTap: () async {
              final selected = await customShowModalBottomSheet<int>(
                  context: context,
                  title: LocaleKeys.selectAccount.tr(),
                  items: accountPickerItems,
                  type: 'line'
              );
              if (selected != null) {
                transactionCreateController.updateAccount(selected.id);
              }
            },
          ),

          // Поле выбора Проекта
          CustomSecondaryPickerField(
            context: context,
            icon: Icons.work_outline,
            currentValueDisplay: currentProjectDisplay,
            width: (MediaQuery.of(context).size.width / 3) - 16,
            onTap: () async {
              final selected = await customShowModalBottomSheet<int>(
                  context: context,
                  title: LocaleKeys.selectProject.tr(),
                  items: projectPickerItems,
                  type: 'line'
              );
              if (selected != null) {
                transactionCreateController.updateProject(selected.id);
              }
            },
          ),

          // Поле выбора Даты
          CustomSecondaryPickerField(
            context: context,
            icon: Icons.date_range,
            currentValueDisplay: currentDateDisplay,
            width: (MediaQuery.of(context).size.width / 3) - 16,
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: transactionState.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                final currentTime = TimeOfDay.fromDateTime(transactionState.date);
                final newDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  currentTime.hour,
                  currentTime.minute,
                );
                transactionCreateController.updateDate(newDateTime);
              }
            },
          ),
        ],
      ),
    );
  }
}