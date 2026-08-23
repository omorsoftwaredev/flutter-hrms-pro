import '../../domain/entities/mobile_attendance_report_entity.dart';

class MobileAttendanceReportModel
    extends MobileAttendanceReportEntity {
  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const MobileAttendanceReportModel({
    required super.attendanceDate,

    super.attendanceId,

    super.attendanceNo,

    super.companyId,

    super.employeeId,

    super.departmentId,

    super.designationId,

    super.shiftId,

    super.attendanceStatus,

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

    super.reportStatus,

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
  // FROM ENTITY
  //=================================================================

  factory MobileAttendanceReportModel.fromEntity(
      MobileAttendanceReportEntity entity,
      ) {
    return MobileAttendanceReportModel(
      attendanceDate:
      entity.attendanceDate,

      attendanceId:
      entity.attendanceId,

      attendanceNo:
      entity.attendanceNo,

      companyId:
      entity.companyId,

      employeeId:
      entity.employeeId,

      departmentId:
      entity.departmentId,

      designationId:
      entity.designationId,

      shiftId:
      entity.shiftId,

      attendanceStatus:
      entity.attendanceStatus,

      shiftName:
      entity.shiftName,

      shiftCode:
      entity.shiftCode,

      shiftStartTime:
      entity.shiftStartTime,

      shiftEndTime:
      entity.shiftEndTime,

      breakMinutes:
      entity.breakMinutes,

      lateGraceMinutes:
      entity.lateGraceMinutes,

      earlyLeaveGraceMinutes:
      entity.earlyLeaveGraceMinutes,

      minimumWorkingMinutes:
      entity.minimumWorkingMinutes,

      halfDayThresholdMinutes:
      entity.halfDayThresholdMinutes,

      isNightShift:
      entity.isNightShift,

      isFlexible:
      entity.isFlexible,

      checkInRequired:
      entity.checkInRequired,

      checkOutRequired:
      entity.checkOutRequired,

      dayOfWeek:
      entity.dayOfWeek,

      isWorkingDay:
      entity.isWorkingDay,

      checkInTime:
      entity.checkInTime,

      checkInLatitude:
      entity.checkInLatitude,

      checkInLongitude:
      entity.checkInLongitude,

      checkInAddress:
      entity.checkInAddress,

      checkInAccuracy:
      entity.checkInAccuracy,

      checkOutTime:
      entity.checkOutTime,

      checkOutLatitude:
      entity.checkOutLatitude,

      checkOutLongitude:
      entity.checkOutLongitude,

      checkOutAddress:
      entity.checkOutAddress,

      checkOutAccuracy:
      entity.checkOutAccuracy,

      reportStatus:
      entity.reportStatus,

      lateMinutes:
      entity.lateMinutes,

      earlyLeaveMinutes:
      entity.earlyLeaveMinutes,

      actualWorkMinutes:
      entity.actualWorkMinutes,

      overtimeMinutes:
      entity.overtimeMinutes,

      isLate:
      entity.isLate,

      isEarlyOut:
      entity.isEarlyOut,

      isAbsent:
      entity.isAbsent,

      isHoliday:
      entity.isHoliday,

      isPresent:
      entity.isPresent,
    );
  }

  //=================================================================
  // FROM JSON
  //=================================================================

  factory MobileAttendanceReportModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final attendanceDate =
    _parseDateTime(
      json['attendance_date'],
    );

    final checkInTime =
    _parseDateTimeNullable(
      json['check_in_time'],
    );

    final checkOutTime =
    _parseDateTimeNullable(
      json['check_out_time'],
    );

    final attendanceStatus =
        _parseString(
          json['attendance_status'],
        ) ??
            'PRESENT';

    final isHoliday =
    _parseBool(
      json['is_holiday'],
    );

    final isPresent =
    _parseBool(
      json['is_present'],
    );

    final isAbsent =
    _parseBool(
      json['is_absent'],
    );

    final isLate =
    _parseBool(
      json['is_late'],
    );

    final isEarlyOut =
    _parseBool(
      json['is_early_out'],
    );

    final reportStatus =
        _parseString(
          json['report_status'],
        ) ??
            _calculateReportStatus(
              attendanceStatus:
              attendanceStatus,
              isHoliday:
              isHoliday,
              isPresent:
              isPresent,
              isAbsent:
              isAbsent,
              checkInTime:
              checkInTime,
            );

    return MobileAttendanceReportModel(
      //=============================================================
      // DATE
      //=============================================================

      attendanceDate:
      attendanceDate,

      //=============================================================
      // ATTENDANCE
      //=============================================================

      attendanceId:
      _parseString(
        json['attendance_id'] ??
            json['id'],
      ),

      attendanceNo:
      _parseString(
        json['attendance_no'],
      ),

      companyId:
      _parseString(
        json['company_id'],
      ),

      employeeId:
      _parseString(
        json['employee_id'],
      ),

      departmentId:
      _parseString(
        json['department_id'],
      ),

      designationId:
      _parseString(
        json['designation_id'],
      ),

      shiftId:
      _parseString(
        json['shift_id'],
      ),

      attendanceStatus:
      attendanceStatus,

      //=============================================================
      // SHIFT
      //=============================================================

      shiftName:
      _parseString(
        json['shift_name'],
      ),

      shiftCode:
      _parseString(
        json['shift_code'],
      ),

      shiftStartTime:
      _parseString(
        json['shift_start_time'],
      ),

      shiftEndTime:
      _parseString(
        json['shift_end_time'],
      ),

      breakMinutes:
      _parseInt(
        json['break_minutes'],
      ),

      lateGraceMinutes:
      _parseInt(
        json['late_grace_minutes'],
      ),

      earlyLeaveGraceMinutes:
      _parseInt(
        json['early_leave_grace_minutes'],
      ),

      minimumWorkingMinutes:
      _parseInt(
        json['minimum_working_minutes'],
      ),

      halfDayThresholdMinutes:
      _parseInt(
        json['half_day_threshold_minutes'],
      ),

      isNightShift:
      _parseBool(
        json['is_night_shift'],
      ),

      isFlexible:
      _parseBool(
        json['is_flexible'],
      ),

      checkInRequired:
      json.containsKey(
        'check_in_required',
      )
          ? _parseBool(
        json['check_in_required'],
      )
          : true,

      checkOutRequired:
      json.containsKey(
        'check_out_required',
      )
          ? _parseBool(
        json['check_out_required'],
      )
          : true,

      //=============================================================
      // COMPANY WORKING DAY
      //=============================================================

      dayOfWeek:
      _parseInt(
        json['day_of_week'],
        fallback:
        attendanceDate.weekday,
      ),

      isWorkingDay:
      json.containsKey(
        'is_working_day',
      )
          ? _parseBool(
        json['is_working_day'],
      )
          : true,

      //=============================================================
      // CHECK-IN
      //=============================================================

      checkInTime:
      checkInTime,

      checkInLatitude:
      _parseDouble(
        json['check_in_latitude'],
      ),

      checkInLongitude:
      _parseDouble(
        json['check_in_longitude'],
      ),

      checkInAddress:
      _parseString(
        json['check_in_address'],
      ),

      checkInAccuracy:
      _parseDouble(
        json['check_in_accuracy'],
      ),

      //=============================================================
      // CHECK-OUT
      //=============================================================

      checkOutTime:
      checkOutTime,

      checkOutLatitude:
      _parseDouble(
        json['check_out_latitude'],
      ),

      checkOutLongitude:
      _parseDouble(
        json['check_out_longitude'],
      ),

      checkOutAddress:
      _parseString(
        json['check_out_address'],
      ),

      checkOutAccuracy:
      _parseDouble(
        json['check_out_accuracy'],
      ),

      //=============================================================
      // CALCULATED REPORT INFORMATION
      //=============================================================

      reportStatus:
      reportStatus,

      lateMinutes:
      _parseInt(
        json['late_minutes'],
      ),

      earlyLeaveMinutes:
      _parseInt(
        json['early_leave_minutes'],
      ),

      actualWorkMinutes:
      _parseInt(
        json['actual_work_minutes'],
      ),

      overtimeMinutes:
      _parseInt(
        json['overtime_minutes'],
      ),

      isLate:
      isLate,

      isEarlyOut:
      isEarlyOut,

      isAbsent:
      isAbsent,

      isHoliday:
      isHoliday,

      isPresent:
      isPresent,
    );
  }

  //=================================================================
  // TO JSON
  //=================================================================

  Map<String, dynamic> toJson() {
    return {
      //===============================================================
      // DATE
      //===============================================================

      'attendance_date':
      _formatDate(
        attendanceDate,
      ),

      //===============================================================
      // ATTENDANCE
      //===============================================================

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

      //===============================================================
      // SHIFT
      //===============================================================

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

      'late_grace_minutes':
      lateGraceMinutes,

      'early_leave_grace_minutes':
      earlyLeaveGraceMinutes,

      'minimum_working_minutes':
      minimumWorkingMinutes,

      'half_day_threshold_minutes':
      halfDayThresholdMinutes,

      'is_night_shift':
      isNightShift,

      'is_flexible':
      isFlexible,

      'check_in_required':
      checkInRequired,

      'check_out_required':
      checkOutRequired,

      //===============================================================
      // COMPANY WORKING DAY
      //===============================================================

      'day_of_week':
      dayOfWeek,

      'is_working_day':
      isWorkingDay,

      //===============================================================
      // CHECK-IN
      //===============================================================

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

      //===============================================================
      // CHECK-OUT
      //===============================================================

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

      //===============================================================
      // CALCULATED REPORT INFORMATION
      //===============================================================

      'report_status':
      reportStatus,

      'late_minutes':
      lateMinutes,

      'early_leave_minutes':
      earlyLeaveMinutes,

      'actual_work_minutes':
      actualWorkMinutes,

      'overtime_minutes':
      overtimeMinutes,

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

  //=================================================================
  // TO DATABASE JSON
  //=================================================================

  Map<String, dynamic> toDatabaseJson() {
    return {
      'attendance_date':
      _formatDate(
        attendanceDate,
      ),

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

      'late_minutes':
      lateMinutes,

      'early_leave_minutes':
      earlyLeaveMinutes,

      'actual_work_minutes':
      actualWorkMinutes,

      'overtime_minutes':
      overtimeMinutes,

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

      'report_status':
      reportStatus,
    };
  }

  //=================================================================
  // COPY WITH
  //=================================================================

  MobileAttendanceReportModel copyWithModel({
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
    return MobileAttendanceReportModel(
      attendanceDate:
      attendanceDate ??
          this.attendanceDate,

      attendanceId:
      attendanceId ??
          this.attendanceId,

      attendanceNo:
      attendanceNo ??
          this.attendanceNo,

      companyId:
      companyId ??
          this.companyId,

      employeeId:
      employeeId ??
          this.employeeId,

      departmentId:
      departmentId ??
          this.departmentId,

      designationId:
      designationId ??
          this.designationId,

      shiftId:
      shiftId ??
          this.shiftId,

      attendanceStatus:
      attendanceStatus ??
          this.attendanceStatus,

      shiftName:
      shiftName ??
          this.shiftName,

      shiftCode:
      shiftCode ??
          this.shiftCode,

      shiftStartTime:
      shiftStartTime ??
          this.shiftStartTime,

      shiftEndTime:
      shiftEndTime ??
          this.shiftEndTime,

      breakMinutes:
      breakMinutes ??
          this.breakMinutes,

      lateGraceMinutes:
      lateGraceMinutes ??
          this.lateGraceMinutes,

      earlyLeaveGraceMinutes:
      earlyLeaveGraceMinutes ??
          this.earlyLeaveGraceMinutes,

      minimumWorkingMinutes:
      minimumWorkingMinutes ??
          this.minimumWorkingMinutes,

      halfDayThresholdMinutes:
      halfDayThresholdMinutes ??
          this.halfDayThresholdMinutes,

      isNightShift:
      isNightShift ??
          this.isNightShift,

      isFlexible:
      isFlexible ??
          this.isFlexible,

      checkInRequired:
      checkInRequired ??
          this.checkInRequired,

      checkOutRequired:
      checkOutRequired ??
          this.checkOutRequired,

      dayOfWeek:
      dayOfWeek ??
          this.dayOfWeek,

      isWorkingDay:
      isWorkingDay ??
          this.isWorkingDay,

      checkInTime:
      checkInTime ??
          this.checkInTime,

      checkInLatitude:
      checkInLatitude ??
          this.checkInLatitude,

      checkInLongitude:
      checkInLongitude ??
          this.checkInLongitude,

      checkInAddress:
      checkInAddress ??
          this.checkInAddress,

      checkInAccuracy:
      checkInAccuracy ??
          this.checkInAccuracy,

      checkOutTime:
      checkOutTime ??
          this.checkOutTime,

      checkOutLatitude:
      checkOutLatitude ??
          this.checkOutLatitude,

      checkOutLongitude:
      checkOutLongitude ??
          this.checkOutLongitude,

      checkOutAddress:
      checkOutAddress ??
          this.checkOutAddress,

      checkOutAccuracy:
      checkOutAccuracy ??
          this.checkOutAccuracy,

      reportStatus:
      reportStatus ??
          this.reportStatus,

      lateMinutes:
      lateMinutes ??
          this.lateMinutes,

      earlyLeaveMinutes:
      earlyLeaveMinutes ??
          this.earlyLeaveMinutes,

      actualWorkMinutes:
      actualWorkMinutes ??
          this.actualWorkMinutes,

      overtimeMinutes:
      overtimeMinutes ??
          this.overtimeMinutes,

      isLate:
      isLate ??
          this.isLate,

      isEarlyOut:
      isEarlyOut ??
          this.isEarlyOut,

      isAbsent:
      isAbsent ??
          this.isAbsent,

      isHoliday:
      isHoliday ??
          this.isHoliday,

      isPresent:
      isPresent ??
          this.isPresent,
    );
  }

  //=================================================================
  // DATE PARSER
  //=================================================================

  static DateTime _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return DateTime.now();
    }

    if (value is DateTime) {
      return value;
    }

    final parsed =
    DateTime.tryParse(
      value.toString(),
    );

    return parsed ?? DateTime.now();
  }

  //=================================================================
  // NULLABLE DATE PARSER
  //=================================================================

  static DateTime? _parseDateTimeNullable(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final text =
    value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return DateTime.tryParse(text);
  }

  //=================================================================
  // STRING PARSER
  //=================================================================

  static String? _parseString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final text =
    value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  //=================================================================
  // DOUBLE PARSER
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
      value.toString().trim(),
    );
  }

  //=================================================================
  // INT PARSER
  //=================================================================

  static int _parseInt(
      dynamic value, {
        int fallback = 0,
      }) {
    if (value == null) {
      return fallback;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    ) ??
        fallback;
  }

  //=================================================================
  // BOOL PARSER
  //=================================================================

  static bool _parseBool(
      dynamic value, {
        bool fallback = false,
      }) {
    if (value == null) {
      return fallback;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized =
    value
        .toString()
        .trim()
        .toLowerCase();

    if (normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'y') {
      return true;
    }

    if (normalized == 'false' ||
        normalized == '0' ||
        normalized == 'no' ||
        normalized == 'n') {
      return false;
    }

    return fallback;
  }

  //=================================================================
  // FORMAT DATE
  //=================================================================

  static String _formatDate(
      DateTime date,
      ) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  //=================================================================
  // CALCULATE REPORT STATUS
  //=================================================================

  static String _calculateReportStatus({
    required String attendanceStatus,
    required bool isHoliday,
    required bool isPresent,
    required bool isAbsent,
    required DateTime? checkInTime,
  }) {
    final status =
    attendanceStatus
        .trim()
        .toUpperCase();

    if (isHoliday) {
      return 'HOLIDAY';
    }

    if (status == 'HOLIDAY') {
      return 'HOLIDAY';
    }

    if (status == 'ABSENT') {
      return 'ABSENT';
    }

    if (status == 'LEAVE') {
      return 'LEAVE';
    }

    if (status == 'HALF_DAY') {
      return 'HALF_DAY';
    }

    if (isAbsent) {
      return 'ABSENT';
    }

    if (isPresent ||
        checkInTime != null ||
        status == 'PRESENT') {
      return 'PRESENT';
    }

    return 'ABSENT';
  }
}