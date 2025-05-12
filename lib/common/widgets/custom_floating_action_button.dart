import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/custom_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.primary,
      foregroundColor: CustomColors.onPrimary,
      shape: const CircleBorder(),
      elevation: 4.0,
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}