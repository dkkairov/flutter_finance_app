// lib/features/projects/presentation/screens/edit_project_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../auth/presentation/providers/auth_providers.dart'; // Для selectedTeamIdProvider
import '../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../data/models/project_model.dart';
import '../data/models/project_payload.dart';
import '../presentation/providers/project_providers.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final ProjectModel? initialProject; // Если передается, значит редактируем существующий проект

  const EditProjectScreen({super.key, this.initialProject});

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get isEditing => widget.initialProject != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.initialProject!.name;
      _descriptionController.text = widget.initialProject!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();

      final teamId = ref.read(selectedTeamIdProvider);

      if (teamId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.noTeamSelectedError.tr())),
        );
        return;
      }

      // ИЗМЕНЕНО: Добавлена передача teamId в ProjectPayload
      final payload = ProjectPayload(
        name: name,
        description: description,
        teamId: teamId, // Передаем teamId в payload
      );

      try {
        final repository = ref.read(projectRepositoryProvider);
        if (isEditing) {
          // Логика обновления проекта
          await repository.updateProject(
            teamId: teamId,
            projectId: widget.initialProject!.id,
            payload: payload,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.projectUpdatedSuccessfully.tr())),
            );
          }
        } else {
          // Логика создания проекта
          await repository.createProject(teamId: teamId, payload: payload);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.projectCreatedSuccessfully.tr())),
            );
          }
        }

        // Инвалидируем провайдер, чтобы UI обновился
        ref.invalidate(projectsProvider);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = isEditing
              ? '${LocaleKeys.failedToUpdateProject.tr()}: ${e.toString()}'
              : '${LocaleKeys.failedToCreateProject.tr()}: ${e.toString()}';
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
        title: Text(isEditing ? LocaleKeys.editProject.tr() : LocaleKeys.createProject.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.projectName.tr(),
                controller: _nameController,
                validator: (value) =>
                value?.trim().isEmpty == true ? LocaleKeys.projectNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: LocaleKeys.projectDescription.tr(),
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: isEditing ? LocaleKeys.save.tr() : LocaleKeys.create.tr(),
                onPressed: _saveProject,
              ),
            ],
          ),
        ),
      ),
    );
  }
}