import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../domain/models/transaction.dart';
import '../providers/transaction_provider.dart';


class TransactionFormScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsNotifier = ref.read(transactionRepositoryProvider);

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
                  id: 1,
                  userId: 1,
                  transactionType: 'expense',
                  transactionCategoryId: 1,
                  amount: 500.0,
                  accountId: 1,
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  isActive: true,
                );

                try {
                  await transactionsNotifier.createTransaction(transaction);
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
