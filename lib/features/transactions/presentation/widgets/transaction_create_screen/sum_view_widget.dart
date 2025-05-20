import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../providers/transaction_controller.dart';

// final selectedCurrencyProvider = StateProvider((ref) => '₸ Тенге (KZT)');
final selectedCurrencySymbol = '₸';
// TODO: добавить автоматический выбор валюты в зависимости от счета. При этом валюта для наличных, например "Наличные USD", должна быть автоматически создана на основе настроек. Для этого нужно будет создать отдельный провайдер, который будет возвращать валюту в зависимости от выбранного счета. Также нужно будет добавить логику в контроллер транзакций, чтобы он мог обрабатывать разные валюты.

class SumViewWidget extends ConsumerWidget {
  const SumViewWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionCreateControllerProvider);
    final raw = ref.read(transactionCreateControllerProvider.notifier).rawAmount;
    final formatted = _formatCurrency(context, raw);
    // final selectedCurrency = ref.watch(selectedCurrencyProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(formatted, style: CustomTextStyles.normalLarge),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              ref.read(transactionCreateControllerProvider.notifier).deleteLastDigit();
            },
            icon: const Icon(Icons.backspace),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(BuildContext context, String raw) {
    if (raw.isEmpty) return '0 $selectedCurrencySymbol';
    final clean = raw.replaceAll(',', '.');
    final value = double.tryParse(clean) ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: context.locale.languageCode == 'ru' ? 'ru_RU' : 'en_US',
      symbol: selectedCurrencySymbol,
      decimalDigits: raw.contains(',') ? 2 : 0,
    );
    return formatter.format(value);
  }
}