import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_draggable_scrollable_sheet.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../domain/models/account.dart';
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys

// Импорты для Riverpod, репозитория и провайдера счетов
import '../../data/repositories/account_repository.dart';
import '../providers/accounts_provider.dart';
import '../../../currencies/data/models/currency_model.dart'; // Если у вас есть модель валюты
import '../../../currencies/presentation/providers/currency_providers.dart'; // Если у вас есть провайдер валют

/// A DraggableScrollableSheet for editing account details.
///
/// Requires the Account object to edit.
class EditAccountBottomSheet extends ConsumerStatefulWidget { // <--- ИЗМЕНЕНО НА ConsumerStatefulWidget
  final Account account; // Счет, который редактируем

  const EditAccountBottomSheet({super.key, required this.account});

  @override
  ConsumerState<EditAccountBottomSheet> createState() => _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends ConsumerState<EditAccountBottomSheet> {
  final _formKey = GlobalKey<FormState>(); // Ключ для валидации формы
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  String? _selectedCurrencyId; // Для выбора валюты
  bool _isLoading = false; // Для индикатора загрузки

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    // Для баланса, если он может быть null, используем 0.00.
    // Важно: если баланс редактируется напрямую (не через транзакции),
    // то это поле должно быть интерактивным.
    _balanceController = TextEditingController(text: widget.account.balance?.toStringAsFixed(2) ?? '0.00');
    _selectedCurrencyId = widget.account.currencyId; // Устанавливаем текущую валюту счета
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  // --- МЕТОД ОБНОВЛЕНИЯ СЧЕТА ---
  Future<void> _updateAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final accountRepo = ref.read(accountRepositoryProvider);
        final newName = _nameController.text.trim();
        final newBalance = double.tryParse(_balanceController.text.replaceAll(',', '.'));
        final newCurrencyId = _selectedCurrencyId;

        // Отправляем только те поля, которые изменились, или все, если бэкенд ожидает
        // Ваш UpdateAccountRequest принимает 'sometimes', так что это хороший подход.
        await accountRepo.updateAccount(
          widget.account.id,
          name: newName,
          balance: newBalance,
          currencyId: newCurrencyId,
        );

        // После успешного обновления, инвалидируем провайдер, чтобы UI обновился
        ref.invalidate(accountsProvider);

        if (mounted) {
          Navigator.pop(context); // Закрываем лист после сохранения
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.account_updated_successfully.tr())),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${LocaleKeys.error_updating_account.tr()}: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- МЕТОД УДАЛЕНИЯ СЧЕТА ---
  Future<void> _deleteAccount() async {
    // Добавляем диалоговое окно подтверждения
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.confirm_delete.tr()),
          content: Text(LocaleKeys.delete_account_confirmation.tr(args: [widget.account.name])),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(LocaleKeys.delete.tr()),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final accountRepo = ref.read(accountRepositoryProvider);
        await accountRepo.deleteAccount(widget.account.id);

        ref.invalidate(accountsProvider); // Обновляем список счетов
        if (mounted) {
          Navigator.pop(context); // Закрываем bottom sheet
          // Дополнительно закрываем AccountScreen, если он был открыт
          Navigator.pop(context); // Это закроет экран деталей счета
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.account_deleted_successfully.tr())),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${LocaleKeys.error_deleting_account.tr()}: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Получаем список валют для Dropdown
    final currenciesAsyncValue = ref.watch(currenciesProvider);

    List<Widget> fields = [
      Form( // Оборачиваем поля в Form для валидации
        key: _formKey,
        child: Column(
          children: [
            // Поле "Name"
            CustomTextFormField(
              controller: _nameController, // <--- ИСПОЛЬЗУЕМ КОНТРОЛЛЕР
              labelText: LocaleKeys.name.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.account_name_required.tr(); // Используем более точный ключ
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Поле "Currency"
            currenciesAsyncValue.when(
              data: (currencies) {
                if (currencies.isEmpty) {
                  return Text(LocaleKeys.no_currencies_available.tr());
                }
                // Если _selectedCurrencyId еще не установлен, но есть валюты,
                // и при редактировании счету не была назначена валюта (редкий кейс, но на всякий случай)
                if (_selectedCurrencyId == null && currencies.isNotEmpty) {
                  // Попытка найти валюту по умолчанию или выбрать первую
                  _selectedCurrencyId = currencies.first.id;
                }
                return DropdownButtonFormField<String>(
                  value: _selectedCurrencyId,
                  decoration: InputDecoration(labelText: LocaleKeys.currency.tr()),
                  items: currencies.map<DropdownMenuItem<String>>((CurrencyModel currency) {
                    return DropdownMenuItem<String>(
                      value: currency.id,
                      child: Text('${currency.name} (${currency.symbol})'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrencyId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return LocaleKeys.currency_required.tr();
                    }
                    return null;
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()), // Индикатор загрузки для валют
              error: (err, stack) => Text('${LocaleKeys.error_loading_currencies.tr()}: $err'),
            ),
            const SizedBox(height: 16),

            // Поле "Balance"
            CustomTextFormField(
              controller: _balanceController, // <--- ИСПОЛЬЗУЕМ КОНТРОЛЛЕР
              labelText: LocaleKeys.balance.tr(), // Лучше использовать 'current_balance' или 'initial_balance'
              keyboardType: TextInputType.number, // Для числового ввода
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.balance_required.tr();
                }
                if (double.tryParse(value.replaceAll(',', '.')) == null) {
                  return LocaleKeys.invalid_number_format.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Кнопки Save и Delete
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          CustomPrimaryButton(
            onPressed: _updateAccount, // Вызываем метод обновления
            text: LocaleKeys.save_changes.tr(), // Используем более точный текст
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _deleteAccount, // Вызываем метод удаления
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(LocaleKeys.delete_account.tr()),
          ),
        ],
      ),
    ];

    return CustomDraggableScrollableSheet(
      fields: fields,
      title: LocaleKeys.edit_account.tr(), // Изменено на edit_account
    );
  }
}

// Вспомогательная функция для удобного показа bottom sheet'а редактирования счета
void showEditAccountBottomSheet(BuildContext context, Account account) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditAccountBottomSheet(account: account),
  );
}