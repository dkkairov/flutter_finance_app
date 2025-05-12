import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/common/widgets/custom_divider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Если используете Riverpod

// Предполагается, что стили и цвета доступны
import '../../../../common/widgets/custom_draggable_scrollable_sheet.dart';
import '../../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../../common/widgets/custom_text_form_field.dart';
import '../../domain/models/account.dart';
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys

/// A DraggableScrollableSheet for editing account details.
///
/// Requires the Account object to edit.
class EditAccountBottomSheet extends ConsumerWidget {
  final Account account; // Счет, который редактируем

  const EditAccountBottomSheet({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Для реального редактирования нужны TextEditingController для каждого поля,
    // и состояние для управления значениями полей. Для заглушки UI можно использовать initialValue.
    List<Widget> fields = [
      // Поле "Name"
      CustomTextFormField(
        initialValue: account.name, // Предзаполняем текущим описанием счета
        labelText: LocaleKeys.name.tr(), // Лейбл поля -> LocaleKeys.name
      ),
      const SizedBox(height: 16), // Отступ между полями

      // Поле "Currency" (Заглушка - возможно, в будущем будет выбор из списка)
      // На скриншоте это выглядит как поле только для чтения.
      CustomTextFormField(
        initialValue: 'Dollar USA (\$)', // Предзаполняем текущим описанием счета
        labelText: LocaleKeys.currency.tr(), // Лейбл поля -> LocaleKeys.currency
      ),
      const SizedBox(height: 16), // Отступ

      // Поле "Balance" (Заглушка - баланс обычно не редактируется напрямую)
      // На скриншоте это также поле только для чтения.
      CustomTextFormField(
        initialValue: account.balance?.toStringAsFixed(0) ?? '0', // Предзаполняем текущим балансом (безопасный доступ)
        labelText: LocaleKeys.balance.tr(), // Лейбл поля -> LocaleKeys.balance
      ),
      const SizedBox(height: 24), // Отступ перед кнопкой

      // Кнопка "Save"
      CustomPrimaryButton(
        onPressed: () {
          // TODO: Реализовать логику сохранения изменений счета
          // Получить значения из полей (если используются контроллеры)
          // Обновить данные счета (например, через Riverpod Provider или Repository)
          print('Save pressed for account ${account.name}'); // Пример: вывести действие
          Navigator.pop(context); // Закрыть лист после сохранения
        },
        text: LocaleKeys.save.tr(), // "Save" -> LocaleKeys.save
      ),
    ];

    return CustomDraggableScrollableSheet(fields: fields, title: LocaleKeys.editAccount.tr()); // Передаем поля и заголовок -> LocaleKeys.editAccount
  }
}

// Вспомогательная функция для удобного показа bottom sheet'а редактирования счета
void showEditAccountBottomSheet(BuildContext context, Account account) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Позволяет листу занимать больше половины экрана
    backgroundColor: Colors.transparent, // Прозрачный фон, чтобы было видно скругление Container
    builder: (context) => EditAccountBottomSheet(account: account), // Передаем объект счета в виджет листа
  );
}