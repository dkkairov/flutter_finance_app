import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/models/user.dart';
import '../../data/repositories/team_users_repository.dart';

final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000',
  headers: {'Accept': 'application/json'},)));

final teamUsersRepositoryProvider = Provider<TeamUsersRepository>(
      (ref) => TeamUsersRepository(ref.watch(dioProvider)),
);

final teamUsersProvider = FutureProvider.family<List<User>, String>((ref, teamId) async {
  return ref.watch(teamUsersRepositoryProvider).fetchUsersForTeam(teamId);
});
