/// ===============================================================
/// Flutter HRMS Pro
/// Role Permissions
///
/// Version : 0.7.0
/// ===============================================================

import 'permissions.dart';
import 'roles.dart';

class RolePermissions {
  RolePermissions._();

  static final Map<UserRole, Set<Permission>> _permissions = {
    // ===========================================================
    // Developer
    // ===========================================================

    UserRole.developer: {
      ...Permission.values,
    },

    // ===========================================================
    // Company Owner
    // ===========================================================

    UserRole.companyOwner: {
      Permission.viewDashboard,

      // Company
      Permission.companyView,
      Permission.companyUpdate,

      // Department
      Permission.departmentView,
      Permission.departmentCreate,
      Permission.departmentUpdate,
      Permission.departmentDelete,

      // Designation
      Permission.designationView,
      Permission.designationCreate,
      Permission.designationUpdate,
      Permission.designationDelete,

      // Shift
      Permission.shiftView,
      Permission.shiftCreate,
      Permission.shiftUpdate,
      Permission.shiftDelete,

      // Employee
      Permission.employeeView,
      Permission.employeeCreate,
      Permission.employeeUpdate,
      Permission.employeeDelete,

      // Attendance
      Permission.attendanceView,
      Permission.attendanceCreate,
      Permission.attendanceUpdate,
      Permission.attendanceDelete,
      Permission.attendanceCheckIn,
      Permission.attendanceCheckOut,

      // Leave
      Permission.leaveView,
      Permission.leaveCreate,
      Permission.leaveApprove,

      // Reports
      Permission.reportsView,

      // Settings
      Permission.settingsView,
    },

    // ===========================================================
    // Supervisor
    // ===========================================================

    UserRole.supervisor: {
      Permission.viewDashboard,

      Permission.employeeView,

      Permission.attendanceView,
      Permission.attendanceCreate,
      Permission.attendanceUpdate,
      Permission.attendanceCheckIn,
      Permission.attendanceCheckOut,

      Permission.leaveView,
      Permission.leaveCreate,
      Permission.leaveApprove,

      Permission.reportsView,
    },

    // ===========================================================
    // Employee
    // ===========================================================

    UserRole.employee: {
      Permission.viewDashboard,

      Permission.attendanceView,
      Permission.attendanceCheckIn,
      Permission.attendanceCheckOut,

      Permission.leaveView,
      Permission.leaveCreate,
    },
  };

  /// Get all permissions of a role
  static Set<Permission> permissions(UserRole role) {
    return _permissions[role] ?? <Permission>{};
  }

  /// Check a single permission
  static bool hasPermission(
      UserRole role,
      Permission permission,
      ) {
    return permissions(role).contains(permission);
  }

  /// Check any permission
  static bool hasAnyPermission(
      UserRole role,
      List<Permission> permissions,
      ) {
    final userPermissions = RolePermissions.permissions(role);

    return permissions.any(userPermissions.contains);
  }

  /// Check all permissions
  static bool hasAllPermissions(
      UserRole role,
      List<Permission> permissions,
      ) {
    final userPermissions = RolePermissions.permissions(role);

    return permissions.every(userPermissions.contains);
  }
}