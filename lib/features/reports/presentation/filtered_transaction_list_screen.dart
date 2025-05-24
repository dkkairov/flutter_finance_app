// lib/features/reports/presentation/filtered_transaction_list_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../common/theme/custom_colors.dart';
import '../../common/theme/custom_text_styles.dart';
import '../../common/widgets/custom_divider.dart';
import '../../transactions/presentation/widgets/transaction_list_widget.dart';
import '../domain/models/filtered_transactions_list_params.dart';
import '../presentation/providers/report_providers.dart'; // Обновленный импорт

// Экран списка транзакций по категории или проекту (универсальный)
class FilteredTransactionListScreen extends ConsumerWidget {
  final String? categoryId;
  final String? projectId;
  final String title;
  final String transactionType;
  final DateTime startDate;
  final DateTime endDate;
  final String? accountId;

  const FilteredTransactionListScreen({
    super.key,
    this.categoryId,
    this.projectId,
    required this.title,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    this.accountId,
  }) : assert(categoryId != null || projectId != null, 'Either categoryId or projectId must be provided for filtering.');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = CategoryTransactionsListParams(
      categoryId: categoryId,
      projectId: projectId,
      transactionType: transactionType,
      startDate: startDate,
      endDate: endDate,
      accountId: accountId,
    );

    // Watch провайдер для получения списка транзакций
    // ИСПРАВЛЕНО: используем правильное имя провайдера - filteredTransactionsListProvider
    final transactionsAsyncValue = ref.watch(filteredTransactionsListProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: CustomTextStyles.normalMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: CustomColors.onPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                transactionsAsyncValue.when(
                  data: (transactions) {
                    final totalAmount = transactions.fold(0.0, (sum, tr) => sum + tr.amount.abs());
                    return Text(
                      '${LocaleKeys.total.tr()}: ${totalAmount.toStringAsFixed(0)} ${LocaleKeys.tenge_short.tr()}',
                      style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold),
                    );
                  },
                  loading: () => Text('${LocaleKeys.total.tr()}: Loading...'),
                  error: (err, stack) => Text('${LocaleKeys.total.tr()}: Error'),
                ),
                const SizedBox(height: 4),
                // TODO: Рассчитывать эту строку динамически из итогов за день (если нужно)
                Text(
                  '20 april (-5 000 ${LocaleKeys.tenge_short.tr()})',
                  style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
                ),
              ],
            ),
          ),
          const CustomDivider(),

          Expanded(
            child: transactionsAsyncValue.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(LocaleKeys.no_transactions_in_category.tr()), // TODO: Можно сделать универсальнее "Нет транзакций"
                  );
                }
                return TransactionListWidget(transactions: transactions);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('${LocaleKeys.error_loading_transactions.tr()}: $err')),
            ),
          ),
        ],
      ),
    );
  }
}