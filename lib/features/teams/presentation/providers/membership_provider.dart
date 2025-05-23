// lib/features/teams/presentation/providers/membership_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/models/membership_model.dart'; // <--- Импортируем MembershipModel
import '../../data/repositories/membership_repository.dart'; // <--- Импортируем MembershipRepository

// Провайдер для MembershipRepository
final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MembershipRepository(dio: dio);
});

// Провайдер для списка членов команды (теперь возвращает List<MembershipModel>)
final teamMembershipsProvider = FutureProvider.family<List<MembershipModel>, String>((ref, teamId) {
  return ref.watch(membershipRepositoryProvider).fetchMembershipsForTeam(teamId);
});
