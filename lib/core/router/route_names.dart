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
  static const changePassword = 'changePassword';
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
  static const departmentView = 'department-view';
  static const departments = 'departments';
  static const departmentCreate = 'departmentCreate';
  static const departmentEdit = 'departmentEdit';

  // =============================================================
  // Designation
  // =============================================================
  static const designationView = 'designation-view';
  static const designations = 'designations';
  static const designationCreate = 'designationCreate';
  static const designationEdit = 'designationEdit';

  // =============================================================
  // Shift
  // =============================================================
  static const shiftView = 'shift-view';
  static const shifts = 'shifts';
  static const shiftCreate = 'shiftCreate';
  static const shiftEdit = 'shiftEdit';

  // Role
  // =============================================================
  static const roleView = 'role-view';
  static const roles = 'roles';
  static const roleCreate = 'roleCreate';
  static const roleEdit = 'roleEdit';

  // RolePermissions
  // =============================================================
  static const rolePermissionsView = 'rolePermissions-view';
  static const rolePermissions = 'rolePermissions';
  static const rolePermissionsCreate = 'rolePermissionsCreate';
  static const rolePermissionsEdit = 'rolePermissionsEdit';

  // =============================================================
  // Employee
  // =============================================================

  // Employee
  static const employees = 'employees';
  static const employeeCreate = 'employee-create';
  static const employeeEdit = 'employee-edit';
  static const employeeView = 'employee-view';
  static const supervisors = 'supervisors';


  // Employee Account

  static const employeeAccounts =
      'employee-accounts';

  static const employeeAccountCreate =
      'employee-account-create';

  static const employeeAccountEdit =
      'employee-account-edit';

  static const employeeAccountView =
      'employee-account-view';

  // =============================================================
  // Attendance
  // =============================================================

  static const attendance = 'attendance';
  static const String employeeAttendanceReport = 'employeeAttendanceReport';
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
}