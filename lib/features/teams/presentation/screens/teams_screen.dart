// lib/features/teams/presentation/screens/teams_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/common/widgets/custom_floating_action_button.dart';
import 'package:flutter_app_1/features/teams/presentation/screens/show_team_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../../../generated/locale_keys.g.dart';
import '../providers/team_provider.dart';
import 'create_team_screen.dart';

// --- Экран списка команд ---
class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.teams.tr()),
      ),
      body: CustomListViewSeparated(
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
      ),
      floatingActionButton: CustomFloatingActionButton(onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
      )),
    );
  }
}