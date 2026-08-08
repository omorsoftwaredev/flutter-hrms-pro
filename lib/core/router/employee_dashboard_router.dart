/// ===============================================================
/// HRMS Pro
/// Employee Dashboard Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/attendance/presentation/pages/attendance_mobile_page.dart';
import '../../features/attendance/presentation/pages/employee_attendance_report_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/dashboard/pages/employee_dashboard_page.dart';
import 'route_paths.dart';
class EmployeeDashboardRouter {
  const EmployeeDashboardRouter._();

  static List<RouteBase> get routes => [

    // ===========================================================
    // Mobile Attendance
    // ===========================================================
      GoRoute(
        path: RoutePaths.mobileAttendance,
        name: 'mobileAttendance',
        builder: (context, state) {
          return const AttendanceMobilePage();
        },
      ),

    // ===========================================================
// Attendance Report
// ===========================================================
    GoRoute(
      path: RoutePaths.employeeAttendanceReport,
      name: 'employeeAttendanceReport',
      builder: (context, state) {
        final employeeId =
        state.uri.queryParameters['employeeId'];

        if (employeeId == null || employeeId.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Employee ID not found.',
              ),
            ),
          );
        }

        return EmployeeAttendanceReportPage(
          employeeId: employeeId,
        );
      },
    ),
    // ===========================================================
    // Change Password
    // ===========================================================
    GoRoute(
      path: RoutePaths.changePassword,
      name: 'changePassword',
      builder: (context, state) {
        return const ChangePasswordPage();
      },
    ),

  ];
}