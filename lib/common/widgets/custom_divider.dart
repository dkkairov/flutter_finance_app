import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/custom_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: CustomColors.mainLightGrey,
      thickness: 1,
      height: 3,
    );
  }
}
