// lib/features/transaction_categories/presentation/screens/edit_category_screen.dart

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../../common/widgets/custom_show_modal_bottom_sheet.dart'; // Still needed for icon picker
import '../../../common/widgets/custom_picker_fields/picker_item.dart'; // Still needed for icon picker
import '../../data/models/transaction_category_model.dart'; // <--- Импортируем модель категории
import '../../data/models/transaction_category_payload.dart';
import '../../data/repositories/transaction_category_repository.dart';
import '../providers/transaction_category_provider.dart';

class EditCategoryScreen extends ConsumerStatefulWidget {
  final String type; // 'expense' или 'income'
  final TransactionCategoryModel? initialCategory; // Если передается, значит редактируем

  const EditCategoryScreen({
    super.key,
    required this.type,
    this.initialCategory,
  });

  @override
  ConsumerState<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends ConsumerState<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedIconName;

  bool get isEditing => widget.initialCategory != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.initialCategory!.name;
      _selectedIconName = widget.initialCategory!.icon;
    } else {
      // Для нового элемента выбираем первую иконку по умолчанию
      _selectedIconName = kCupertinoIconMap.keys.isNotEmpty ? kCupertinoIconMap.keys.first : null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectIcon() async {
    final List<PickerItem<String>> iconItems = kCupertinoIconMap.keys.map((iconName) {
      return PickerItem<String>(
        value: iconName,
        displayValue: iconName,
        imageUrl: null,
        iconData: iconFromString(iconName),
      );
    }).toList();

    final PickerItem<String>? selected = await customShowModalBottomSheet<String>(
      context: context,
      title: LocaleKeys.selectIcon.tr(),
      type: 'icon',
      items: iconItems,
    );

    if (selected != null) {
      setState(() {
        _selectedIconName = selected.value;
      });
    }
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate() && _selectedIconName != null) {
      final name = _nameController.text.trim();
      final teamId = ref.read(selectedTeamIdProvider);

      if (teamId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.noTeamSelectedError.tr())),
        );
        return;
      }

      final payload = TransactionCategoryPayload(
        name: name,
        teamId: teamId,
        icon: _selectedIconName,
        type: widget.type,
      );

      try {
        final repository = ref.read(transactionCategoryRepositoryProvider);

        if (isEditing) {
          // Логика обновления категории
          await repository.updateTransactionCategory(
            categoryId: widget.initialCategory!.id,
            teamId: teamId,
            payload: payload,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.categoryUpdatedSuccessfully.tr())),
            );
          }
        } else {
          // Логика создания категории
          await repository.createTransactionCategory(payload: payload, teamId: teamId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.categoryCreatedSuccessfully.tr())),
            );
          }
        }

        ref.invalidate(transactionCategoriesProvider(widget.type)); // Обновляем список

        if (mounted) {
          Navigator.of(context).pop(); // Закрываем экран после сохранения
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = isEditing
              ? '${LocaleKeys.failedToUpdateCategory.tr()}: ${e.toString()}'
              : '${LocaleKeys.failedToCreateCategory.tr()}: ${e.toString()}';
          if (e is DioException) {
            if (e.response != null && e.response!.data != null) {
              errorMessage = '${LocaleKeys.failedToCreateCategory.tr()}: ${e.response!.data.toString()}';
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } else if (_selectedIconName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.pleaseSelectAnIcon.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? LocaleKeys.editCategory.tr()
              : (widget.type == 'expense'
              ? LocaleKeys.addExpenseCategory.tr()
              : LocaleKeys.addIncomeCategory.tr()),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.categoryName.tr(),
                controller: _nameController,
                validator: (value) =>
                value?.trim().isEmpty == true ? LocaleKeys.categoryNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: _selectedIconName != null
                    ? Icon(iconFromString(_selectedIconName!), size: 36)
                    : const Icon(Icons.category, size: 36),
                title: Text(LocaleKeys.selectIcon.tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _selectIcon,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: isEditing ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                onPressed: _saveCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}