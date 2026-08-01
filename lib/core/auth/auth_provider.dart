/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Provider
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final authRepositoryProvider =
Provider<AuthRepository>(
      (ref) => AuthRepository(),
);