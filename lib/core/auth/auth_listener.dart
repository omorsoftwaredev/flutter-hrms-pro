/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Listener
///
/// Version : 0.7.0
/// ===============================================================

import 'dart:async';
import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import 'current_user_provider.dart';
import 'auth_repository.dart';
import 'session_provider.dart';

class AuthListener {
  AuthListener._();

  static StreamSubscription<AuthState>? _subscription;

  static void start(WidgetRef ref) {
    _subscription?.cancel();

    _subscription =
        SupabaseService.client.auth.onAuthStateChange.listen(
              (AuthState data) async {
            final session = data.session;

            ref
                .read(sessionProvider.notifier)
                .setSession(session);

            if (session == null) {
              ref
                  .read(currentUserProvider.notifier)
                  .logout();
              return;
            }

            final repository =
            ref.read(authRepositoryProvider);

            final currentUser =
            await repository.currentUser();

            if (currentUser != null) {
              ref
                  .read(currentUserProvider.notifier)
                  .login(currentUser);
            }
          },
        );
  }

  static Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}