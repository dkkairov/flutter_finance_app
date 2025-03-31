// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../features/projects/data/project_provider.dart';
//
// class ProjectsScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final projects = ref.watch(projectsProvider);
//     final projectsNotifier = ref.read(projectsProvider.notifier);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Проекты'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => projectsNotifier.fetchProjects(),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: projects.length,
//         itemBuilder: (context, index) {
//           final project = projects[index];
//           return ListTile(
//             title: Text(project.name),
//             subtitle: Text(project.description),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () => projectsNotifier.deleteProject(project.id),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.pushNamed(context, '/main-project'),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
