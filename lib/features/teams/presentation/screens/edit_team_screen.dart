// lib/features/teams/presentation/screens/edit_team_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../../common/widgets/custom_text_form_field.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/models/team.dart';
import '../providers/team_provider.dart';

class EditTeamScreen extends ConsumerStatefulWidget {
  final Team? initialTeam; // Может быть null, если это добавление новой команды

  const EditTeamScreen({super.key, this.initialTeam});

  @override
  ConsumerState<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends ConsumerState<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialTeam != null) {
      _teamNameController.text = widget.initialTeam!.name;
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTeam != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? LocaleKeys.edit.tr() : LocaleKeys.add.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.name.tr(),
                controller: _teamNameController,
                validator: (value) => value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: isEditing ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final teamName = _teamNameController.text.trim();
                    if (isEditing) {
                      // !!! ЗАГЛУШКА: Реализуйте логику редактирования команды
                      ref.read(teamsProvider.notifier).editTeam(widget.initialTeam!.id, teamName);
                      Navigator.pop(context);
                    } else {
                      // !!! ЗАГЛУШКА: Реализуйте логику добавления новой команды
                      ref.read(teamsProvider.notifier).addTeam(teamName);
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}