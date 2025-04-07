import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transactions/domain/models/transaction_entity.dart';
import 'package:flutter_app_1/features/transactions/data/repositories/transaction_repository.dart';

final transactionControllerProvider =
StateNotifierProvider<TransactionController, TransactionEntity>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return TransactionController(repository: repository);
});

class TransactionController extends StateNotifier<TransactionEntity> {
  final TransactionRepository repository;
  String rawAmount = '';

  TransactionController({required this.repository})
      : super(TransactionEntity(
    id: null,
    userId: 1,
    transactionType: 'expense',
    transactionCategoryId: null,
    amount: 0,
    accountId: 1,
    projectId: 1,
    description: null,
    date: DateTime.now(),
    isActive: true,
  ));

  void updateRawAmount(String value) {
    rawAmount = value;

    final parsed = double.tryParse(value.replaceAll(',', '.')) ?? 0;
    state = state.copyWith(amount: parsed);
  }

  void deleteLastDigit() {
    if (rawAmount.isNotEmpty) {
      updateRawAmount(rawAmount.substring(0, rawAmount.length - 1));
    }
  }

  void updateCategory(int categoryId) {
    state = state.copyWith(transactionCategoryId: categoryId);
    if (state.amount > 0) {
      _createTransaction();
    } else {
      debugPrint('⛔ Укажите сумму перед выбором категории');
    }
  }

  void _createTransaction() async {
    await repository.create(state);
    reset();
  }

  void reset() {
    rawAmount = '';
    state = TransactionEntity(
      id: null,
      serverId: null,
      userId: 1,
      transactionType: 'expense',
      transactionCategoryId: null,
      amount: 0,
      accountId: 1,
      projectId: 1,
      description: null,
      date: DateTime.now(),
      isActive: true,
    );
  }

  void updateDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }
}
