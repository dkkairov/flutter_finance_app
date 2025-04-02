import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/categories/data/category_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final categoriesNotifier = ref.read(categoriesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await categoriesNotifier.fetchCategories();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await categoriesNotifier.deleteCategory(category);
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
