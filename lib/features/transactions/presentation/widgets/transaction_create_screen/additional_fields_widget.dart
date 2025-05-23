import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_picker_fields/custom_secondary_picker_field.dart';
import '../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../../accounts/domain/models/account.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../providers/transaction_controller.dart';

class AdditionalFieldsWidget extends ConsumerWidget {
  final List<Account> accounts;

  const AdditionalFieldsWidget({super.key, required this.accounts});

  static final Map<String, String> _projectOptions = {
    'project_1_uuid': 'Личные расходы',
    'project_5_uuid': 'Проект "Ремонт"',
    'project_10_uuid': 'Проект "Отпуск"',
    'project_12_uuid': 'Работа',
    'project_15_uuid': 'Проект "Курсы"',
    'project_20_uuid': 'Проект "Путешествие"',
    'project_25_uuid': 'Проект "Покупка"',
    'project_30_uuid': 'Проект "Учеба"',
    'project_35_uuid': 'Проект "Спорт"',
    'project_40_uuid': 'Проект "Хобби"',
    'project_50_uuid': 'Проект "Здоровье"',
    'project_60_uuid': 'Проект "Книги"',
    'project_70_uuid': 'Проект "Техника"',
    'project_80_uuid': 'Проект "Авто"',
    'project_90_uuid': 'Проект "Недвижимость"',
    'project_100_uuid': 'Проект "Долги"',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionCreateControllerProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);

    // --- Подготовка данных для пикеров ---

    // Подготовка данных для пикера Счетов из переданного списка accounts
    final List<PickerItem<String>> accountPickerItems = accounts
        .map((account) => PickerItem<String>(value: account.id, displayValue: account.name))
        .toList();

    final String currentAccountDisplay = accounts
        .firstWhere(
          (account) => account.id == transactionState.accountId,
      orElse: () => Account(
        id: '',
        name: LocaleKeys.notSelected.tr(),
        teamId: '', // <--- ДОБАВЛЕНО
        createdAt: DateTime(1970), // <--- ДОБАВЛЕНО (или другое осмысленное дефолтное значение)
      ),
    ).name;


    // Подготовка данных для пикера Проектов
    final List<PickerItem<String>> projectPickerItems = _projectOptions.entries
        .map((entry) => PickerItem<String>(value: entry.key, displayValue: entry.value))
        .toList();
    final String currentProjectDisplay = _projectOptions[transactionState.projectId] ?? LocaleKeys.notSelected.tr();

    // Подготовка данных для пикера Даты (остается без изменений, добавляем в контроллер)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dayBeforeYesterday = today.subtract(const Duration(days: 2));

    final List<PickerItem<DateTime>> datePickerItems = [
      PickerItem(value: today, displayValue: LocaleKeys.today.tr()),
      PickerItem(value: yesterday, displayValue: LocaleKeys.yesterday.tr()),
      PickerItem(value: dayBeforeYesterday, displayValue: LocaleKeys.theDayBeforeYesterday.tr()),
    ];

    final DateTime transactionDate = transactionState.date ?? DateTime.now();

    final currentSimpleDate = DateTime(transactionDate.year, transactionDate.month, transactionDate.day); // Исправлен порядок month/day
    String currentDateDisplay;
    if (currentSimpleDate == today) {
      currentDateDisplay = LocaleKeys.today.tr();
    } else if (currentSimpleDate == yesterday) {
      currentDateDisplay = LocaleKeys.yesterday.tr();
    } else if (currentSimpleDate == dayBeforeYesterday) {
      currentDateDisplay = LocaleKeys.theDayBeforeYesterday.tr();
    } else {
      currentDateDisplay = DateFormat('dd.MM.yyyy').format(transactionDate);
    }

    // --- Построение UI ---
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          // Поле выбора Счета
          CustomSecondaryPickerField(
            context: context,
            icon: Icons.account_balance_wallet,
            currentValueDisplay: currentAccountDisplay,
            width: (MediaQuery.of(context).size.width / 3) - 16,
            onTap: () async {
              final selected = await customShowModalBottomSheet<String>(
                  context: context,
                  title: LocaleKeys.selectAccount.tr(),
                  items: accountPickerItems,
                  type: 'line'
              );
              if (selected != null) {
                transactionCreateController.updateAccount(selected.value);
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
              final selected = await customShowModalBottomSheet<String>(
                  context: context,
                  title: LocaleKeys.selectProject.tr(),
                  items: projectPickerItems,
                  type: 'line'
              );
              if (selected != null) {
                transactionCreateController.updateProject(selected.value);
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
                initialDate: transactionDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                final currentTime = TimeOfDay.fromDateTime(transactionDate);
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