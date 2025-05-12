import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/locale_keys.g.dart';
import '../data/transaction_category_provider.dart';

class TransactionCategoriesScreen extends ConsumerWidget {
  const TransactionCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCategories = ref.watch(transactionCategoriesProvider);
    final categoriesNotifier = ref.read(transactionCategoriesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.categories.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await categoriesNotifier.fetchTransactionCategories();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactionCategories.length,
        itemBuilder: (context, index) {
          final category = transactionCategories[index];
          return ListTile(
            title: Text(category),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await categoriesNotifier.deleteTransactionCategory(category);
              },
            ),
          );
        },
      ),
    );
  }
}