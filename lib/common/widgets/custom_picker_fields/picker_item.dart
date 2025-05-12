class PickerItem<T> {
  final T id;
  final String displayValue;
  final String? imageUrl;

  PickerItem({
    required this.id,
    required this.displayValue,
    this.imageUrl,
  });
}