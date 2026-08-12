import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/role_repository_impl.dart';
import '../../domain/repositories/role_repository.dart';
import 'role_notifier.dart';
import 'role_state.dart';

final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  return RoleRepositoryImpl(ref);
});

final roleProvider = StateNotifierProvider<
    RoleNotifier,
    RoleState>((ref) {
  return RoleNotifier(
    ref.read(roleRepositoryProvider),
  );
});