import 'package:flutter/material.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
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
              text: 'Зарегистрироваться',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
