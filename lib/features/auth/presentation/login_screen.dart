import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../core/routing/main_router.dart';
import '../../../features/auth/data/auth_provider.dart';
import '../../main/presentation/main_screen.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: emailController, hintText: 'Email'),
            SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              hintText: 'Пароль',
              obscureText: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Войти',
              onPressed: () async {
                await authNotifier.login(
                  emailController.text,
                  passwordController.text,
                );
                if (isAuthenticated) {
                  Navigator.pushReplacement(
                    context,
                    FadeRoute(page: MainScreen()),
                  );
                }
              },
            )

          ],
        ),
      ),
    );
  }
}
