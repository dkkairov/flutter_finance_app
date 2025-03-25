import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

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
          TransactionTypeSelector(
            selectedSegment: selectedSegment,
            onValueChanged: (TransactionType value) {
              ref.read(transactionTypeProvider.notifier).state = value;
            },
          ),
          SumSection(),
          NumericKeypad(onKeyPressed: (value) {
            print('Нажата клавиша: $value');
          }),
        ],
      ),
    );
  }
}

class SumSection extends StatelessWidget {
  const SumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '800 000',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: skyColors[TransactionType.expense]
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.backspace)
        )
      ],
    );
  }
}


class TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedSegment;
  final ValueChanged<TransactionType> onValueChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedSegment,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: CupertinoSlidingSegmentedControl<TransactionType>(
        backgroundColor: CupertinoColors.systemGrey2,
        thumbColor: skyColors[selectedSegment]!,
        groupValue: selectedSegment,
        onValueChanged: (TransactionType? value) {
          if (value != null) {
            onValueChanged(value);
          }
        },
        children: const <TransactionType, Widget>{
          TransactionType.expense: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Midnight', style: TextStyle(color: CupertinoColors.white)),
          ),
          TransactionType.income: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Viridian', style: TextStyle(color: CupertinoColors.white)),
          ),
          TransactionType.transfer: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Cerulean', style: TextStyle(color: CupertinoColors.white)),
          ),
        },
      ),
    );
  }
}

class NumericKeypad extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const NumericKeypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    List<String> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '←', '0', '✓'
    ];

    return GridView.builder(
      shrinkWrap: true, // Ограничивает высоту по содержимому
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 колонки
        childAspectRatio: 1.5, // Отношение сторон кнопок
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => onKeyPressed(keys[index]),
            child: Text(keys[index], style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}
