/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Permission
///
/// Version : 0.7.0
/// ===============================================================

import '../auth/current_user.dart';
import '../auth/permissions.dart';

class DashboardPermission {
  const DashboardPermission._();

  static bool canOpen(
      CurrentUser user,
      Permission permission,
      ) {
    return user.hasPermission(permission);
  }
}