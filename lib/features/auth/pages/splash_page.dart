/// ===============================================================
/// Flutter HRMS Pro
/// Splash Page
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/redirect_helper.dart';
import '../../../core/router/route_paths.dart';

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
    // Splash Delay
    await Future.delayed(
      const Duration(seconds: 1),
    );

    try {
      final CurrentUser? user = await ref
          .read(authRepositoryProvider)
          .currentUser();

      if (user != null) {
        ref
            .read(currentUserProvider.notifier)
            .login(user);

        if (!mounted) return;

        context.go(
          RedirectHelper.initial(user),
        );

        return;
      }

      if (!mounted) return;

      context.go(RoutePaths.login);
    } catch (e) {
      if (!mounted) return;

      context.go(RoutePaths.login);
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