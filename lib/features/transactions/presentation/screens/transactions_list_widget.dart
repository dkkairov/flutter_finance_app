import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/section_list_view.dart';
import '../../domain/models/transaction.dart';
import '../../domain/transaction_use_case.dart';

class TransactionsListWidget extends ConsumerStatefulWidget {
  const TransactionsListWidget({super.key});

  @override
  ConsumerState<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}

class _TransactionsListWidgetState extends ConsumerState<TransactionsListWidget> {
  late Future<List<Transaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(transactionUseCaseProvider).fetchTransactions();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = ref.read(transactionUseCaseProvider).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Transaction>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];
          if (transactions.isEmpty) {
            return const Center(child: Text('Нет транзакций'));
          }

          final items = transactions.map((tx) => SectionListItemModel(
            title: tx.transactionCategoryId.toString(),
            subtitle: tx.date.toString(),
            trailing: Text(
              (tx.amount > 0 ? '+' : '') + tx.amount.toStringAsFixed(0) + ' ₸',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tx.amount > 0 ? Colors.green : Colors.red,
              ),
            ),
            onTap: () {}, // TODO: добавить переход к деталям транзакции
          )).toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SectionListView(items: items),
          );
        },
      ),
    );
  }
}