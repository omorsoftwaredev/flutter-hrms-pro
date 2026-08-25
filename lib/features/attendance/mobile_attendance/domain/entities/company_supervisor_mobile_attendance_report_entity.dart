// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Entity
//
// Version : 6.0.0
//
// Purpose:
// - Company-level supervisor mobile attendance report
// - Employee attendance information
// - Department / designation information
// - Shift information
// - Check-in / check-out information
// - Location information
// - Actual Hour (AH)
// - Working Hour (WH)
// - Overtime (OT)
// - Late calculation
// - Early-out calculation
// - Attendance status calculation
//
// Attendance Status Rules:
//
// 1. Present
// 2. Late
// 3. Early Out
// 4. Late + Early Out
// 5. Missing Check-out
// 6. Absent
// 7. Holiday
//
// Shift Rules:
//
// - graceInMinutes
//     Employee can check in within this grace period without being late.
//
// - graceOutMinutes
//     Employee can leave this many minutes before shift end without
//     being marked as Early Out.
//
// Calculation Rules:
//
// - AH = Shift Start -> Shift End
// - WH = Check-In -> Check-Out
// - OT = WH - AH
// - OT cannot be negative
//
// Architecture:
// - Domain Layer
// ============================================================================

class CompanySupervisorMobileAttendanceReportEntity {
  // ==========================================================================
  // ATTENDANCE
  // ==========================================================================

  final DateTime attendanceDate;

  final String? attendanceId;

  final String? attendanceNo;

  final String? companyId;

  final String? employeeId;

  final String? departmentId;

  final String? designationId;

  final String? shiftId;

  /// Raw attendance status received from backend.
  final String attendanceStatus;

  // ==========================================================================
  // EMPLOYEE
  // ==========================================================================

  final String? employeeCode;

  final String? employeeName;

  final String? employeeEmail;

  final String? employeePhone;

  final String? employeeProfilePhoto;

  // ==========================================================================
  // DEPARTMENT
  // ==========================================================================

  final String? departmentName;

  // ==========================================================================
  // DESIGNATION
  // ==========================================================================

  final String? designationName;

  // ==========================================================================
  // SHIFT
  // ==========================================================================

  final String? shiftName;

  final String? shiftCode;

  /// Shift start time.
  ///
  /// Supports:
  /// - 09:00
  /// - 09:00:00
  /// - 9:00 AM
  /// - 09:00 AM
  final String? shiftStartTime;

  /// Shift end time.
  ///
  /// Supports:
  /// - 18:00
  /// - 18:00:00
  /// - 6:00 PM
  /// - 06:00 PM
  final String? shiftEndTime;

  /// Break duration configured in shift.
  final int breakMinutes;

  /// Allowed late check-in grace period.
  ///
  /// Example:
  /// Shift Start = 10:00 AM
  /// graceInMinutes = 15
  ///
  /// Up to 10:15 AM = Present
  /// 10:16 AM = Late
  final int graceInMinutes;

  /// Allowed early check-out grace period.
  ///
  /// Example:
  /// Shift End = 7:00 PM
  /// graceOutMinutes = 15
  ///
  /// 6:45 PM = Present
  /// 6:44 PM = Early Out
  final int graceOutMinutes;

  /// Minimum expected working hours from shift configuration.
  final int minimumWorkingMinutes;

  final bool isNightShift;

  final bool isFlexible;

  final bool checkInRequired;

  final bool checkOutRequired;

  // ==========================================================================
  // WORKING DAY
  // ==========================================================================

  final int dayOfWeek;

  final bool isWorkingDay;

  // ==========================================================================
  // CHECK IN
  // ==========================================================================

  final DateTime? checkInTime;

  final double? checkInLatitude;

  final double? checkInLongitude;

  final String? checkInAddress;

  final double? checkInAccuracy;

  // ==========================================================================
  // CHECK OUT
  // ==========================================================================

  final DateTime? checkOutTime;

  final double? checkOutLatitude;

  final double? checkOutLongitude;

  final String? checkOutAddress;

  final double? checkOutAccuracy;

  // ==========================================================================
  // REPORT
  // ==========================================================================

  /// Backend report status, if available.
  final String reportStatus;

  // ==========================================================================
  // STATUS FLAGS
  //
  // These are kept as optional backend flags for compatibility.
  // Actual status is calculated from shift + attendance time.
  // ==========================================================================

  final bool isLate;

  final bool isEarlyOut;

  final bool isAbsent;

  final bool isHoliday;

  final bool isPresent;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const CompanySupervisorMobileAttendanceReportEntity({
    // ------------------------------------------------------------------------
    // Attendance
    // ------------------------------------------------------------------------

    required this.attendanceDate,
    this.attendanceId,
    this.attendanceNo,
    this.companyId,
    this.employeeId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    required this.attendanceStatus,

    // ------------------------------------------------------------------------
    // Employee
    // ------------------------------------------------------------------------

    this.employeeCode,
    this.employeeName,
    this.employeeEmail,
    this.employeePhone,
    this.employeeProfilePhoto,

    // ------------------------------------------------------------------------
    // Department
    // ------------------------------------------------------------------------

    this.departmentName,

    // ------------------------------------------------------------------------
    // Designation
    // ------------------------------------------------------------------------

    this.designationName,

    // ------------------------------------------------------------------------
    // Shift
    // ------------------------------------------------------------------------

    this.shiftName,
    this.shiftCode,
    this.shiftStartTime,
    this.shiftEndTime,
    this.breakMinutes = 0,
    this.graceInMinutes = 0,
    this.graceOutMinutes = 0,
    this.minimumWorkingMinutes = 0,
    this.isNightShift = false,
    this.isFlexible = false,
    this.checkInRequired = true,
    this.checkOutRequired = true,

    // ------------------------------------------------------------------------
    // Working day
    // ------------------------------------------------------------------------

    required this.dayOfWeek,
    this.isWorkingDay = true,

    // ------------------------------------------------------------------------
    // Check in
    // ------------------------------------------------------------------------

    this.checkInTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInAddress,
    this.checkInAccuracy,

    // ------------------------------------------------------------------------
    // Check out
    // ------------------------------------------------------------------------

    this.checkOutTime,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutAddress,
    this.checkOutAccuracy,

    // ------------------------------------------------------------------------
    // Report
    // ------------------------------------------------------------------------

    this.reportStatus = '',

    // ------------------------------------------------------------------------
    // Backend compatibility flags
    // ------------------------------------------------------------------------

    this.isLate = false,
    this.isEarlyOut = false,
    this.isAbsent = false,
    this.isHoliday = false,
    this.isPresent = false,
  });

  // ==========================================================================
  // BASIC ATTENDANCE STATE
  // ==========================================================================

  bool get hasCheckedIn {
    return checkInTime != null;
  }

  bool get hasCheckedOut {
    return checkOutTime != null;
  }

  bool get isCompleteAttendance {
    return hasCheckedIn && hasCheckedOut;
  }

  bool get isPendingCheckout {
    return hasCheckedIn && !hasCheckedOut;
  }

  bool get hasAttendanceRecord {
    return attendanceId != null &&
        attendanceId!.trim().isNotEmpty;
  }

  // ==========================================================================
  // ACTUAL HOUR (AH)
  //
  // AH = Shift Start -> Shift End
  //
  // Example:
  //
  // 10:00 AM -> 7:00 PM
  // AH = 9h
  //
  // Night shift:
  //
  // 10:00 PM -> 6:00 AM
  // AH = 8h
  // ==========================================================================

  int get actualHourMinutes {
    final int? startMinutes =
    _timeStringToMinutes(shiftStartTime);

    final int? endMinutes =
    _timeStringToMinutes(shiftEndTime);

    if (startMinutes == null ||
        endMinutes == null) {
      return 0;
    }

    int difference =
        endMinutes - startMinutes;

    if (difference < 0) {
      difference += 24 * 60;
    }

    return difference > 0
        ? difference
        : 0;
  }

  double get actualHour {
    return actualHourMinutes / 60.0;
  }

  double get actualHourHours {
    return actualHour;
  }

  String get actualHourDuration {
    return _formatDuration(
      actualHourMinutes,
    );
  }

  // ==========================================================================
  // WORKING HOUR (WH)
  //
  // WH = Check-In -> Check-Out
  //
  // Example:
  //
  // Check-In  = 10:05 AM
  // Check-Out = 7:10 PM
  //
  // WH = 9h 05m
  // ==========================================================================

  int get workingHourMinutes {
    if (checkInTime == null ||
        checkOutTime == null) {
      return 0;
    }

    DateTime start = checkInTime!;

    DateTime end = checkOutTime!;

    if (end.isBefore(start)) {
      end = end.add(
        const Duration(days: 1),
      );
    }

    final int difference =
        end.difference(start).inMinutes;

    return difference > 0
        ? difference
        : 0;
  }

  double get workingHour {
    return workingHourMinutes / 60.0;
  }

  double get workingHourHours {
    return workingHour;
  }

  String get workingHourDuration {
    return _formatDuration(
      workingHourMinutes,
    );
  }

  // ==========================================================================
  // OVERTIME (OT)
  //
  // OT = WH - AH
  //
  // Example:
  //
  // AH = 9h
  // WH = 9h 30m
  // OT = 30m
  //
  // OT can never be negative.
  // ==========================================================================

  int get calculatedOvertimeMinutes {
    final int difference =
        workingHourMinutes -
            actualHourMinutes;

    if (difference <= 0) {
      return 0;
    }

    return difference;
  }

  double get calculatedOvertime {
    return calculatedOvertimeMinutes / 60.0;
  }

  double get calculatedOvertimeHours {
    return calculatedOvertime;
  }

  String get calculatedOvertimeDuration {
    return _formatDuration(
      calculatedOvertimeMinutes,
    );
  }

  // ==========================================================================
  // CALCULATION AVAILABILITY
  // ==========================================================================

  bool get canCalculateActualHour {
    return actualHourMinutes > 0;
  }

  bool get canCalculateWorkingHour {
    return checkInTime != null &&
        checkOutTime != null &&
        workingHourMinutes > 0;
  }

  bool get canCalculateOvertime {
    return canCalculateWorkingHour &&
        actualHourMinutes > 0;
  }

  bool get hasCalculatedAttendanceHours {
    return canCalculateActualHour &&
        canCalculateWorkingHour;
  }

  // ==========================================================================
  // EFFECTIVE REPORT VALUES
  // ==========================================================================

  int get effectiveActualHourMinutes {
    return actualHourMinutes > 0
        ? actualHourMinutes
        : 0;
  }

  int get effectiveWorkingHourMinutes {
    return canCalculateWorkingHour
        ? workingHourMinutes
        : 0;
  }

  int get effectiveOvertimeMinutes {
    return canCalculateOvertime
        ? calculatedOvertimeMinutes
        : 0;
  }

  // ==========================================================================
  // REPORT DISPLAY VALUES
  // ==========================================================================

  String get displayActualHour {
    return _formatDuration(
      effectiveActualHourMinutes,
    );
  }

  String get displayWorkingHour {
    return _formatDuration(
      effectiveWorkingHourMinutes,
    );
  }

  String get displayOvertime {
    return _formatDuration(
      effectiveOvertimeMinutes,
    );
  }

  // ==========================================================================
  // LATE CALCULATION
  //
  // Rule:
  //
  // Allowed check-in =
  // Shift Start + graceInMinutes
  //
  // Example:
  //
  // Shift Start = 10:00 AM
  // Grace       = 15 minutes
  //
  // 10:15 AM = Present
  // 10:16 AM = Late
  // ==========================================================================

  int get calculatedLateMinutes {
    if (checkInTime == null) {
      return 0;
    }

    final int? shiftStartMinutes =
    _timeStringToMinutes(
      shiftStartTime,
    );

    if (shiftStartMinutes == null) {
      return 0;
    }

    final DateTime shiftStart =
    _buildShiftDateTime(
      checkInTime!,
      shiftStartMinutes,
    );

    final DateTime allowedCheckIn =
    shiftStart.add(
      Duration(
        minutes: _safeGraceInMinutes,
      ),
    );

    if (!checkInTime!.isAfter(
      allowedCheckIn,
    )) {
      return 0;
    }

    final int minutes =
        checkInTime!
            .difference(allowedCheckIn)
            .inMinutes;

    return minutes > 0
        ? minutes
        : 0;
  }

  String get calculatedLateDuration {
    return _formatDuration(
      calculatedLateMinutes,
    );
  }

  // ==========================================================================
  // EARLY OUT CALCULATION
  //
  // Rule:
  //
  // Allowed early checkout =
  // Shift End - graceOutMinutes
  //
  // Example:
  //
  // Shift End = 7:00 PM
  // Grace Out = 15 minutes
  //
  // 6:45 PM = Present
  // 6:44 PM = Early Out
  // ==========================================================================

  int get calculatedEarlyOutMinutes {
    if (checkOutTime == null) {
      return 0;
    }

    final int? shiftEndMinutes =
    _timeStringToMinutes(
      shiftEndTime,
    );

    if (shiftEndMinutes == null) {
      return 0;
    }

    DateTime shiftEnd =
    _buildShiftDateTime(
      checkOutTime!,
      shiftEndMinutes,
    );

    final int? shiftStartMinutes =
    _timeStringToMinutes(
      shiftStartTime,
    );

    // ------------------------------------------------------------------------
    // Overnight / Night Shift
    // ------------------------------------------------------------------------

    if (shiftStartMinutes != null &&
        shiftEndMinutes < shiftStartMinutes) {
      final DateTime shiftStart =
      _buildShiftDateTime(
        checkOutTime!,
        shiftStartMinutes,
      );

      if (shiftEnd.isBefore(
        shiftStart,
      )) {
        shiftEnd = shiftEnd.add(
          const Duration(days: 1),
        );
      }
    }

    final DateTime allowedCheckOut =
    shiftEnd.subtract(
      Duration(
        minutes: _safeGraceOutMinutes,
      ),
    );

    if (!checkOutTime!.isBefore(
      allowedCheckOut,
    )) {
      return 0;
    }

    final int minutes =
        allowedCheckOut
            .difference(checkOutTime!)
            .inMinutes;

    return minutes > 0
        ? minutes
        : 0;
  }

  String get calculatedEarlyOutDuration {
    return _formatDuration(
      calculatedEarlyOutMinutes,
    );
  }

  // ==========================================================================
  // CALCULATED STATUS FLAGS
  // ==========================================================================

  bool get calculatedIsLate {
    return calculatedLateMinutes > 0;
  }

  bool get calculatedIsEarlyOut {
    return calculatedEarlyOutMinutes > 0;
  }

  // ==========================================================================
  // FINAL ATTENDANCE STATUS
  //
  // This is the main status calculator.
  //
  // Priority:
  //
  // Holiday
  // Absent
  // Missing Check-out
  // Late + Early Out
  // Late
  // Early Out
  // Present
  // ==========================================================================

  String get calculatedAttendanceStatus {
    // ------------------------------------------------------------------------
    // Holiday
    // ------------------------------------------------------------------------

    if (isHoliday ||
        normalizedAttendanceStatus == 'HOLIDAY') {
      return 'HOLIDAY';
    }

    // ------------------------------------------------------------------------
    // Absent
    // ------------------------------------------------------------------------

    if (isAbsent ||
        normalizedAttendanceStatus == 'ABSENT') {
      return 'ABSENT';
    }

    // ------------------------------------------------------------------------
    // No check-in
    // ------------------------------------------------------------------------

    if (isWorkingDay &&
        checkInRequired &&
        checkInTime == null) {
      return 'ABSENT';
    }

    // ------------------------------------------------------------------------
    // Missing check-out
    // ------------------------------------------------------------------------

    if (checkInTime != null &&
        checkOutRequired &&
        checkOutTime == null) {
      return 'MISSING_CHECK_OUT';
    }

    // ------------------------------------------------------------------------
    // Both Late + Early Out
    // ------------------------------------------------------------------------

    if (calculatedIsLate &&
        calculatedIsEarlyOut) {
      return 'LATE_EARLY_OUT';
    }

    // ------------------------------------------------------------------------
    // Late only
    // ------------------------------------------------------------------------

    if (calculatedIsLate) {
      return 'LATE';
    }

    // ------------------------------------------------------------------------
    // Early Out only
    // ------------------------------------------------------------------------

    if (calculatedIsEarlyOut) {
      return 'EARLY_OUT';
    }

    // ------------------------------------------------------------------------
    // Present
    // ------------------------------------------------------------------------

    if (checkInTime != null) {
      return 'PRESENT';
    }

    return 'UNKNOWN';
  }

  // ==========================================================================
  // DISPLAY STATUS
  // ==========================================================================

  String get displayCalculatedAttendanceStatus {
    switch (calculatedAttendanceStatus) {
      case 'PRESENT':
        return 'Present';

      case 'LATE':
        return 'Late';

      case 'EARLY_OUT':
        return 'Early Out';

      case 'LATE_EARLY_OUT':
        return 'Late + Early Out';

      case 'MISSING_CHECK_OUT':
        return 'Missing Check-out';

      case 'ABSENT':
        return 'Absent';

      case 'HOLIDAY':
        return 'Holiday';

      default:
        return 'Unknown';
    }
  }

  // ==========================================================================
  // EFFECTIVE STATUS FLAGS
  // ==========================================================================

  bool get isMarkedPresent {
    return calculatedAttendanceStatus == 'PRESENT';
  }

  bool get isMarkedAbsent {
    return calculatedAttendanceStatus == 'ABSENT';
  }

  bool get isMarkedHoliday {
    return calculatedAttendanceStatus == 'HOLIDAY';
  }

  bool get isMarkedLate {
    return calculatedIsLate;
  }

  bool get isMarkedEarlyOut {
    return calculatedIsEarlyOut;
  }

  bool get hasLateMinutes {
    return calculatedLateMinutes > 0;
  }

  bool get hasEarlyLeaveMinutes {
    return calculatedEarlyOutMinutes > 0;
  }

  bool get hasOvertime {
    return effectiveOvertimeMinutes > 0;
  }

  // ==========================================================================
  // BACKWARD-COMPATIBLE STATUS HELPERS
  //
  // These getters allow existing UI code to continue using:
  //
  // lateMinutes
  // earlyLeaveMinutes
  //
  // without storing those values in the database.
  // ==========================================================================

  int get lateMinutes {
    return calculatedLateMinutes;
  }

  int get earlyLeaveMinutes {
    return calculatedEarlyOutMinutes;
  }

  String get lateDuration {
    return calculatedLateDuration;
  }

  String get earlyLeaveDuration {
    return calculatedEarlyOutDuration;
  }

  // ==========================================================================
  // WORKING DAY HELPERS
  // ==========================================================================

  bool get isNonWorkingDay {
    return !isWorkingDay;
  }

  String get displayDayOfWeek {
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Monday';

      case DateTime.tuesday:
        return 'Tuesday';

      case DateTime.wednesday:
        return 'Wednesday';

      case DateTime.thursday:
        return 'Thursday';

      case DateTime.friday:
        return 'Friday';

      case DateTime.saturday:
        return 'Saturday';

      case DateTime.sunday:
        return 'Sunday';

      default:
        return 'Unknown';
    }
  }

  // ==========================================================================
  // SHIFT HELPERS
  // ==========================================================================

  bool get hasShift {
    return shiftId != null ||
        shiftName != null ||
        shiftStartTime != null ||
        shiftEndTime != null;
  }

  bool get hasShiftTiming {
    return shiftStartTime != null &&
        shiftStartTime!.trim().isNotEmpty &&
        shiftEndTime != null &&
        shiftEndTime!.trim().isNotEmpty;
  }

  bool get isNightShiftAttendance {
    return isNightShift;
  }

  bool get requiresCheckIn {
    return checkInRequired;
  }

  bool get requiresCheckOut {
    return checkOutRequired;
  }

  int get _safeGraceInMinutes {
    return graceInMinutes < 0
        ? 0
        : graceInMinutes;
  }

  int get _safeGraceOutMinutes {
    return graceOutMinutes < 0
        ? 0
        : graceOutMinutes;
  }

  // ==========================================================================
  // LOCATION HELPERS
  // ==========================================================================

  bool get hasCheckInLocation {
    return _isValidCoordinate(
      checkInLatitude,
    ) &&
        _isValidCoordinate(
          checkInLongitude,
        );
  }

  bool get hasCheckOutLocation {
    return _isValidCoordinate(
      checkOutLatitude,
    ) &&
        _isValidCoordinate(
          checkOutLongitude,
        );
  }

  bool get hasCheckInAddress {
    return checkInAddress != null &&
        checkInAddress!.trim().isNotEmpty;
  }

  bool get hasCheckOutAddress {
    return checkOutAddress != null &&
        checkOutAddress!.trim().isNotEmpty;
  }

  bool get hasCheckInAccuracy {
    return checkInAccuracy != null &&
        checkInAccuracy!.isFinite &&
        checkInAccuracy! >= 0;
  }

  bool get hasCheckOutAccuracy {
    return checkOutAccuracy != null &&
        checkOutAccuracy!.isFinite &&
        checkOutAccuracy! >= 0;
  }

  static bool _isValidCoordinate(
      double? value,
      ) {
    return value != null &&
        value.isFinite;
  }

  // ==========================================================================
  // LOCATION DISPLAY
  // ==========================================================================

  String get checkInLocation {
    if (hasCheckInAddress) {
      return checkInAddress!.trim();
    }

    if (hasCheckInLocation) {
      return displayCheckInCoordinates;
    }

    return 'Location unavailable';
  }

  String get checkOutLocation {
    if (hasCheckOutAddress) {
      return checkOutAddress!.trim();
    }

    if (hasCheckOutLocation) {
      return displayCheckOutCoordinates;
    }

    return 'Location unavailable';
  }

  String get displayCheckInAddress {
    final String value =
        checkInAddress?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'Location unavailable';
  }

  String get displayCheckOutAddress {
    final String value =
        checkOutAddress?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'Location unavailable';
  }

  String get displayCheckInCoordinates {
    if (!hasCheckInLocation) {
      return 'Location unavailable';
    }

    return '${checkInLatitude!.toStringAsFixed(6)}, '
        '${checkInLongitude!.toStringAsFixed(6)}';
  }

  String get displayCheckOutCoordinates {
    if (!hasCheckOutLocation) {
      return 'Location unavailable';
    }

    return '${checkOutLatitude!.toStringAsFixed(6)}, '
        '${checkOutLongitude!.toStringAsFixed(6)}';
  }

  // ==========================================================================
  // EMPLOYEE DISPLAY HELPERS
  // ==========================================================================

  String get displayEmployeeName {
    final String value =
        employeeName?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'Unknown Employee';
  }

  String get displayEmployeeCode {
    final String value =
        employeeCode?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayEmployeeEmail {
    final String value =
        employeeEmail?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayEmployeePhone {
    final String value =
        employeePhone?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayEmployeeProfilePhoto {
    final String value =
        employeeProfilePhoto?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return '';
  }

  // ==========================================================================
  // ORGANIZATION DISPLAY HELPERS
  // ==========================================================================

  String get displayDepartmentName {
    final String value =
        departmentName?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayDesignationName {
    final String value =
        designationName?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  // ==========================================================================
  // SHIFT DISPLAY HELPERS
  // ==========================================================================

  String get displayShiftName {
    final String value =
        shiftName?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayShiftCode {
    final String value =
        shiftCode?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    return 'N/A';
  }

  String get displayShiftTime {
    final String start =
        shiftStartTime?.trim() ?? '';

    final String end =
        shiftEndTime?.trim() ?? '';

    if (start.isNotEmpty &&
        end.isNotEmpty) {
      return '$start - $end';
    }

    if (start.isNotEmpty) {
      return start;
    }

    if (end.isNotEmpty) {
      return end;
    }

    return 'N/A';
  }

  // ==========================================================================
  // GRACE DISPLAY
  // ==========================================================================

  String get displayGraceIn {
    return '$graceInMinutes min';
  }

  String get displayGraceOut {
    return '$graceOutMinutes min';
  }

  // ==========================================================================
  // STATUS HELPERS
  // ==========================================================================

  String get normalizedAttendanceStatus {
    return attendanceStatus
        .trim()
        .toUpperCase();
  }

  String get normalizedReportStatus {
    return reportStatus
        .trim()
        .toUpperCase();
  }

  String get displayAttendanceStatus {
    return displayCalculatedAttendanceStatus;
  }

  String get displayReportStatus {
    final String status =
        normalizedReportStatus;

    if (status.isEmpty) {
      return 'Unknown';
    }

    return _toTitleCase(status);
  }

  static String _toTitleCase(
      String value,
      ) {
    return value
        .split(
      RegExp(r'[\s_-]+'),
    )
        .where(
          (String part) =>
      part.isNotEmpty,
    )
        .map(
          (String part) =>
      '${part[0].toUpperCase()}'
          '${part.substring(1).toLowerCase()}',
    )
        .join(' ');
  }

  // ==========================================================================
  // ATTENDANCE QUALITY HELPERS
  // ==========================================================================

  bool get isMissingCheckIn {
    return checkInRequired &&
        isWorkingDay &&
        !isAbsent &&
        !isHoliday &&
        checkInTime == null;
  }

  bool get isMissingCheckOut {
    return checkOutRequired &&
        isWorkingDay &&
        !isAbsent &&
        !isHoliday &&
        checkInTime != null &&
        checkOutTime == null;
  }

  bool get hasIncompleteAttendance {
    return isMissingCheckIn ||
        isMissingCheckOut;
  }

  // ==========================================================================
  // REPORT SUMMARY
  // ==========================================================================

  String get summaryStatus {
    return displayCalculatedAttendanceStatus;
  }

  // ==========================================================================
  // DATE HELPERS
  // ==========================================================================

  bool get hasValidAttendanceDate {
    return attendanceDate.year >= 2000;
  }

  // ==========================================================================
  // INTERNAL DATE/TIME HELPER
  // ==========================================================================

  static DateTime _buildShiftDateTime(
      DateTime referenceDate,
      int minutes,
      ) {
    final int hour =
        minutes ~/ 60;

    final int minute =
        minutes % 60;

    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      hour,
      minute,
    );
  }

  // ==========================================================================
  // TIME STRING PARSER
  //
  // Supports:
  //
  // 09:00
  // 09:00:00
  // 09:00:00.000
  // 9:00 AM
  // 09:00 AM
  // 6:00 PM
  // 06:00 PM
  // ==========================================================================

  static int? _timeStringToMinutes(
      String? value,
      ) {
    if (value == null) {
      return null;
    }

    String normalized =
    value.trim();

    if (normalized.isEmpty) {
      return null;
    }

    // ------------------------------------------------------------------------
    // Normalize AM / PM
    // ------------------------------------------------------------------------

    normalized =
        normalized
            .replaceAll(
          RegExp(r'\s+'),
          ' ',
        )
            .toUpperCase();

    final bool hasAm =
    normalized.endsWith(' AM');

    final bool hasPm =
    normalized.endsWith(' PM');

    if (hasAm || hasPm) {
      final String timePart =
      normalized.substring(
        0,
        normalized.length - 3,
      ).trim();

      final List<String> parts =
      timePart.split(':');

      if (parts.length < 2) {
        return null;
      }

      final int? rawHour =
      int.tryParse(
        parts[0].trim(),
      );

      final int? minute =
      int.tryParse(
        parts[1].trim(),
      );

      if (rawHour == null ||
          minute == null) {
        return null;
      }

      if (rawHour < 1 ||
          rawHour > 12 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      int hour =
          rawHour;

      if (hasAm) {
        if (hour == 12) {
          hour = 0;
        }
      } else if (hasPm) {
        if (hour != 12) {
          hour += 12;
        }
      }

      return (hour * 60) + minute;
    }

    // ------------------------------------------------------------------------
    // 24-hour format
    // ------------------------------------------------------------------------

    final List<String> parts =
    normalized.split(':');

    if (parts.length < 2) {
      return null;
    }

    final int? hour =
    int.tryParse(
      parts[0].trim(),
    );

    final int? minute =
    int.tryParse(
      parts[1].trim(),
    );

    if (hour == null ||
        minute == null) {
      return null;
    }

    if (hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return (hour * 60) + minute;
  }

  // ==========================================================================
  // DURATION FORMATTER
  // ==========================================================================

  static String _formatDuration(
      int totalMinutes,
      ) {
    final int safeMinutes =
    totalMinutes < 0
        ? 0
        : totalMinutes;

    final int hours =
        safeMinutes ~/ 60;

    final int minutes =
        safeMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  // ==========================================================================
  // DEBUG / SUMMARY
  // ==========================================================================

  @override
  String toString() {
    return 'CompanySupervisorMobileAttendanceReportEntity('
        'attendanceId: $attendanceId, '
        'attendanceDate: $attendanceDate, '
        'employeeId: $employeeId, '
        'employeeName: $employeeName, '
        'employeeCode: $employeeCode, '
        'departmentName: $departmentName, '
        'designationName: $designationName, '
        'shiftName: $shiftName, '
        'shiftStartTime: $shiftStartTime, '
        'shiftEndTime: $shiftEndTime, '
        'graceInMinutes: $graceInMinutes, '
        'graceOutMinutes: $graceOutMinutes, '
        'actualHourMinutes: $actualHourMinutes, '
        'workingHourMinutes: $workingHourMinutes, '
        'calculatedOvertimeMinutes: $calculatedOvertimeMinutes, '
        'calculatedLateMinutes: $calculatedLateMinutes, '
        'calculatedEarlyOutMinutes: $calculatedEarlyOutMinutes, '
        'calculatedAttendanceStatus: '
        '$calculatedAttendanceStatus, '
        'displayActualHour: $displayActualHour, '
        'displayWorkingHour: $displayWorkingHour, '
        'displayOvertime: $displayOvertime, '
        'checkInTime: $checkInTime, '
        'checkOutTime: $checkOutTime'
        ')';
  }
}