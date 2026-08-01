/// ===============================================================
/// Flutter HRMS Pro
/// Permission Helper
///
/// Version : 0.7.0
/// ===============================================================

import 'permissions.dart';

class PermissionHelper {
  const PermissionHelper._();

  static bool hasPermission(
      Set<Permission> userPermissions,
      Permission permission,
      ) {
    return userPermissions.contains(permission);
  }

  static bool hasAnyPermission(
      Set<Permission> userPermissions,
      List<Permission> permissions,
      ) {
    return permissions.any(userPermissions.contains);
  }

  static bool hasAllPermissions(
      Set<Permission> userPermissions,
      List<Permission> permissions,
      ) {
    return permissions.every(userPermissions.contains);
  }
}
