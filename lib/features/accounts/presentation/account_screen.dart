// lib/features/accounts/presentation/account_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/accounts/presentation/widgets/edit_account_bottom_sheet.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_text_styles.dart';
import '../../../../common/widgets/custom_divider.dart';
import '../../transactions/presentation/widgets/transaction_list_widget.dart';
import '../domain/models/account.dart';
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys


// Экран деталей счета
class AccountScreen extends StatelessWidget {
  final Account account; // Принимаем объект общей модели Account

  const AccountScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {


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
              // TODO: ПОКАЗАТЬ BOTTOM SHEET РЕДАКТИРОВАНИЯ СЧЕТА
              showEditAccountBottomSheet(context, account);
            },
          ),
        ],
      ),
      body: Column( // Используем Column для общего вертикального макета
        children: [
          // Секция баланса счета
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Настраиваем отступы
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание текста по левому краю
              children: [
                // !!! Отображение текущего баланса счета из переданного объекта Account
                Text(
                  // Используем оператор ?. для безопасного доступа к balance, если он может быть null
                  '${LocaleKeys.balance.tr()}: ${account.balance?.toStringAsFixed(0)} ${LocaleKeys.tenge_short.tr()}', // Показываем N/A если balance null
                  style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold), // Пример стиля
                ),
                const SizedBox(height: 4), // Небольшой вертикальный отступ
                // !!! ЗАГЛУШКА: Вторая строка с датой и изменением баланса
                // TODO: Рассчитывать эту строку динамически из итогов за день
                Text(
                  '20 april (-5 000 ${LocaleKeys.tenge_short.tr()})', // Пример текста из скриншота
                  style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey), // Пример стиля
                ),
              ],
            ),
          ),
          CustomDivider(), // Разделитель после секции баланса

          // Секция списка транзакций счета
          Expanded( // Expanded заставляет список транзакций занять все оставшееся пространство
            child: TransactionListWidget(),
          ),
        ],
      ),
    );
  }
}