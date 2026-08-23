import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/helpers/database_error_helper.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../domain/entities/mobile_attendance_report_entity.dart';
import '../models/mobile_attendance_report_model.dart';
import 'mobile_attendance_report_repository.dart';

class MobileAttendanceReportRepositoryImpl
    implements MobileAttendanceReportRepository {
  //=================================================================
  // SUPABASE
  //=================================================================

  final SupabaseClient _supabase = SupabaseService.client;

  static const String _attendanceTable = 'attendance';

  //=================================================================
  // DATE FORMAT
  //=================================================================

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  //=================================================================
  // START OF DAY
  //=================================================================

  DateTime _startOfDay(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  //=================================================================
  // END OF DAY
  //=================================================================

  DateTime _endOfDay(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    );
  }

  //=================================================================
  // PARSE DATE TIME
  //=================================================================

  DateTime? _parseDateTime(dynamic value) {
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

  double? _parseDouble(dynamic value) {
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

  int _parseInt(dynamic value) {
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

  bool _parseBool(dynamic value) {
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

  //=================================================================
  // TIME TO MINUTES
  //=================================================================

  int _timeToMinutes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 0;
    }

    try {
      final parts = value.trim().split(':');

      if (parts.length < 2) {
        return 0;
      }

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      if (hour < 0 || hour > 23) {
        return 0;
      }

      if (minute < 0 || minute > 59) {
        return 0;
      }

      return (hour * 60) + minute;
    } catch (_) {
      return 0;
    }
  }

  //=================================================================
  // BUILD SCHEDULED TIME
  //=================================================================

  DateTime? _buildScheduledTime({
    required DateTime attendanceDate,
    required String? time,
    bool nextDay = false,
  }) {
    final minutes = _timeToMinutes(time);

    if (minutes <= 0) {
      return null;
    }

    final baseDate = nextDay
        ? attendanceDate.add(
      const Duration(days: 1),
    )
        : attendanceDate;

    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  //=================================================================
  // DETECT NIGHT SHIFT
  //=================================================================

  bool _isOvernightShift({
    required String? shiftStartTime,
    required String? shiftEndTime,
    required bool isNightShift,
  }) {
    if (isNightShift) {
      return true;
    }

    final start = _timeToMinutes(
      shiftStartTime,
    );

    final end = _timeToMinutes(
      shiftEndTime,
    );

    if (start <= 0 || end <= 0) {
      return false;
    }

    return end < start;
  }

  //=================================================================
  // ACTUAL WORK MINUTES
  //=================================================================

  int _calculateActualWorkMinutes({
    required DateTime? checkIn,
    required DateTime? checkOut,
    required int breakMinutes,
  }) {
    if (checkIn == null || checkOut == null) {
      return 0;
    }

    final difference = checkOut
        .difference(checkIn)
        .inMinutes;

    final actual = difference - breakMinutes;

    return actual < 0 ? 0 : actual;
  }

  //=================================================================
  // LATE MINUTES
  //=================================================================

  int _calculateLateMinutes({
    required DateTime attendanceDate,
    required DateTime? checkIn,
    required String? shiftStartTime,
    required int lateGraceMinutes,
  }) {
    if (checkIn == null ||
        shiftStartTime == null ||
        shiftStartTime.trim().isEmpty) {
      return 0;
    }

    final scheduledStart = _buildScheduledTime(
      attendanceDate: attendanceDate,
      time: shiftStartTime,
    );

    if (scheduledStart == null) {
      return 0;
    }

    final allowedStart = scheduledStart.add(
      Duration(
        minutes: lateGraceMinutes,
      ),
    );

    if (!checkIn.isAfter(allowedStart)) {
      return 0;
    }

    return checkIn
        .difference(scheduledStart)
        .inMinutes;
  }

  //=================================================================
  // EARLY LEAVE MINUTES
  //=================================================================

  int _calculateEarlyLeaveMinutes({
    required DateTime attendanceDate,
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String? shiftStartTime,
    required String? shiftEndTime,
    required int earlyLeaveGraceMinutes,
    required bool isNightShift,
  }) {
    if (checkOut == null ||
        shiftEndTime == null ||
        shiftEndTime.trim().isEmpty) {
      return 0;
    }

    final overnight = _isOvernightShift(
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      isNightShift: isNightShift,
    );

    final scheduledEnd = _buildScheduledTime(
      attendanceDate: attendanceDate,
      time: shiftEndTime,
      nextDay: overnight,
    );

    if (scheduledEnd == null) {
      return 0;
    }

    final allowedEnd = scheduledEnd.subtract(
      Duration(
        minutes: earlyLeaveGraceMinutes,
      ),
    );

    if (!checkOut.isBefore(allowedEnd)) {
      return 0;
    }

    return scheduledEnd
        .difference(checkOut)
        .inMinutes;
  }

  //=================================================================
  // OVERTIME MINUTES
  //=================================================================

  int _calculateOvertimeMinutes({
    required DateTime attendanceDate,
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String? shiftStartTime,
    required String? shiftEndTime,
    required bool isNightShift,
  }) {
    if (checkOut == null ||
        shiftEndTime == null ||
        shiftEndTime.trim().isEmpty) {
      return 0;
    }

    final overnight = _isOvernightShift(
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      isNightShift: isNightShift,
    );

    final scheduledEnd = _buildScheduledTime(
      attendanceDate: attendanceDate,
      time: shiftEndTime,
      nextDay: overnight,
    );

    if (scheduledEnd == null) {
      return 0;
    }

    if (!checkOut.isAfter(scheduledEnd)) {
      return 0;
    }

    return checkOut
        .difference(scheduledEnd)
        .inMinutes;
  }

  //=================================================================
  // BUILD REPORT
  //=================================================================

  MobileAttendanceReportModel _buildReport(
      Map<String, dynamic> json,
      ) {
    final attendanceDate =
        _parseDateTime(
          json['attendance_date'],
        ) ??
            DateTime.now();

    final checkIn = _parseDateTime(
      json['check_in_time'],
    );

    final checkOut = _parseDateTime(
      json['check_out_time'],
    );

    final shiftStartTime =
    json['shift_start_time']?.toString();

    final shiftEndTime =
    json['shift_end_time']?.toString();

    final breakMinutes = _parseInt(
      json['break_minutes'],
    );

    final lateGraceMinutes = _parseInt(
      json['late_grace_minutes'],
    );

    final earlyLeaveGraceMinutes =
    _parseInt(
      json['early_leave_grace_minutes'],
    );

    // ---------------------------------------------------------------
    // These two fields are intentionally read from attendance only.
    //
    // They are NOT requested from shifts because the current
    // shifts table does not contain these columns.
    // ---------------------------------------------------------------

    final minimumWorkingMinutes =
    _parseInt(
      json['minimum_working_minutes'],
    );

    final halfDayThresholdMinutes =
    _parseInt(
      json['half_day_threshold_minutes'],
    );

    final isNightShift = _parseBool(
      json['is_night_shift'],
    );

    final isFlexible = _parseBool(
      json['is_flexible'],
    );

    final actualWorkMinutes =
    _parseInt(
      json['actual_work_minutes'],
    ) > 0
        ? _parseInt(
      json['actual_work_minutes'],
    )
        : _calculateActualWorkMinutes(
      checkIn: checkIn,
      checkOut: checkOut,
      breakMinutes: breakMinutes,
    );

    final lateMinutes =
    _parseInt(
      json['late_minutes'],
    ) > 0
        ? _parseInt(
      json['late_minutes'],
    )
        : _calculateLateMinutes(
      attendanceDate: attendanceDate,
      checkIn: checkIn,
      shiftStartTime: shiftStartTime,
      lateGraceMinutes: lateGraceMinutes,
    );

    final earlyLeaveMinutes =
    _parseInt(
      json['early_leave_minutes'],
    ) > 0
        ? _parseInt(
      json['early_leave_minutes'],
    )
        : _calculateEarlyLeaveMinutes(
      attendanceDate: attendanceDate,
      checkIn: checkIn,
      checkOut: checkOut,
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      earlyLeaveGraceMinutes:
      earlyLeaveGraceMinutes,
      isNightShift: isNightShift,
    );

    final overtimeMinutes =
    _parseInt(
      json['overtime_minutes'],
    ) > 0
        ? _parseInt(
      json['overtime_minutes'],
    )
        : _calculateOvertimeMinutes(
      attendanceDate: attendanceDate,
      checkIn: checkIn,
      checkOut: checkOut,
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      isNightShift: isNightShift,
    );

    final status = json['attendance_status']
        ?.toString()
        .trim()
        .toUpperCase();

    final normalizedStatus =
    status == null || status.isEmpty
        ? 'PRESENT'
        : status;

    final isPresent =
        _parseBool(
          json['is_present'],
        ) ||
            normalizedStatus == 'PRESENT';

    final isAbsent =
        _parseBool(
          json['is_absent'],
        ) ||
            normalizedStatus == 'ABSENT';

    final isLate =
        _parseBool(
          json['is_late'],
        ) ||
            lateMinutes > 0;

    final isEarlyOut =
        _parseBool(
          json['is_early_out'],
        ) ||
            earlyLeaveMinutes > 0;

    final isHoliday = _parseBool(
      json['is_holiday'],
    );

    final reportStatus =
    json['report_status']
        ?.toString()
        .trim()
        .isNotEmpty ==
        true
        ? json['report_status']
        .toString()
        .trim()
        : _resolveReportStatus(
      attendanceStatus: normalizedStatus,
      isHoliday: isHoliday,
      isAbsent: isAbsent,
      isPresent: isPresent,
      isLate: isLate,
      isEarlyOut: isEarlyOut,
      checkIn: checkIn,
      checkOut: checkOut,
    );

    return MobileAttendanceReportModel(
      attendanceDate: attendanceDate,

      attendanceId:
      json['attendance_id']?.toString() ??
          json['id']?.toString(),

      attendanceNo:
      json['attendance_no']?.toString(),

      companyId:
      json['company_id']?.toString(),

      employeeId:
      json['employee_id']?.toString(),

      departmentId:
      json['department_id']?.toString(),

      designationId:
      json['designation_id']?.toString(),

      shiftId:
      json['shift_id']?.toString(),

      attendanceStatus:
      normalizedStatus,

      shiftName:
      json['shift_name']?.toString(),

      shiftCode:
      json['shift_code']?.toString(),

      shiftStartTime:
      shiftStartTime,

      shiftEndTime:
      shiftEndTime,

      breakMinutes:
      breakMinutes,

      lateGraceMinutes:
      lateGraceMinutes,

      earlyLeaveGraceMinutes:
      earlyLeaveGraceMinutes,

      minimumWorkingMinutes:
      minimumWorkingMinutes,

      halfDayThresholdMinutes:
      halfDayThresholdMinutes,

      isNightShift:
      isNightShift,

      isFlexible:
      isFlexible,

      checkInRequired:
      json['check_in_required'] == null
          ? true
          : _parseBool(
        json['check_in_required'],
      ),

      checkOutRequired:
      json['check_out_required'] == null
          ? true
          : _parseBool(
        json['check_out_required'],
      ),

      dayOfWeek:
      _parseInt(
        json['day_of_week'],
      ) >
          0
          ? _parseInt(
        json['day_of_week'],
      )
          : attendanceDate.weekday,

      isWorkingDay:
      json['is_working_day'] == null
          ? true
          : _parseBool(
        json['is_working_day'],
      ),

      checkInTime:
      checkIn,

      checkInLatitude:
      _parseDouble(
        json['check_in_latitude'],
      ),

      checkInLongitude:
      _parseDouble(
        json['check_in_longitude'],
      ),

      checkInAddress:
      json['check_in_address']
          ?.toString(),

      checkInAccuracy:
      _parseDouble(
        json['check_in_accuracy'],
      ),

      checkOutTime:
      checkOut,

      checkOutLatitude:
      _parseDouble(
        json['check_out_latitude'],
      ),

      checkOutLongitude:
      _parseDouble(
        json['check_out_longitude'],
      ),

      checkOutAddress:
      json['check_out_address']
          ?.toString(),

      checkOutAccuracy:
      _parseDouble(
        json['check_out_accuracy'],
      ),

      reportStatus:
      reportStatus,

      lateMinutes:
      lateMinutes,

      earlyLeaveMinutes:
      earlyLeaveMinutes,

      actualWorkMinutes:
      actualWorkMinutes,

      overtimeMinutes:
      overtimeMinutes,

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
  // REPORT STATUS
  //=================================================================

  String _resolveReportStatus({
    required String attendanceStatus,
    required bool isHoliday,
    required bool isAbsent,
    required bool isPresent,
    required bool isLate,
    required bool isEarlyOut,
    required DateTime? checkIn,
    required DateTime? checkOut,
  }) {
    if (isHoliday) {
      return 'HOLIDAY';
    }

    if (isAbsent) {
      return 'ABSENT';
    }

    if (attendanceStatus == 'LEAVE') {
      return 'LEAVE';
    }

    if (attendanceStatus == 'OFF') {
      return 'OFF';
    }

    if (isLate && isEarlyOut) {
      return 'LATE & EARLY OUT';
    }

    if (isLate) {
      return 'LATE';
    }

    if (isEarlyOut) {
      return 'EARLY OUT';
    }

    if (isPresent && checkIn != null) {
      if (checkOut != null) {
        return 'PRESENT';
      }

      return 'CHECKED IN';
    }

    return attendanceStatus.isEmpty
        ? 'ABSENT'
        : attendanceStatus;
  }

  //=================================================================
  // LOAD REPORT
  //=================================================================

  Future<MobileAttendanceReportEntity?>
  _loadReport({
    required String employeeId,
    required DateTime date,
  }) async {
    final employee = employeeId.trim();

    if (employee.isEmpty) {
      return null;
    }

    final selectedDate = _formatDate(date);

    try {
      final response = await _supabase
          .from(_attendanceTable)
          .select('''
            *,
            shifts (
              id,
              name,
              code,
              start_time,
              end_time,
              break_minutes,
              late_grace_minutes,
              early_leave_grace_minutes,
              is_night_shift,
              is_flexible,
              check_in_required,
              check_out_required
            )
          ''')
          .eq(
        'employee_id',
        employee,
      )
          .eq(
        'attendance_date',
        selectedDate,
      )
          .order(
        'check_in_time',
        ascending: false,
      )
          .limit(1);

      if (response.isEmpty) {
        return null;
      }

      final raw = Map<String, dynamic>.from(
        response.first,
      );

      _mergeShiftData(raw);

      return _buildReport(raw);
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //=================================================================
  // MERGE SHIFT DATA
  //=================================================================

  void _mergeShiftData(
      Map<String, dynamic> json,
      ) {
    final shift = json['shifts'];

    if (shift is! Map) {
      return;
    }

    final shiftMap =
    Map<String, dynamic>.from(
      shift,
    );

    json['shift_name'] ??=
    shiftMap['name'];

    json['shift_code'] ??=
    shiftMap['code'];

    json['shift_start_time'] ??=
    shiftMap['start_time'];

    json['shift_end_time'] ??=
    shiftMap['end_time'];

    json['break_minutes'] ??=
    shiftMap['break_minutes'];

    json['late_grace_minutes'] ??=
    shiftMap['late_grace_minutes'];

    json['early_leave_grace_minutes'] ??=
    shiftMap[
    'early_leave_grace_minutes'];

    json['is_night_shift'] ??=
    shiftMap['is_night_shift'];

    json['is_flexible'] ??=
    shiftMap['is_flexible'];

    json['check_in_required'] ??=
    shiftMap['check_in_required'];

    json['check_out_required'] ??=
    shiftMap['check_out_required'];

    // IMPORTANT:
    //
    // minimum_working_minutes
    // half_day_threshold_minutes
    //
    // are NOT read from shifts because these
    // columns do not currently exist there.
  }

  //=================================================================
  // GET TODAY REPORT
  //=================================================================

  @override
  Future<MobileAttendanceReportEntity?>
  getTodayReport({
    required String employeeId,
  }) async {
    return _loadReport(
      employeeId: employeeId,
      date: DateTime.now(),
    );
  }

  //=================================================================
  // GET REPORT BY DATE
  //=================================================================

  @override
  Future<MobileAttendanceReportEntity?>
  getReportByDate({
    required String employeeId,
    required DateTime date,
  }) async {
    return _loadReport(
      employeeId: employeeId,
      date: date,
    );
  }

  //=================================================================
  // GET REPORTS BY DATE RANGE
  //=================================================================

  @override
  Future<List<MobileAttendanceReportEntity>>
  getReportsByDateRange({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final employee = employeeId.trim();

    if (employee.isEmpty) {
      return [];
    }

    final start = _startOfDay(
      startDate,
    );

    final end = _endOfDay(
      endDate,
    );

    if (start.isAfter(end)) {
      throw Exception(
        'Start date cannot be after end date.',
      );
    }

    try {
      final response = await _supabase
          .from(_attendanceTable)
          .select('''
            *,
            shifts (
              id,
              name,
              code,
              start_time,
              end_time,
              break_minutes,
              late_grace_minutes,
              early_leave_grace_minutes,
              is_night_shift,
              is_flexible,
              check_in_required,
              check_out_required
            )
          ''')
          .eq(
        'employee_id',
        employee,
      )
          .gte(
        'attendance_date',
        _formatDate(start),
      )
          .lte(
        'attendance_date',
        _formatDate(end),
      )
          .order(
        'attendance_date',
        ascending: true,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      final reports =
      <MobileAttendanceReportEntity>[];

      for (final item in response) {
        final json =
        Map<String, dynamic>.from(
          item,
        );

        _mergeShiftData(json);

        reports.add(
          _buildReport(json),
        );
      }

      return reports;
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //=================================================================
  // GET CURRENT MONTH REPORTS
  //=================================================================

  @override
  Future<List<MobileAttendanceReportEntity>>
  getCurrentMonthReports({
    required String employeeId,
  }) async {
    final now = DateTime.now();

    final startDate = DateTime(
      now.year,
      now.month,
      1,
    );

    final endDate = DateTime(
      now.year,
      now.month + 1,
      0,
    );

    return getReportsByDateRange(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  //=================================================================
  // GET REPORT SUMMARY
  //=================================================================

  @override
  Future<Map<String, dynamic>>
  getReportSummary({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final reports =
    await getReportsByDateRange(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    );

    int present = 0;
    int absent = 0;
    int late = 0;
    int earlyOut = 0;
    int holiday = 0;
    int leave = 0;
    int workingDays = 0;

    int totalLateMinutes = 0;
    int totalEarlyLeaveMinutes = 0;
    int totalActualWorkMinutes = 0;
    int totalOvertimeMinutes = 0;

    for (final report in reports) {
      if (report.isWorkingDay) {
        workingDays++;
      }

      if (report.isPresent) {
        present++;
      }

      if (report.isAbsent) {
        absent++;
      }

      if (report.isLate) {
        late++;
      }

      if (report.isEarlyOut) {
        earlyOut++;
      }

      if (report.isHoliday) {
        holiday++;
      }

      if (report.attendanceStatus
          .toUpperCase() ==
          'LEAVE') {
        leave++;
      }

      totalLateMinutes +=
          report.lateMinutes;

      totalEarlyLeaveMinutes +=
          report.earlyLeaveMinutes;

      totalActualWorkMinutes +=
          report.actualWorkMinutes;

      totalOvertimeMinutes +=
          report.overtimeMinutes;
    }

    final attendanceRate =
    workingDays <= 0
        ? 0.0
        : (present / workingDays) * 100;

    return {
      'employee_id': employeeId,

      'start_date':
      _formatDate(startDate),

      'end_date':
      _formatDate(endDate),

      'total_records':
      reports.length,

      'working_days':
      workingDays,

      'present_days':
      present,

      'absent_days':
      absent,

      'late_days':
      late,

      'early_out_days':
      earlyOut,

      'holiday_days':
      holiday,

      'leave_days':
      leave,

      'total_late_minutes':
      totalLateMinutes,

      'total_early_leave_minutes':
      totalEarlyLeaveMinutes,

      'total_actual_work_minutes':
      totalActualWorkMinutes,

      'total_overtime_minutes':
      totalOvertimeMinutes,

      'attendance_rate':
      double.parse(
        attendanceRate.toStringAsFixed(
          2,
        ),
      ),
    };
  }

  //=================================================================
  // REFRESH TODAY REPORT
  //=================================================================

  @override
  Future<MobileAttendanceReportEntity?>
  refreshTodayReport({
    required String employeeId,
  }) async {
    return getTodayReport(
      employeeId: employeeId,
    );
  }
}