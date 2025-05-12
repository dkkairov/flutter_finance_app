// lib/features/settings/presentation/screens/delete_options_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../../../generated/locale_keys.g.dart'; // Import LocaleKeys

class DeleteOptionsScreen extends ConsumerWidget {
  const DeleteOptionsScreen({super.key});

  Future<void> _showDeleteProfileConfirmation(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmProfileDeletionTitle.tr()),
          content: Text(LocaleKeys.confirmProfileDeletionContent.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Закрыть диалог
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                print('Запущена процедура удаления профиля');
                // !!! ЗАГЛУШКА: Здесь должна быть реальная логика удаления профиля
                // ref.read(userProfileProvider.notifier).deleteProfile(); // Пример
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Вернуться на экран настроек
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(LocaleKeys.deleteProfile.tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteTransactionsConfirmation(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmDeleteAllTransactionsTitle.tr()),
          content: Text(LocaleKeys.confirmDeleteAllTransactionsContent.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Закрыть диалог
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                print('Запущена процедура удаления всех транзакций');
                // !!! ЗАГЛУШКА: Здесь должна быть реальная логика удаления всех транзакций
                // ref.read(transactionListProvider.notifier).deleteAllTransactions(); // Пример
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Вернуться на экран настроек
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(LocaleKeys.deleteAllTransactions.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteOptions = [
      {
        'title': LocaleKeys.deleteProfile.tr(),
        'subtitle': LocaleKeys.deleteProfileSubtitle.tr(),
        'onTap': () => _showDeleteProfileConfirmation(context, ref),
      },
      {
        'title': LocaleKeys.deleteAllTransactions.tr(),
        'subtitle': LocaleKeys.deleteAllTransactionsSubtitle.tr(),
        'onTap': () => _showDeleteTransactionsConfirmation(context, ref),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.deleteProfileAndData.tr()),
      ),
      body: CustomListViewSeparated(
        items: deleteOptions,
        itemBuilder: (context, item) {
          return CustomListItem(
            titleText: item['title'] as String,
            subtitleText: item['subtitle'] as String?,
            onTap: item['onTap'] as VoidCallback?,
          );
        },
      ),
    );
  }
}