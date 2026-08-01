/// ===============================================================
/// Flutter HRMS Pro
/// Session Provider
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'session_service.dart';

class SessionNotifier extends StateNotifier<Session?> {
  SessionNotifier()
      : super(
    SessionService.currentSession,
  );

  Session? get session => state;

  bool get isLoggedIn => state != null;

  void setSession(Session? session) {
    state = session;
  }

  void clear() {
    state = null;
  }
}

final sessionProvider =
StateNotifierProvider<SessionNotifier, Session?>(
      (ref) => SessionNotifier(),
);