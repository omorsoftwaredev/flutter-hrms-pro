/// ===============================================================
/// Flutter HRMS Pro
/// Route Paths
///
/// Version : 0.8.0
/// ===============================================================

class RoutePaths {
  const RoutePaths._();

  // =============================================================
  // Authentication
  // =============================================================

  static const splash = '/';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const changePassword = '/change-password';
  static const updatePassword = '/update-password';
  static const String supervisors = '/supervisors';
  static const String supervisorDepartmentAssignments =
      '/supervisor-department-assignments';
  static const String supervisorDepartmentManage =
      '/supervisor-department-manage';

  static const String supervisorDepartmentStatus =
      '/supervisor-department-status';

  static const String supervisorAssignment = '/supervisor-assignment';
  static const supervisorDashboard = '/supervisor-dashboard';

  // =============================================================
  // Dashboard
  // =============================================================

  static const dashboard = '/dashboard';

  // =============================================================
  // Dashboards
  // =============================================================

  static const developerDashboard = '/dashboard/developer';

  static const companyDashboard = '/dashboard/company';

  static const hrDashboard = '/dashboard/hr';

  static const String employeeDashboard = '/employee-dashboard';

  // =============================================================
  // Company
  // =============================================================

  static const companies = '/companies';
  static const companyCreate = '/companies/create';
  static const companyDetails = '/companies/details';
  static const companyEdit = '/companies/edit';

  // =============================================================
  // Department
  // =============================================================
  static const departmentView = '/departments/view';
  static const departments = '/departments';
  static const departmentCreate = '/departments/create';
  static const departmentEdit = '/departments/edit';

  // =============================================================
  // Designation
  // =============================================================
  static const designationView = '/designations/view';
  static const designations = '/designations';
  static const designationCreate = '/designations/create';
  static const designationEdit = '/designations/edit';

  // =============================================================
  // Shift
  // =============================================================
  static const shiftView = '/shifts/view';
  static const shifts = '/shifts';
  static const shiftCreate = '/shifts/create';
  static const shiftEdit = '/shifts/edit';

  // Role
  // =============================================================
  static const roleView = '/roles/view';
  static const roles = '/roles';
  static const roleCreate = '/roles/create';
  static const roleEdit = '/roles/edit';

  // RolePermissions
  // =============================================================
  static const rolePermissionsView = '/role-permissions/view';
  static const rolePermissions = '/role-permissions';
  static const rolePermissionsCreate = '/role-permissions/create';
  static const rolePermissionsEdit = '/role-permissions/edit';

  // =============================================================
  // Employee
  // =============================================================

  // Employee
  static const employees = '/dashboard/employees';

  static const employeeCreate = '/dashboard/employees/create';

  static const employeeEdit = '/dashboard/employees/edit';

  static const employeeView = '/dashboard/employees/view';

  // Employee Account

  static const employeesAccounts = '/dashboard/employee-accounts';

  static const employeeAccountCreate = '/dashboard/employee-accounts/create';

  static const employeeAccountEdit = '/dashboard/employee-accounts/edit';

  static const employeeAccountView = '/dashboard/employee-accounts/view';

  // =============================================================
  // Attendance
  // =============================================================
  static const String employeeAttendanceReport = '/employee-attendance-report';
  static const String supervisorEmployeeAttendanceReport =
      '/superviosr-employee-attendance-report';
  static const attendance = '/attendance';
  static const mobileAttendance = '/attendance/mobile';
  static const attendanceHistory = '/attendance/history';

  // =============================================================
  // Leave
  // =============================================================

  static const leave = '/leave';
  static const leaveApply = '/leave/apply';
  static const leaveHistory = '/leave/history';
  static const leaveApproval = '/leave/approval';

  // =============================================================
  // Reports
  // =============================================================

  static const reports = '/reports';
  static const attendanceReport = '/reports/attendance';
  static const employeeReport = '/reports/employees';
  static const leaveReport = '/reports/leave';

  // =============================================================
  // Notifications
  // =============================================================

  static const notifications = '/notifications';

  // =============================================================
  // Profile
  // =============================================================

  static const profile = '/profile';

  // =============================================================
  // Error Pages
  // =============================================================

  static const unauthorized = '/unauthorized';
  static const notFound = '/404';

  static const companyAccounts = '/company-accounts';

  static const companyAccountCreate = '/company-accounts/create';

  static const companyAccountEdit = '/company-accounts/edit';

  static const companyAccountDetails = '/company-accounts/details';

// =============================================================
// SETTINGS
// =============================================================

  static const String themeSettings =
      '/settings/theme';

  static const String workingDaysSettings =
      '/settings/attendance/working-days';
}
