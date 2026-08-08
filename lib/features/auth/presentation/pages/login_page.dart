import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../providers/login_controller.dart';
import 'package:go_router/go_router.dart';
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(
    // text: "omor.software.dev@gmail.com",
    text: "EMP0002",
  );

  final _passwordController = TextEditingController(
    // text: "Admin@123456",
    text: "123456",
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final passwordHash = _passwordController.text;

    if (username.isEmpty || passwordHash.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username and Password are required.',
          ),
        ),
      );
      return;
    }

    try {
       await ref.read(loginControllerProvider).login(
        context: context,
        username: username,
         passwordHash: passwordHash,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loginLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.apartment,
                  size: AppSizes.logoSize,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Flutter HRMS Pro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Employee Management System",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username / Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("LOGIN"),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.push('/forgot-password');
                  },
                  child: const Text('Forgot Password'),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Version 0.1.0",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}