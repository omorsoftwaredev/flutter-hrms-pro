import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import 'role_state.dart';

class RoleNotifier extends StateNotifier<RoleState> {
  RoleNotifier(this._repository) : super(const RoleState());

  final RoleRepository _repository;

  Future<void> loadRoles() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final roles = await _repository.getRoles();

      state = state.copyWith(
        roles: roles,
        filteredRoles: roles,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadRoles();
  }

  Future<void> createRole(
      RoleEntity role,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createRole(role);

      state = state.copyWith(
        isSaving: false,
      );

      await loadRoles();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> updateRole(
      RoleEntity role,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateRole(role);

      state = state.copyWith(
        isSaving: false,
      );

      await loadRoles();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> deleteRole(
      String id,
      ) async {
    try {
      await _repository.deleteRole(id);

      await loadRoles();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> getRoleById(
      String id,
      ) async {
    try {
      final role = await _repository.getRoleById(id);

      state = state.copyWith(
        selectedRole: role,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> toggleRoleStatus(
      RoleEntity role,
      ) async {
    try {
      final updatedRole = role.copyWith(
        isActive: !role.isActive,
        updatedAt: DateTime.now(),
      );

      await _repository.updateRole(updatedRole);

      await loadRoles();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredRoles: state.roles,
      );
      return;
    }

    final filtered = state.roles.where((role) {
      return role.roleCode
          .toLowerCase()
          .contains(query) ||
          role.roleName
              .toLowerCase()
              .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredRoles: filtered,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedRole: null,
    );
  }
}