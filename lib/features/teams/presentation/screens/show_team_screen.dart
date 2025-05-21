import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../../users/presentation/user_details_screen.dart';
import '../../data/models/team_model.dart';
import '../providers/team_users_provider.dart';
import 'edit_team_screen.dart';

class ShowTeamScreen extends ConsumerWidget {
  final TeamModel team;

  const ShowTeamScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(teamUsersProvider(team.id));

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
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка загрузки пользователей: $err')),
        data: (usersInTeam) {
          if (usersInTeam.isEmpty) {
            return Center(child: Text(LocaleKeys.noUsersInTeam.tr()));
          }
          return CustomListViewSeparated(
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
          );
        },
      ),
    );
  }
}
