import 'package:flutter/material.dart';
import '../theme/custom_text_styles.dart';
import 'custom_divider.dart';

class CustomDraggableScrollableSheet extends StatelessWidget {
  const CustomDraggableScrollableSheet({
    super.key,
    required this.fields,
    required this.title,
  });

  final List<Widget> fields;
  final String title; // Заголовок по умолчанию

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false, // Не занимает всю высоту изначально
      initialChildSize: 0.5, // Начальная высота (50% от доступной)
      minChildSize: 0.2, // Минимальная высота
      maxChildSize: 0.8, // Максимальная высота
      builder: (context, scrollController) {
        return Container(
          // Добавляем скругленные углы сверху и фон
          decoration: const BoxDecoration(
            color: Colors.white, // Или цвет фона вашего приложения
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Шапка листа: Заголовок и кнопка закрытия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title, // Заголовок листа редактирования
                      style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold), // Пример стиля
                    ),
                    // Кнопка закрытия листа
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Разделитель под шапкой
              CustomDivider(),
              // Поля для редактирования
              Expanded( // Expanded нужен, чтобы секция с полями могла скроллиться
                child: ListView( // Используем ListView для прокручиваемых полей формы
                  controller: scrollController, // Привязываем контроллер скролла листа
                  padding: const EdgeInsets.all(16.0), // Отступы вокруг полей формы
                  children: fields
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}