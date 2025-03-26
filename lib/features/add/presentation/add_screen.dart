import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/add/presentation/sum_viewer_widget.dart';
import 'package:flutter_app_1/features/add/presentation/transaction_type_selector_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import 'additional_fields_widget.dart';
import 'category_picker_widget.dart';
import 'numeric_keypad_widget.dart';

enum TransactionType { expense, income, transfer}

Map<TransactionType, Color> skyColors = <TransactionType, Color>{
  TransactionType.expense: const Color(0xff191970),
  TransactionType.income: const Color(0xff40826d),
  TransactionType.transfer: const Color(0xff007ba7),
};

class AddScreen extends ConsumerWidget {
  AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TransactionType selectedSegment = ref.watch(transactionTypeProvider);

    return Scaffold(
      body: Column(
        children: [
          TransactionTypeSelectorWidget(
            selectedSegment: selectedSegment,
            onValueChanged: (TransactionType value) {
              ref.read(transactionTypeProvider.notifier).state = value;
            },
          ),
          CategoryPickerWidget(),
          AdditionalFieldsWidget(),
          SumViewerWidget(),
          NumericKeypadWidget(onKeyPressed: (value) {
            print('Нажата клавиша: $value');
          }),
        ],
      ),
    );
  }
}