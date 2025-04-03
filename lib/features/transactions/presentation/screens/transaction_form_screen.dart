import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../domain/models/transaction_entity.dart';
import '../providers/transaction_provider.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(transactionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить Транзакцию')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: titleController, hintText: 'Описание'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: amountController,
              hintText: 'Сумма',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Сохранить',
              onPressed: () async {
                try {
                  final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                  if (amount == 0.0) throw Exception('Введите корректную сумму');

                  final transaction = TransactionEntity(
                    id: DateTime.now().millisecondsSinceEpoch,
                    type: 'expense',
                    amount: amount,
                    date: DateTime.now(),
                    description: titleController.text.trim(),
                  );

                  await repository.create(transaction);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${e.toString()}')),
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
