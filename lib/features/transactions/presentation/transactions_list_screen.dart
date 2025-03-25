import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/transaction_item.dart';
import '../../../features/transactions/data/transaction_provider.dart';

class TransactionsListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final transactionsNotifier = ref.read(transactionsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Транзакции'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await transactionsNotifier.fetchTransactions();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Dismissible(
            key: Key(transaction.id),
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              await transactionsNotifier.deleteTransaction(transaction.id);
            },
            child: TransactionItem(
              title: transaction.title,
              amount: transaction.amount,
              date: transaction.date,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/main-transaction');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
