import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart'; // Import LocaleKeys

// --- Riverpod Providers (Stubs) ---
final deleteDataProvider = Provider((ref) => DeleteDataNotifier());

class DeleteDataNotifier {
  Future<void> deleteAllData(BuildContext context) async {
    print('Attempting to delete all data...');
    bool? confirmed = await _showConfirmationDialog(
      context,
      LocaleKeys.confirmDeletion.tr(), // Заголовок из макета -> LocaleKeys.confirmDeletion
      LocaleKeys.deleteAllDataConfirmation.tr(), // Текст из макета -> LocaleKeys.deleteAllDataConfirmation
    );
    if (confirmed == true) {
      print('Confirmed: Deleting all data...');
      // Здесь логика удаления всех данных
    } else {
      print('Cancelled: Delete all data');
    }
  }

  Future<void> deleteTransactionsOnly(BuildContext context) async {
    print('Attempting to delete transactions only...');
    bool? confirmed = await _showConfirmationDialog(
      context,
      LocaleKeys.confirmDeletion.tr(), // Заголовок из макета -> LocaleKeys.confirmDeletion
      LocaleKeys.deleteTransactionsConfirmation.tr(), // Текст из макета -> LocaleKeys.deleteTransactionsConfirmation
    );
    if (confirmed == true) {
      print('Confirmed: Deleting transactions only...');
      // Здесь логика удаления только транзакций
    } else {
      print('Cancelled: Delete transactions only');
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.cancel.tr()), // Текст кнопки из макета -> LocaleKeys.cancel
              onPressed: () {
                Navigator.of(context).pop(false); // Возвращаем false при отмене
              },
            ),
            TextButton(
              child: Text(LocaleKeys.confirm.tr()), // Текст кнопки из макета -> LocaleKeys.confirm
              onPressed: () {
                Navigator.of(context).pop(true); // Возвращаем true при подтверждении
              },
            ),
          ],
        );
      },
    );
  }
}

// --- UI Screen ---
class DeleteProfileScreen extends ConsumerWidget {
  // Конструктор может быть const, если все его параметры могут быть const
  const DeleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteNotifier = ref.watch(deleteDataProvider);

    return Scaffold(
      appBar: AppBar(
        // Используем const, так как Text здесь константный
        title: Text(LocaleKeys.deleteProfileAndData.tr()), // Можно уточнить заголовок по макету -> LocaleKeys.deleteProfileAndData
      ),
      body: ListView(
        children: <Widget>[
          // Убираем const перед ListTile, т.к. onTap не константный
          ListTile(
            title: Text(LocaleKeys.deleteAllData.tr()), // const для Text допустим -> LocaleKeys.deleteAllData
            subtitle: Text(LocaleKeys.deleteAllDataSubtitle.tr()), // const для Text допустим -> LocaleKeys.deleteAllDataSubtitle
            onTap: () => deleteNotifier.deleteAllData(context), // Эта функция не константа
          ),
          // Убираем const перед ListTile
          ListTile(
            title: Text(LocaleKeys.deleteTransactions.tr()), // const для Text допустим -> LocaleKeys.deleteTransactions
            subtitle: Text(LocaleKeys.deleteTransactionsOnlySubtitle.tr()), // const для Text допустим -> LocaleKeys.deleteTransactionsOnlySubtitle
            onTap: () => deleteNotifier.deleteTransactionsOnly(context), // Эта функция не константа
          ),
        ],
      ),
      // Можно добавить BottomNavigationBar, если он нужен на этом экране
      // bottomNavigationBar: BottomNavigationBar( /* ... */ ),
    );
  }
}