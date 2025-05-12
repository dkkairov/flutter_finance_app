import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transactions/presentation/widgets/transaction_create_screen/sum_view_widget.dart';
import 'package:flutter_app_1/features/transactions/presentation/widgets/transaction_create_screen/transaction_type_selector_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../main.dart'; // Убедитесь, что этот импорт правильный для transactionTypeProvider
import '../../../accounts/domain/models/account.dart';
import '../providers/transaction_controller.dart';
import '../widgets/transaction_create_screen/additional_fields_widget.dart';
import '../widgets/transaction_create_screen/category_picker_widget.dart';
import '../widgets/transaction_create_screen/numeric_keypad_widget.dart';
import '../widgets/transaction_create_screen/transfer_accounts_selector_widget.dart'; // Импортируем новый виджет

enum TransactionType { expense, income, transfer}

// Пример списка счетов. В реальном приложении эти данные должны приходить из вашего слоя данных.
final List<Account> availableAccounts = [
  Account(id: 1, name: 'Наличные'),
  Account(id: 2, name: 'Счет Банка А'),
  Account(id: 3, name: 'Счет Банка Б'),
  Account(id: 10, name: 'Депозит'),
];


class TransactionCreateScreen extends ConsumerWidget {
  const TransactionCreateScreen ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TransactionType selectedSegment = ref.watch(transactionTypeProvider);

    return Scaffold(
      body: Column(
        children: [
          TransactionTypeSelectorWidget(
            selectedSegment: selectedSegment,
            onValueChanged: (TransactionType value) {
              ref.read(transactionTypeProvider.notifier).state = value;
              // При смене типа транзакции, возможно, нужно сбросить некоторые поля в контроллере
              ref.read(transactionCreateControllerProvider.notifier).resetFieldsForType(value);
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedSegment == TransactionType.transfer
                ?
            TransferAccountsSelectorWidget(
              key: const ValueKey('transfer_selector'),
              accounts: availableAccounts, // Используем заглушку списка счетов
            )
                :
            Column(
              key: const ValueKey('category_fields'),
              children: [
                CategoryPickerWidget(transactionType: selectedSegment),
                AdditionalFieldsWidget(accounts: availableAccounts), // Используем заглушку списка счетов
              ],
            ),
          ),
          const SumViewWidget(),
          const NumericKeypadWidget(),
        ],
      ),
    );
  }
}