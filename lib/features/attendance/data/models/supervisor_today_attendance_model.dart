import '../../domain/entities/attendance_report_entity.dart';

class SupervisorTodayAttendanceModel {
  final String employeeId;
  final String employeeCode;
  final String employeeName;

  final String? departmentId;
  final String? departmentName;

  final AttendanceReportStatus status;

  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  final String? checkInAddress;
  final String? checkOutAddress;

  final int lateMinutes;
  final int earlyExitMinutes;
  final int workMinutes;

  const SupervisorTodayAttendanceModel({
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.departmentId,
    required this.departmentName,
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.lateMinutes,
    required this.earlyExitMinutes,
    required this.workMinutes,
  });

  String get statusText {
    switch (status) {
      case AttendanceReportStatus.present:
        return 'Present';

      case AttendanceReportStatus.late:
        return 'Late';

      case AttendanceReportStatus.absent:
        return 'Absent';

      case AttendanceReportStatus.leave:
        return 'Leave';

      case AttendanceReportStatus.dayOff:
        return 'Day Off';

      case AttendanceReportStatus.holiday:
        return 'Holiday';

      case AttendanceReportStatus.earlyOut:
        return 'Early Out';
    }
  }
}