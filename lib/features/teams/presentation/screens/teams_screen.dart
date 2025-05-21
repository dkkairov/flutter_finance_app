// lib/features/teams/features/screens/teams_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/teams/presentation/screens/show_team_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/widgets/custom_floating_action_button.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../providers/team_provider.dart';
import 'create_team_screen.dart';

// --- Экран списка команд ---
class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.teams.tr()),
      ),
      body: teamsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
        data: (teams) {
          if (teams.isEmpty) {
            return Center(child: Text('Нет команд'));
            // Можно заменить на локализацию: LocaleKeys.noTeamsFound.tr()
          }
          return CustomListViewSeparated(
            items: teams,
            itemBuilder: (context, team) {
              return CustomListItem(
                titleText: team.name,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowTeamScreen(team: team),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
        ),
      ),
    );
  }
}
