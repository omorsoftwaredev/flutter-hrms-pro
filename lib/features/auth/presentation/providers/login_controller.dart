import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/auth/user_type.dart';
import '../../../../core/router/route_paths.dart';

final loginLoadingProvider =
StateProvider<bool>((ref) => false);

final loginControllerProvider =
Provider<LoginController>((ref) {
  return LoginController(ref);
});

class LoginController {
  final Ref ref;

  LoginController(this.ref);

  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final CurrentUser user = await ref
          .read(authRepositoryProvider)
          .login(
        username: username,
        password: password,
      );

      ref
          .read(currentUserProvider.notifier)
          .login(user);

      if (!context.mounted) return;

      switch (user.userType) {
        case UserType.developer:
          context.go(RoutePaths.developerDashboard);
          break;

        case UserType.company:
          context.go(RoutePaths.companyDashboard);
          break;

        case UserType.hr:
          context.go(RoutePaths.hrDashboard);
          break;

        case UserType.supervisor:
          context.go(RoutePaths.supervisorDashboard);
          break;

        case UserType.employee:
          context.go(RoutePaths.employeeDashboard);
          break;
      }
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }
}