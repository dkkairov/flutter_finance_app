import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.mainLightGrey,
      thickness: 1,
      height: 2,
    );
  }
}
