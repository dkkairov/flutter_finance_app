// lib/features/reports/presentation/category_transaction_list_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../common/theme/custom_colors.dart';
import '../../common/theme/custom_text_styles.dart';
import '../../common/widgets/custom_divider.dart';
import '../../transactions/presentation/widgets/transaction_list_widget.dart';
import '../domain/models/category_transactions_list_params.dart';
import '../presentation/providers/report_providers.dart'; // Оставьте этот импорт


// Экран списка транзакций по категории
class CategoryTransactionListScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;
  final String transactionType;
  final DateTime startDate;
  final DateTime endDate;
  final String? accountId;

  const CategoryTransactionListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    this.accountId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = CategoryTransactionsListParams(
      categoryId: categoryId,
      transactionType: transactionType,
      startDate: startDate,
      endDate: endDate,
      accountId: accountId,
    );

    // Watch провайдер для получения списка транзакций по категории
    // ИЗМЕНЕНО: Ожидаем List<TransactionModel>
    // ИЗМЕНЕНИЕ ЗДЕСЬ: УБЕРИТЕ 'ReportProviders.'
    final transactionsAsyncValue = ref.watch(categoryTransactionsListProvider(params)); // <--- ВОТ ЭТО ИЗМЕНЕНИЕ

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
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
                Text(
                  '20 april (-5 000 ${LocaleKeys.tenge_short.tr()})', // TODO: Рассчитывать эту строку динамически из итогов за день
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
                    child: Text(LocaleKeys.no_transactions_in_category.tr()),
                  );
                }
                // ИЗМЕНЕНО: Передаем List<TransactionModel> в TransactionListWidget
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