// lib/features/projects/features/screens/edit_project_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../data/domain/project.dart';
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys

class EditProjectScreen extends ConsumerStatefulWidget {
  final Project? initialProject;

  const EditProjectScreen({super.key, this.initialProject});

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialProject != null) {
      _nameController.text = widget.initialProject!.name;
      _descriptionController.text = widget.initialProject!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialProject != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? LocaleKeys.editProject.tr() : LocaleKeys.addProject.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: LocaleKeys.projectName.tr(),
                controller: _nameController,
                validator: (value) => value?.trim().isEmpty == true ? LocaleKeys.projectNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                labelText: LocaleKeys.projectDescription.tr(),
                controller: _descriptionController,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: isEditing ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text.trim();
                    final description = _descriptionController.text.trim();
                    if (isEditing) {
                      // !!! ЗАГЛУШКА: Реализуйте логику редактирования проекта
                      print('Редактировать проект ID: ${widget.initialProject!.id}, Name: $name, Description: $description');
                      // ref.read(projectsProvider.notifier).updateProject(widget.initialProject!.id, name, description);
                    } else {
                      // !!! ЗАГЛУШКА: Реализуйте логику добавления нового проекта
                      print('Добавить проект Name: $name, Description: $description');
                      // ref.read(projectsProvider.notifier).addProject(name, description);
                    }
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