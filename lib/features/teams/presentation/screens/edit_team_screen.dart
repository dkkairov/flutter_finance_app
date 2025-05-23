// lib/features/teams/presentation/screens/edit_team_screen.dart

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/widgets/custom_buttons/custom_primary_button.dart';
import '../../../common/widgets/custom_text_form_field.dart';
import '../../data/models/team_model.dart';
import '../../data/models/membership_model.dart';
import '../providers/team_provider.dart';
import '../../data/repositories/team_repository.dart';
import '../providers/membership_provider.dart'; // Оставляем этот импорт
import '../../data/repositories/membership_repository.dart'; // <--- НОВЫЙ ИМПОРТ для MembershipRepository
// import '../../../../core/models/user.dart'; // User модель импортируется через MembershipModel

class EditTeamScreen extends ConsumerStatefulWidget {
  final TeamModel team;

  const EditTeamScreen({super.key, required this.team});

  @override
  ConsumerState<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends ConsumerState<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      if (name == widget.team.name) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.noChangesToSave.tr())),
        );
        return;
      }

      try {
        final repository = ref.read(teamRepositoryProvider);
        await repository.updateTeam(widget.team.id, name);

        ref.invalidate(teamsProvider);
        ref.read(selectedTeamProvider.notifier).update((state) {
          if (state?.id == widget.team.id) {
            return widget.team.copyWith(name: name);
          }
          return state;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.teamUpdatedSuccessfully.tr())),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToUpdateTeam.tr()}: ${e.toString()}';
          if (e is DioException && e.response != null && e.response!.data != null) {
            errorMessage = '${LocaleKeys.failedToUpdateTeam.tr()}: ${e.response!.data['message'] ?? 'Unknown error'}';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  Future<void> _deleteTeam() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmDeleteTeamTitle.tr()),
          content: Text(LocaleKeys.confirmDeleteTeamMessage.tr(args: [widget.team.name])),
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
        final repository = ref.read(teamRepositoryProvider);
        await repository.deleteTeam(widget.team.id);

        ref.invalidate(teamsProvider);
        if (ref.read(selectedTeamProvider)?.id == widget.team.id) {
          ref.read(selectedTeamProvider.notifier).state = null;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.teamDeletedSuccessfully.tr())),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToDeleteTeam.tr()}: ${e.toString()}';
          if (e is DioException && e.response != null && e.response!.data != null) {
            errorMessage = '${LocaleKeys.failedToDeleteTeam.tr()}: ${e.response!.data['message'] ?? 'Unknown error'}';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  Future<void> _addTeamMember() async {
    String? memberEmail;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.addTeamMember.tr()),
          content: Form(
            key: formKey,
            child: CustomTextFormField(
              labelText: LocaleKeys.memberEmail.tr(),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return LocaleKeys.emailCannotBeEmpty.tr();
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return LocaleKeys.invalidEmailFormat.tr();
                }
                return null;
              },
              onChanged: (value) {
                memberEmail = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(memberEmail);
                }
              },
              child: Text(LocaleKeys.add.tr()),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      try {
        final membershipRepository = ref.read(membershipRepositoryProvider); // <--- Используем MembershipRepository
        await membershipRepository.inviteMemberByEmail(
          widget.team.id,
          result, // email
          role: 'member', // Или дать пользователю выбрать роль, если это возможно
        );

        ref.invalidate(teamMembershipsProvider(widget.team.id)); // Обновляем список членств
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.memberAddedSuccessfully.tr())),
          );
        }
      } on DioException catch (e) { // Более специфичная обработка ошибок
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToAddMember.tr()}: ${e.toString()}';
          if (e.response != null && e.response!.data != null) {
            // Если бэкенд возвращает specific message, используем его
            errorMessage = '${LocaleKeys.failedToAddMember.tr()}: ${e.response!.data['message'] ?? 'Unknown error'}';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) { // Общая обработка других ошибок
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${LocaleKeys.failedToAddMember.tr()}: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _removeTeamMember(MembershipModel membership) async { // <--- Принимает MembershipModel
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.confirmRemoveMemberTitle.tr()),
          content: Text(LocaleKeys.confirmRemoveMemberMessage.tr(args: [membership.user.name, widget.team.name])), // Используем membership.user.name
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(LocaleKeys.remove.tr()),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final membershipRepository = ref.read(membershipRepositoryProvider); // <--- Используем MembershipRepository
        await membershipRepository.removeMembership(widget.team.id, membership.id); // <--- Передаем membership.id

        ref.invalidate(teamMembershipsProvider(widget.team.id)); // <--- Обновляем провайдер членств
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.memberRemovedSuccessfully.tr())),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '${LocaleKeys.failedToRemoveMember.tr()}: ${e.toString()}';
          if (e is DioException && e.response != null && e.response!.data != null) {
            errorMessage = '${LocaleKeys.failedToRemoveMember.tr()}: ${e.response!.data['message'] ?? 'Unknown error'}';
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
        title: Text(LocaleKeys.teamDetails.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteTeam,
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
                labelText: LocaleKeys.teamName.tr(),
                controller: _nameController,
                validator: (value) =>
                value?.trim().isEmpty == true ? LocaleKeys.teamNameCannotBeEmpty.tr() : null,
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: LocaleKeys.save.tr(),
                onPressed: _saveTeam,
              ),
              const SizedBox(height: 32),
              // --- Секция пользователей команды ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.teamMembers.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: _addTeamMember,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTeamMembersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMembersList() {
    final teamMembershipsAsync = ref.watch(teamMembershipsProvider(widget.team.id)); // <--- ИСПОЛЬЗУЕМ НОВЫЙ ПРОВАЙДЕР

    return teamMembershipsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${LocaleKeys.failedToLoadTeamMembers.tr()}: $err')),
      data: (memberships) { // <--- ТЕПЕРЬ ПОЛУЧАЕМ СПИСОК MembershipModel
        if (memberships.isEmpty) {
          return Center(child: Text(LocaleKeys.noTeamMembers.tr()));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: memberships.length,
          itemBuilder: (context, index) {
            final membership = memberships[index]; // <--- Это MembershipModel
            final user = membership.user; // <--- Получаем вложенного User'а

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text(user.name), // <--- Теперь user.name будет всегда доступно
                subtitle: Text('${user.email} (${membership.role.tr()})'), // <--- Отображаем email и роль
                trailing: IconButton(
                  icon: const Icon(Icons.person_remove), // Возможно, Icons.person_remove
                  onPressed: () => _removeTeamMember(membership), // <--- Передаем MembershipModel
                ),
              ),
            );
          },
        );
      },
    );
  }
}

extension on TeamModel {
  TeamModel copyWith({String? name}) {
    return TeamModel(
      id: this.id,
      name: name ?? this.name,
      isActive: this.isActive,
      ownerId: this.ownerId,
      type: this.type,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      deletedAt: this.deletedAt,
      updatedBy: this.updatedBy,
      syncedAt: this.syncedAt,
    );
  }
}