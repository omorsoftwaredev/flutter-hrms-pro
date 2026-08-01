/// ===============================================================
/// Flutter HRMS Pro
/// Role Definitions
///
/// Version : 0.8.1
/// ===============================================================

enum UserRole {
  developer,
  superAdmin,
  companyOwner,
  supervisor,
  employee,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.developer:
        return 'developer';

      case UserRole.superAdmin:
        return 'super_admin';

      case UserRole.companyOwner:
        return 'company_owner';

      case UserRole.supervisor:
        return 'supervisor';

      case UserRole.employee:
        return 'employee';
    }
  }

  String get title {
    switch (this) {
      case UserRole.developer:
        return 'Developer';

      case UserRole.superAdmin:
        return 'Super Admin';

      case UserRole.companyOwner:
        return 'Company Owner';

      case UserRole.supervisor:
        return 'Supervisor';

      case UserRole.employee:
        return 'Employee';
    }
  }

  static UserRole fromString(String? role) {
    final value = (role ?? '').trim().toLowerCase();

    switch (value) {
      case 'developer':
        return UserRole.developer;

      case 'super_admin':
      case 'superadmin':
        return UserRole.superAdmin;

      case 'company_owner':
      case 'companyowner':
        return UserRole.companyOwner;

      case 'supervisor':
        return UserRole.supervisor;

      case 'employee':
        return UserRole.employee;

      default:
        return UserRole.employee;
    }
  }
}