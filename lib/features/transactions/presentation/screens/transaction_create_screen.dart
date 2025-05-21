import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../main.dart';
import '../../../accounts/domain/models/account.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart'; // <--- НОВЫЙ ИМПОРТ
import '../providers/transaction_controller.dart';
import '../widgets/transaction_create_screen/additional_fields_widget.dart';
import '../widgets/transaction_create_screen/category_picker_widget.dart';
import '../widgets/transaction_create_screen/numeric_keypad_widget.dart';
import '../widgets/transaction_create_screen/sum_view_widget.dart';
import '../widgets/transaction_create_screen/transaction_type_selector_widget.dart';
import '../widgets/transaction_create_screen/transfer_accounts_selector_widget.dart';

enum TransactionType { expense, income, transfer }

class TransactionCreateScreen extends ConsumerWidget {
  const TransactionCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TransactionType selectedSegment = ref.watch(transactionTypeProvider);

    // НОВОЕ: Наблюдаем за accountsProvider
    final accountsAsyncValue = ref.watch(accountsProvider);

    return Scaffold(
      body: accountsAsyncValue.when(
        // Состояние загрузки
        loading: () => const Center(child: CircularProgressIndicator()),
        // Состояние ошибки
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки счетов: ${error.toString()}'),
        ),
        // Состояние успешной загрузки
        data: (accounts) {
          // После успешной загрузки, передаем реальные счета в дочерние виджеты
          return Column(
            children: [
              TransactionTypeSelectorWidget(
                selectedSegment: selectedSegment,
                onValueChanged: (TransactionType value) {
                  ref.read(transactionTypeProvider.notifier).state = value;
                  // При смене типа транзакции, возможно, нужно сбросить некоторые поля в контроллере
                  // ref.read(transactionCreateControllerProvider.notifier).resetFieldsForType(value);
                },
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: selectedSegment == TransactionType.transfer
                    ?
                TransferAccountsSelectorWidget(
                  key: const ValueKey('transfer_selector'),
                )
                    :
                Column(
                  key: const ValueKey('category_fields'),
                  children: [
                    // CategoryPickerWidget теперь будет получать категории сам через свой провайдер
                    CategoryPickerWidget(),
                    AdditionalFieldsWidget(accounts: accounts), // ИСПОЛЬЗУЕМ РЕАЛЬНЫЕ СЧЕТА
                  ],
                ),
              ),
              const SumViewWidget(),
              const NumericKeypadWidget(),
            ],
          );
        },
      ),
    );
  }
}