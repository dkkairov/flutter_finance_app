import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// !!! ИМПОРТИРУЕМ ОБЩУЮ МОДЕЛЬ Account из доменного слоя
// !!! Импортируем AccountScreen
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/theme/custom_text_styles.dart';
import '../../common/widgets/custom_divider.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../domain/models/account.dart';
import 'account_screen.dart'; // Убедитесь, что путь правильный
import '../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys


// !!! УДАЛЕНО: Модель данных _Account больше не определяется здесь.
// Мы используем общую модель Account из domain/models.
// class _Account { ... }


// AccountsScreen
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Отображение общего баланса
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text('${LocaleKeys.balance_total.tr()}: 800 000 \$'), // TODO: Динамический баланс
                ),
              ),
              const CustomDivider(), // Разделитель после баланса

              // Секция списка счетов
              Expanded( // Список занимает все доступное пространство
                child: AccountListContentWidget(), // Виджет, который строит список счетов
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
        )
    );
  }
}

// Класс, который предоставляет содержимое списка счетов
class AccountListContentWidget extends StatelessWidget {
  AccountListContentWidget({super.key});

  // !!! ЗАГЛУШКА: Список счетов. Используем ОБЩУЮ модель Account из доменного слоя.
  // !!! Создаем экземпляры Account без полей icon и subtitle, как в модели
  // Добавляем id, teamId, currencyId, isActive для соответствия модели с бэкенда
  final List<Account> items = [ // Используем ОБЩИЙ тип Account
    Account(id: 1, name: 'Основной счет', balance: 100000, ),
    Account(id: 2, name: 'Кредитная карта', balance: -15000, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 3, name: 'Сберегательный счет', balance: 500000, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 4, name: 'Электронный кошелек', balance: 5000, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 5, name: 'Счет 5 (Команда 2)', balance: 100, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 6, name: 'Счет 6 (Команда 2)', balance: 200, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 7, name: 'Счет 7 (Команда 2)', balance: 300, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 8, name: 'Счет 8', balance: 100, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 9, name: 'Счет 9', balance: 200, ), // title -> name, УДАЛЕНЫ icon/subtitle
    Account(id: 10, name: 'Счет 10', balance: 300,), // title -> name, УДАЛЕНЫ icon/subtitle
  ];

  @override
  Widget build(BuildContext context) {
    // Используем CustomListViewSeparated с ОБЩИМ типом Account
    return CustomListViewSeparated<Account>( // Используем ОБЩИЙ тип Account
      items: items, // Передаем список объектов Account
      itemBuilder: (context, item) { // item здесь имеет тип Account
        return CustomListItem(
          // !!! ИСПРАВЛЕНО: Leading теперь null, так как в модели нет поля icon
          leading: null, // Или вычисляем иконку на основе item.currencyId или других полей
          // !!! Используем item.name для заголовка (соответствует title в UI)
          titleText: item.name, // Используем name из модели Account
          // !!! ИСПРАВЛЕНО: Subtitle теперь null, так как в модели нет поля subtitle
          subtitleText: null, // Или вычисляем подзаголовок на основе item.currencyId или других полей
          trailing: Row( // Trailing остается виджетом Row, используем item.balance
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.balance!.toStringAsFixed(0)} \$', // Пока оставляем валюту жестко заданной
                style: CustomTextStyles.normalMedium.copyWith(
                  color: item.balance! < 0 ? CustomColors.error : CustomColors.mainDarkGrey,
                ),
              ),
              const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
            ],
          ),
          onTap: () {
            // !!! ИСПРАВЛЕНО: ПЕРЕДАЕМ ОБЪЕКТ account (который равен item)
            // в конструктор AccountScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountScreen(account: item) // Передаем объект item (Account)
              ),
            );
            // TODO: В AccountScreen использовать account.id для загрузки реальных данных и транзакций,
            // если данные, переданные сюда, недостаточны.
          },
        );
      },
    );
  }
}