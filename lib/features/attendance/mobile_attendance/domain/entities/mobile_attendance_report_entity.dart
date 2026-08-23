class MobileAttendanceReportEntity {
  //=================================================================
  // DATE
  //=================================================================

  final DateTime attendanceDate;

  //=================================================================
  // ATTENDANCE
  //=================================================================

  final String? attendanceId;

  final String? attendanceNo;

  final String? companyId;

  final String? employeeId;

  final String? departmentId;

  final String? designationId;

  final String? shiftId;

  final String attendanceStatus;

  //=================================================================
  // SHIFT
  //=================================================================

  final String? shiftName;

  final String? shiftCode;

  final String? shiftStartTime;

  final String? shiftEndTime;

  final int breakMinutes;

  final int lateGraceMinutes;

  final int earlyLeaveGraceMinutes;

  final int minimumWorkingMinutes;

  final int halfDayThresholdMinutes;

  final bool isNightShift;

  final bool isFlexible;

  final bool checkInRequired;

  final bool checkOutRequired;

  //=================================================================
  // COMPANY WORKING DAY
  //=================================================================

  final int dayOfWeek;

  final bool isWorkingDay;

  //=================================================================
  // CHECK-IN
  //=================================================================

  final DateTime? checkInTime;

  final double? checkInLatitude;

  final double? checkInLongitude;

  final String? checkInAddress;

  final double? checkInAccuracy;

  //=================================================================
  // CHECK-OUT
  //=================================================================

  final DateTime? checkOutTime;

  final double? checkOutLatitude;

  final double? checkOutLongitude;

  final String? checkOutAddress;

  final double? checkOutAccuracy;

  //=================================================================
  // CALCULATED REPORT INFORMATION
  //=================================================================

  final String reportStatus;

  final int lateMinutes;

  final int earlyLeaveMinutes;

  final int actualWorkMinutes;

  final int overtimeMinutes;

  final bool isLate;

  final bool isEarlyOut;

  final bool isAbsent;

  final bool isHoliday;

  final bool isPresent;

  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const MobileAttendanceReportEntity({
    required this.attendanceDate,

    this.attendanceId,

    this.attendanceNo,

    this.companyId,

    this.employeeId,

    this.departmentId,

    this.designationId,

    this.shiftId,

    this.attendanceStatus = 'PRESENT',

    this.shiftName,

    this.shiftCode,

    this.shiftStartTime,

    this.shiftEndTime,

    this.breakMinutes = 0,

    this.lateGraceMinutes = 0,

    this.earlyLeaveGraceMinutes = 0,

    this.minimumWorkingMinutes = 0,

    this.halfDayThresholdMinutes = 0,

    this.isNightShift = false,

    this.isFlexible = false,

    this.checkInRequired = true,

    this.checkOutRequired = true,

    required this.dayOfWeek,

    this.isWorkingDay = true,

    this.checkInTime,

    this.checkInLatitude,

    this.checkInLongitude,

    this.checkInAddress,

    this.checkInAccuracy,

    this.checkOutTime,

    this.checkOutLatitude,

    this.checkOutLongitude,

    this.checkOutAddress,

    this.checkOutAccuracy,

    this.reportStatus = 'ABSENT',

    this.lateMinutes = 0,

    this.earlyLeaveMinutes = 0,

    this.actualWorkMinutes = 0,

    this.overtimeMinutes = 0,

    this.isLate = false,

    this.isEarlyOut = false,

    this.isAbsent = false,

    this.isHoliday = false,

    this.isPresent = false,
  });

  //=================================================================
  // COPY WITH
  //=================================================================

  MobileAttendanceReportEntity copyWith({
    DateTime? attendanceDate,

    String? attendanceId,

    String? attendanceNo,

    String? companyId,

    String? employeeId,

    String? departmentId,

    String? designationId,

    String? shiftId,

    String? attendanceStatus,

    String? shiftName,

    String? shiftCode,

    String? shiftStartTime,

    String? shiftEndTime,

    int? breakMinutes,

    int? lateGraceMinutes,

    int? earlyLeaveGraceMinutes,

    int? minimumWorkingMinutes,

    int? halfDayThresholdMinutes,

    bool? isNightShift,

    bool? isFlexible,

    bool? checkInRequired,

    bool? checkOutRequired,

    int? dayOfWeek,

    bool? isWorkingDay,

    DateTime? checkInTime,

    double? checkInLatitude,

    double? checkInLongitude,

    String? checkInAddress,

    double? checkInAccuracy,

    DateTime? checkOutTime,

    double? checkOutLatitude,

    double? checkOutLongitude,

    String? checkOutAddress,

    double? checkOutAccuracy,

    String? reportStatus,

    int? lateMinutes,

    int? earlyLeaveMinutes,

    int? actualWorkMinutes,

    int? overtimeMinutes,

    bool? isLate,

    bool? isEarlyOut,

    bool? isAbsent,

    bool? isHoliday,

    bool? isPresent,
  }) {
    return MobileAttendanceReportEntity(
      attendanceDate: attendanceDate ?? this.attendanceDate,

      attendanceId: attendanceId ?? this.attendanceId,

      attendanceNo: attendanceNo ?? this.attendanceNo,

      companyId: companyId ?? this.companyId,

      employeeId: employeeId ?? this.employeeId,

      departmentId: departmentId ?? this.departmentId,

      designationId: designationId ?? this.designationId,

      shiftId: shiftId ?? this.shiftId,

      attendanceStatus: attendanceStatus ?? this.attendanceStatus,

      shiftName: shiftName ?? this.shiftName,

      shiftCode: shiftCode ?? this.shiftCode,

      shiftStartTime: shiftStartTime ?? this.shiftStartTime,

      shiftEndTime: shiftEndTime ?? this.shiftEndTime,

      breakMinutes: breakMinutes ?? this.breakMinutes,

      lateGraceMinutes: lateGraceMinutes ?? this.lateGraceMinutes,

      earlyLeaveGraceMinutes:
          earlyLeaveGraceMinutes ?? this.earlyLeaveGraceMinutes,

      minimumWorkingMinutes:
          minimumWorkingMinutes ?? this.minimumWorkingMinutes,

      halfDayThresholdMinutes:
          halfDayThresholdMinutes ?? this.halfDayThresholdMinutes,

      isNightShift: isNightShift ?? this.isNightShift,

      isFlexible: isFlexible ?? this.isFlexible,

      checkInRequired: checkInRequired ?? this.checkInRequired,

      checkOutRequired: checkOutRequired ?? this.checkOutRequired,

      dayOfWeek: dayOfWeek ?? this.dayOfWeek,

      isWorkingDay: isWorkingDay ?? this.isWorkingDay,

      checkInTime: checkInTime ?? this.checkInTime,

      checkInLatitude: checkInLatitude ?? this.checkInLatitude,

      checkInLongitude: checkInLongitude ?? this.checkInLongitude,

      checkInAddress: checkInAddress ?? this.checkInAddress,

      checkInAccuracy: checkInAccuracy ?? this.checkInAccuracy,

      checkOutTime: checkOutTime ?? this.checkOutTime,

      checkOutLatitude: checkOutLatitude ?? this.checkOutLatitude,

      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,

      checkOutAddress: checkOutAddress ?? this.checkOutAddress,

      checkOutAccuracy: checkOutAccuracy ?? this.checkOutAccuracy,

      reportStatus: reportStatus ?? this.reportStatus,

      lateMinutes: lateMinutes ?? this.lateMinutes,

      earlyLeaveMinutes: earlyLeaveMinutes ?? this.earlyLeaveMinutes,

      actualWorkMinutes: actualWorkMinutes ?? this.actualWorkMinutes,

      overtimeMinutes: overtimeMinutes ?? this.overtimeMinutes,

      isLate: isLate ?? this.isLate,

      isEarlyOut: isEarlyOut ?? this.isEarlyOut,

      isAbsent: isAbsent ?? this.isAbsent,

      isHoliday: isHoliday ?? this.isHoliday,

      isPresent: isPresent ?? this.isPresent,
    );
  }
}
