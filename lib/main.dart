import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/common/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/network/network_status_notifier.dart';
import 'core/routing/main_router.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/common/providers/theme_provider.dart';
import 'features/transactions/presentation/providers/transaction_provider.dart';
import 'features/transactions/presentation/screens/transaction_create_screen.dart';
import 'generated/codegen_loader.g.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  const storage = FlutterSecureStorage();

  // 🟡 ← вставь свой рабочий токен здесь:
  const token = '2|veKU80pgY9vElZi64CwVzU9Zb7i6nEfSEDNnlVaJ84b30191';
  await storage.write(key: 'token', value: token);

  final check = await storage.read(key: 'token');
  debugPrint('📦 Токен сохранён: $check'); // ← вот это добавь

  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ru', 'RU'),
      // Locale('kk', 'KZ'),
    ],
    path: 'lib/core/localization/languages',
    fallbackLocale: Locale('en', 'US'),
    assetLoader: CodegenLoader(),
    child: ProviderScope(child: MyApp()),
  ));
}

final bottomNavProvider = StateProvider<int>((ref) => 2);
final transactionTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);

class MyApp extends ConsumerStatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();

    final syncService = ref.read(offlineSyncServiceProvider);
    final network = ref.read(networkStatusProvider);

    network.isConnected().then((connected) {
      if (connected) syncService.syncPendingRequests();
    });

    network.onStatusChange.listen((isOnline) {
      if (isOnline) syncService.syncPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.system;
    final init = ref.watch(authInitProvider);

    return init.when(
      data: (_) {
        final token = ref.watch(authTokenProvider);
        return MaterialApp(
          title: 'Fin16',
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: themeMode,
          initialRoute: token == null ? MainRouter.loginRoute : MainRouter.initialRoute,
          onGenerateRoute: MainRouter.generateRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Center(child: Text('Ошибка запуска: $e')),
    );


  }
}