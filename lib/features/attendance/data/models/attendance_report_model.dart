import '../../domain/entities/attendance_report_entity.dart';

class AttendanceReportModel extends AttendanceReportEntity {
  const AttendanceReportModel({
    required super.date,
    required super.status,

    // Attendance Time
    super.checkInTime,
    super.checkOutTime,

    // Location
    super.checkInAddress,
    super.checkOutAddress,

    // Attendance Calculation
    super.lateMinutes,
    super.earlyExitMinutes,
    super.workMinutes,

    // Day Information
    super.isWeekend,
    super.isHoliday,
    super.isLeave,
  });

  // ============================================================
  // FROM ENTITY
  // ============================================================

  factory AttendanceReportModel.fromEntity(
      AttendanceReportEntity entity,
      ) {
    return AttendanceReportModel(
      date: entity.date,
      status: entity.status,

      // Attendance Time
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,

      // Location
      checkInAddress: entity.checkInAddress,
      checkOutAddress: entity.checkOutAddress,

      // Attendance Calculation
      lateMinutes: entity.lateMinutes,
      earlyExitMinutes: entity.earlyExitMinutes,
      workMinutes: entity.workMinutes,

      // Day Information
      isWeekend: entity.isWeekend,
      isHoliday: entity.isHoliday,
      isLeave: entity.isLeave,
    );
  }
}