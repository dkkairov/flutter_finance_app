import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- НОВЫЙ ИМПОРТ ДЛЯ RIVERPOD
import '../../../../generated/locale_keys.g.dart';

// Импорты для Accounts
import '../domain/models/account.dart'; // Твоя модель Account
import '../presentation/providers/accounts_provider.dart'; // Твой провайдер accountsProvider
import '../../auth/presentation/providers/auth_providers.dart'; // Для selectedTeamIdProvider

// Импорты для общих виджетов
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/theme/custom_text_styles.dart';
import '../../common/widgets/custom_divider.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';

import 'account_screen.dart'; // Убедитесь, что путь правильный

class AccountsScreen extends ConsumerWidget { // <--- ИЗМЕНЕНО НА ConsumerWidget
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <--- ДОБАВЛЕНО WidgetRef ref
    // TODO: Динамический баланс будет вычисляться из списка счетов

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Отображение общего баланса
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                // TODO: Здесь нужно будет вычислять общий баланс из загруженных счетов
                child: Text('${LocaleKeys.balance_total.tr()}: 800 000 \$'),
              ),
            ),
            const CustomDivider(), // Разделитель после баланса

            // Секция списка счетов
            Expanded( // Список занимает все доступное пространство
              // AccountListContentWidget теперь будет ConsumerWidget
              child: AccountListContentWidget(),
            ),

            const CustomDivider(), // Разделитель после списка
          ],
        ),
      ),
      // FloatingActionButton для добавления нового счета
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // TODO: Логика открытия формы добавления нового счета
          print('Нажата кнопка "новый счет"');
        },
      ),
    );
  }
}

// Класс, который предоставляет содержимое списка счетов
class AccountListContentWidget extends ConsumerWidget { // <--- ИЗМЕНЕНО НА ConsumerWidget
  const AccountListContentWidget({super.key}); // <--- СДЕЛАНО const

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <--- ДОБАВЛЕНО WidgetRef ref
    final accountsAsyncValue = ref.watch(accountsProvider); // <--- НАБЛЮДАЕМ ЗА ПРОВАЙДЕРОМ СЧЕТОВ

    return accountsAsyncValue.when(
      data: (accounts) {
        // Проверяем, если список счетов пуст, показываем соответствующее сообщение
        if (accounts.isEmpty) {
          return Center(
            child: Text('No accounts'), // Или другое сообщение
          );
        }

        return CustomListViewSeparated<Account>(
          items: accounts, // Используем реальные данные из провайдера
          itemBuilder: (context, item) {
            return CustomListItem(
              leading: null, // Иконка будет вычисляться, если понадобится, на основе типа счета или валюты
              titleText: item.name,
              subtitleText: null, // Или вычисляем подзаголовок (например, валюта)
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // Убедись, что balance не null, иначе используй 0.0
                    '${item.balance?.toStringAsFixed(0) ?? '0'} \$', // TODO: Динамическая валюта
                    style: CustomTextStyles.normalMedium.copyWith(
                      // Проверяем на null перед сравнением
                      color: (item.balance ?? 0) < 0 ? CustomColors.error : CustomColors.mainDarkGrey,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountScreen(account: item),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()), // Показываем загрузку
      error: (err, stack) => Center(child: Text('Ошибка загрузки счетов: $err')), // Показываем ошибку
    );
  }
}