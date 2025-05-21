import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/team_model.dart';
import '../providers/team_provider.dart';
import '../../../common/theme/custom_colors.dart';
import '../../../common/theme/custom_text_styles.dart';
import '../../../common/widgets/custom_divider.dart';

class TeamSelectorBottomSheet extends ConsumerWidget {
  const TeamSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider); // Асинхронный список команд
    final selectedTeam = ref.watch(selectedTeamProvider);
    final selectedTeamNotifier = ref.read(selectedTeamProvider.notifier);

    return teamsAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 200,
        child: Center(child: Text('Ошибка загрузки команд: $err')),
      ),
      data: (teams) {
        if (teams.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(child: Text(LocaleKeys.noTeamsFound.tr())),
          );
        }
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.selectTeam.tr(),
                          style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  CustomDivider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];
                        final isSelected = team.id == selectedTeam?.id;

                        return InkWell(
                          onTap: () async {
                            selectedTeamNotifier.state = team;
                            await LocalStorageService.saveSelectedTeamId(team.id);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  team.name,
                                  style: CustomTextStyles.normalMedium.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? CustomColors.primary : CustomColors.mainDarkGrey,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: CustomColors.primary, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Вспомогательная функция для удобного показа bottom sheet'а
void showTeamSelectorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TeamSelectorBottomSheet(),
  );
}
