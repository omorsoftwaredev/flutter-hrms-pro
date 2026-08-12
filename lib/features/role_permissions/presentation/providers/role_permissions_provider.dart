import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/role_permissions_repository_impl.dart';
import '../../domain/repositories/role_permissions_repository.dart';
import 'role_permissions_notifier.dart';
import 'role_permissions_state.dart';

// =============================================================
// ROLE PERMISSIONS REPOSITORY PROVIDER
// =============================================================

final rolePermissionsRepositoryProvider =
Provider<RolePermissionsRepository>((ref) {
  return RolePermissionsRepositoryImpl(ref);
});

// =============================================================
// ROLE PERMISSIONS PROVIDER
// =============================================================

final rolePermissionsProvider = StateNotifierProvider<
    RolePermissionsNotifier,
    RolePermissionsState>((ref) {
  return RolePermissionsNotifier(
    ref.read(rolePermissionsRepositoryProvider),
  );
});