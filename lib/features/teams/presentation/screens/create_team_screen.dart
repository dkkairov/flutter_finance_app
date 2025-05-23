// lib/features/teams/presentation/screens/create_team_screen.dart

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../providers/team_provider.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createTeam() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      try {
        final repository = ref.read(teamRepositoryProvider);
        await repository.createTeam(name);

        ref.invalidate(teamsProvider); // Обновляем список команд

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.teamCreatedSuccessfully.tr())),
          );
          Navigator.of(context).pop(); // Возвращаемся после успешного создания
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToCreateTeam.tr()}: ${e.toString()}';
          if (e is DioException) {
            if (e.response != null && e.response!.data != null) {
              errorMessage = '${LocaleKeys.failedToCreateTeam.tr()}: ${e.response!.data['message'] ?? 'Unknown error'}';
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.createTeam.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.teamName.tr(),
                controller: _nameController,
                validator: (value) =>
                value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
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