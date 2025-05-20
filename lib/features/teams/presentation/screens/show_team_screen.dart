import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../../users/presentation/user_details_screen.dart';
import '../../domain/models/team.dart';
import 'edit_team_screen.dart';

// --- Экран деталей команды ---
class ShowTeamScreen extends ConsumerWidget {
  final Team team;

  const ShowTeamScreen({super.key, required this.team});

  // !!! ЗАГЛУШКА: Здесь должна быть логика получения пользователей команды
  List<User> _getUsersForTeam(Team team) {
    return [
      User(id: 1, name: 'Пользователь 1', email: 'user1@example.com'),
      User(id: 2, name: 'Пользователь 2', email: 'user2@example.com'),
      User(id: 3, name: 'Пользователь 3', email: 'user3@example.com'),
      User(id: 4, name: 'Пользователь 4', email: 'user4@example.com'),
      User(id: 5, name: 'Пользователь 5', email: 'user5@example.com'),
      // ... другие пользователи
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersInTeam = _getUsersForTeam(team); // Получаем заглушку пользователей

    return Scaffold(
      appBar: AppBar(
        title: Text('${LocaleKeys.team.tr()}: ${team.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTeamScreen(initialTeam: team),
                ),
              );
            },
          ),
        ],
      ),
      body: usersInTeam.isEmpty
          ? Center(child: Text(LocaleKeys.noUsersInTeam.tr()))
          : CustomListViewSeparated(
        items: usersInTeam,
        itemBuilder: (context, user) {
          return CustomListItem(
            titleText: user.name,
            subtitleText: user.email,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}