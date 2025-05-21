import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../features/common/theme/custom_colors.dart';
import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../../accounts/domain/models/account.dart'; // <--- УБЕДИТЬСЯ, ЧТО ЭТО ПРАВИЛЬНЫЙ ИМПОРТ Account
import '../../../../../generated/locale_keys.g.dart';
import '../../providers/transaction_controller.dart';


class TransferAccountsSelectorWidget extends ConsumerWidget {
  final List<Account> accounts; // Теперь это реальные счета

  const TransferAccountsSelectorWidget({
    super.key,
    required this.accounts,
  });

  Widget _buildAccountField({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required String? currentAccountId, // <--- ИЗМЕНЕНО НА String?
    required List<Account> availableAccounts,
    required Function(String) onAccountSelected, // <--- ИЗМЕНЕНО НА String
  }) {
    // Ищем текущее название счета по ID
    final String currentAccountName =
        availableAccounts.firstWhere(
              (account) => account.id == currentAccountId,
          orElse: () => Account(id: '', name: LocaleKeys.selectAccount.tr()), // <--- ID теперь пустая строка для заглушки
        ).name;

    return InkWell(
      onTap: () async {
        final List<PickerItem<String>> pickerItems = availableAccounts // <--- PickerItem теперь с String ID
            .map((account) => PickerItem<String>(id: account.id, displayValue: account.name))
            .toList();

        final selected = await customShowModalBottomSheet<String>( // <--- customShowModalBottomSheet теперь с String ID
          context: context,
          title: label,
          items: pickerItems,
          type: 'line',
        );

        if (selected != null) {
          onAccountSelected(selected.id); // Вызываем переданный колбэк с ID выбранного счета (String)
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CustomColors.mainLightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
            ),
            const SizedBox(height: 2),
            Text(
              currentAccountName,
              style: CustomTextStyles.normalMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionCreateControllerProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);

    // Получаем выбранные счета для "откуда" и "куда" из состояния контроллера
    final String? fromAccountId = transactionState.fromAccountId; // <--- ТИП String?
    final String? toAccountId = transactionState.toAccountId;     // <--- ТИП String?

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          _buildAccountField(
            context: context,
            ref: ref,
            label: LocaleKeys.fromAccount.tr(),
            currentAccountId: fromAccountId,
            availableAccounts: accounts,
            onAccountSelected: (accountId) {
              transactionCreateController.updateFromAccount(accountId); // <--- ID теперь String
            },
          ),
          const SizedBox(height: 16),
          const Icon(Icons.arrow_downward),
          const SizedBox(height: 16),
          _buildAccountField(
            context: context,
            ref: ref,
            label: LocaleKeys.toAccount.tr(),
            currentAccountId: toAccountId,
            availableAccounts: accounts,
            onAccountSelected: (accountId) {
              transactionCreateController.updateToAccount(accountId); // <--- ID теперь String
            },
          ),
          const SizedBox(height: 100),
          // TODO: В БУДУЩЕМ - добавить валидацию, чтобы счета From и To не совпадали
        ],
      ),
    );
  }
}