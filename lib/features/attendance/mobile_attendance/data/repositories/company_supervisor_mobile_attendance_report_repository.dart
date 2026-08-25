// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Repository
//
// Purpose:
// - Company-scoped attendance reports
// - Supervisor-scoped attendance reports
// - Optional department-scoped filtering
// - Today / Date / Date Range / Current Month reports
// - Attendance summary
// - Refresh support
//
// Architecture:
// - Domain / Repository Contract
//
// Version : 1.0.0
// ============================================================================

import '../../domain/entities/company_supervisor_mobile_attendance_report_entity.dart';

// ============================================================================
// COMPANY SUPERVISOR MOBILE ATTENDANCE REPORT REPOSITORY
// ============================================================================
//
// Company-scoped + Supervisor-scoped + Department-scoped attendance
// report operations.
//
// IMPORTANT:
// Every report request requires [companyId] and [supervisorId].
//
// [departmentId] is optional because a supervisor may be allowed to
// view all assigned departments or a specifically selected department.
//
// ============================================================================

abstract class CompanySupervisorMobileAttendanceReportRepository {
  // ==========================================================================
  // GET TODAY REPORTS
  // ==========================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>>
  getTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });

  // ==========================================================================
  // GET REPORT BY DATE
  // ==========================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>>
  getReportsByDate({
    required String companyId,
    required String supervisorId,
    required DateTime date,
    String? departmentId,
  });

  // ==========================================================================
  // GET REPORTS BY DATE RANGE
  // ==========================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>>
  getReportsByDateRange({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  });

  // ==========================================================================
  // GET CURRENT MONTH REPORTS
  // ==========================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>>
  getCurrentMonthReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });

  // ==========================================================================
  // GET REPORT SUMMARY
  // ==========================================================================

  Future<Map<String, dynamic>> getReportSummary({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  });

  // ==========================================================================
  // REFRESH TODAY REPORTS
  // ==========================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>>
  refreshTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });
}