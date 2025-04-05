import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';


class AdditionalFieldsWidget extends StatefulWidget {
  @override
  _AdditionalFieldsWidgetState createState() => _AdditionalFieldsWidgetState();
}

class _AdditionalFieldsWidgetState extends State<AdditionalFieldsWidget> {
  final List<String> fields = ['Account', 'Project', 'Date']; // Можно дополнять новыми полями

  final Map<String, String?> selectedValues = {};

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      selectedValues[field] = null; // Изначально пустые значения
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < fields.length; i += 3)
          Row(
            children: [
              for (int j = i; j < i + 3 && j < fields.length; j++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainLightGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedValues[fields[j]],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        dropdownColor: AppColors.mainDarkGrey,
                        style: AppTextStyles.normalMedium,
                        items: ['Option 1', 'Option 2', 'Option 3']
                            .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValues[fields[j]] = value;
                          });
                        },
                        hint: Text(
                          fields[j],
                          style: AppTextStyles.normalMedium,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}