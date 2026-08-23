class SupervisorMobileAttendanceReportEntity {
  //=================================================================
  // ATTENDANCE
  //=================================================================

  final DateTime attendanceDate;

  final String? attendanceId;

  final String? attendanceNo;

  final String? companyId;

  final String? employeeId;

  final String? departmentId;

  final String? designationId;

  final String? shiftId;

  final String attendanceStatus;

  //=================================================================
  // EMPLOYEE
  //=================================================================

  final String? employeeCode;

  final String? employeeName;

  final String? employeeEmail;

  final String? employeePhone;

  final String? employeeProfilePhoto;

  //=================================================================
  // DEPARTMENT
  //=================================================================

  final String? departmentName;

  //=================================================================
  // DESIGNATION
  //=================================================================

  final String? designationName;

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
  // WORKING DAY
  //=================================================================

  final int dayOfWeek;

  final bool isWorkingDay;

  //=================================================================
  // CHECK IN
  //=================================================================

  final DateTime? checkInTime;

  final double? checkInLatitude;

  final double? checkInLongitude;

  final String? checkInAddress;

  final double? checkInAccuracy;

  //=================================================================
  // CHECK OUT
  //=================================================================

  final DateTime? checkOutTime;

  final double? checkOutLatitude;

  final double? checkOutLongitude;

  final String? checkOutAddress;

  final double? checkOutAccuracy;

  //=================================================================
  // REPORT
  //=================================================================

  final String reportStatus;

  final int lateMinutes;

  final int earlyLeaveMinutes;

  final int actualWorkMinutes;

  final int overtimeMinutes;

  //=================================================================
  // STATUS FLAGS
  //=================================================================

  final bool isLate;

  final bool isEarlyOut;

  final bool isAbsent;

  final bool isHoliday;

  final bool isPresent;

  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const SupervisorMobileAttendanceReportEntity({
    required this.attendanceDate,
    this.attendanceId,
    this.attendanceNo,
    this.companyId,
    this.employeeId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    required this.attendanceStatus,
    this.employeeCode,
    this.employeeName,
    this.employeeEmail,
    this.employeePhone,
    this.employeeProfilePhoto,
    this.departmentName,
    this.designationName,
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
    required this.reportStatus,
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
}