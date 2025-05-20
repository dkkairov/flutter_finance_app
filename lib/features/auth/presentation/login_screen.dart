// lib/features/auth/features/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../data/auth_repository.dart';
// import '../../../core/repository/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Вызов реального login
      final token = await ref.read(authRepositoryProvider).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Сохрани токен в хранилище (и в Riverpod, если нужно)
      await ref.read(authRepositoryProvider).saveToken(token);
      ref.read(authTokenProvider.notifier).state = token;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка авторизации: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomPrimaryButton(
              onPressed: _login,
              text: 'Войти',
            ),
          ],
        ),
      ),
    );
  }
}
