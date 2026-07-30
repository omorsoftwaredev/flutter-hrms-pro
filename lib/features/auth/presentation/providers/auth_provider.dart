import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository.dart';

///======================================================
/// Repository
///======================================================

final authRepositoryProvider =
Provider<AuthRepository>(
      (ref) => AuthRepository(),
);

///======================================================
/// Current User
///======================================================

final currentUserProvider =
Provider<User?>(
      (ref) {
    return ref
        .read(authRepositoryProvider)
        .currentUser();
  },
);

///======================================================
/// Current Session
///======================================================

final currentSessionProvider =
Provider<Session?>(
      (ref) {
    return ref
        .read(authRepositoryProvider)
        .currentSession();
  },
);

///======================================================
/// Login Status
///======================================================

final isLoggedInProvider =
Provider<bool>(
      (ref) {
    return ref
        .read(authRepositoryProvider)
        .isLoggedIn();
  },
);