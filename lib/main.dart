import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/add/presentation/add_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/network_status_notifier.dart';
import 'core/network/offline_sync_service.dart';
import 'core/theme/theme_manager.dart';
import 'core/routing/main_router.dart';
import 'core/localization/app_localizations.dart';

void main() {
  // final container = ProviderContainer();
  // final offlineSyncService = container.read(offlineSyncServiceProvider);
  //
  // container.listen(networkStatusProvider, (prev, next) {
  //   if (next == NetworkStatus.online) {
  //     offlineSyncService.syncPendingRequests();
  //   }
  // });


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

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

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
