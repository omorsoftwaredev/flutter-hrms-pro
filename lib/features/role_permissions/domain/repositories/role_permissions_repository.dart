import '../entities/role_permissions_entity.dart';
import '../entities/role_permissions_view_entity.dart';

abstract class RolePermissionsRepository {
  // =============================================================
  // GET ALL ROLE PERMISSIONS
  // =============================================================

  /// Get all role permissions.
  ///
  /// Includes:
  /// - companyName
  /// - roleName
  Future<List<RolePermissionsViewEntity>> getRolePermissions();

  // =============================================================
  // GET ROLE PERMISSIONS BY ROLE ID
  // =============================================================

  /// Get all permissions for a specific role.
  ///
  /// Includes:
  /// - companyName
  /// - roleName
  Future<List<RolePermissionsViewEntity>> getRolePermissionsByRoleId(
      String roleId,
      );

  // =============================================================
  // GET ROLE PERMISSION BY ID
  // =============================================================

  /// Get a single role permission.
  ///
  /// Includes:
  /// - companyName
  /// - roleName
  Future<RolePermissionsViewEntity> getRolePermissionById(
      String id,
      );

  // =============================================================
  // CREATE ROLE PERMISSION
  // =============================================================

  /// Create a new role permission.
  Future<void> createRolePermission(
      RolePermissionsEntity rolePermission,
      );

  // =============================================================
  // UPDATE ROLE PERMISSION
  // =============================================================

  /// Update an existing role permission.
  Future<void> updateRolePermission(
      RolePermissionsEntity rolePermission,
      );

  // =============================================================
  // DELETE ROLE PERMISSION
  // =============================================================

  /// Delete a role permission.
  Future<void> deleteRolePermission(
      String id,
      );
}