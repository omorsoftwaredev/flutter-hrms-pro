/// ===============================================================
/// Flutter HRMS Pro
/// Role Helper
///
/// Version : 0.7.0
/// ===============================================================

import 'roles.dart';

class RoleHelper {
  const RoleHelper._();

  /// Convert database string to UserRole
  static UserRole fromString(String? role) {
    return UserRoleExtension.fromString(role);
  }

  /// Convert enum to database string
  static String toStringValue(UserRole role) {
    return role.value;
  }

  /// Check Role
  static bool isDeveloper(String? role) =>
      fromString(role) == UserRole.developer;

  static bool isCompanyOwner(String? role) =>
      fromString(role) == UserRole.companyOwner;

  static bool isSupervisor(String? role) =>
      fromString(role) == UserRole.supervisor;

  static bool isEmployee(String? role) =>
      fromString(role) == UserRole.employee;
}