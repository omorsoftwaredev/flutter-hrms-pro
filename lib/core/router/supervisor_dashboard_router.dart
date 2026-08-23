/// ===============================================================
/// HRMS Pro
/// Supervisor Dashboard Router
///
/// Version : 1.0.1
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_hrms_pro/features/attendance/mobile_attendance/presentation/pages/supervisor_mobile_attendance_report_page.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';

class SupervisorDashboardRouter {
  const SupervisorDashboardRouter._();

  static List<RouteBase> get routes => [
    // ===========================================================
    // Supervisor Attendance Report
    // ===========================================================

    // GoRoute(
    //   path: RoutePaths.supervisorEmployeeAttendanceReport,
    //   name: 'supervisorEmployeeAttendanceReport',
    //   builder: (context, state) {
    //     final supervisorEmployeeId =
    //     state.uri.queryParameters['supervisorEmployeeId'];
    //
    //     if (supervisorEmployeeId == null ||
    //         supervisorEmployeeId.isEmpty) {
    //       return const Scaffold(
    //         body: Center(
    //           child: Text(
    //             'Supervisor Employee ID not found.',
    //           ),
    //         ),
    //       );
    //     }
    //
    //     return SupervisorMobileAttendanceReportPage(
    //       supervisorEmployeeId: supervisorEmployeeId,
    //     );
    //   },
    // ),

    GoRoute(
      path: RoutePaths.supervisorEmployeeAttendanceReport,
      name: 'supervisorEmployeeAttendanceReport',
      builder: (context, state) {
        final supervisorEmployeeId =
        state.uri.queryParameters['supervisorEmployeeId'];

        final companyId =
        state.uri.queryParameters['companyId'];

        //===============================================================
        // VALIDATION
        //===============================================================

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

        if (companyId == null || companyId.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Company ID not found.',
              ),
            ),
          );
        }

        //===============================================================
        // PAGE
        //===============================================================

        return SupervisorMobileAttendanceReportPage(
          supervisorId: supervisorEmployeeId,
          companyId: companyId,
        );
      },
    ),

  ];
}