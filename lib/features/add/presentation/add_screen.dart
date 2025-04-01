import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';
import 'package:flutter_app_1/features/add/presentation/sum_viewer_widget.dart';
import 'package:flutter_app_1/features/add/presentation/transaction_type_selector_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import 'additional_fields_widget.dart';
import 'category_picker_widget.dart';
import 'numeric_keypad_widget.dart';

enum TransactionType { expense, income, transfer}

class AddScreen extends ConsumerWidget {
  const AddScreen({super.key});

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