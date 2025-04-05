import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

import '../providers/amount_input_provider.dart';

class SumViewWidget extends ConsumerWidget {
  const SumViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raw = ref.watch(amountInputProvider);
    final amount = _formatCurrency(raw);

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: SizedBox(),),
          Expanded(flex: 2, child: Center(child: Text(amount, style: AppTextStyles.normalLarge))),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                final current = ref.read(amountInputProvider);
                if (current.isNotEmpty) {
                  ref.read(amountInputProvider.notifier).state = current.substring(0, current.length - 1);
                }
              },
              icon: const Icon(Icons.backspace),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(String input) {
    if (input.isEmpty) return '0 ₸';

    // Заменяем запятую на точку для double
    final clean = input.replaceAll(',', '.');
    // Если ввели только "0," — делаем "0.00"
    final value = double.tryParse(clean) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₸',
      decimalDigits: input.contains(',') ? 2 : 0,
    );
    return formatter.format(value);
  }

}
