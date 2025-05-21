import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../data/models/team_model.dart';
import '../providers/team_provider.dart';

class EditTeamScreen extends ConsumerStatefulWidget {
  final TeamModel? initialTeam; // null — создание, не null — редактирование

  const EditTeamScreen({super.key, this.initialTeam});

  @override
  ConsumerState<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends ConsumerState<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

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

  Future<void> _saveTeam() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final teamName = _teamNameController.text.trim();

    try {
      final repo = ref.read(teamRepositoryProvider);

      if (widget.initialTeam != null) {
        // Редактирование
        await repo.updateTeam(widget.initialTeam!.id, teamName);
      } else {
        // Создание новой
        await repo.createTeam(teamName);
      }
      if (mounted) Navigator.pop(context, true); // Вернуть true, если нужно обновить список
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
      });
    } finally {
      if (mounted) setState(() {
        _isLoading = false;
      });
    }
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
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              CustomTextFormField(
                labelText: LocaleKeys.name.tr(),
                controller: _teamNameController,
                validator: (value) => value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomPrimaryButton(
                text: isEditing ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                onPressed: _saveTeam,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
