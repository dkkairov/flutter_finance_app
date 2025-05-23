import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- НОВЫЙ ИМПОРТ ДЛЯ RIVERPOD
import '../../../../../generated/locale_keys.g.dart';

// Импорты для Accounts
import '../../domain/models/account.dart'; // Твоя модель Account
import '../providers/accounts_provider.dart'; // Твой провайдер accountsProvider
import '../../../auth/presentation/providers/auth_providers.dart'; // Для selectedTeamIdProvider

// Импорты для общих виджетов
import '../../../common/theme/custom_colors.dart';
import '../../../common/theme/custom_text_styles.dart';
import '../../../common/widgets/custom_divider.dart';
import '../../../common/widgets/custom_floating_action_button.dart';
import '../../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../widgets/create_account_bottom_sheet.dart';
import 'account_screen.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsyncValue = ref.watch(accountsProvider); // Снова watch, чтобы реагировать на изменения

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Отображение общего баланса
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: accountsAsyncValue.when(
                    data: (accounts) {
                      double totalBalance = accounts.fold(0.0, (sum, account) => sum + (account.balance ?? 0.0));
                      // Убедитесь, что здесь тоже toStringAsFixed(2) для общего баланса
                      return Text(
                        '${LocaleKeys.balance_total.tr()}: ${totalBalance.toStringAsFixed(2)} \$',
                        style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold), // Можно добавить стиль
                      );
                    },
                    loading: () => const Text('Calculating balance...'), // TODO: Локализация
                    error: (err, stack) => const Text('Error calculating balance'), // TODO: Локализация
                  ),
                ),
              ),
              const CustomDivider(), // Разделитель после баланса

              // Секция списка счетов
              Expanded( // Список занимает все доступное пространство
                child: AccountListContentWidget(),
              ),

              const CustomDivider(), // Разделитель после списка
            ],
          ),
        ),
        // FloatingActionButton для добавления нового счета
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            // Открытие формы добавления счета
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Важно для Full-Screen bottom sheet
              backgroundColor: Colors.transparent, // Для скругленных углов
              builder: (context) {
                return const AccountCreateBottomSheet(); // Убедитесь, что это ваш виджет для создания
              },
            );
          },
        )
    );
  }
}

// Класс, который предоставляет содержимое списка счетов
class AccountListContentWidget extends ConsumerWidget {
  const AccountListContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsyncValue = ref.watch(accountsProvider);

    return accountsAsyncValue.when(
      data: (accounts) {
        if (accounts.isEmpty) {
          return Center(
            child: Text(LocaleKeys.no_accounts_yet.tr()), // TODO: Локализация
          );
        }

        return CustomListViewSeparated<Account>(
          items: accounts,
          itemBuilder: (context, item) {
            return CustomListItem(
              leading: null, // Если у вас есть иконки или другие виджеты слева
              titleText: item.name,
              subtitleText: null, // Если у вас есть подзаголовок (например, тип счета)
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // ОТОБРАЖЕНИЕ БАЛАНСА С ДВУМЯ ЗНАКАМИ ПОСЛЕ ЗАПЯТОЙ
                    '${item.balance?.toStringAsFixed(2) ?? '0.00'} \$', // Убедитесь, что '0.00' для дефолта и валюта правильная
                    style: CustomTextStyles.normalMedium.copyWith(
                      color: (item.balance ?? 0) < 0 ? CustomColors.error : CustomColors.mainDarkGrey,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
                ],
              ),
              onTap: () {
                // ПЕРЕДАЕМ ТОЛЬКО ID СЧЕТА В AccountScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountScreen(accountId: item.id), // Передаем только ID
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Ошибка загрузки счетов: $err')), // TODO: Локализация
    );
  }
}