// lib/core/routing/main_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- НОВЫЙ ИМПОРТ
import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/main_screen.dart';
import '../../features/transaction_categories/presentation/screens/transaction_categories_screen.dart';
import '../../features/transactions/presentation/screens/transaction_create_screen.dart';

// Добавляем импорты, необходимые для AuthChecker логики
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/teams/presentation/providers/team_provider.dart';


class MainRouter {
  static const String initialRoute = '/'; // MainScreen
  static const String loginRoute = '/login';
  static const String splashRoute = '/splash'; // <--- НОВЫЙ МАРШРУТ ДЛЯ SPLASH

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    print('Generating route for: ${settings.name}');

    // Важно: для Riverpod провайдеров в generateRoute
    // нужно использовать ProviderScope, если виджет, который вы возвращаете,
    // не является частью существующего ProviderScope.
    // Однако, так как MyApp уже оборачивает все в ProviderScope, это не проблема.

    switch (settings.name) {
      case splashRoute:
      // ВОТ ГДЕ ТЕПЕРЬ ЛОГИКА _AuthChecker
        return MaterialPageRoute(builder: (context) {
          // Важно: используем Consumer здесь, чтобы получить доступ к ref
          return Consumer(
            builder: (context, ref, child) {
              // Логика _AuthChecker (из main.dart)
              return FutureBuilder<void>(
                // Ждем инициализации токена и команд
                future: _performAuthAndTeamInitialization(ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // После завершения Future, решаем, куда навигировать
                    final token = ref.read(authTokenProvider);
                    // Важно: pushReplacement сразу после загрузки.
                    // Используем post-frame callback, чтобы убедиться, что контекст верен
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      if (token == null) {
                        Navigator.of(context).pushReplacementNamed(loginRoute);
                      } else {
                        Navigator.of(context).pushReplacementNamed(initialRoute);
                      }
                    });
                    // Пока ждем навигации, показываем Splash Screen
                    return _buildSplashScreen();
                  } else if (snapshot.hasError) {
                    // Обработка ошибок во время инициализации
                    print('AuthChecker Error: ${snapshot.error}');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка запуска приложения: ${snapshot.error}'))
                      );
                      // В случае ошибки, возможно, стоит сразу перейти на экран входа
                      Navigator.of(context).pushReplacementNamed(loginRoute);
                    });
                    return _buildSplashScreen(); // Или экран ошибки
                  }
                  // Пока загружается, показываем Splash Screen
                  return _buildSplashScreen();
                },
              );
            },
          );
        });

      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case initialRoute: // '/'
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/accounts':
        return FadeRoute(pageBuilder: (_, __, ___) => const AccountsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }

  // Вспомогательная функция для логики инициализации
  static Future<void> _performAuthAndTeamInitialization(WidgetRef ref) async {
    await ref.read(authInitializationProvider.future);
    final token = ref.read(authTokenProvider);
    if (token != null) {
      await ref.read(teamsProvider.future);
      await ref.read(selectedTeamInitProvider.future);
    }
  }

  // Вспомогательная функция для построения Splash Screen UI
  static Widget _buildSplashScreen() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Загрузка приложения...'),
          ],
        ),
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget Function(BuildContext, Animation<double>, Animation<double>) pageBuilder;

  FadeRoute({required this.pageBuilder})
      : super(
    pageBuilder: pageBuilder,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}