import '../../domain/entities/attendance_report_entity.dart';

class AttendanceReportModel extends AttendanceReportEntity {
  const AttendanceReportModel({
    required super.date,
    required super.status,
    super.checkInTime,
    super.checkOutTime,
    super.checkInAddress,
    super.checkOutAddress,
    super.lateMinutes,
    super.earlyExitMinutes,
    super.workMinutes,
    super.isWeekend,
    super.isHoliday,
    super.isLeave,
  });

  factory AttendanceReportModel.fromEntity(
      AttendanceReportEntity entity,
      ) {
    return AttendanceReportModel(
      date: entity.date,
      status: entity.status,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      checkInAddress: entity.checkInAddress,
      checkOutAddress: entity.checkOutAddress,
      lateMinutes: entity.lateMinutes,
      earlyExitMinutes: entity.earlyExitMinutes,
      workMinutes: entity.workMinutes,
      isWeekend: entity.isWeekend,
      isHoliday: entity.isHoliday,
      isLeave: entity.isLeave,
    );
  }
}