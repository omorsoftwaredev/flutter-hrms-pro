import 'roles.dart';
import 'user_type.dart';
import 'permissions.dart';
import 'role_permissions.dart';

class CurrentUser {
  final String userId;
  final String employeeId;
  final String companyId;

  final String fullName;
  final String email;

  final UserRole role;
  final UserType userType;

  const CurrentUser({
    required this.userId,
    required this.employeeId,
    required this.companyId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.userType,
  });

  // ===========================================================
  // Login
  // ===========================================================

  bool get isLoggedIn => userId.isNotEmpty;

  // ===========================================================
  // User Type
  // ===========================================================

  bool get isDeveloper =>
      userType == UserType.developer;

  bool get isCompany =>
      userType == UserType.company;

  bool get isHr =>
      userType == UserType.hr;

  bool get isSupervisor =>
      userType == UserType.supervisor;

  bool get isEmployee =>
      userType == UserType.employee;

  // ===========================================================
  // Permission
  // ===========================================================

  Set<Permission> get permissions =>
      RolePermissions.permissions(role);

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  bool can(Permission permission) {
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
    UserType? userType,
  }) {
    return CurrentUser(
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      companyId: companyId ?? this.companyId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      userType: userType ?? this.userType,
    );
  }

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
  userType: $userType,
)
''';
  }
}