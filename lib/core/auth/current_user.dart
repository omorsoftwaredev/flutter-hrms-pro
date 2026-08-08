/// ===============================================================
/// Flutter HRMS Pro
/// Current User
///
/// Version : 2.1.0
/// ===============================================================

import 'roles.dart';
import 'user_type.dart';
import 'permissions.dart';
import 'role_permissions.dart';

class CurrentUser {
  // =============================================================
  // Common Login Information
  // =============================================================

  final String userId;

  /// Login username
  final String loginName;

  /// Display user type
  ///
  /// Developer / Company / Employee
  final UserType userType;

  /// Permission role
  final UserRole role;

  final String fullName;
  final String email;

  // =============================================================
  // Employee Information
  // =============================================================

  final String employeeId;

  final String? employeeCode;

  final String? employeeName;

  // =============================================================
  // Company Information
  // =============================================================

  final String companyId;

  final String? companyName;

  // =============================================================
  // Department Information
  // =============================================================

  final String? departmentId;

  final String? departmentName;

  // =============================================================
  // Designation Information
  // =============================================================

  final String? designationId;

  final String? designationName;

  // =============================================================
  // Constructor
  // =============================================================

  const CurrentUser({
    required this.userId,
    required this.loginName,
    required this.userType,
    required this.role,
    required this.fullName,
    required this.email,

    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,

    required this.companyId,
    required this.companyName,

    required this.departmentId,
    required this.departmentName,

    required this.designationId,
    required this.designationName,
  });

  // =============================================================
  // Login
  // =============================================================

  bool get isLoggedIn {
    return userId.isNotEmpty;
  }

  // =============================================================
  // Login User
  // =============================================================
  //
  // UI-তে "Login User" হিসেবে এটা ব্যবহার করতে পারবে।
  //
  // Example:
  // Employee
  // Company
  // Developer
  //

  String get loginUser {
    switch (userType) {
      case UserType.developer:
        return 'Developer';

      case UserType.company:
        return 'Company';

      case UserType.hr:
        return 'HR';

      case UserType.supervisor:
        return 'Supervisor';

      case UserType.employee:
        return 'Employee';
    }
  }

  // =============================================================
  // User Type Helpers
  // =============================================================

  bool get isDeveloper => userType == UserType.developer;

  bool get isCompany => userType == UserType.company;

  bool get isHr => userType == UserType.hr;

  bool get isSupervisor => userType == UserType.supervisor;

  bool get isEmployee => userType == UserType.employee;

  // =============================================================
  // Role Helpers
  // =============================================================

  bool get isDeveloperRole => role == UserRole.developer;

  bool get isCompanyOwner => role == UserRole.companyOwner;

  bool get isHrRole => role == UserRole.hr;

  bool get isSupervisorRole => role == UserRole.supervisor;

  bool get isEmployeeRole => role == UserRole.employee;

  // =============================================================
  // Permission
  // =============================================================

  Set<Permission> get permissions => RolePermissions.permissions(role);

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  bool can(Permission permission) {
    return hasPermission(permission);
  }

  // =============================================================
  // Display Helpers
  // =============================================================

  /// Employee display name
  ///
  /// Employee Name থাকলে সেটা দেখাবে,
  /// না থাকলে fullName দেখাবে।
  String get displayEmployeeName {
    if (employeeName != null && employeeName!.trim().isNotEmpty) {
      return employeeName!;
    }

    if (fullName.trim().isNotEmpty) {
      return fullName;
    }

    return loginName;
  }

  /// Company display name
  ///
  /// Company Name থাকলে সেটা দেখাবে।
  /// না থাকলে empty থাকবে।
  String get displayCompanyName {
    if (companyName != null && companyName!.trim().isNotEmpty) {
      return companyName!;
    }

    return '';
  }

  /// Department display name
  String get displayDepartmentName {
    if (departmentName != null && departmentName!.trim().isNotEmpty) {
      return departmentName!;
    }

    return '';
  }

  /// Designation display name
  String get displayDesignationName {
    if (designationName != null && designationName!.trim().isNotEmpty) {
      return designationName!;
    }

    return '';
  }

  // =============================================================
  // Copy With
  // =============================================================

  CurrentUser copyWith({
    String? userId,
    String? loginName,
    UserType? userType,
    UserRole? role,
    String? fullName,
    String? email,

    String? employeeId,
    String? employeeCode,
    String? employeeName,

    String? companyId,
    String? companyName,

    String? departmentId,
    String? departmentName,

    String? designationId,
    String? designationName,
  }) {
    return CurrentUser(
      userId: userId ?? this.userId,
      loginName: loginName ?? this.loginName,
      userType: userType ?? this.userType,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,

      employeeId: employeeId ?? this.employeeId,

      employeeCode: employeeCode ?? this.employeeCode,

      employeeName: employeeName ?? this.employeeName,

      companyId: companyId ?? this.companyId,

      companyName: companyName ?? this.companyName,

      departmentId: departmentId ?? this.departmentId,

      departmentName: departmentName ?? this.departmentName,

      designationId: designationId ?? this.designationId,

      designationName: designationName ?? this.designationName,
    );
  }

  // =============================================================
  // Display Name
  // =============================================================

  /// Main display name for UI.
  ///
  /// Employee Name থাকলে Employee Name দেখাবে,
  /// না থাকলে Full Name,
  /// সেটাও না থাকলে Login Name দেখাবে.
  String get displayName {
    if (employeeName != null && employeeName!.trim().isNotEmpty) {
      return employeeName!;
    }

    if (fullName.trim().isNotEmpty) {
      return fullName;
    }

    return loginName;
  }

  // =============================================================
  // To String
  // =============================================================

  @override
  String toString() {
    return '''
CurrentUser(
  userId: $userId,
  loginName: $loginName,
  loginUser: $loginUser,
  userType: $userType,
  role: ${role.value},
  fullName: $fullName,
  email: $email,

  employeeId: $employeeId,
  employeeCode: $employeeCode,
  employeeName: $employeeName,

  companyId: $companyId,
  companyName: $companyName,

  departmentId: $departmentId,
  departmentName: $departmentName,

  designationId: $designationId,
  designationName: $designationName,
)
''';
  }
}
