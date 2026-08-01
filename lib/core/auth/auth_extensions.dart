/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Extensions
///
/// Version : 0.7.0
/// ===============================================================

import 'current_user.dart';
import 'roles.dart';

extension CurrentUserExtension on CurrentUser {
  /// ----------------------------------------------------------------
  /// Authentication
  /// ----------------------------------------------------------------

  bool get isLoggedIn => userId.isNotEmpty;

  bool get hasCompany => companyId.isNotEmpty;

  bool get hasEmployee => employeeId.isNotEmpty;

  /// ----------------------------------------------------------------
  /// Display
  /// ----------------------------------------------------------------

  String get displayName {
    if (fullName.trim().isNotEmpty) {
      return fullName;
    }

    return email;
  }

  /// ----------------------------------------------------------------
  /// Roles
  /// ----------------------------------------------------------------

  bool get isDeveloper =>
      role == UserRole.developer;

  bool get isSuperAdmin =>
      role == UserRole.superAdmin;

  bool get isCompanyOwner =>
      role == UserRole.companyOwner;

  bool get isSupervisor =>
      role == UserRole.supervisor;

  bool get isEmployee =>
      role == UserRole.employee;

  /// ----------------------------------------------------------------
  /// Management Roles
  /// ----------------------------------------------------------------

  bool get isAdmin =>
      isDeveloper ||
          isSuperAdmin ||
          isCompanyOwner;

  bool get canManage =>
      isDeveloper ||
          isSuperAdmin ||
          isCompanyOwner ||
          isSupervisor;

  /// ----------------------------------------------------------------
  /// Role Name
  /// ----------------------------------------------------------------

  String get roleName => role.title;

  String get roleValue => role.value;
}