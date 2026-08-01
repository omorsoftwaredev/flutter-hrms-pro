/// ===============================================================
/// Flutter HRMS Pro
/// Session Service
///
/// Version : 0.7.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class SessionService {
  SessionService._();

  static final SupabaseClient _client = SupabaseService.client;

  /// Current Session
  static Session? get currentSession =>
      _client.auth.currentSession;

  /// Current User
  static User? get currentAuthUser =>
      _client.auth.currentUser;

  /// Is Logged In
  static bool get isLoggedIn =>
      currentAuthUser != null;

  /// Refresh Session
  static Future<AuthResponse> refreshSession(
      String refreshToken,
      ) {
    return _client.auth.refreshSession(
      refreshToken,
    );
  }

  /// Logout
  static Future<void> logout() async {
    await _client.auth.signOut();
  }
}