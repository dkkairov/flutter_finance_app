import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
import 'package:vibration/vibration.dart';
import '../providers/amount_input_provider.dart';

class NumericKeypadWidget extends ConsumerWidget {
  const NumericKeypadWidget({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '0', 'comment_icon'];



    void handleKeyPress(String key) {
      final current = ref.read(amountInputProvider);
      String updated = current;

      // Максимум 9 символов
      if (current.length >= 9) return;

      if (key == ',') {
        // Если уже есть запятая — игнорируем
        if (current.contains(',')) return;
        // Если пусто — начинаем с "0,"
        updated = current.isEmpty ? '0,' : current + ',';
      } else if (RegExp(r'^\d$').hasMatch(key)) {
        updated += key;
      }

      // Удаление ведущих нулей, если нет запятой
      if (!updated.contains(',') && updated.startsWith('0') && updated.length > 1) {
        updated = updated.replaceFirst(RegExp(r'^0+'), '');
      }

      ref.read(amountInputProvider.notifier).state = updated;
    }




    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        return key == 'comment_icon'
        ? ElevatedButton.icon(
          onPressed: () async {
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 30);
            }
            handleKeyPress(key);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          icon: const Icon(Icons.comment),
          label: const Text(''),
        )
        : ElevatedButton(
          onPressed: () async {
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 30);
            }
            handleKeyPress(key);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Text(key, style: AppTextStyles.normalLarge),
        );
      },
    );
  }
}
