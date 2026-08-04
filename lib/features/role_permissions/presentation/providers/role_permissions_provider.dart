import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/role_permissions_repository_impl.dart';
import 'role_permissions_notifier.dart';
import 'role_permissions_state.dart';


final rolePermissionsProvider =
StateNotifierProvider<
    RolePermissionsNotifier,
    RolePermissionsState>(
      (ref) {

    return RolePermissionsNotifier(
      RolePermissionsRepositoryImpl(),
    );

  },
);