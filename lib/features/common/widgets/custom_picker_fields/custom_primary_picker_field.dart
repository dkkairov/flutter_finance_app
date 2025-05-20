import 'package:flutter/material.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';

class CustomPrimaryPickerField extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String currentValueDisplay;
  final VoidCallback onTap;
  final double? width;

  const CustomPrimaryPickerField({super.key,
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
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignment: Alignment.centerLeft,
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
