/// ===============================================================
/// Flutter HRMS Pro
/// Route Guard
///
/// Version : 0.8.0
/// ===============================================================

import '../auth/current_user.dart';
import '../auth/permissions.dart';

class RouteGuard {
  const RouteGuard._();

  static bool isLoggedIn(CurrentUser? user) {
    return user?.isLoggedIn ?? false;
  }

  static bool hasPermission(
      CurrentUser? user,
      Permission permission,
      ) {
    if (user == null) {
      return false;
    }

    return user.can(permission);
  }

  static bool isDeveloper(CurrentUser? user) =>
      user?.isDeveloper ?? false;

  static bool isCompanyOwner(CurrentUser? user) =>
      user?.isCompany ?? false;

  static bool isSupervisor(CurrentUser? user) =>
      user?.isSupervisor ?? false;

  static bool isEmployee(CurrentUser? user) =>
      user?.isEmployee ?? false;
}