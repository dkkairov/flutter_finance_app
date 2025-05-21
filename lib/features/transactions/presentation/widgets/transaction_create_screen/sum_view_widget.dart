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

    // Заменяем запятую на точку для корректного парсинга в double
    final clean = raw.replaceAll(',', '.');
    final value = double.tryParse(clean) ?? 0.0;

    // Используем NumberFormat.simpleCurrency для получения символа,
    // или NumberFormat.currency с символом, если мы его хотим жестко задать.
    // Если нам нужен только пробел, то лучше использовать NumberFormat без symbol
    // и добавить его вручную.

    final formatter = NumberFormat(
      // Используем шаблон без символа валюты.
      // #,##0.00 будет использовать локальный разделитель тысяч (запятую для en_US)
      // # ##0.00 - это не сработает напрямую для `NumberFormat`
      // `decimalDigits` будет 0, если нет запятой, 2, если есть (для копеек/центов)
      // Для целых чисел без дробной части: #,##0
      // Для чисел с дробной частью: #,##0.00
      raw.contains(',') ? '#,##0.00' : '#,##0',
      context.locale.languageCode == 'ru' ? 'ru_RU' : 'en_US', // Используем русскую локаль для запятой как десятичного разделителя
    );

    String formattedValue = formatter.format(value);

    // Теперь заменяем разделитель тысяч (который будет запятой, если локаль en_US, или пробелом/неразрывным пробелом для ru_RU)
    // Если локаль 'ru_RU' используется, то NumberFormat уже может использовать неразрывный пробел (NBSP)
    // Давайте явно заменим все нечисловые разделители, кроме точки (если она есть) или запятой
    // (если это десятичный разделитель) на обычный пробел.

    // Попробуем просто заменить "," на " " в форматированной строке,
    // так как для ru_RU разделитель тысяч может быть неразрывным пробелом,
    // а для en_US это всегда ","
    formattedValue = formattedValue.replaceAll(',', ' '); // Заменяем "," на пробел

    // В случае ru_RU, NumberFormat использует неразрывный пробел (NBSP).
    // Мы можем захотеть заменить его на обычный пробел, если он нам не нужен.
    // Если формат ru_RU уже дает пробел, то эта замена не нужна.
    // Но чтобы быть уверенным, что везде будет обычный пробел:
    formattedValue = formattedValue.replaceAll('\u00A0', ' '); // Заменяем неразрывный пробел на обычный

    return '$formattedValue $selectedCurrencySymbol';
  }
}