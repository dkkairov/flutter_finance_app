// lib/features/teams/features/screens/create_team_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../providers/team_provider.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final teamName = _teamNameController.text.trim();
    try {
      final repo = ref.read(teamRepositoryProvider);
      await repo.createTeam(teamName);

      if (mounted) Navigator.pop(context, true); // Можно вернуть true, чтобы в списке команд обновиться
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              CustomTextFormField(
                labelText: LocaleKeys.teamName.tr(),
                controller: _teamNameController,
                validator: (value) => value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomPrimaryButton(
                text: LocaleKeys.create.tr(),
                onPressed: _createTeam,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
