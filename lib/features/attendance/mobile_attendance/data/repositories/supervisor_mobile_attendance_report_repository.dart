import '../../domain/entities/supervisor_mobile_attendance_report_entity.dart';

///=================================================================
/// SUPERVISOR MOBILE ATTENDANCE REPORT REPOSITORY
///=================================================================
///
/// Company-scoped + Supervisor-scoped + Department-scoped attendance
/// report operations.
///
/// IMPORTANT:
/// Every report request requires [companyId] and [supervisorId].
///
/// [departmentId] is optional because a supervisor may be allowed to
/// view all assigned departments or a specifically selected department.
///
///=================================================================

abstract class SupervisorMobileAttendanceReportRepository {
  //=================================================================
  // GET TODAY REPORTS
  //=================================================================

  Future<List<SupervisorMobileAttendanceReportEntity>> getTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });

  //=================================================================
  // GET REPORT BY DATE
  //=================================================================

  Future<List<SupervisorMobileAttendanceReportEntity>> getReportsByDate({
    required String companyId,
    required String supervisorId,
    required DateTime date,
    String? departmentId,
  });

  //=================================================================
  // GET REPORTS BY DATE RANGE
  //=================================================================

  Future<List<SupervisorMobileAttendanceReportEntity>> getReportsByDateRange({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  });

  //=================================================================
  // GET CURRENT MONTH REPORTS
  //=================================================================

  Future<List<SupervisorMobileAttendanceReportEntity>>
  getCurrentMonthReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });

  //=================================================================
  // GET REPORT SUMMARY
  //=================================================================

  Future<Map<String, dynamic>> getReportSummary({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  });

  //=================================================================
  // REFRESH TODAY REPORTS
  //=================================================================

  Future<List<SupervisorMobileAttendanceReportEntity>> refreshTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  });
}