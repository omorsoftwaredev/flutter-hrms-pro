/// ===============================================================
/// HRMS Pro
/// Supervisor Dashboard Router
///
/// Version : 1.0.1
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/pages/supervisor_attendance_report_page.dart';
import 'route_paths.dart';

class SupervisorDashboardRouter {
  const SupervisorDashboardRouter._();

  static List<RouteBase> get routes => [
    // ===========================================================
    // Supervisor Attendance Report
    // ===========================================================

    GoRoute(
      path: RoutePaths.supervisorEmployeeAttendanceReport,
      name: 'supervisorEmployeeAttendanceReport',
      builder: (context, state) {
        final supervisorEmployeeId =
        state.uri.queryParameters['supervisorEmployeeId'];

        if (supervisorEmployeeId == null ||
            supervisorEmployeeId.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Supervisor Employee ID not found.',
              ),
            ),
          );
        }

        return SupervisorAttendanceReportPage(
          supervisorEmployeeId: supervisorEmployeeId,
        );
      },
    ),
  ];
}