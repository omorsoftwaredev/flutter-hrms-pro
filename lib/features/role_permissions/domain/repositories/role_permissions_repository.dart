import '../entities/role_permissions_entity.dart';
import '../entities/role_permissions_view_entity.dart';


abstract class RolePermissionsRepository {


  /// Get all permissions
  /// Include:
  /// - companyName
  /// - roleName
  Future<List<RolePermissionsViewEntity>>
  getRolePermissions();



  /// Get permissions by role id
  /// Include:
  /// - companyName
  /// - roleName
  Future<List<RolePermissionsViewEntity>>
  getRolePermissionsByRoleId(
      String roleId,
      );



  /// Get single permission details
  /// Include:
  /// - companyName
  /// - roleName
  Future<RolePermissionsViewEntity>
  getRolePermissionById(
      String id,
      );



  /// Create permission
  Future<void> createRolePermission(
      RolePermissionsEntity rolePermission,
      );



  /// Update permission
  Future<void> updateRolePermission(
      RolePermissionsEntity rolePermission,
      );



  /// Delete permission
  Future<void> deleteRolePermission(
      String id,
      );

}