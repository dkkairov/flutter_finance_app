import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// Убедитесь, что путь к bottom sheet'у правильный (если он используется)
import 'package:flutter_app_1/features/accounts/presentation/widgets/edit_account_bottom_sheet.dart';
// Убедитесь, что пути к темам и разделителю правильные
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_text_styles.dart';
import '../../../../common/widgets/custom_divider.dart'; // Предполагается, что CustomDivider доступен
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys

// !!! ИМПОРТИРУЕМ ОБЩУЮ МОДЕЛЬ Account из доменного слоя


// !!! ИМПОРТИРУЕМ ЭКРАН ДЕТАЛЕЙ ТРАНЗАКЦИИ (ЗАГЛУШКА)
// Убедитесь, что путь правильный.

import '../../../common/widgets/custom_amount_text.dart';
import '../../transactions/presentation/screens/transaction_detail_screen.dart';
import '../../transactions/presentation/widgets/transaction_list_widget.dart';





// Экран деталей счета
class CategoryTransactionListScreen extends StatelessWidget {
  // final TransactionCategory transactionCategory; // Принимаем объект общей модели

  const CategoryTransactionListScreen({super.key,
    // required this.transactionCategory
  });

  @override
  Widget build(BuildContext context) {


    return Scaffold( // Scaffold уже предоставляет SafeArea в body по умолчанию
      appBar: AppBar(
        // Кнопка "назад" обычно добавляется автоматически при навигации через Navigator.push
        // Заголовок с названием счета из объекта Account
        title: Text(
          'Category Name'.tr(), // Используем название счета из переданного объекта Account
          // transactionCategory.name,
          style: CustomTextStyles.normalMedium.copyWith( // Пример стиля для заголовка AppBar
            fontWeight: FontWeight.bold,
            color: CustomColors.onPrimary, // Цвет текста в AppBar
          ),
        ),
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
                  '${LocaleKeys.total.tr()}: 150000 ${LocaleKeys.tenge_short.tr()}', // Показываем N/A если balance null
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
          const CustomDivider(), // Разделитель после секции баланса

          // Секция списка транзакций счета
          Expanded( // Expanded заставляет список транзакций занять все оставшееся пространство
            child: TransactionListWidget(),
          ),
        ],
      ),
    );
  }
}