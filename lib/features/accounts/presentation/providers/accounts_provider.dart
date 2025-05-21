// lib/features/accounts/presentation/providers/accounts_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/account_repository.dart'; // Путь к accountRepositoryProvider
import '../../domain/models/account.dart'; // Путь к модели Account

/// Провайдер, который предоставляет список всех счетов для текущей команды.
/// Он зависит от AccountRepository и selectedTeamIdProvider.
/// Когда selectedTeamIdProvider меняется, этот провайдер автоматически обновляется.
final accountsProvider = FutureProvider.autoDispose<List<Account>>((ref) async {
  // Смотрим за изменением selectedTeamIdProvider.
  // Если команда меняется, этот провайдер перезапустится.
  final teamId = ref.watch(selectedTeamIdProvider);

  if (teamId == null) {
    // Если teamId null (например, пользователь не вошел в систему или команда не выбрана),
    // возвращаем пустой список или выбрасываем ошибку, в зависимости от логики.
    // Пока что возвращаем пустой список, так как на этот экран мы должны попадать уже с teamId.
    return [];
  }

  final accountRepository = ref.watch(accountRepositoryProvider);
  return accountRepository.fetchAccounts();
});