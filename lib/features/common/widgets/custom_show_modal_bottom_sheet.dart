import 'package:flutter/material.dart';
import 'custom_list_view/custom_list_view_separated.dart';
import 'custom_picker_fields/picker_item.dart';
import 'custom_list_view/custom_list_item.dart';

Future<PickerItem<T>?> customShowModalBottomSheet<T>({
  required BuildContext context,
  required String title,
  required String type,
  required List<PickerItem<T>> items,
}) async {
  return showModalBottomSheet<PickerItem<T>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: _BottomSheetContent<T>(
          title: title,
          items: items,
          type: type,
        ),
      );
    },
  );
}

class _BottomSheetContent<T> extends StatefulWidget {
  final String title;
  final String type;
  final List<PickerItem<T>> items;

  const _BottomSheetContent({
    required this.title,
    required this.items,
    required this.type,
  });

  @override
  State<_BottomSheetContent<T>> createState() => _BottomSheetContentState<T>();
}

class _BottomSheetContentState<T> extends State<_BottomSheetContent<T>> {
  late List<PickerItem<T>> filteredItems;
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();

  // !!! ИЗМЕНЕНО: Увеличено количество элементов на странице для 4 строк
  static const int itemsPerPage = 16; // Изменено с 12 на 16 для отображения 4 строк (4 * 4 = 16)

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.displayValue.toLowerCase().contains(query))
          .toList();
    });

    final pageCount = (filteredItems.length / itemsPerPage).ceil();
    if (_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          // Проверяем, нужно ли переключиться на первую страницу
          if (_pageController.page != null && _pageController.page! >= pageCount && pageCount > 0) {
            _pageController.jumpToPage(0);
          } else if (pageCount == 0 && _pageController.page != 0) {
            // Если после фильтрации нет элементов, переходим на 0 страницу
            _pageController.jumpToPage(0);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int pageCount = (filteredItems.length / itemsPerPage).ceil();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            // Шапка
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Поле поиска
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Основной контент
            if (filteredItems.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: Text('Ничего не найдено')),
              )
            else
              SizedBox(
                // !!! ИЗМЕНЕНО: Увеличена высота для размещения 4 строк
                height: 400, // Увеличено с 300 для размещения 4 строк
                child: widget.type == 'icon' ? PageView.builder(
                  key: ValueKey(filteredItems.length),
                  controller: _pageController,
                  itemCount: pageCount,
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * itemsPerPage;
                    final end = (start + itemsPerPage).clamp(0, filteredItems.length);
                    final pageItems = filteredItems.sublist(start, end);

                    return GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 8,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.9, // Оставляем для достаточной высоты элемента
                      children: pageItems.map((item) {
                        return _IconWithTextPickerItem<T>(
                              item: item,
                              onTap: () => Navigator.pop(context, item),
                        );
                      }).toList(),
                    );
                  },
                ) : CustomListViewSeparated( //
                  items: filteredItems, // Передаем список объектов Account
                  itemBuilder: (context, item) { // item здесь имеет тип Account
                    return CustomListItem(
                      titleText: item.displayValue, // Используем name из модели Account
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ) ,
              ),
            const SizedBox(height: 12),

            if (pageCount > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageCount,
                      (index) => AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double selected = 0;
                      if (_pageController.hasClients && _pageController.page != null) {
                        selected = (_pageController.page! - index).abs();
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: selected < 0.5 ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: selected < 0.5 ? Colors.red : Colors.grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _IconWithTextPickerItem<T> extends StatelessWidget {
  final PickerItem<T> item;
  final VoidCallback onTap;

  const _IconWithTextPickerItem({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: item.imageUrl != null // Если есть URL изображения
                ? ClipOval(child: Image.network(item.imageUrl!, fit: BoxFit.cover, width: 50, height: 50))
                : (item.iconData != null // Если есть IconData
                ? Icon(item.iconData, size: 30, color: Colors.black54) // Используем IconData
                : const Icon(Icons.folder, size: 30)), // Дефолтная иконка
          ),
          const SizedBox(height: 8),
          Text(
            item.displayValue,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LinePickerItem<T> extends StatelessWidget {
  final PickerItem<T> item;
  final VoidCallback onTap;

  const _LinePickerItem({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListItem(
      onTap: onTap,
      titleText: item.displayValue,
    );
  }
}