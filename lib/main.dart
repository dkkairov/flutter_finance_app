import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/add/presentation/add_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'common/providers/theme_provider.dart';
import 'core/network/network_status_notifier.dart';
import 'core/routing/main_router.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/theme_manager.dart';

import 'features/transactions/presentation/providers/transaction_dependencies.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();

  // 🟡 ← вставь свой рабочий токен здесь:
  const token = '1|SxInNroV15HXdmVfercVMBTCvdJgLGnyOPiTDytP9cf82459';
  await storage.write(key: 'token', value: token);

  final check = await storage.read(key: 'token');
  debugPrint('📦 Токен сохранён: $check'); // ← вот это добавь

  runApp(ProviderScope(child: MyApp()));
}

final bottomNavProvider = StateProvider<int>((ref) => 0);
final transactionTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);

class MyApp extends ConsumerStatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Locale _locale = const Locale('ru');

  // @override
  // void initState() {
  //   super.initState();
  //
  //   Future.microtask(() async {
  //     final syncService = ref.read(offlineSyncServiceProvider);
  //     await syncService.syncPendingRequests();
  //   });
  // }

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



  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.system;

    return MaterialApp(
      title: 'Финансовый учёт',
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: themeMode,
      initialRoute: MainRouter.initialRoute,
      onGenerateRoute: MainRouter.generateRoute,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kz')],
      locale: _locale,
    );
  }
}