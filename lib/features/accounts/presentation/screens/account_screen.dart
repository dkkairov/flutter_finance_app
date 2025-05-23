// lib/features/accounts/features/account_screen.dart

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/accounts/presentation/widgets/edit_account_bottom_sheet.dart';
import '../../../common/theme/custom_colors.dart';
import '../../../common/theme/custom_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/widgets/custom_divider.dart';
import '../../../transactions/presentation/widgets/transaction_list_widget.dart';
import '../../domain/models/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/accounts_provider.dart';

// Экран деталей счета
class AccountScreen extends ConsumerWidget { // <--- ИЗМЕНЕНО НА ConsumerWidget
  final String accountId; // <--- ИЗМЕНЕНО: Теперь принимаем только ID счета

  const AccountScreen({super.key, required this.accountId}); // <--- ИЗМЕНЕНО

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <--- ДОБАВЛЕНО WidgetRef ref
    // 1. Наблюдаем за accountsProvider
    final accountsAsyncValue = ref.watch(accountsProvider);

    return accountsAsyncValue.when(
      data: (accounts) {
        // 2. Находим нужный счет по accountId
        final Account? account = accounts.firstWhereOrNull( // <--- ИЗМЕНЕНО
              (acc) => acc.id == accountId,
        );

        if (account == null) {
          // Если счет не найден (например, был удален), показываем ошибку или возвращаемся назад
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Использование addPostFrameCallback для предотвращения ошибок "setState during build"
            // при навигации назад, если счет был удален.
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.account_not_found_or_deleted.tr())), // TODO: Локализация
            );
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator())); // Или другое сообщение
        }

        // Если счет найден, продолжаем строить UI
        return Scaffold(
          appBar: AppBar(
            title: Text(
              account.name,
              style: CustomTextStyles.normalMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: CustomColors.onPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // ПОКАЗАТЬ BOTTOM SHEET РЕДАКТИРОВАНИЯ СЧЕТА
                  // Передаем актуальный объект account, который мы только что получили из провайдера
                  showEditAccountBottomSheet(context, account);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Секция баланса счета
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${LocaleKeys.balance.tr()}: ${account.balance?.toStringAsFixed(2) ?? '0.00'} ${LocaleKeys.tenge_short.tr()}',
                      style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '20 april (-5 000 ${LocaleKeys.tenge_short.tr()})',
                      style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
                    ),
                  ],
                ),
              ),
              const CustomDivider(),

              // Секция списка транзакций счета
              Expanded(
                child: TransactionListWidget(), // Возможно, нужно передавать account.id сюда в будущем
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())), // Показываем загрузку
      error: (err, stack) => Scaffold(body: Center(child: Text('Ошибка загрузки счета: $err'))), // Показываем ошибку
    );
  }
}