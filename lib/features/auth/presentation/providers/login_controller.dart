/// ===============================================================
/// Flutter HRMS Pro
/// Login Controller
///
/// Version : 2.1.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/auth/user_type.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/supabase_service.dart';

// ===============================================================
// LOGIN LOADING PROVIDER
// ===============================================================

final loginLoadingProvider = StateProvider<bool>((ref) => false);

// ===============================================================
// LOGIN CONTROLLER PROVIDER
// ===============================================================

final loginControllerProvider = Provider<LoginController>((ref) {
  return LoginController(ref);
});

// ===============================================================
// LOGIN CONTROLLER
// ===============================================================

class LoginController {
  final Ref ref;

  LoginController(this.ref);

  // =============================================================
  // LOGIN
  // =============================================================

  Future<void> login({
    required BuildContext context,
    required String username,
    required String passwordHash,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      // =========================================================
      // BEFORE LOGIN DEBUG
      // =========================================================

      debugPrint('');
      debugPrint('=====================================================');

      debugPrint('LOGIN CONTROLLER - START');

      debugPrint('USERNAME = $username');

      debugPrint(
        'SUPABASE USER BEFORE LOGIN = '
        '${SupabaseService.client.auth.currentUser?.id}',
      );

      debugPrint(
        'SUPABASE SESSION BEFORE LOGIN = '
        '${SupabaseService.client.auth.currentSession != null}',
      );

      debugPrint('=====================================================');

      // =========================================================
      // APPLICATION LOGIN
      // =========================================================

      final CurrentUser user = await ref
          .read(authRepositoryProvider)
          .login(username: username, passwordHash: passwordHash);

      // =========================================================
      // AFTER LOGIN - SUPABASE AUTH CHECK
      // =========================================================

      final supabaseUser = SupabaseService.client.auth.currentUser;

      final supabaseSession = SupabaseService.client.auth.currentSession;

      debugPrint('');
      debugPrint('=====================================================');

      debugPrint('LOGIN CONTROLLER - AFTER LOGIN');

      debugPrint('CURRENT USER MODEL ID = ${user.userId}');

      debugPrint('CURRENT USER MODEL EMAIL = ${user.email}');

      debugPrint(
        'SUPABASE AUTH USER ID = '
        '${supabaseUser?.id}',
      );

      debugPrint(
        'SUPABASE AUTH EMAIL = '
        '${supabaseUser?.email}',
      );

      debugPrint(
        'SUPABASE SESSION EXISTS = '
        '${supabaseSession != null}',
      );

      debugPrint('=====================================================');

      // =========================================================
      // CURRENT USER PROVIDER
      // =========================================================

      ref.read(currentUserProvider.notifier).login(user);

      // =========================================================
      // AUTH WARNING
      // =========================================================

      if (supabaseUser == null || supabaseSession == null) {
        debugPrint('');
        debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

        debugPrint('WARNING: APPLICATION LOGIN SUCCESSFUL');

        debugPrint('BUT SUPABASE AUTH SESSION IS NOT AVAILABLE.');

        debugPrint('Supervisor INSERT WILL FAIL WITH RLS.');

        debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }

      // =========================================================
      // NAVIGATION
      // =========================================================

      if (!context.mounted) {
        return;
      }

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
