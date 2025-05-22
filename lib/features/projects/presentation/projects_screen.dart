// lib/features/projects/presentation/screens/projects_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../data/domain/project.dart'; // Эту строку можно удалить, если Project больше не используется напрямую
import '../../common/widgets/custom_floating_action_button.dart';
import '../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../data/models/project_model.dart'; // <--- ИМПОРТИРУЙТЕ ProjectModel
import 'edit_project_screen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../presentation/providers/project_providers.dart'; // <--- ИМПОРТИРУЙТЕ НОВЫЙ ПРОВАЙДЕР

// УДАЛИТЕ ЭТУ ЗАГЛУШКУ:
// final projectsProvider = StateProvider<List<Project>>((ref) => [
//   Project(id: 1, name: 'Проект 1', description: 'Описание проекта номер один, которое может быть довольно длинным и занимать несколько строк.'),
//   Project(id: 2, name: 'Второй проект', description: 'Краткое описание второго проекта.'),
//   Project(id: 3, name: 'Проект с очень длинным названием', description: 'Описание этого проекта тоже может быть очень длинным, чтобы проверить ограничение на количество строк в подзаголовке.'),
// ]);

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Теперь watch'им FutureProvider, который возвращает AsyncValue
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.projects.tr()),
      ),
      body: projectsAsyncValue.when(
        data: (projects) {
          // Если данные успешно загружены
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
        loading: () => const Center(child: CircularProgressIndicator()), // Показывать индикатор загрузки
        error: (error, stack) {
          // Обработка ошибок
          print('Error loading projects: $error');
          return Center(
            child: Text('errorLoadingProjects: $error'), // Предполагается, что у вас есть такой ключ локализации
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