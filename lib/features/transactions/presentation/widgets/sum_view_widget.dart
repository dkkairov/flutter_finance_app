import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_controller.dart';

class SumViewWidget extends ConsumerWidget {
  const SumViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionControllerProvider);
    final raw = ref.read(transactionControllerProvider.notifier).rawAmount;
    final formatted = _formatCurrency(raw);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(formatted, style: AppTextStyles.normalLarge),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              ref.read(transactionControllerProvider.notifier).deleteLastDigit();
            },
            icon: const Icon(Icons.backspace),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(String raw) {
    if (raw.isEmpty) return '0 ₸';
    final clean = raw.replaceAll(',', '.');
    final value = double.tryParse(clean) ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₸',
      decimalDigits: raw.contains(',') ? 2 : 0,
    );
    return formatter.format(value);
  }
}
