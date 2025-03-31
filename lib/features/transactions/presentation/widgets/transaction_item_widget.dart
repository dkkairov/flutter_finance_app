// lib/features/transactions/presentation/widgets/transaction_item_widget.dart

import 'package:flutter/material.dart';

import '../../domain/models/transaction.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.transactionType == 'expense';
    final color = isExpense ? Colors.red : Colors.green;
    final sign = isExpense ? '-' : '+';

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.category, color: color),
      ),
      title: Text(
        transaction.description ?? 'Без описания',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('Проект: ${transaction.projectId ?? '—'}'),
      trailing: Text(
        '$sign${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
