/// ===============================================================
/// Flutter HRMS Pro
/// Permissions
///
/// Version : 1.0.0
/// ===============================================================

enum Permission {
  // Dashboard
  viewDashboard,

  // Company
  companyView,
  companyCreate,
  companyUpdate,
  companyDelete,

  // Department
  departmentView,
  departmentCreate,
  departmentUpdate,
  departmentDelete,

  // Designation
  designationView,
  designationCreate,
  designationUpdate,
  designationDelete,

  // Shift
  shiftView,
  shiftCreate,
  shiftUpdate,
  shiftDelete,

  // Employee
  employeeView,
  employeeCreate,
  employeeUpdate,
  employeeDelete,

  // Attendance
  attendanceView,
  attendanceCreate,
  attendanceUpdate,
  attendanceDelete,
  attendanceCheckIn,
  attendanceCheckOut,

  // Leave
  leaveView,
  leaveCreate,
  leaveApprove,

  // Reports
  reportsView,

  // Settings
  settingsView,
}