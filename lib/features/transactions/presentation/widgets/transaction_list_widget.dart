import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/common/theme/custom_colors.dart';
import '../../../../features/common/theme/custom_text_styles.dart';
import '../../../common/widgets/custom_amount_text.dart';
import '../../../common/widgets/custom_divider.dart';
import '../screens/transaction_detail_screen.dart';


// !!! ЗАГЛУШКА: Модель данных для транзакции внутри представления счета (остается приватной в этом файле)
// Добавим id к транзакции заглушки, чтобы можно было ее идентифицировать при переходе.
class DummyAccountTransaction {
  final int id; // Добавляем ID для идентификации транзакции
  final String categoryName; // Название категории
  final String time; // Время (например, "15:02")
  final double amount; // Сумма транзакции
  // TODO: Возможно, добавить другие поля, которые могут понадобиться для деталей транзакции (например, accountId, date, comment)
  DummyAccountTransaction({required this.id, required this.categoryName, required this.time, required this.amount});
}

// !!! ЗАГЛУШКА: Данные транзакций для демонстрации на этом экране (остается приватной в этом файле)
final Map<String, List<DummyAccountTransaction>> _currentAccountTransactions = {
  '20 april': [ // Дата как ключ группы
    DummyAccountTransaction(id: 101, categoryName: 'Category 1', time: '15:02', amount: -5000),
    DummyAccountTransaction(id: 102, categoryName: 'Category 2', time: '14:02', amount: -20),
    DummyAccountTransaction(id: 103, categoryName: 'Category 3', time: '11:41', amount: 10000), // Пример дохода
  ],
  '19 april': [
    DummyAccountTransaction(id: 104, categoryName: 'Category 2', time: '14:02', amount: -20),
    DummyAccountTransaction(id: 105, categoryName: 'Category 2', time: '14:02', amount: -20),
  ],
  // TODO: Добавьте больше заглушек данных по необходимости
};

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> dates = _currentAccountTransactions.keys.toList();
    return ListView.builder(
      // Используем ListView.builder для построения групп транзакций по датам
      itemCount: dates.length, // Количество групп (дат)
      itemBuilder: (context, index) {
        final date = dates[index];
        final transactions = _currentAccountTransactions[date]!; // Получаем список транзакций для этой даты из приватной переменной заглушек

        // Вычисляем общую сумму транзакций за день для заголовка группы (ЗАГЛУШКА)
        final dailyTotal = transactions.map((tx) => tx.amount).fold(0.0, (sum, amount) => sum + amount);
        final dailyTotalString = dailyTotal.toStringAsFixed(0); // Форматируем сумму
        // Формат для отображения суммы за день (например: +5000 тг или -5000 тг)
        final dailyTotalDisplay = '${dailyTotal > 0 ? '+' : ''}${dailyTotalString} ₸';


        return Column( // Используем Column для каждой группы по дате
          crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание содержимого группы по левому краю
          children: [
            // Заголовок группы по дате
            Padding(
              // Отступы вокруг заголовка даты
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                // !!! Заголовок даты с суммой за день
                '$date ($dailyTotalDisplay)', // Например: "20 april (+5000 тг)"
                style: CustomTextStyles.normalSmall.copyWith(fontWeight: FontWeight.bold, color: CustomColors.mainGrey), // Пример стиля
              ),
            ),
            // Список транзакций внутри этой группы по дате
            Column(
              children: transactions.map((tx) {
                // !!! ОБЕРНУТЬ КАЖДЫЙ ЭЛЕМЕНТ ТРАНЗАКЦИИ В InkWell ДЛЯ НАЖАТИЯ
                return InkWell(
                  onTap: () {
                    // !!! НАВИГАЦИЯ НА ЭКРАН ДЕТАЛЕЙ ТРАНЗАКЦИИ
                    print('Нажата транзакция: ${tx.categoryName} ${tx.amount}');

                    // !!! ПЕРЕДАЕМ ОБЪЕКТ ТРАНЗАКЦИИ (tx) НАПРЯМУЮ В TransactionDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Передаем объект tx (_DummyAccountTransaction) в конструктор TransactionDetailScreen
                        builder: (context) => TransactionDetailScreen(transaction: tx),
                      ),
                    );
                  },
                  // !!! Тело элемента транзакции (ваш текущий Padding с Row)
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      // ... содержимое строки транзакции (иконка, категория/время, сумма)
                      // Заглушка для иконки категории (серый кружок)
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.mainLightGrey, // Пример цвета заглушки
                          ),
                          // TODO: Добавить реальную иконку категории
                        ),
                        const SizedBox(width: 8),

                        // Название категории и время
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.categoryName.tr(),
                                style: CustomTextStyles.normalMedium,
                              ),
                              Text(
                                tx.time,
                                style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Сумма транзакции
                        CustomAmountText(
                          amount: tx.amount,
                          currencySymbol: '₸', // Передаем символ валюты
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(), // Преобразуем результат map в List<Widget>
            ),
            const CustomDivider(),
          ],
        );
      },
    );
  }
}