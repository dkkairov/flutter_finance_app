import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Colors.grey[300],
        foregroundColor: isPrimary ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
