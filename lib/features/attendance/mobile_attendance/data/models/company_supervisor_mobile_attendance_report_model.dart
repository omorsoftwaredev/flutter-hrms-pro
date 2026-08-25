// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Model
//
// Version : 7.0.0
//
// Purpose:
// - Parse company supervisor attendance report
// - Normalize attendance information
// - Normalize check-in / check-out location
// - Parse shift timing
// - Calculate Actual Hour (AH)
// - Calculate Working Hour (WH)
// - Calculate Overtime (OT)
// - Calculate Late using grace_in_minutes
// - Calculate Early Out using grace_out_minutes
// - Calculate final attendance status
// - Safe JSON serialization
//
// Calculation Rules:
//
// AH = Shift Start -> Shift End
//
// WH = Check-In -> Check-Out
//
// OT = WH - AH
// OT cannot be negative.
//
// Late:
// Check-In > Shift Start + grace_in_minutes
//
// Early Out:
// Check-Out < Shift End - grace_out_minutes
//
// Final Status:
//
// PRESENT
// LATE
// EARLY_OUT
// LATE_EARLY_OUT
// MISSING_CHECK_OUT
// ABSENT
// HOLIDAY
// UNKNOWN
//
// IMPORTANT:
// This Model MUST stay synchronized with:
// CompanySupervisorMobileAttendanceReportEntity
// ============================================================================

import '../../domain/entities/company_supervisor_mobile_attendance_report_entity.dart';

class CompanySupervisorMobileAttendanceReportModel
    extends CompanySupervisorMobileAttendanceReportEntity {
  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const CompanySupervisorMobileAttendanceReportModel({
    // ------------------------------------------------------------------------
    // Attendance
    // ------------------------------------------------------------------------

    required super.attendanceDate,
    super.attendanceId,
    super.attendanceNo,
    super.companyId,
    super.employeeId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    required super.attendanceStatus,

    // ------------------------------------------------------------------------
    // Employee
    // ------------------------------------------------------------------------

    super.employeeCode,
    super.employeeName,
    super.employeeEmail,
    super.employeePhone,
    super.employeeProfilePhoto,

    // ------------------------------------------------------------------------
    // Department
    // ------------------------------------------------------------------------

    super.departmentName,

    // ------------------------------------------------------------------------
    // Designation
    // ------------------------------------------------------------------------

    super.designationName,

    // ------------------------------------------------------------------------
    // Shift
    // ------------------------------------------------------------------------

    super.shiftName,
    super.shiftCode,
    super.shiftStartTime,
    super.shiftEndTime,
    super.breakMinutes,
    super.graceInMinutes,
    super.graceOutMinutes,
    super.minimumWorkingMinutes,
    super.isNightShift,
    super.isFlexible,
    super.checkInRequired,
    super.checkOutRequired,

    // ------------------------------------------------------------------------
    // Working Day
    // ------------------------------------------------------------------------

    required super.dayOfWeek,
    super.isWorkingDay,

    // ------------------------------------------------------------------------
    // Check-In
    // ------------------------------------------------------------------------

    super.checkInTime,
    super.checkInLatitude,
    super.checkInLongitude,
    super.checkInAddress,
    super.checkInAccuracy,

    // ------------------------------------------------------------------------
    // Check-Out
    // ------------------------------------------------------------------------

    super.checkOutTime,
    super.checkOutLatitude,
    super.checkOutLongitude,
    super.checkOutAddress,
    super.checkOutAccuracy,

    // ------------------------------------------------------------------------
    // Report
    // ------------------------------------------------------------------------

    super.reportStatus,

    // ------------------------------------------------------------------------
    // Backend Compatibility Flags
    // ------------------------------------------------------------------------

    super.isLate,
    super.isEarlyOut,
    super.isAbsent,
    super.isHoliday,
    super.isPresent,
  });

  // ==========================================================================
  // FROM JSON
  // ==========================================================================

  factory CompanySupervisorMobileAttendanceReportModel.fromJson(
      Map<String, dynamic> json,
      ) {
    // ========================================================================
    // DATE
    // ========================================================================

    final DateTime attendanceDate = _parseDateTime(
      json['attendance_date'],
    );

    // ========================================================================
    // DAY OF WEEK
    //
    // Database value is preferred.
    //
    // If database does not provide day_of_week,
    // attendanceDate.weekday is used.
    // ========================================================================

    final int dayOfWeek = _normalizeDayOfWeek(
      json['day_of_week'],
      fallback: attendanceDate.weekday,
    );

    // ========================================================================
    // WORKING DAY
    // ========================================================================

    final bool isWorkingDay = _toBool(
      json['is_working_day'],
      defaultValue: true,
    );

    // ========================================================================
    // CHECK-IN LOCATION
    // ========================================================================

    final double? checkInLatitude = _toDouble(
      json['check_in_latitude'],
    );

    final double? checkInLongitude = _toDouble(
      json['check_in_longitude'],
    );

    final String? checkInAddress = _toNullableString(
      json['check_in_address'],
    );

    final double? checkInAccuracy = _toDouble(
      json['check_in_accuracy'],
    );

    // ========================================================================
    // CHECK-OUT LOCATION
    // ========================================================================

    final double? checkOutLatitude = _toDouble(
      json['check_out_latitude'],
    );

    final double? checkOutLongitude = _toDouble(
      json['check_out_longitude'],
    );

    final String? checkOutAddress = _toNullableString(
      json['check_out_address'],
    );

    final double? checkOutAccuracy = _toDouble(
      json['check_out_accuracy'],
    );

    // ========================================================================
    // LOCATION DEBUG
    // ========================================================================

    _debugLocation(
      checkInLatitude: checkInLatitude,
      checkInLongitude: checkInLongitude,
      checkInAddress: checkInAddress,
      checkInAccuracy: checkInAccuracy,
      checkOutLatitude: checkOutLatitude,
      checkOutLongitude: checkOutLongitude,
      checkOutAddress: checkOutAddress,
      checkOutAccuracy: checkOutAccuracy,
    );

    // ========================================================================
    // CHECK-IN / CHECK-OUT TIME
    // ========================================================================

    final DateTime? checkInTime = _parseNullableDateTime(
      json['check_in_time'],
    );

    final DateTime? checkOutTime = _parseNullableDateTime(
      json['check_out_time'],
    );

    // ========================================================================
    // ATTENDANCE STATUS
    // ========================================================================

    final String attendanceStatus = _toStringValue(
      json['attendance_status'],
      defaultValue: 'UNKNOWN',
    );

    // ========================================================================
    // REPORT STATUS
    // ========================================================================

    final String reportStatus = _toStringValue(
      json['report_status'] ??
          json['attendance_status'],
      defaultValue: attendanceStatus,
    );

    // ========================================================================
    // SHIFT TIME
    // ========================================================================

    final String? shiftStartTime = _toNullableString(
      json['shift_start_time'],
    );

    final String? shiftEndTime = _toNullableString(
      json['shift_end_time'],
    );

    // ========================================================================
    // MODEL
    // ========================================================================

    final CompanySupervisorMobileAttendanceReportModel model =
    CompanySupervisorMobileAttendanceReportModel(
      // ----------------------------------------------------------------------
      // Attendance
      // ----------------------------------------------------------------------

      attendanceDate: attendanceDate,

      attendanceId: _toNullableString(
        json['id'] ??
            json['attendance_id'],
      ),

      attendanceNo: _toNullableString(
        json['attendance_no'],
      ),

      companyId: _toNullableString(
        json['company_id'],
      ),

      employeeId: _toNullableString(
        json['employee_id'],
      ),

      departmentId: _toNullableString(
        json['department_id'],
      ),

      designationId: _toNullableString(
        json['designation_id'],
      ),

      shiftId: _toNullableString(
        json['shift_id'],
      ),

      attendanceStatus: attendanceStatus,

      // ----------------------------------------------------------------------
      // Employee
      // ----------------------------------------------------------------------

      employeeCode: _toNullableString(
        json['employee_code'],
      ),

      employeeName: _toNullableString(
        json['employee_name'],
      ),

      employeeEmail: _toNullableString(
        json['employee_email'],
      ),

      employeePhone: _toNullableString(
        json['employee_phone'],
      ),

      employeeProfilePhoto: _toNullableString(
        json['employee_profile_photo'],
      ),

      // ----------------------------------------------------------------------
      // Department
      // ----------------------------------------------------------------------

      departmentName: _toNullableString(
        json['department_name'],
      ),

      // ----------------------------------------------------------------------
      // Designation
      // ----------------------------------------------------------------------

      designationName: _toNullableString(
        json['designation_name'],
      ),

      // ----------------------------------------------------------------------
      // Shift
      // ----------------------------------------------------------------------

      shiftName: _toNullableString(
        json['shift_name'],
      ),

      shiftCode: _toNullableString(
        json['shift_code'],
      ),

      shiftStartTime: shiftStartTime,

      shiftEndTime: shiftEndTime,

      breakMinutes: _toInt(
        json['break_minutes'],
      ),

      graceInMinutes: _toInt(
        json['grace_in_minutes'],
      ),

      graceOutMinutes: _toInt(
        json['grace_out_minutes'],
      ),

      minimumWorkingMinutes: _toInt(
        json['minimum_working_minutes'],
      ),

      isNightShift: _toBool(
        json['is_night_shift'],
      ),

      isFlexible: _toBool(
        json['is_flexible'],
      ),

      checkInRequired: _toBool(
        json['check_in_required'],
        defaultValue: true,
      ),

      checkOutRequired: _toBool(
        json['check_out_required'],
        defaultValue: true,
      ),

      // ----------------------------------------------------------------------
      // Working Day
      // ----------------------------------------------------------------------

      dayOfWeek: dayOfWeek,

      isWorkingDay: isWorkingDay,

      // ----------------------------------------------------------------------
      // Check-In
      // ----------------------------------------------------------------------

      checkInTime: checkInTime,

      checkInLatitude: checkInLatitude,

      checkInLongitude: checkInLongitude,

      checkInAddress: checkInAddress,

      checkInAccuracy: checkInAccuracy,

      // ----------------------------------------------------------------------
      // Check-Out
      // ----------------------------------------------------------------------

      checkOutTime: checkOutTime,

      checkOutLatitude: checkOutLatitude,

      checkOutLongitude: checkOutLongitude,

      checkOutAddress: checkOutAddress,

      checkOutAccuracy: checkOutAccuracy,

      // ----------------------------------------------------------------------
      // Report
      // ----------------------------------------------------------------------

      reportStatus: reportStatus,

      // ----------------------------------------------------------------------
      // Backend Compatibility Flags
      // ----------------------------------------------------------------------

      isLate: _toBool(
        json['is_late'],
      ),

      isEarlyOut: _toBool(
        json['is_early_out'],
      ),

      isAbsent: _toBool(
        json['is_absent'],
      ),

      isHoliday: _toBool(
        json['is_holiday'],
      ),

      isPresent: _toBool(
        json['is_present'],
      ),
    );

    // ========================================================================
    // CALCULATION DEBUG
    // ========================================================================

    model.debugWorkingCalculation();

    return model;
  }

  // ==========================================================================
  // LOCATION DEBUG
  // ==========================================================================

  static void _debugLocation({
    required double? checkInLatitude,
    required double? checkInLongitude,
    required String? checkInAddress,
    required double? checkInAccuracy,
    required double? checkOutLatitude,
    required double? checkOutLongitude,
    required String? checkOutAddress,
    required double? checkOutAccuracy,
  }) {
    print('');
    print(
      '==============================================================',
    );
    print(
      'COMPANY SUPERVISOR ATTENDANCE LOCATION DEBUG',
    );
    print(
      '==============================================================',
    );

    print('');
    print('[CHECK-IN LOCATION]');

    print(
      'Latitude : $checkInLatitude',
    );

    print(
      'Longitude: $checkInLongitude',
    );

    print(
      'Address  : $checkInAddress',
    );

    print(
      'Accuracy : $checkInAccuracy',
    );

    print('');
    print('[CHECK-OUT LOCATION]');

    print(
      'Latitude : $checkOutLatitude',
    );

    print(
      'Longitude: $checkOutLongitude',
    );

    print(
      'Address  : $checkOutAddress',
    );

    print(
      'Accuracy : $checkOutAccuracy',
    );

    print('');
    print('[LOCATION RESULT]');

    print(
      'Check-In : '
          '${checkInLatitude != null && checkInLongitude != null ? 'DATA FOUND' : 'DATA MISSING'}',
    );

    print(
      'Check-Out: '
          '${checkOutLatitude != null && checkOutLongitude != null ? 'DATA FOUND' : 'DATA MISSING'}',
    );

    print('');
    print(
      '==============================================================',
    );
    print(
      'END LOCATION DEBUG',
    );
    print(
      '==============================================================',
    );
    print('');
  }

  // ==========================================================================
  // ATTENDANCE CALCULATION DEBUG
  // ==========================================================================

  void debugWorkingCalculation() {
    print('');
    print(
      '==============================================================',
    );
    print(
      'COMPANY SUPERVISOR ATTENDANCE HOUR / STATUS DEBUG',
    );
    print(
      '==============================================================',
    );

    print(
      'Employee       : $displayEmployeeName',
    );

    print(
      'Employee ID    : $employeeId',
    );

    print(
      'Attendance ID  : $attendanceId',
    );

    print(
      'Attendance Date: $attendanceDate',
    );

    print(
      'Day of Week    : $displayDayOfWeek',
    );

    print(
      'Working Day    : $isWorkingDay',
    );

    print(
      'Shift          : $displayShiftTime',
    );

    print(
      'Grace In       : $graceInMinutes minutes',
    );

    print(
      'Grace Out      : $graceOutMinutes minutes',
    );

    print(
      'Check-In       : $checkInTime',
    );

    print(
      'Check-Out      : $checkOutTime',
    );

    print('');

    print(
      '---------------- CALCULATION ----------------',
    );

    print(
      'AH Shift Start -> End : '
          '$actualHourMinutes minutes '
          '($actualHourDuration)',
    );

    print(
      'WH Check-In -> Out    : '
          '$workingHourMinutes minutes '
          '($workingHourDuration)',
    );

    print(
      'OT WH - AH            : '
          '$calculatedOvertimeMinutes minutes '
          '($calculatedOvertimeDuration)',
    );

    print('');

    print(
      '---------------- ATTENDANCE STATUS -----------',
    );

    print(
      'Calculated Late      : '
          '${calculatedIsLate ? 'YES' : 'NO'}',
    );

    print(
      'Calculated Early Out : '
          '${calculatedIsEarlyOut ? 'YES' : 'NO'}',
    );

    print(
      'Calculated Late Min  : '
          '$calculatedLateMinutes',
    );

    print(
      'Calculated Early Min : '
          '$calculatedEarlyOutMinutes',
    );

    print(
      'Final Status         : '
          '$calculatedAttendanceStatus',
    );

    print(
      'Display Status       : '
          '$displayCalculatedAttendanceStatus',
    );

    print('');

    print(
      '---------------- EFFECTIVE ------------------',
    );

    print(
      'Effective AH : '
          '$effectiveActualHourMinutes minutes '
          '($displayActualHour)',
    );

    print(
      'Effective WH : '
          '$effectiveWorkingHourMinutes minutes '
          '($displayWorkingHour)',
    );

    print(
      'Effective OT : '
          '$effectiveOvertimeMinutes minutes '
          '($displayOvertime)',
    );

    print('');

    print(
      '---------------- FLAGS ----------------------',
    );

    print(
      'Has Check-In       : $hasCheckedIn',
    );

    print(
      'Has Check-Out      : $hasCheckedOut',
    );

    print(
      'Complete Attendance: $isCompleteAttendance',
    );

    print(
      'Pending Check-Out  : $isPendingCheckout',
    );

    print(
      'Marked Present     : $isMarkedPresent',
    );

    print(
      'Marked Absent      : $isMarkedAbsent',
    );

    print(
      'Marked Holiday     : $isMarkedHoliday',
    );

    print(
      'Marked Late        : $isMarkedLate',
    );

    print(
      'Marked Early Out   : $isMarkedEarlyOut',
    );

    print('');

    print(
      '==============================================================',
    );
    print('');
  }

  // ==========================================================================
  // TO JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      // ----------------------------------------------------------------------
      // Attendance
      // ----------------------------------------------------------------------

      'attendance_date':
      attendanceDate.toIso8601String(),

      'attendance_id':
      attendanceId,

      'attendance_no':
      attendanceNo,

      'company_id':
      companyId,

      'employee_id':
      employeeId,

      'department_id':
      departmentId,

      'designation_id':
      designationId,

      'shift_id':
      shiftId,

      'attendance_status':
      attendanceStatus,

      // ----------------------------------------------------------------------
      // Employee
      // ----------------------------------------------------------------------

      'employee_code':
      employeeCode,

      'employee_name':
      employeeName,

      'employee_email':
      employeeEmail,

      'employee_phone':
      employeePhone,

      'employee_profile_photo':
      employeeProfilePhoto,

      // ----------------------------------------------------------------------
      // Department
      // ----------------------------------------------------------------------

      'department_name':
      departmentName,

      // ----------------------------------------------------------------------
      // Designation
      // ----------------------------------------------------------------------

      'designation_name':
      designationName,

      // ----------------------------------------------------------------------
      // Shift
      // ----------------------------------------------------------------------

      'shift_name':
      shiftName,

      'shift_code':
      shiftCode,

      'shift_start_time':
      shiftStartTime,

      'shift_end_time':
      shiftEndTime,

      'break_minutes':
      breakMinutes,

      'grace_in_minutes':
      graceInMinutes,

      'grace_out_minutes':
      graceOutMinutes,

      'minimum_working_minutes':
      minimumWorkingMinutes,

      'is_night_shift':
      isNightShift,

      'is_flexible':
      isFlexible,

      'check_in_required':
      checkInRequired,

      'check_out_required':
      checkOutRequired,

      // ----------------------------------------------------------------------
      // Working Day
      // ----------------------------------------------------------------------

      'day_of_week':
      dayOfWeek,

      'is_working_day':
      isWorkingDay,

      // ----------------------------------------------------------------------
      // Check-In
      // ----------------------------------------------------------------------

      'check_in_time':
      checkInTime?.toIso8601String(),

      'check_in_latitude':
      checkInLatitude,

      'check_in_longitude':
      checkInLongitude,

      'check_in_address':
      checkInAddress,

      'check_in_accuracy':
      checkInAccuracy,

      // ----------------------------------------------------------------------
      // Check-Out
      // ----------------------------------------------------------------------

      'check_out_time':
      checkOutTime?.toIso8601String(),

      'check_out_latitude':
      checkOutLatitude,

      'check_out_longitude':
      checkOutLongitude,

      'check_out_address':
      checkOutAddress,

      'check_out_accuracy':
      checkOutAccuracy,

      // ----------------------------------------------------------------------
      // Report
      // ----------------------------------------------------------------------

      'report_status':
      reportStatus,

      // ----------------------------------------------------------------------
      // Calculated Values
      // ----------------------------------------------------------------------

      'actual_hour_minutes':
      actualHourMinutes,

      'actual_hour':
      actualHour,

      'actual_hour_duration':
      actualHourDuration,

      'working_hour_minutes':
      workingHourMinutes,

      'working_hour':
      workingHour,

      'working_hour_duration':
      workingHourDuration,

      'calculated_overtime_minutes':
      calculatedOvertimeMinutes,

      'calculated_overtime':
      calculatedOvertime,

      'calculated_overtime_duration':
      calculatedOvertimeDuration,

      // ----------------------------------------------------------------------
      // Late / Early Out
      // ----------------------------------------------------------------------

      'calculated_late_minutes':
      calculatedLateMinutes,

      'calculated_late_duration':
      calculatedLateDuration,

      'calculated_early_out_minutes':
      calculatedEarlyOutMinutes,

      'calculated_early_out_duration':
      calculatedEarlyOutDuration,

      'calculated_is_late':
      calculatedIsLate,

      'calculated_is_early_out':
      calculatedIsEarlyOut,

      // ----------------------------------------------------------------------
      // Final Status
      // ----------------------------------------------------------------------

      'calculated_attendance_status':
      calculatedAttendanceStatus,

      'display_calculated_attendance_status':
      displayCalculatedAttendanceStatus,

      // ----------------------------------------------------------------------
      // Effective Values
      // ----------------------------------------------------------------------

      'effective_actual_hour_minutes':
      effectiveActualHourMinutes,

      'effective_working_hour_minutes':
      effectiveWorkingHourMinutes,

      'effective_overtime_minutes':
      effectiveOvertimeMinutes,

      // ----------------------------------------------------------------------
      // Backend Compatibility Flags
      // ----------------------------------------------------------------------

      'is_late':
      isLate,

      'is_early_out':
      isEarlyOut,

      'is_absent':
      isAbsent,

      'is_holiday':
      isHoliday,

      'is_present':
      isPresent,
    };
  }

  // ==========================================================================
  // DAY OF WEEK NORMALIZER
  // ==========================================================================

  static int _normalizeDayOfWeek(
      dynamic value, {
        required int fallback,
      }) {
    final int parsed = _toInt(
      value,
      defaultValue: 0,
    );

    if (parsed >= DateTime.monday &&
        parsed <= DateTime.sunday) {
      return parsed;
    }

    if (fallback >= DateTime.monday &&
        fallback <= DateTime.sunday) {
      return fallback;
    }

    return DateTime.monday;
  }

  // ==========================================================================
  // STRING
  // ==========================================================================

  static String _toStringValue(
      dynamic value, {
        String defaultValue = '',
      }) {
    if (value == null) {
      return defaultValue;
    }

    final String result =
    value.toString().trim();

    if (result.isEmpty) {
      return defaultValue;
    }

    return result;
  }

  // ==========================================================================
  // NULLABLE STRING
  // ==========================================================================

  static String? _toNullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final String result =
    value.toString().trim();

    if (result.isEmpty) {
      return null;
    }

    return result;
  }

  // ==========================================================================
  // DOUBLE
  // ==========================================================================

  static double? _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    final String valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return null;
    }

    final double? result =
    double.tryParse(valueString);

    if (result == null ||
        !result.isFinite) {
      return null;
    }

    return result;
  }

  // ==========================================================================
  // INTEGER
  // ==========================================================================

  static int _toInt(
      dynamic value, {
        int defaultValue = 0,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    final String valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return defaultValue;
    }

    return int.tryParse(
      valueString,
    ) ??
        defaultValue;
  }

  // ==========================================================================
  // BOOLEAN
  // ==========================================================================

  static bool _toBool(
      dynamic value, {
        bool defaultValue = false,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      if (value == 1) {
        return true;
      }

      if (value == 0) {
        return false;
      }
    }

    final String normalized =
    value
        .toString()
        .trim()
        .toLowerCase();

    switch (normalized) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;

      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;

      default:
        return defaultValue;
    }
  }

  // ==========================================================================
  // REQUIRED DATETIME
  // ==========================================================================

  static DateTime _parseDateTime(
      dynamic value,
      ) {
    if (value is DateTime) {
      return value;
    }

    if (value == null) {
      return DateTime.now();
    }

    final String valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return DateTime.now();
    }

    return DateTime.tryParse(
      valueString,
    ) ??
        DateTime.now();
  }

  // ==========================================================================
  // NULLABLE DATETIME
  // ==========================================================================

  static DateTime? _parseNullableDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final String valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return null;
    }

    return DateTime.tryParse(
      valueString,
    );
  }

  // ==========================================================================
  // STRING
  // ==========================================================================

  @override
  String toString() {
    return 'CompanySupervisorMobileAttendanceReportModel('
        'attendanceId: $attendanceId, '
        'attendanceDate: $attendanceDate, '
        'dayOfWeek: $dayOfWeek, '
        'isWorkingDay: $isWorkingDay, '
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
        'checkInTime: $checkInTime, '
        'checkOutTime: $checkOutTime, '
        'actualHourMinutes: $actualHourMinutes, '
        'workingHourMinutes: $workingHourMinutes, '
        'calculatedOvertimeMinutes: '
        '$calculatedOvertimeMinutes, '
        'calculatedLateMinutes: '
        '$calculatedLateMinutes, '
        'calculatedEarlyOutMinutes: '
        '$calculatedEarlyOutMinutes, '
        'calculatedAttendanceStatus: '
        '$calculatedAttendanceStatus'
        ')';
  }
}