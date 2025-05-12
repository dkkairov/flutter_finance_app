// lib/features/teams/presentation/screens/create_team_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../../common/widgets/custom_text_form_field.dart';
import '../../../../generated/locale_keys.g.dart';
import '../providers/team_provider.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.createTeam.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.teamName.tr(),
                controller: _teamNameController,
                validator: (value) => value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: LocaleKeys.create.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final teamName = _teamNameController.text.trim();
                    // !!! ЗАГЛУШКА: Реализуйте логику добавления новой команды
                    ref.read(teamsProvider.notifier).addTeam(teamName);
                    Navigator.pop(context);
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