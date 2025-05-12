// lib/features/teams/presentation/screens/user_details_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_picker_fields/custom_primary_picker_field.dart';
import '../../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../../core/models/user.dart';
import '../../../../generated/locale_keys.g.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  String? _selectedRole; // Для хранения выбранной роли

  // !!! ЗАГЛУШКА: Здесь должен быть реальный список ролей
  final List<String> _availableRoles = ['Администратор', 'Редактор', 'Наблюдатель'];

  Future<void> _showRolePicker(BuildContext context) async {
    final pickedRoleItem = await customShowModalBottomSheet<String>(
      context: context,
      title: LocaleKeys.selectRole.tr(),
      type: 'line',
      items: _availableRoles
          .map((role) => PickerItem<String>(id: role, displayValue: role.tr()))
          .toList(),
    );

    if (pickedRoleItem != null) {
      setState(() {
        _selectedRole = pickedRoleItem.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.userDetails.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${LocaleKeys.name.tr()}:', style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.user.name, style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 16),
            Text('${LocaleKeys.email.tr()}:', style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.user.email, style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            Text('${LocaleKeys.role.tr()}:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            CustomPrimaryPickerField(
              context: context,
              icon: Icons.person_outline, // Или другая подходящая иконка
              currentValueDisplay: _selectedRole?.tr() ?? LocaleKeys.selectRole.tr(),
              onTap: () => _showRolePicker(context),
            ),
            const SizedBox(height: 32),
            CustomPrimaryButton(
              text: LocaleKeys.save.tr(),
              onPressed: () {
                // !!! ЗАГЛУШКА: Здесь должна быть логика сохранения роли (_selectedRole)
                print('Сохранить роль: $_selectedRole для пользователя ${widget.user.id}');
                // Возможно, вызвать провайдер или сервис для обновления роли
              },
            ),
          ],
        ),
      ),
    );
  }
}