// lib/features/projects/features/screens/projects_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../data/domain/project.dart';
import 'edit_project_screen.dart';
import '../../../../generated/locale_keys.g.dart'; // Импорт LocaleKeys

// --- Riverpod Provider (Stub) ---
final projectsProvider = StateProvider<List<Project>>((ref) => [
  Project(id: 1, name: 'Проект 1', description: 'Описание проекта номер один, которое может быть довольно длинным и занимать несколько строк.'),
  Project(id: 2, name: 'Второй проект', description: 'Краткое описание второго проекта.'),
  Project(id: 3, name: 'Проект с очень длинным названием', description: 'Описание этого проекта тоже может быть очень длинным, чтобы проверить ограничение на количество строк в подзаголовке.'),
]);

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.projects.tr()),
      ),
      body: projects.isEmpty
          ? Center(child: Text(LocaleKeys.noProjects.tr()))
          : CustomListViewSeparated(
        items: projects,
        itemBuilder: (context, project) {
          return CustomListItem(
            titleText: project.name,
            subtitleText: project.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProjectScreen(initialProject: project),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProjectScreen(), // Для добавления новый проект без initialProject
            ),
          );
        },
      ),
    );
  }
}