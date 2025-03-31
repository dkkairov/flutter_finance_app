import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/budget/presentation/budget_screen.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/categories/presentation/category_form_screen.dart';
import '../../features/projects/presentation/project_form_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/transactions/presentation/screens/transaction_form_screen.dart';
import '../../features/transactions/presentation/screens/transactions_list_screen.dart';

class MainRouter {
  static const String initialRoute = '/';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/transactions':
        return MaterialPageRoute(builder: (_) => TransactionListScreen());
      case '/main-transaction':
        return MaterialPageRoute(builder: (_) => TransactionFormScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case '/main-category':
        return MaterialPageRoute(builder: (_) => CategoryFormScreen());
      // case '/projects':
      //   return MaterialPageRoute(builder: (_) => ProjectsScreen());
      // case '/reports':
      //   return MaterialPageRoute(builder: (_) => ReportsScreen());
      case '/budget':
        return MaterialPageRoute(builder: (_) => BudgetScreen());
      // case '/settings':
      //   return MaterialPageRoute(builder: (_) => SettingsScreen());
      case '/main-project':
        return MaterialPageRoute(builder: (_) => ProjectFormScreen());
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
    case '/transactions':
      return FadeRoute(page: TransactionListScreen());
    case '/categories':
      return FadeRoute(page: CategoriesScreen());
    // case '/projects':
    //   return FadeRoute(page: ProjectsScreen());
    // case '/reports':
      // return FadeRoute(page: ReportsScreen());
    case '/budget':
      return FadeRoute(page: BudgetScreen());
    // case '/settings':
    //   return FadeRoute(page: SettingsScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Route not found: ${settings.name}')),
        ),
      );
  }
}