/// ===============================================================
/// Flutter HRMS Pro
/// Splash Page
///
/// Version : 0.8.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/redirect_helper.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    try {
      // =========================================================
      // Load current user from Supabase
      // =========================================================

      final CurrentUser? user = await ref
          .read(authRepositoryProvider)
          .currentUser();

      if (user != null) {
        ref
            .read(currentUserProvider.notifier)
            .login(user);
      }

      if (!mounted) return;

      context.go(
        RedirectHelper.initial(user),
      );
    } catch (e) {
      if (!mounted) return;

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}