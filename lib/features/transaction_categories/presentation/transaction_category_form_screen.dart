// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
// import '../../../common/widgets/custom_text_field.dart';
// import '../../../generated/locale_keys.g.dart';
//
// class CategoryFormScreen extends StatelessWidget {
//   CategoryFormScreen({super.key});
//
//   final TextEditingController nameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(LocaleKeys.addCategory.tr())),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(controller: nameController, hintText: LocaleKeys.categoryName.tr()),
//             const SizedBox(height: 24),
//             CustomPrimaryButton(
//               text: LocaleKeys.save.tr(),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // TODO: Implement logic to save the category name
//                 final categoryName = nameController.text.trim();
//                 print('Category Name to save: $categoryName');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }