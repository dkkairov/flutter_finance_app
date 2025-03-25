import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../features/transactions/data/transaction_provider.dart';

class TransactionFormScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsNotifier = ref.read(transactionsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Добавить Транзакцию')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: titleController, hintText: 'Название транзакции'),
            SizedBox(height: 16),
            CustomTextField(controller: amountController, hintText: 'Сумма'),
            SizedBox(height: 24),
            CustomButton(
              text: 'Сохранить',
              onPressed: () async {
                final transaction = Transaction(
                  id: '',  // ID будет присвоен сервером
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  date: DateTime.now(),
                );

                try {
                  await transactionsNotifier.addTransaction(transaction);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка добавления транзакции: ${e.toString()}')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
