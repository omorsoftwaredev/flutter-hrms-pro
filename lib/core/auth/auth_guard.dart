/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Guard
///
/// Version : 0.7.0
/// ===============================================================

import 'current_user.dart';
import 'permissions.dart';
import 'roles.dart';

class AuthGuard {
  const AuthGuard._();

  // =============================================================
  // Login
  // =============================================================

  static bool isLoggedIn(CurrentUser? user) {
    return user != null && user.isLoggedIn;
  }

  // =============================================================
  // Role Checks
  // =============================================================

  static bool isDeveloper(CurrentUser? user) {
    return user?.role == UserRole.developer;
  }

  static bool isCompanyOwner(CurrentUser? user) {
    return user?.role == UserRole.companyOwner;
  }

  static bool isSupervisor(CurrentUser? user) {
    return user?.role == UserRole.supervisor;
  }

  static bool isEmployee(CurrentUser? user) {
    return user?.role == UserRole.employee;
  }

  // =============================================================
  // Admin
  // =============================================================

  static bool isAdmin(CurrentUser? user) {
    if (user == null) return false;

    return user.role == UserRole.developer ||
        user.role == UserRole.companyOwner;
  }

  // =============================================================
  // Permission
  // =============================================================

  static bool canAccess(
      CurrentUser? user,
      Permission permission,
      ) {
    if (user == null) return false;

    return user.can(permission);
  }

  static bool canAny(
      CurrentUser? user,
      List<Permission> permissions,
      ) {
    if (user == null) return false;

    for (final permission in permissions) {
      if (user.can(permission)) {
        return true;
      }
    }

    return false;
  }

  static bool canAll(
      CurrentUser? user,
      List<Permission> permissions,
      ) {
    if (user == null) return false;

    for (final permission in permissions) {
      if (!user.can(permission)) {
        return false;
      }
    }

    return true;
  }
}