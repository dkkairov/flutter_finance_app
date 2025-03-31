// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/routing/main_router.dart';
// import '../../../core/localization/app_localizations.dart';
// import '../../../main.dart';
// import '../../auth/data/auth_provider.dart';
// import '../../auth/presentation/login_screen.dart';
//
// class SettingsScreen extends ConsumerWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authNotifier = ref.read(authProvider.notifier);
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButton<Locale>(
//               value: Localizations.localeOf(context),
//               items: const [
//                 DropdownMenuItem(value: Locale('en'), child: Text('English')),
//                 DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
//                 DropdownMenuItem(value: Locale('kz'), child: Text('Қазақша')),
//               ],
//               onChanged: (Locale? locale) {
//                 if (locale != null) {
//                   MyApp.setLocale(context, locale);
//                 }
//               },
//             ),
//             ListTile(
//               title: Text(AppLocalizations.of(context).translate('logout')),
//               trailing: IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () async {
//                   await authNotifier.logout();
//                   Navigator.pushReplacement(
//                     context,
//                     FadeRoute(page: LoginScreen()),
//                   );
//                 },
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// extension on Provider<AuthService> {
//   ProviderListenable? get notifier => null;
// }
