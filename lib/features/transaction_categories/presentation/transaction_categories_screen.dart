import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/transaction_category_provider.dart';

class TransactionCategoriesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCategories = ref.watch(transactionCategoriesProvider);
    final categoriesNotifier = ref.read(transactionCategoriesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
              icon: Icon(Icons.delete),
              onPressed: () async {
                await categoriesNotifier.deleteTransactionCategory(category);
              },
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/main-category');
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
