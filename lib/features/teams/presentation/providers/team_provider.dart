import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/team.dart'; // Импорт модели Team

class TeamsNotifier extends StateNotifier<List<Team>> {
  TeamsNotifier([List<Team>? initialTeams]) : super(initialTeams ?? []);

  void addTeam(String name) {
    final newId = state.isEmpty ? 1 : state.last.id + 1;
    final newTeam = Team(id: newId, name: name);
    state = [...state, newTeam];
    print('Added team: $name with id: $newId');
  }

  void editTeam(int id, String newName) {
    state = state.map((team) {
      if (team.id == id) {
        return team.copyWith(name: newName);
      }
      return team;
    }).toList();
    print('Edited team $id to $newName');
  }

  void deleteTeam(int id) {
    state = state.where((team) => team.id != id).toList();
    print('Deleted team: $id');
  }
}

// Provider, предоставляющий экземпляр TeamsNotifier
final teamsProvider = StateNotifierProvider<TeamsNotifier, List<Team>>((ref) {
  // !!! ЗАГЛУШКА: Замените на загрузку реальных данных, если необходимо
  return TeamsNotifier([
    Team(id: 1, name: 'Private'),
    Team(id: 2, name: 'Team 1'),
    Team(id: 3, name: 'Team 2'),
  ]);
});

// Provider для хранения текущей выбранной команды (может использоваться в других частях приложения)
final selectedTeamProvider = StateProvider<Team?>((ref) {
  final teams = ref.watch(teamsProvider);
  return teams.isNotEmpty ? teams.first : null; // Выбираем первый элемент, если список не пуст
});