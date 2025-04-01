// // lib/features/transactions/presentation/widgets/transaction_list_widget.dart
//
// import 'package:flutter/material.dart';
//
// import '../../domain/models/transaction.dart';
//
// class TransactionListWidget extends StatelessWidget {
//   final List<Transaction> transactions;
//
//   const TransactionListWidget({super.key, required this.transactions});
//
//   @override
//   Widget build(BuildContext context) {
//     if (transactions.isEmpty) {
//       return const Center(child: Text('Нет транзакций'));
//     }
//     return ListView.separated(
//       itemCount: transactions.length,
//       separatorBuilder: (_, __) => const Divider(height: 1),
//       itemBuilder: (context, index) {
//         final t = transactions[index];
//         final isExpense = t.transactionType == 'expense';
//         final sign = isExpense ? '-' : '+';
//
//         return ListTile(
//           leading: const Icon(Icons.category),
//           title: Text(t.description ?? 'Без описания'),
//           subtitle: Text('projectId = ${t.projectId ?? '—'}'),
//           trailing: Text(
//             '$sign${t.amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: isExpense ? Colors.red : Colors.green,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
