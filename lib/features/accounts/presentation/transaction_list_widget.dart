import 'package:flutter/material.dart';

class Transaction {
  final String category;
  final String project;
  final double amount;
  final IconData icon;
  final bool isExpense;

  Transaction({
    required this.category,
    required this.project,
    required this.amount,
    required this.icon,
    required this.isExpense,
  });
}

class TransactionListWidget extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
        category: "Продукты",
        project: "Семейный бюджет",
        amount: 2500.00,
        icon: Icons.shopping_cart,
        isExpense: true),
    Transaction(
        category: "Зарплата",
        project: "Основной доход",
        amount: 150000.00,
        icon: Icons.account_balance_wallet,
        isExpense: false),
    Transaction(
        category: "Развлечения",
        project: "Выходные",
        amount: 5000.00,
        icon: Icons.movie,
        isExpense: true),
    Transaction(
        category: "Фриланс",
        project: "Дополнительный заработок",
        amount: 30000.00,
        icon: Icons.computer,
        isExpense: false),
  ];

  TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: Icon(transaction.icon, size: 32, color: Colors.blueGrey),
            title: Text(transaction.category, style: TextStyle(fontSize: 16)),
            subtitle: Text(transaction.project, style: TextStyle(color: Colors.grey)),
            trailing: Text(
              "${transaction.isExpense ? "-" : "+"}${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.isExpense ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
