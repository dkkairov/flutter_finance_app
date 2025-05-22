// lib/features/projects/presentation/screens/edit_project_screen.dart

import 'package:dio/dio.dart'; // <--- Добавьте импорт DioException
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../data/models/project_model.dart';
import '../../data/models/project_payload.dart';
import '../providers/project_providers.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final ProjectModel? initialProject;

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

      final payload = ProjectPayload(
        name: name,
        description: description,
        teamId: teamId,
      );

      try {
        final repository = ref.read(projectRepositoryProvider);
        if (isEditing) {
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
          await repository.createProject(teamId: teamId, payload: payload);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.projectCreatedSuccessfully.tr())),
            );
          }
        }

        ref.invalidate(projectsProvider);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = isEditing
              ? '${LocaleKeys.failedToUpdateProject.tr()}: ${e.toString()}'
              : '${LocaleKeys.failedToCreateProject.tr()}: ${e.toString()}';
          if (e is DioException) { // <--- Проверяем на DioException
            if (e.response != null && e.response!.data != null) {
              errorMessage = '${isEditing ? LocaleKeys.failedToUpdateProject.tr() : LocaleKeys.failedToCreateProject.tr()}: ${e.response!.data.toString()}';
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  // НОВЫЙ МЕТОД: Удаление проекта
  Future<void> _deleteProject() async {
    final teamId = ref.read(selectedTeamIdProvider);

    if (teamId == null || !isEditing) {
      return; // Нельзя удалить, если нет teamId или это не режим редактирования
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmDeleteProjectTitle.tr()), // Новый ключ локализации
          content: Text(LocaleKeys.confirmDeleteProjectMessage.tr(args: [widget.initialProject!.name])), // Новый ключ
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(LocaleKeys.delete.tr()),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(projectRepositoryProvider);
        await repository.deleteProject(
          teamId: teamId,
          projectId: widget.initialProject!.id,
        );

        ref.invalidate(projectsProvider); // Обновляем список проектов

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.projectDeletedSuccessfully.tr())), // Новый ключ
          );
          Navigator.of(context).pop(); // Возвращаемся после успешного удаления
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToDeleteProject.tr()}: ${e.toString()}'; // Новый ключ
          if (e is DioException) {
            if (e.response != null && e.response!.data != null) {
              errorMessage = '${LocaleKeys.failedToDeleteProject.tr()}: ${e.response!.data.toString()}';
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
        title: Text(isEditing ? LocaleKeys.editProject.tr() : LocaleKeys.createProject.tr()),
        actions: [
          if (isEditing) // Показываем кнопку удаления только в режиме редактирования
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteProject, // Вызываем метод удаления
            ),
        ],
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