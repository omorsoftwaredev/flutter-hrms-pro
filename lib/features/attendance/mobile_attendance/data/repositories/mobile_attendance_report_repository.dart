import '../../domain/entities/mobile_attendance_report_entity.dart';

abstract class MobileAttendanceReportRepository {
  //=================================================================
  // GET TODAY REPORT
  //=================================================================

  Future<MobileAttendanceReportEntity?> getTodayReport({
    required String employeeId,
  });

  //=================================================================
  // GET REPORT BY DATE
  //=================================================================

  Future<MobileAttendanceReportEntity?> getReportByDate({
    required String employeeId,
    required DateTime date,
  });

  //=================================================================
  // GET REPORT BY DATE RANGE
  //=================================================================

  Future<List<MobileAttendanceReportEntity>> getReportsByDateRange({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  });

  //=================================================================
  // GET CURRENT MONTH REPORT
  //=================================================================

  Future<List<MobileAttendanceReportEntity>> getCurrentMonthReports({
    required String employeeId,
  });

  //=================================================================
  // GET REPORT SUMMARY
  //=================================================================

  Future<Map<String, dynamic>> getReportSummary({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  });

  //=================================================================
  // REFRESH TODAY REPORT
  //=================================================================

  Future<MobileAttendanceReportEntity?> refreshTodayReport({
    required String employeeId,
  });
}