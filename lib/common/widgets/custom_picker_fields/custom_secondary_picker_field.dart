import 'package:flutter/material.dart';
import '../../../core/theme/custom_colors.dart';
import '../../../core/theme/custom_text_styles.dart';

class CustomSecondaryPickerField extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String currentValueDisplay;
  final VoidCallback onTap;
  final double? width;

  const CustomSecondaryPickerField({super.key,
    required this.currentValueDisplay,
    required this.onTap,
    this.width,
    required this.context,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CustomColors.mainLightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child:
        Text(
          currentValueDisplay,
          style: CustomTextStyles.normalMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
