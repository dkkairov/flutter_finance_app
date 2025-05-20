import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../../../features/common/theme/custom_colors.dart';
import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../providers/transaction_controller.dart';

class NumericKeypadWidget extends ConsumerWidget {
  const NumericKeypadWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Определяем клавиши для нашей клавиатуры
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '0', 'comment_icon'];

    // Используем GridView для отображения клавиш сеткой
    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          GridView.builder(
            shrinkWrap: true, // Запрещаем GridView занимать бесконечное пространство
            physics: const NeverScrollableScrollPhysics(), // Отключаем прокрутку для GridView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 колонки в сетке
              childAspectRatio: 2.5, // Соотношение сторон кнопок
            ),
            itemCount: keys.length, // Количество элементов в сетке равно количеству клавиш
            itemBuilder: (context, index) {
              final key = keys[index]; // Получаем символ текущей клавиши

              // Если клавиша - иконка комментария
              if (key == 'comment_icon') {
                return ElevatedButton.icon(
                  onPressed: () async {
                    // Вибрация при нажатии, если поддерживается
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(duration: 30);
                    }
                    // TODO: Добавить логику обработки нажатия на иконку комментария
                    print("Comment button pressed"); // Пример: выводим сообщение в консоль
                  },
                  icon: const Icon(Icons.comment), // Иконка комментария
                  label: const Text(''), // Текст кнопки пустой
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Убираем скругление углов
                    backgroundColor: CustomColors.mainLightGrey, // Цвет кнопки
                  ),
                );
              } else { // Если клавиша - цифра или запятая
                return ElevatedButton(
                  onPressed: () async {
                    // Вибрация при нажатии, если поддерживается
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate(duration: 30);
                    }
                    // Получаем доступ к контроллеру транзакций
                    final controller = ref.read(transactionCreateControllerProvider.notifier);
                    String raw = controller.rawAmount; // Получаем текущее введенное значение
                    String newRaw = raw;

                    if (key == ',') { // Если нажата запятая
                      // Запрещаем добавлять вторую запятую
                      if (raw.contains(',')) return;
                      // Если строка пустая, начинаем с "0,", иначе добавляем запятую в конец
                      newRaw = raw.isEmpty ? '0,' : '$raw,';
                    } else { // Если нажата цифра
                      newRaw += key;
                      // ---- Начало добавленной логики ограничения целой части ----
                      final integerPart = newRaw.split(',')[0];
                      if (integerPart.length > 12) {
                        return; // Прекращаем выполнение обработчика, если целая часть слишком длинная
                      }
                      // ---- Конец добавленной логики ограничения целой части ----

                      // ---- Начало добавленной логики ограничения дробной части ----
                      if (newRaw.contains(',')) {
                        final commaIndex = newRaw.indexOf(',');
                        final decimalDigits = newRaw.substring(commaIndex + 1);
                        if (decimalDigits.length > 2) {
                          return; // Прекращаем выполнение обработчика, если дробная часть слишком длинная
                        }
                      }
                      // ---- Конец добавленной логики ограничения дробной части ----
                    }
                    // Обновляем значение в контроллере
                    controller.updateRawAmount(newRaw);
                  }, // Убедись, что стиль текста определен
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Убираем скругление углов
                    backgroundColor: CustomColors.mainLightGrey, // Цвет кнопки
                  ),
                  // Отображаем символ клавиши на кнопке
                  child: Text(key == ',' ? ',' : key, style: CustomTextStyles.normalLarge),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}