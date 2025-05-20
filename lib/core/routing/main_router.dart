import 'package:flutter/material.dart';
import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/main_screen.dart';
import '../../features/transaction_categories/presentation/transaction_categories_screen.dart';
import '../../features/transactions/presentation/screens/transaction_create_screen.dart';

class MainRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen());
      // case '/transactions':
      //   return MaterialPageRoute(builder: (_) => TransactionsScreen());
      case '/transactions/create':
        return MaterialPageRoute(builder: (_) => TransactionCreateScreen());
      case '/transaction_categories':
        return MaterialPageRoute(builder: (_) => TransactionCategoriesScreen());
      case '/accounts':
        return FadeRoute(page: AccountsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return FadeRoute(page: LoginScreen());
    case '/register':
      return FadeRoute(page: RegisterScreen());
    case '/':
      return FadeRoute(page: MainScreen());
    // case '/transactions':
    //   return FadeRoute(page: TransactionsScreen());
    case '/transactions/create':
      return MaterialPageRoute(builder: (_) => TransactionCreateScreen());
    case '/transaction_categories':
      return FadeRoute(page: TransactionCategoriesScreen());
    case '/accounts':
      return FadeRoute(page: AccountsScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Route not found: ${settings.name}')),
        ),
      );
  }
}