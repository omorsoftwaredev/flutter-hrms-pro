/// ===============================================================
/// Flutter HRMS Pro
/// Route Names
///
/// Version : 0.8.0
/// ===============================================================

class RouteNames {
  const RouteNames._();

  // =============================================================
  // Authentication
  // =============================================================

  static const splash = 'splash';
  static const login = 'login';
  static const forgotPassword = 'forgotPassword';
  static const updatePassword = 'updatePassword';

  // =============================================================
  // Dashboard
  // =============================================================

  static const dashboard = 'dashboard';

  static const developerDashboard = 'developerDashboard';
  static const companyDashboard = 'companyDashboard';
  static const hrDashboard = 'hrDashboard';
  static const supervisorDashboard = 'supervisorDashboard';
  static const employeeDashboard = 'employeeDashboard';

  // =============================================================
  // Company
  // =============================================================

  static const companies = 'companies';
  static const companyCreate = 'companyCreate';
  static const companyDetails = 'companyDetails';
  static const companyEdit = 'companyEdit';

  // =============================================================
  // Department
  // =============================================================

  static const departments = 'departments';
  static const departmentCreate = 'departmentCreate';
  static const departmentEdit = 'departmentEdit';

  // =============================================================
  // Designation
  // =============================================================

  static const designations = 'designations';
  static const designationCreate = 'designationCreate';
  static const designationEdit = 'designationEdit';

  // =============================================================
  // Shift
  // =============================================================

  static const shifts = 'shifts';
  static const shiftCreate = 'shiftCreate';
  static const shiftEdit = 'shiftEdit';

  // =============================================================
  // Employee
  // =============================================================

  static const employees = 'employees';
  static const employeeCreate = 'employeeCreate';
  static const employeeDetails = 'employeeDetails';
  static const employeeEdit = 'employeeEdit';

  // =============================================================
  // Attendance
  // =============================================================

  static const attendance = 'attendance';
  static const mobileAttendance = 'mobileAttendance';
  static const attendanceHistory = 'attendanceHistory';

  // =============================================================
  // Leave
  // =============================================================

  static const leave = 'leave';
  static const leaveApply = 'leaveApply';
  static const leaveHistory = 'leaveHistory';
  static const leaveApproval = 'leaveApproval';

  // =============================================================
  // Reports
  // =============================================================

  static const reports = 'reports';
  static const attendanceReport = 'attendanceReport';
  static const employeeReport = 'employeeReport';
  static const leaveReport = 'leaveReport';

  // =============================================================
  // Notifications
  // =============================================================

  static const notifications = 'notifications';

  // =============================================================
  // Settings
  // =============================================================

  static const settings = 'settings';

  // =============================================================
  // Profile
  // =============================================================

  static const profile = 'profile';

  // =============================================================
  // Error Pages
  // =============================================================

  static const unauthorized = 'unauthorized';
  static const notFound = 'notFound';

  // Company Account

  static const companyAccounts = 'companyAccounts';

  static const companyAccountCreate =
      'companyAccountCreate';

  static const companyAccountEdit =
      'companyAccountEdit';

  static const companyAccountDetails =
      'companyAccountDetails';

  static const roles = 'roles';
  static const roleCreate = 'roleCreate';
  static const roleEdit = 'roleEdit';

  static const rolePermissions = 'rolePermissions';
  static const rolePermissionEdit =
      'rolePermissionEdit';
}