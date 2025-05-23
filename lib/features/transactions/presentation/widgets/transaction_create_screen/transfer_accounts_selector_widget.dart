// lib/features/transactions/presentation/widgets/transaction_create_screen/transfer_accounts_selector_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_picker_fields/custom_secondary_picker_field.dart';
import '../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../accounts/domain/models/account.dart';
import '../../providers/transaction_controller.dart';
import '../../../../accounts/presentation/providers/accounts_provider.dart';

class TransferAccountsSelectorWidget extends ConsumerWidget {
  const TransferAccountsSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final transactionState = ref.watch(transactionCreateControllerProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);
    final rawAmount = transactionCreateController.rawAmount;

    return accountsAsync.when(
      data: (accounts) {
        final List<PickerItem<String>> accountPickerItems = accounts
            .map((account) => PickerItem<String>(value: account.id, displayValue: account.name))
            .toList();

        // Отображение выбранного счета "Откуда"
        final String currentFromAccountDisplay = accounts
            .firstWhere(
              (account) => account.id == transactionState.fromAccountId,
          orElse: () => Account(
            id: '',
            name: LocaleKeys.notSelected.tr(),
            teamId: '', // <--- ДОБАВЛЕНО
            createdAt: DateTime(1970), // <--- ДОБАВЛЕНО
          ),
        )
            .name;

        // Отображение выбранного счета "Куда"
        final String currentToAccountDisplay = accounts
            .firstWhere(
              (account) => account.id == transactionState.toAccountId,
          orElse: () => Account(
            id: '',
            name: LocaleKeys.notSelected.tr(),
            teamId: '', // <--- ДОБАВЛЕНО
            createdAt: DateTime(1970), // <--- ДОБАВЛЕНО
          ),
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
                        title: 'transferFromAccount', // TODO: Локализация
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
                        title: 'transferToAccount', // TODO: Локализация
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
              ElevatedButton(
                onPressed: () async {
                  print('DEBUG: TransferAccountsSelectorWidget - rawAmount before parsing: "$rawAmount"');
                  final cleanedRawAmount = rawAmount.replaceAll(' ', '').replaceAll(',', '.');
                  print('DEBUG: TransferAccountsSelectorWidget - cleanedRawAmount: "$cleanedRawAmount"');
                  final parsedAmount = double.tryParse(cleanedRawAmount);
                  print('DEBUG: TransferAccountsSelectorWidget - parsed amount: $parsedAmount');

                  if (parsedAmount == null || parsedAmount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.transferAmountInvalid.tr()), // TODO: Локализация
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final errorMessage = await transactionCreateController.createTransaction();

                  if (errorMessage == null) {
                    transactionCreateController.resetForm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.transferCreatedSuccessfully.tr()), // TODO: Локализация
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(LocaleKeys.createTransfer.tr()), // TODO: Локализация
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