import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/section_list_view.dart';
import '../providers/transaction_dependencies.dart';
import '../providers/transaction_provider.dart';

class TransactionsListWidget extends ConsumerStatefulWidget {
  const TransactionsListWidget({super.key});

  @override
  ConsumerState<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}

class _TransactionsListWidgetState extends ConsumerState<TransactionsListWidget> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final remote = ref.read(transactionRemoteDataSourceProvider);
      try {
        final result = await remote.fetchTransactions();
        debugPrint('✅ Получено ${result.length} транзакций:');
        for (var tx in result) {
          debugPrint('- ${tx.description ?? 'Без описания'}: ${tx.amount} ₸');
        }
      } catch (e, st) {
        debugPrint('❌ Ошибка при получении транзакций: $e\n$st');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionStreamProvider);
    final repository = ref.read(transactionRepositoryProvider);

    return transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Ошибка: $error')),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(child: Text('Нет транзакций'));
        }

        final items = transactions.map((tx) {
          return SectionListItemModel(
            title: tx.type,
            subtitle: tx.date.toString(),
            trailing: Text(
              (tx.amount > 0 ? '+' : '') + tx.amount.toStringAsFixed(0) + ' ₸',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tx.amount > 0 ? Colors.green : Colors.red,
              ),
            ),
            onTap: () {},
          );
        }).toList();

        return RefreshIndicator(
          onRefresh: () => repository.fetch(),
          child: SectionListView(items: items),
        );
      },
    );
  }
}
