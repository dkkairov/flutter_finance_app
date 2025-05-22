// lib/features/transactions/presentation/widgets/transaction_create_screen/transfer_accounts_selector_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_picker_fields/custom_secondary_picker_field.dart';
import '../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
// import '../../../../common/widgets/custom_show_bottom_sheet.dart'; // УДАЛЯЕМ этот импорт
import '../../../../../generated/locale_keys.g.dart';
import '../../../../accounts/domain/models/account.dart';
import '../../providers/transaction_controller.dart';
import '../../../../accounts/presentation/providers/accounts_provider.dart'; // Для получения списка счетов

class TransferAccountsSelectorWidget extends ConsumerWidget {
  const TransferAccountsSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final transactionState = ref.watch(transactionCreateControllerProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);
    final rawAmount = transactionCreateController.rawAmount; // Получаем текущую сумму

    return accountsAsync.when(
      data: (accounts) {
        final List<PickerItem<String>> accountPickerItems = accounts
            .map((account) => PickerItem<String>(value: account.id, displayValue: account.name))
            .toList();

        // Отображение выбранного счета "Откуда"
        final String currentFromAccountDisplay = accounts
            .firstWhere(
              (account) => account.id == transactionState.fromAccountId,
          orElse: () => Account(id: '', name: LocaleKeys.notSelected.tr()),
        )
            .name;

        // Отображение выбранного счета "Куда"
        final String currentToAccountDisplay = accounts
            .firstWhere(
              (account) => account.id == transactionState.toAccountId,
          orElse: () => Account(id: '', name: LocaleKeys.notSelected.tr()),
        )
            .name;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  CustomSecondaryPickerField(
                    context: context,
                    icon: Icons.account_balance_wallet_outlined,
                    currentValueDisplay: currentFromAccountDisplay,
                    width: (MediaQuery.of(context).size.width / 2) - 16,
                    onTap: () async {
                      final selected = await customShowModalBottomSheet<String>(
                        context: context,
                        title: 'transferFromAccount',
                        items: accountPickerItems,
                        type: 'line',
                      );
                      if (selected != null) {
                        transactionCreateController.updateFromAccount(selected.value);
                      }
                    },
                  ),
                  CustomSecondaryPickerField(
                    context: context,
                    icon: Icons.account_balance_wallet,
                    currentValueDisplay: currentToAccountDisplay,
                    width: (MediaQuery.of(context).size.width / 2) - 16,
                    onTap: () async {
                      final selected = await customShowModalBottomSheet<String>(
                        context: context,
                        title: 'transferToAccount',
                        items: accountPickerItems,
                        type: 'line',
                      );
                      if (selected != null) {
                        transactionCreateController.updateToAccount(selected.value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Кнопка для создания перевода
              ElevatedButton(
                onPressed: () async {
                  // Вызываем метод создания транзакции (для перевода)
                  // Проверка на сумму
                  // Убедимся, что парсим сумму, убрав и пробелы, и заменяя запятую на точку
                  print('DEBUG: TransferAccountsSelectorWidget - rawAmount before parsing: "$rawAmount"');
                  final cleanedRawAmount = rawAmount.replaceAll(' ', '').replaceAll(',', '.');
                  print('DEBUG: TransferAccountsSelectorWidget - cleanedRawAmount: "$cleanedRawAmount"');
                  final parsedAmount = double.tryParse(cleanedRawAmount); // Временно сохраним результат парсинга
                  print('DEBUG: TransferAccountsSelectorWidget - parsed amount: $parsedAmount');

                  if (parsedAmount == null || parsedAmount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("transferAmountInvalid"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final errorMessage = await transactionCreateController.createTransaction();

                  if (errorMessage == null) {
                    // Успех! Сбрасываем форму и показываем SnackBar
                    transactionCreateController.resetForm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('transferCreatedSuccessfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // TODO: Возможно, навигация на главный экран или обновление списка транзакций
                  } else {
                    // Ошибка! Показываем SnackBar с сообщением об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('createTransfer'),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Ошибка загрузки счетов для перевода: $err')),
    );
  }
}