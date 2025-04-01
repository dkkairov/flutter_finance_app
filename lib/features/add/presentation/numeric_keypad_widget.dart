import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';

class NumericKeypadWidget extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const NumericKeypadWidget({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    List<String> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      ',', '0', 'comment_icon'
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
        return keys[index] == 'comment_icon'
            ? ElevatedButton.icon(
              onPressed: () => onKeyPressed(keys[index]),
              icon: Icon(CupertinoIcons.ellipses_bubble),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ), label: Text(''),
            )
            : ElevatedButton(
            onPressed: () => onKeyPressed(keys[index]),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
                keys[index],
                style: AppTextStyles.normalLarge
            ),
        );
      },
    );
  }
}