import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../common/widgets/custom_text_form_field.dart'; // Import LocaleKeys

// --- Riverpod Providers (Stubs) ---
final expenseCategoriesProvider = Provider((ref) => ExpenseCategoriesNotifier());
final incomeCategoriesProvider = Provider((ref) => IncomeCategoriesNotifier());

class ExpenseCategoriesNotifier {
  final List<String> _categories = ['Category 1', 'Category 2', 'Category 3', 'Category 4', 'Category 5']; // Заглушка данных

  List<String> get categories => _categories;

  void addCategory(String newCategory) {
    _categories.add(newCategory);
    print('Added new expense category: $newCategory');
  }

  void editCategory(String oldCategory, String newCategory) {
    final index = _categories.indexOf(oldCategory);
    if (index != -1) {
      _categories[index] = newCategory;
      print('Edited expense category from $oldCategory to $newCategory');
    }
  }
}

class IncomeCategoriesNotifier {
  final List<String> _categories = ['Category 1', 'Category 2', 'Category 3', 'Category 4']; // Заглушка данных

  List<String> get categories => _categories;

  void addCategory(String newCategory) {
    _categories.add(newCategory);
    print('Added new income category: $newCategory');
  }

  void editCategory(String oldCategory, String newCategory) {
    final index = _categories.indexOf(oldCategory);
    if (index != -1) {
      _categories[index] = newCategory;
      print('Edited income category from $oldCategory to $newCategory');
    }
  }
}

// --- BottomSheet Widget ---
class _CategoryBottomSheet extends StatefulWidget {
  final String type;
  final String? initialCategoryName;

  const _CategoryBottomSheet({required this.type, this.initialCategoryName});

  @override
  State<_CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<_CategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryName != null) {
      _categoryNameController.text = widget.initialCategoryName!;
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _submit(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final categoryName = _categoryNameController.text.trim();
      if (categoryName.isNotEmpty) {
        if (widget.initialCategoryName == null) {
          // Добавление новой категории
          if (widget.type == 'expense') {
            ref.read(expenseCategoriesProvider).addCategory(categoryName);
          } else if (widget.type == 'income') {
            ref.read(incomeCategoriesProvider).addCategory(categoryName);
          }
          Navigator.pop(context);
        } else {
          // Редактирование существующей категории
          if (widget.type == 'expense') {
            ref.read(expenseCategoriesProvider).editCategory(widget.initialCategoryName!, categoryName);
          } else if (widget.type == 'income') {
            ref.read(incomeCategoriesProvider).editCategory(widget.initialCategoryName!, categoryName);
          }
          Navigator.pop(context);
        }
      }
    }
  }

  String? _validateCategoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.categoryNameCannotBeEmpty.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialCategoryName == null
                  ? '${LocaleKeys.addNew.tr()} ${widget.type == 'expense' ? LocaleKeys.expense.tr() : LocaleKeys.income.tr()} ${LocaleKeys.category.tr()}'
                  : '${LocaleKeys.edit.tr()} ${widget.type == 'expense' ? LocaleKeys.expense.tr() : LocaleKeys.income.tr()} ${LocaleKeys.category.tr()}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              labelText: LocaleKeys.categoryName.tr(),
              controller: _categoryNameController,
              validator: _validateCategoryName,
            ),
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, _) => CustomPrimaryButton(
                text: widget.initialCategoryName == null ? LocaleKeys.addCategory.tr() : LocaleKeys.saveChanges.tr(),
                onPressed: () => _submit(ref),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
          ],
        ),
      ),
    );
  }
}

// --- UI Screen ---
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen(this.type, {super.key});

  final String type;

  void _showCategoryBottomSheet(BuildContext context, WidgetRef ref, {String? initialCategoryName}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take up more height
      builder: (BuildContext context) {
        return _CategoryBottomSheet(type: type, initialCategoryName: initialCategoryName);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseCategoriesNotifier = ref.watch(expenseCategoriesProvider);
    final incomeCategoriesNotifier = ref.watch(incomeCategoriesProvider);

    final List<String> categories = switch (type) {
      'expense' => expenseCategoriesNotifier.categories,
      'income' => incomeCategoriesNotifier.categories,
      _ => [], // Обработка неизвестного типа (опционально)
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('${type == 'expense' ? LocaleKeys.expenseCategories.tr() : LocaleKeys.incomeCategories.tr()}'),
      ),
      body: CustomListViewSeparated(
        items: categories,
        itemBuilder: (context, item) => CustomListItem(
          titleText: item.tr(), // Ensure the category names are also translatable if needed
          onTap: () => _showCategoryBottomSheet(context, ref, initialCategoryName: item), // Для редактирования
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _showCategoryBottomSheet(context, ref), // Для добавления
      ),
    );
  }
}