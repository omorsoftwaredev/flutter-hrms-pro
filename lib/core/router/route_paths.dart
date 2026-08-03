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
  static const updatePassword = '/update-password';

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

  static const supervisorDashboard = '/dashboard/supervisor';

  static const employeeDashboard = '/dashboard/employee';

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

  static const departments = '/departments';
  static const departmentCreate = '/departments/create';
  static const departmentEdit = '/departments/edit';

  // =============================================================
  // Designation
  // =============================================================

  static const designations = '/designations';
  static const designationCreate = '/designations/create';
  static const designationEdit = '/designations/edit';

  // =============================================================
  // Shift
  // =============================================================

  static const shifts = '/shifts';
  static const shiftCreate = '/shifts/create';
  static const shiftEdit = '/shifts/edit';

  // =============================================================
  // Employee
  // =============================================================

  static const employees = '/employees';
  static const employeeCreate = '/employees/create';
  static const employeeDetails = '/employees/details';
  static const employeeEdit = '/employees/edit';

  // =============================================================
  // Attendance
  // =============================================================

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
  // Settings
  // =============================================================

  static const settings = '/settings';

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

  static const companyAccountCreate =
      '/company-accounts/create';

  static const companyAccountEdit =
      '/company-accounts/edit';

  static const companyAccountDetails =
      '/company-accounts/details';

  static const roles = '/roles';
  static const roleCreate = '/roles/create';
  static const roleEdit = '/roles/edit';

  static const rolePermissions = '/role-permissions';
  static const rolePermissionEdit =
      '/role-permissions/edit';



}