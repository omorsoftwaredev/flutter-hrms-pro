import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/role_permissions_entity.dart';
import '../../domain/repositories/role_permissions_repository.dart';
import 'role_permissions_state.dart';

class RolePermissionsNotifier
    extends StateNotifier<RolePermissionsState> {
  RolePermissionsNotifier(this._repository)
      : super(const RolePermissionsState());

  final RolePermissionsRepository _repository;

  // =============================================================
  // LOAD ALL ROLE PERMISSIONS
  // =============================================================

  Future<void> loadRolePermissions() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final permissions =
      await _repository.getRolePermissions();

      state = state.copyWith(
        rolePermissions: permissions,
        filteredRolePermissions: permissions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // LOAD PERMISSIONS BY ROLE ID
  // =============================================================

  Future<void> loadByRoleId(
      String roleId,
      ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final permissions =
      await _repository.getRolePermissionsByRoleId(
        roleId,
      );

      state = state.copyWith(
        rolePermissions: permissions,
        filteredRolePermissions: permissions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> refresh() async {
    await loadRolePermissions();
  }

  // =============================================================
  // CREATE ROLE PERMISSION
  // =============================================================

  Future<void> createRolePermission(
      RolePermissionsEntity permission,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createRolePermission(
        permission,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadRolePermissions();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE ROLE PERMISSION
  // =============================================================

  Future<void> updateRolePermission(
      RolePermissionsEntity permission,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateRolePermission(
        permission,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadRolePermissions();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE ROLE PERMISSION
  // =============================================================

  Future<void> deleteRolePermission(
      String id,
      ) async {
    try {
      state = state.copyWith(
        error: null,
      );

      await _repository.deleteRolePermission(
        id,
      );

      await loadRolePermissions();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // GET ROLE PERMISSION BY ID
  // =============================================================

  Future<void> getRolePermissionById(
      String id,
      ) async {
    try {
      state = state.copyWith(
        error: null,
      );

      final permission =
      await _repository.getRolePermissionById(
        id,
      );

      state = state.copyWith(
        selectedRolePermission: permission,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // TOGGLE SINGLE PERMISSION
  // =============================================================

  Future<void> togglePermission(
      RolePermissionsEntity permission,
      String type,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      RolePermissionsEntity updated =
      permission.copyWith(
        updatedAt: DateTime.now(),
      );

      switch (type) {
        case 'view':
          updated = updated.copyWith(
            canView: !permission.canView,
          );
          break;

        case 'create':
          updated = updated.copyWith(
            canCreate: !permission.canCreate,
          );
          break;

        case 'update':
          updated = updated.copyWith(
            canUpdate: !permission.canUpdate,
          );
          break;

        case 'delete':
          updated = updated.copyWith(
            canDelete: !permission.canDelete,
          );
          break;

        case 'export':
          updated = updated.copyWith(
            canExport: !permission.canExport,
          );
          break;

        case 'approve':
          updated = updated.copyWith(
            canApprove: !permission.canApprove,
          );
          break;

        default:
          throw Exception(
            'Invalid permission type: $type',
          );
      }

      await _repository.updateRolePermission(
        updated,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadRolePermissions();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // SEARCH
  // =============================================================

  void search(
      String keyword,
      ) {
    final query =
    keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredRolePermissions:
        state.rolePermissions,
      );

      return;
    }

    final filtered =
    state.rolePermissions.where(
          (data) {
        return data.permission.moduleName
            .toLowerCase()
            .contains(query) ||
            data.roleName
                .toLowerCase()
                .contains(query) ||
            data.companyName
                .toLowerCase()
                .contains(query);
      },
    ).toList();

    state = state.copyWith(
      search: query,
      filteredRolePermissions: filtered,
    );
  }

  // =============================================================
  // CLEAR SELECTION
  // =============================================================

  void clearSelection() {
    state = state.copyWith(
      selectedRolePermission: null,
    );
  }
}