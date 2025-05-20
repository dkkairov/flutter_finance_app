import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../features/common/widgets/custom_buttons/custom_primary_button.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _showConfirmationDialog(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmDeletion.tr()),
          content: Text(LocaleKeys.confirmDeleteAllDataConfirmation.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Закрыть диалог
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                print('Запущена процедура удаления учетной записи и данных');
                // !!! ЗАГЛУШКА: Здесь должна быть реальная логика удаления данных и аккаунта
                // Например, вызов провайдера или сервиса для удаления
                // ref.read(authProvider.notifier).deleteAccount(); // Пример вызова провайдера
                Navigator.of(dialogContext).pop(); // Закрыть диалог
                // Возможно, перенаправить пользователя на экран выхода или авторизации
                Navigator.of(context).pop(); // Вернуться на экран настроек (или куда необходимо)
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(LocaleKeys.deleteAllData.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.deleteProfileAndData.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              LocaleKeys.deleteProfileSubtitle.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.deleteAllDataSubtitle.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomPrimaryButton(
              text: LocaleKeys.deleteAllData.tr(),
              onPressed: () => _showConfirmationDialog(context, ref),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Вернуться на экран настроек
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
          ],
        ),
      ),
    );
  }
}