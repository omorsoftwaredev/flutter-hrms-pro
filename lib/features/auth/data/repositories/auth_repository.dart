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
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
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