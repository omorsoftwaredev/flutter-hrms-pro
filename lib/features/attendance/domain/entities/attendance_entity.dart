class AttendanceEntity {
  final String? id;

  final String? companyId;
  final String? employeeId;
  final String? departmentId;
  final String? designationId;
  final String? shiftId;
  final String? holidayId;
  final String? leaveRequestId;

  final String attendanceNo;

  final DateTime attendanceDate;

  final String? shiftName;

  final String? shiftStart;
  final String? shiftEnd;

  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  final int workMinutes;
  final int overtimeMinutes;
  final int lateMinutes;
  final int earlyExitMinutes;

  final String attendanceStatus;

  final bool isLeave;
  final bool isHoliday;
  final bool isWeekend;

  final double? checkInLatitude;
  final double? checkInLongitude;

  final double? checkOutLatitude;
  final double? checkOutLongitude;

  final String? deviceName;
  final String? deviceId;
  final String? ipAddress;

  final String? remarks;

  final bool isActive;

  final String? createdBy;
  final String? updatedBy;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? checkInAddress;
  final String? checkOutAddress;

  const AttendanceEntity({
    this.id,
    this.companyId,
    this.employeeId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    this.holidayId,
    this.leaveRequestId,
    required this.attendanceNo,
    required this.attendanceDate,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
    this.checkInTime,
    this.checkOutTime,
    this.workMinutes = 0,
    this.overtimeMinutes = 0,
    this.lateMinutes = 0,
    this.earlyExitMinutes = 0,
    this.attendanceStatus = 'PRESENT',
    this.isLeave = false,
    this.isHoliday = false,
    this.isWeekend = false,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.deviceName,
    this.deviceId,
    this.ipAddress,
    this.remarks,
    this.isActive = true,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.checkInAddress,
    this.checkOutAddress,
  });

  AttendanceEntity copyWith({
    String? id,
    String? companyId,
    String? employeeId,
    String? departmentId,
    String? designationId,
    String? shiftId,
    String? holidayId,
    String? leaveRequestId,
    String? attendanceNo,
    DateTime? attendanceDate,
    String? shiftName,
    String? shiftStart,
    String? shiftEnd,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? workMinutes,
    int? overtimeMinutes,
    int? lateMinutes,
    int? earlyExitMinutes,
    String? attendanceStatus,
    bool? isLeave,
    bool? isHoliday,
    bool? isWeekend,
    double? checkInLatitude,
    double? checkInLongitude,
    double? checkOutLatitude,
    double? checkOutLongitude,
    String? deviceName,
    String? deviceId,
    String? ipAddress,
    String? remarks,
    bool? isActive,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? checkInAddress,
    String? checkOutAddress,
  }) {
    return AttendanceEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      employeeId: employeeId ?? this.employeeId,
      departmentId: departmentId ?? this.departmentId,
      designationId: designationId ?? this.designationId,
      shiftId: shiftId ?? this.shiftId,
      holidayId: holidayId ?? this.holidayId,
      leaveRequestId: leaveRequestId ?? this.leaveRequestId,
      attendanceNo: attendanceNo ?? this.attendanceNo,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      shiftName: shiftName ?? this.shiftName,
      shiftStart: shiftStart ?? this.shiftStart,
      shiftEnd: shiftEnd ?? this.shiftEnd,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      workMinutes: workMinutes ?? this.workMinutes,
      overtimeMinutes: overtimeMinutes ?? this.overtimeMinutes,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      earlyExitMinutes: earlyExitMinutes ?? this.earlyExitMinutes,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      isLeave: isLeave ?? this.isLeave,
      isHoliday: isHoliday ?? this.isHoliday,
      isWeekend: isWeekend ?? this.isWeekend,
      checkInLatitude: checkInLatitude ?? this.checkInLatitude,
      checkInLongitude: checkInLongitude ?? this.checkInLongitude,
      checkOutLatitude: checkOutLatitude ?? this.checkOutLatitude,
      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      ipAddress: ipAddress ?? this.ipAddress,
      remarks: remarks ?? this.remarks,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checkInAddress:
      checkInAddress ?? this.checkInAddress,

      checkOutAddress:
      checkOutAddress ?? this.checkOutAddress,
    );
  }
}