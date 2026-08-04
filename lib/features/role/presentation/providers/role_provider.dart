import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/role_repository_impl.dart';
import 'role_notifier.dart';
import 'role_state.dart';

final roleProvider =
StateNotifierProvider<RoleNotifier, RoleState>(
      (ref) => RoleNotifier(
    RoleRepositoryImpl(),
  ),
);