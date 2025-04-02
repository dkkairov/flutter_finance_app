import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';

class SumViewWidget extends StatelessWidget {
  const SumViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '800 000',
            style: AppTextStyles.normalLarge,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.backspace)
          )
        ],
      ),
    );
  }
}