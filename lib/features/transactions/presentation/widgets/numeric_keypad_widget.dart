import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart'; // Убедись, что этот импорт правильный
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_1/features/transactions/presentation/providers/transaction_controller.dart'; // Убедись, что этот импорт правильный
import 'package:vibration/vibration.dart';

class NumericKeypadWidget extends ConsumerWidget {
  const NumericKeypadWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Определяем клавиши для нашей клавиатуры
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '0', 'comment_icon'];

    // Используем GridView для отображения клавиш сеткой
    return Expanded(
      child: GridView.builder(
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
                if (key == ',') { // Если нажата запятая
                  // Запрещаем добавлять вторую запятую
                  if (raw.contains(',')) return;
                  // Если строка пустая, начинаем с "0,", иначе добавляем запятую в конец
                  raw = raw.isEmpty ? '0,' : raw + ',';
                } else { // Если нажата цифра
                  // ---- Начало добавленной логики ----
                  // Проверяем, есть ли уже запятая в строке
                  if (raw.contains(',')) {
                    // Находим позицию запятой
                    final commaIndex = raw.indexOf(',');
                    // Считаем количество цифр после запятой
                    final decimalDigits = raw.substring(commaIndex + 1);
                    // Если после запятой уже 2 или больше цифр, ничего не делаем (выходим из функции)
                    if (decimalDigits.length >= 2) {
                      return; // Прекращаем выполнение обработчика
                    }
                  }
                  // ---- Конец добавленной логики ----
                  // Если проверка пройдена, добавляем нажатую цифру к строке
                  raw += key;
                }
                // Обновляем значение в контроллере
                controller.updateRawAmount(raw);
              },
              // Отображаем символ клавиши на кнопке
              child: Text(key, style: AppTextStyles.normalLarge), // Убедись, что стиль текста определен
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Убираем скругление углов
              ),
            );
          }
        },
      ),
    );
  }
}