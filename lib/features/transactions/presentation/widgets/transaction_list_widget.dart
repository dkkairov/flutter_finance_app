// lib/features/transactions/presentation/widgets/transaction_list_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart'; // <--- ИМПОРТ TransactionModel

class TransactionListWidget extends ConsumerWidget {
  final List<TransactionModel>? transactions; // Теперь принимает List<TransactionModel>

  const TransactionListWidget({super.key, this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions != null) {
      if (transactions!.isEmpty) {
        return const Center(child: Text('No transactions.')); // TODO: Локализация
      }
      return ListView.builder(
        itemCount: transactions!.length,
        itemBuilder: (context, index) {
          final transaction = transactions![index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Теперь используем поля из TransactionModel,
                        // включая вложенные (если они приходят из API)
                        Text(
                          transaction.description ?? transaction.category?.name ?? 'No Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${transaction.amount.toStringAsFixed(0)} ${transaction.account?.currencySymbol ?? ''}', // Используем символ валюты из счета
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: transaction.transactionType == 'expense' ? Colors.red : Colors.green,
                          ),
                        ),
                        Text(
                          '${transaction.date.day}.${transaction.date.month}.${transaction.date.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (transaction.account?.name != null)
                          Text(
                            'Account: ${transaction.account!.name}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        if (transaction.project?.name != null)
                          Text(
                            'Project: ${transaction.project!.name}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('Please provide transactions to TransactionListWidget.'));
    }
  }
}