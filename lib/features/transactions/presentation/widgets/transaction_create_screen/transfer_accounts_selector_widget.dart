import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../features/common/theme/custom_colors.dart';
import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../../accounts/domain/models/account.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../providers/transaction_controller.dart';

// Предполагаемая модель счета. Замените на вашу реальную модель!
// class Account {
//   final int id;
//   final String name;
//   Account({required this.id, required this.name});
// }


class TransferAccountsSelectorWidget extends ConsumerWidget {
  // Принимаем список счетов и функцию для показа bottom sheet'а
  final List<Account> accounts;
  // final Future<PickerItem<int>?> Function({ // Пример, если передавать функцию
  //   required BuildContext context,
  //   required String title,
  //   required List<PickerItem<int>> items,
  // }) showItemPicker;


  const TransferAccountsSelectorWidget({
    super.key,
    required this.accounts,
    // required this.showItemPicker,
  });

  // Хелпер для построения поля выбора счета
  Widget _buildAccountField({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required int? currentAccountId,
    required List<Account> availableAccounts, // Счета для выбора
    required Function(int) onAccountSelected, // Обработчик выбора счета
  }) {
    // Ищем текущее название счета по ID
    final String currentAccountName =
        availableAccounts.firstWhere(
              (account) => account.id == currentAccountId,
          orElse: () => Account(id: -1, name: LocaleKeys.selectAccount.tr()), // Замените на ваш класс Account
        ).name;


    return InkWell(
      onTap: () async {
        // Преобразуем список счетов в PickerItem для bottom sheet'а
        final List<PickerItem<int>> pickerItems = availableAccounts
            .map((account) => PickerItem<int>(id: account.id, displayValue: account.name))
            .toList();

        final selected = await customShowModalBottomSheet<int>(
          context: context,
          title: label, // Используем метку поля как заголовок bottom sheet'а
          items: pickerItems,
          type: 'line',
        );

        if (selected != null) {
          onAccountSelected(selected.id); // Вызываем переданный колбэк с ID выбранного счета
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CustomColors.mainLightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label, // Метка поля ("С какого счета", "На какой счет")
              style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey), // Метка чуть меньше и серее
            ),
            const SizedBox(height: 2),
            Text(
              currentAccountName, // Отображаем выбранное название счета
              style: CustomTextStyles.normalMedium,
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
    // Получаем текущее состояние контроллера транзакций
    final transactionState = ref.watch(transactionCreateControllerProvider);
    // Получаем notifier контроллера для вызова методов обновления
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);

    // Получаем выбранные счета для "откуда" и "куда" из состояния контроллера
    final int? fromAccountId = transactionState.fromAccountId; // Вам нужно будет добавить эти поля в состояние контроллера
    final int? toAccountId = transactionState.toAccountId; // Вам нужно будет добавить эти поля в состояние контроллера

    // TODO: В БУДУЩЕМ - реализовать логику установки счета по умолчанию для fromAccountId
    // Например, при инициализации TransferTransactionsState можно установить fromAccountId = ID счета по умолчанию

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Добавляем горизонтальный отступ
      child: Column( // Используем Column для вертикального расположения полей
        children: [
          // Поле "С какого счета"
          _buildAccountField(
            context: context,
            ref: ref,
            label: LocaleKeys.fromAccount.tr(),
            currentAccountId: fromAccountId,
            availableAccounts: accounts, // Передаем список счетов
            onAccountSelected: (accountId) {
              // Вызываем метод контроллера для обновления счета "откуда"
              transactionCreateController.updateFromAccount(accountId); // Вам нужно будет добавить этот метод в контроллер
            },
          ),
          const SizedBox(height: 16), // Отступ между полями
          // Иконка или текст "->"
          const Icon(Icons.arrow_downward), // Или Icons.arrow_forward если UI горизонтальный
          const SizedBox(height: 16),
          // Поле "На какой счет"
          _buildAccountField(
            context: context,
            ref: ref,
            label: LocaleKeys.toAccount.tr(),
            currentAccountId: toAccountId,
            availableAccounts: accounts, // Передаем список счетов
            onAccountSelected: (accountId) {
              // Вызываем метод контроллера для обновления счета "куда"
              transactionCreateController.updateToAccount(accountId); // Вам нужно будет добавить этот метод в контроллер
            },
          ),
          const SizedBox(height: 100),
          // TODO: В БУДУЩЕМ - добавить валидацию, чтобы счета From и To не совпадали
        ],
      ),
    );
  }
}