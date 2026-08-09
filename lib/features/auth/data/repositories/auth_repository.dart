import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository();

  final SupabaseClient _client =
      Supabase.instance.client;

  ///=====================================
  /// LOGIN
  ///=====================================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // =============================================================
    // LOGIN AUTH DEBUG
    // =============================================================

    debugPrint(
      '=====================================================',
    );

    debugPrint('LOGIN AUTH DEBUG');

    debugPrint(
      'USER ID = ${_client.auth.currentUser?.id}',
    );

    debugPrint(
      'USER EMAIL = ${_client.auth.currentUser?.email}',
    );

    debugPrint(
      'SESSION EXISTS = ${_client.auth.currentSession != null}',
    );

    debugPrint(
      'RESPONSE USER ID = ${response.user?.id}',
    );

    debugPrint(
      'RESPONSE SESSION EXISTS = ${response.session != null}',
    );

    debugPrint(
      '=====================================================',
    );

    return response;
  }

  ///=====================================
  /// LOGOUT
  ///=====================================

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  ///=====================================
  /// CURRENT USER
  ///=====================================

  User? currentUser() {
    return _client.auth.currentUser;
  }

  ///=====================================
  /// CURRENT SESSION
  ///=====================================

  Session? currentSession() {
    return _client.auth.currentSession;
  }

  ///=====================================
  /// IS LOGGED IN
  ///=====================================

  bool isLoggedIn() {
    return _client.auth.currentUser != null;
  }

  ///=====================================
  /// REFRESH SESSION
  ///=====================================

  Future<AuthResponse> refreshSession() async {
    return await _client.auth.refreshSession();
  }

  ///=====================================
  /// RESET PASSWORD
  ///=====================================

  Future<void> resetPassword(
      String email,
      ) async {
    await _client.auth.resetPasswordForEmail(
      email,
    );
  }
}