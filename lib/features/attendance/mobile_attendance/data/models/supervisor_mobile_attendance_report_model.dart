import '../../domain/entities/supervisor_mobile_attendance_report_entity.dart';

class SupervisorMobileAttendanceReportModel
    extends SupervisorMobileAttendanceReportEntity {
  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const SupervisorMobileAttendanceReportModel({
    required super.attendanceDate,
    super.attendanceId,
    super.attendanceNo,
    super.companyId,
    super.employeeId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    required super.attendanceStatus,
    super.employeeCode,
    super.employeeName,
    super.employeeEmail,
    super.employeePhone,
    super.employeeProfilePhoto,
    super.departmentName,
    super.designationName,
    super.shiftName,
    super.shiftCode,
    super.shiftStartTime,
    super.shiftEndTime,
    super.breakMinutes,
    super.lateGraceMinutes,
    super.earlyLeaveGraceMinutes,
    super.minimumWorkingMinutes,
    super.halfDayThresholdMinutes,
    super.isNightShift,
    super.isFlexible,
    super.checkInRequired,
    super.checkOutRequired,
    required super.dayOfWeek,
    super.isWorkingDay,
    super.checkInTime,
    super.checkInLatitude,
    super.checkInLongitude,
    super.checkInAddress,
    super.checkInAccuracy,
    super.checkOutTime,
    super.checkOutLatitude,
    super.checkOutLongitude,
    super.checkOutAddress,
    super.checkOutAccuracy,
    required super.reportStatus,
    super.lateMinutes,
    super.earlyLeaveMinutes,
    super.actualWorkMinutes,
    super.overtimeMinutes,
    super.isLate,
    super.isEarlyOut,
    super.isAbsent,
    super.isHoliday,
    super.isPresent,
  });

  //=================================================================
  // FROM JSON
  //=================================================================

  factory SupervisorMobileAttendanceReportModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SupervisorMobileAttendanceReportModel(
      attendanceDate: DateTime.parse(
        json['attendance_date'].toString(),
      ),
      attendanceId: json['attendance_id']?.toString() ??
          json['id']?.toString(),
      attendanceNo: json['attendance_no']?.toString(),
      companyId: json['company_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      departmentId: json['department_id']?.toString(),
      designationId: json['designation_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      attendanceStatus:
      json['attendance_status']?.toString().trim().toUpperCase() ??
          'PRESENT',
      employeeCode: json['employee_code']?.toString(),
      employeeName: json['employee_name']?.toString(),
      employeeEmail: json['employee_email']?.toString(),
      employeePhone: json['employee_phone']?.toString(),
      employeeProfilePhoto:
      json['employee_profile_photo']?.toString(),
      departmentName: json['department_name']?.toString(),
      designationName: json['designation_name']?.toString(),
      shiftName: json['shift_name']?.toString(),
      shiftCode: json['shift_code']?.toString(),
      shiftStartTime: json['shift_start_time']?.toString(),
      shiftEndTime: json['shift_end_time']?.toString(),
      breakMinutes: _parseInt(
        json['break_minutes'],
      ),
      lateGraceMinutes: _parseInt(
        json['late_grace_minutes'],
      ),
      earlyLeaveGraceMinutes: _parseInt(
        json['early_leave_grace_minutes'],
      ),
      minimumWorkingMinutes: _parseInt(
        json['minimum_working_minutes'],
      ),
      halfDayThresholdMinutes: _parseInt(
        json['half_day_threshold_minutes'],
      ),
      isNightShift: _parseBool(
        json['is_night_shift'],
      ),
      isFlexible: _parseBool(
        json['is_flexible'],
      ),
      checkInRequired: json['check_in_required'] == null
          ? true
          : _parseBool(
        json['check_in_required'],
      ),
      checkOutRequired: json['check_out_required'] == null
          ? true
          : _parseBool(
        json['check_out_required'],
      ),
      dayOfWeek: _parseInt(
        json['day_of_week'],
      ) >
          0
          ? _parseInt(
        json['day_of_week'],
      )
          : DateTime.parse(
        json['attendance_date'].toString(),
      ).weekday,
      isWorkingDay: json['is_working_day'] == null
          ? true
          : _parseBool(
        json['is_working_day'],
      ),
      checkInTime: _parseDateTime(
        json['check_in_time'],
      ),
      checkInLatitude: _parseDouble(
        json['check_in_latitude'],
      ),
      checkInLongitude: _parseDouble(
        json['check_in_longitude'],
      ),
      checkInAddress: json['check_in_address']?.toString(),
      checkInAccuracy: _parseDouble(
        json['check_in_accuracy'],
      ),
      checkOutTime: _parseDateTime(
        json['check_out_time'],
      ),
      checkOutLatitude: _parseDouble(
        json['check_out_latitude'],
      ),
      checkOutLongitude: _parseDouble(
        json['check_out_longitude'],
      ),
      checkOutAddress: json['check_out_address']?.toString(),
      checkOutAccuracy: _parseDouble(
        json['check_out_accuracy'],
      ),
      reportStatus:
      json['report_status']?.toString().trim().isNotEmpty == true
          ? json['report_status'].toString().trim()
          : json['attendance_status']
          ?.toString()
          .trim()
          .toUpperCase() ??
          'PRESENT',
      lateMinutes: _parseInt(
        json['late_minutes'],
      ),
      earlyLeaveMinutes: _parseInt(
        json['early_leave_minutes'],
      ),
      actualWorkMinutes: _parseInt(
        json['actual_work_minutes'],
      ),
      overtimeMinutes: _parseInt(
        json['overtime_minutes'],
      ),
      isLate: _parseBool(
        json['is_late'],
      ),
      isEarlyOut: _parseBool(
        json['is_early_out'],
      ),
      isAbsent: _parseBool(
        json['is_absent'],
      ),
      isHoliday: _parseBool(
        json['is_holiday'],
      ),
      isPresent: _parseBool(
        json['is_present'],
      ),
    );
  }

  //=================================================================
  // TO JSON
  //=================================================================

  Map<String, dynamic> toJson() {
    return {
      'attendance_date': attendanceDate.toIso8601String(),
      'attendance_id': attendanceId,
      'attendance_no': attendanceNo,
      'company_id': companyId,
      'employee_id': employeeId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'attendance_status': attendanceStatus,
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'employee_email': employeeEmail,
      'employee_phone': employeePhone,
      'employee_profile_photo': employeeProfilePhoto,
      'department_name': departmentName,
      'designation_name': designationName,
      'shift_name': shiftName,
      'shift_code': shiftCode,
      'shift_start_time': shiftStartTime,
      'shift_end_time': shiftEndTime,
      'break_minutes': breakMinutes,
      'late_grace_minutes': lateGraceMinutes,
      'early_leave_grace_minutes':
      earlyLeaveGraceMinutes,
      'minimum_working_minutes':
      minimumWorkingMinutes,
      'half_day_threshold_minutes':
      halfDayThresholdMinutes,
      'is_night_shift': isNightShift,
      'is_flexible': isFlexible,
      'check_in_required': checkInRequired,
      'check_out_required': checkOutRequired,
      'day_of_week': dayOfWeek,
      'is_working_day': isWorkingDay,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_in_latitude': checkInLatitude,
      'check_in_longitude': checkInLongitude,
      'check_in_address': checkInAddress,
      'check_in_accuracy': checkInAccuracy,
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_out_latitude': checkOutLatitude,
      'check_out_longitude': checkOutLongitude,
      'check_out_address': checkOutAddress,
      'check_out_accuracy': checkOutAccuracy,
      'report_status': reportStatus,
      'late_minutes': lateMinutes,
      'early_leave_minutes': earlyLeaveMinutes,
      'actual_work_minutes': actualWorkMinutes,
      'overtime_minutes': overtimeMinutes,
      'is_late': isLate,
      'is_early_out': isEarlyOut,
      'is_absent': isAbsent,
      'is_holiday': isHoliday,
      'is_present': isPresent,
    };
  }

  //=================================================================
  // PARSE DATE TIME
  //=================================================================

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  //=================================================================
  // PARSE DOUBLE
  //=================================================================

  static double? _parseDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  //=================================================================
  // PARSE INT
  //=================================================================

  static int _parseInt(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  //=================================================================
  // PARSE BOOL
  //=================================================================

  static bool _parseBool(
      dynamic value,
      ) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value
        .toString()
        .trim()
        .toLowerCase();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes';
  }
}