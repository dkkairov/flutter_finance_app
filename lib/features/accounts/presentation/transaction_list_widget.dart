import 'package:flutter/material.dart';
import '../../transactions/presentation/providers/transaction_provider.dart';

class TransactionListWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionListWidget({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isExpense = transaction.type == 'expense';

        return ListTile(
          leading: Icon(
            Icons.category, // Здесь можно использовать кастомные иконки
            color: Colors.blue,
          ),
          title: Text(transaction.categoryName),
          subtitle: Text(transaction.projectName ?? 'Без проекта'),
          trailing: Text(
            '${isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
