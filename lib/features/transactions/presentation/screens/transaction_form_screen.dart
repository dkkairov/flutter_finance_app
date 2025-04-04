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
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(transactionRepositoryProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
              hintText: 'Описание',
            ),
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
                  final amount = double.tryParse(amountController.text) ?? 0;

                  final newTransaction = TransactionEntity(
                    id: DateTime.now().millisecondsSinceEpoch, // Временно, Drift сам перезапишет
                    userId: 1, // Пока заглушка
                    transactionType: 'expense',
                    transactionCategoryId: null,
                    amount: amount,
                    accountId: 1,
                    projectId: null,
                    description: titleController.text,
                    date: DateTime.now(),
                    isActive: true,
                  );

                  await repository.create(newTransaction);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка при сохранении: $e')),
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
