import 'package:flutter/material.dart';
import 'add_screen.dart';

class SumViewerWidget extends StatelessWidget {
  const SumViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
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
      ),
    );
  }
}