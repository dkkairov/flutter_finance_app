import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/section_list_view.dart';
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
      try {
        final result = await ref.read(transactionFetchProvider);
        debugPrint('✅ Загружено ${result.length} транзакций и сохранено в базу.');
      } catch (e, st) {
        debugPrint('❌ Ошибка при загрузке и сохранении транзакций: $e\n$st');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(transactionRepositoryProvider);
    final transactionsAsync = ref.watch(transactionStreamProvider);

    return transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Ошибка: $error')),
      data: (transactions) {
        debugPrint('📦 Из локальной базы: ${transactions.length} транзакций');

        if (transactions.isEmpty) {
          return const Center(child: Text('Нет транзакций'));
        }

        final items = transactions.map((tx) {
          return SectionListItemModel(
            title: tx.transactionType,
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
