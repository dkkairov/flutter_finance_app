// lib/features/projects/presentation/screens/projects_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_floating_action_button.dart';
import '../../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../data/models/project_model.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../providers/project_providers.dart';
import 'edit_project_screen.dart'; // <--- Убедитесь, что этот импорт есть

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.projects.tr()),
      ),
      body: projectsAsyncValue.when(
        data: (projects) {
          if (projects.isEmpty) {
            return Center(child: Text(LocaleKeys.noProjects.tr()));
          }
          return CustomListViewSeparated(
            items: projects,
            itemBuilder: (context, project) {
              return CustomListItem(
                titleText: project.name,
                subtitleText: project.description,
                onTap: () {
                  // Для редактирования существующего проекта
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProjectScreen(initialProject: project),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print('Error loading projects: $error');
          return Center(
            child: Text('${LocaleKeys.errorLoadingProjects.tr()}: $error'), // Используем локализацию
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // Для добавления нового проекта
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProjectScreen(), // Создаем новый проект
            ),
          );
        },
      ),
    );
  }
}