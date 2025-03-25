import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;

  const TransactionItem({
    required this.title,
    required this.amount,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('${date.toLocal()}'),
      trailing: Text('\$${amount.toStringAsFixed(2)}'),
    );
  }
}
