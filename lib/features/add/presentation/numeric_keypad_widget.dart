import 'package:flutter/material.dart';

class NumericKeypadWidget extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const NumericKeypadWidget({super.key, required this.onKeyPressed});

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
        childAspectRatio: 2.5, // Отношение сторон кнопок
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () => onKeyPressed(keys[index]),
          child: Text(
              keys[index],
              style: const TextStyle(
                fontSize: 24,
              )
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      },
    );
  }
}