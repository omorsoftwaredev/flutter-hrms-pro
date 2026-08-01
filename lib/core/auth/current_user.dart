/// ===============================================================
/// Flutter HRMS Pro
/// Current User Model
///
/// Version : 0.7.0
/// ===============================================================

import 'permissions.dart';
import 'role_permissions.dart';
import 'roles.dart';

class CurrentUser {
  final String userId;
  final String employeeId;
  final String companyId;
  final String fullName;
  final String email;
  final UserRole role;

  const CurrentUser({
    required this.userId,
    required this.employeeId,
    required this.companyId,
    required this.fullName,
    required this.email,
    required this.role,
  });

  // ===========================================================
  // Login
  // ===========================================================

  bool get isLoggedIn => userId.isNotEmpty;

  // ===========================================================
  // Role Helpers
  // ===========================================================

  bool get isDeveloper => role == UserRole.developer;

  bool get isSuperAdmin => role == UserRole.superAdmin;

  bool get isCompanyOwner => role == UserRole.companyOwner;

  bool get isSupervisor => role == UserRole.supervisor;

  bool get isEmployee => role == UserRole.employee;

  // ===========================================================
  // Permission Helpers
  // ===========================================================

  Set<Permission> get permissions =>
      RolePermissions.permissions(role);

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  bool can(Permission permission) {
    return hasPermission(permission);
  }

  bool canManage(Permission permission) {
    return hasPermission(permission);
  }

  // ===========================================================
  // Copy
  // ===========================================================

  CurrentUser copyWith({
    String? userId,
    String? employeeId,
    String? companyId,
    String? fullName,
    String? email,
    UserRole? role,
  }) {
    return CurrentUser(
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      companyId: companyId ?? this.companyId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  // ===========================================================
  // Debug
  // ===========================================================

  @override
  String toString() {
    return '''
CurrentUser(
  userId: $userId,
  employeeId: $employeeId,
  companyId: $companyId,
  fullName: $fullName,
  email: $email,
  role: ${role.value},
)
''';
  }
}