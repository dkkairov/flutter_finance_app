// lib/features/accounts/presentation/widgets/create_account_bottom_sheet.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../data/repositories/account_repository.dart';
import '../providers/accounts_provider.dart';
import '../../../currencies/data/models/currency_model.dart';
import '../../../currencies/presentation/providers/currency_providers.dart';

class AccountCreateBottomSheet extends ConsumerStatefulWidget {
  const AccountCreateBottomSheet({super.key});

  @override
  ConsumerState<AccountCreateBottomSheet> createState() => _AccountCreateBottomSheetState();
}

class _AccountCreateBottomSheetState extends ConsumerState<AccountCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String? _selectedCurrencyId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final accountRepo = ref.read(accountRepositoryProvider);
        await accountRepo.createAccount(
          name: _nameController.text.trim(),
          balance: double.parse(_balanceController.text.replaceAll(',', '.')),
          currencyId: _selectedCurrencyId!,
        );

        ref.invalidate(accountsProvider);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.account_created_successfully.tr())),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${LocaleKeys.error_creating_account.tr()}: $e')),
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
    final currenciesAsyncValue = ref.watch(currenciesProvider);

    return Container( // <--- ДОБАВЛЕНО: ОБЕРТЫВАЕМ В CONTAINER
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Используем цвет фона карты темы
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), // Скругленные углы сверху
      ),
      padding: EdgeInsets.only(
        // Оставим padding здесь, чтобы контент не прилипал к краям контейнера
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.create_new_account.tr(), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: _nameController,
              labelText: LocaleKeys.account_name.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.account_name_required.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: _balanceController,
              labelText: LocaleKeys.initial_balance.tr(),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.initial_balance_required.tr();
                }
                if (double.tryParse(value.replaceAll(',', '.')) == null) {
                  return LocaleKeys.invalid_number_format.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            currenciesAsyncValue.when(
              data: (currencies) {
                if (currencies.isEmpty) {
                  return Text(LocaleKeys.no_currencies_available.tr());
                }
                if (_selectedCurrencyId == null && currencies.isNotEmpty) {
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
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('${LocaleKeys.error_loading_currencies.tr()}: $err'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _createAccount,
              child: Text(LocaleKeys.create_account_button.tr()),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}