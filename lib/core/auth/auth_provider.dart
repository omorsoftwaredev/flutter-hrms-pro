/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Provider
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final authRepositoryProvider =
Provider<AuthRepository>(
      (ref) {
    return AuthRepository();
  },
);