import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/helpers/database_error_helper.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../domain/entities/company_supervisor_mobile_attendance_report_entity.dart';
import '../models/company_supervisor_mobile_attendance_report_model.dart';
import 'company_supervisor_mobile_attendance_report_repository.dart';

///=================================================================
/// COMPANY SUPERVISOR MOBILE ATTENDANCE REPORT REPOSITORY
/// IMPLEMENTATION
///=================================================================
///
/// DATA FLOW
///
/// supervisor
///    ↓
/// assigned departments
///    ↓
/// employees
///    ↓
/// attendance
///    ↓
/// company_working_days
///    ↓
/// local date-wise merge
///    ↓
/// attendance / absent / off-day rows
///    ↓
/// employees
///    ↓
/// departments
///    ↓
/// designations
///    ↓
/// shifts
///    ↓
/// report model
///
/// IMPORTANT
///
/// company_working_days is used to determine whether a date is a
/// working day for the company.
///
/// If:
///
/// is_working_day = false
///     → OFFDAY
///
/// If:
///
/// is_working_day = true
/// AND employee has no attendance
///     → ABSENT
///
/// Attendance rows continue through the existing attendance flow.
///
/// STATUS UI CALCULATION IS NOT CHANGED IN THIS STEP.
///
///=================================================================

class CompanySupervisorMobileAttendanceReportRepositoryImpl
    implements CompanySupervisorMobileAttendanceReportRepository {
  //=================================================================
  // SUPABASE
  //=================================================================

  static final SupabaseClient _supabase = SupabaseService.client;

  //=================================================================
  // TABLES
  //=================================================================

  static const String _attendanceTable = 'attendance';

  static const String _employeesTable = 'employees';

  static const String _departmentsTable = 'departments';

  static const String _designationsTable = 'designations';

  static const String _shiftsTable = 'shifts';

  static const String _supervisorsTable = 'supervisors';

  static const String _supervisorDepartmentsTable =
      'supervisor_departments';

  /// NEW
  static const String _companyWorkingDaysTable =
      'company_working_days';

  //=================================================================
  // DEBUG
  //=================================================================

  static const bool _enableDebugLogs = true;

  void _debug(String message) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    debugPrint('');

    debugPrint(
      '╔══════════════════════════════════════════════════════════════╗',
    );

    debugPrint(
      '║ COMPANY SUPERVISOR MOBILE ATTENDANCE REPORT                ║',
    );

    debugPrint(
      '╚══════════════════════════════════════════════════════════════╝',
    );

    for (final line in message.split('\n')) {
      debugPrint('→ $line');
    }

    debugPrint(
      '──────────────────────────────────────────────────────────────',
    );
  }

  void _debugSection(String title) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    debugPrint('');

    debugPrint(
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    );

    debugPrint('[$title]');

    debugPrint(
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    );
  }

  void _debugValue(String key, dynamic value) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    debugPrint('  $key: $value');
  }

  void _debugJson(
      String title,
      dynamic value,
      ) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    _debugSection(title);

    try {
      const encoder = JsonEncoder.withIndent('  ');

      if (value is Map || value is List) {
        debugPrint(
          encoder.convert(value),
        );
      } else {
        debugPrint(
          value.toString(),
        );
      }
    } catch (_) {
      debugPrint(
        value.toString(),
      );
    }
  }

  void _debugPostgrestError({
    required String operation,
    required PostgrestException error,
  }) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    _debugSection('POSTGREST ERROR');

    _debugValue(
      'Operation',
      operation,
    );

    _debugValue(
      'Code',
      error.code,
    );

    _debugValue(
      'Message',
      error.message,
    );

    _debugValue(
      'Details',
      error.details,
    );

    _debugValue(
      'Hint',
      error.hint,
    );
  }

  //=================================================================
  // SQL DEBUG
  //=================================================================

  String _sqlString(String value) {
    return "'${value.replaceAll("'", "''")}'";
  }

  void _debugSql({
    required String title,
    required String sql,
  }) {
    if (!kDebugMode || !_enableDebugLogs) {
      return;
    }

    debugPrint('');

    debugPrint(
      '╔══════════════════════════════════════════════════════════════╗',
    );

    debugPrint(
      '║ SQL DEBUG                                                    ║',
    );

    debugPrint(
      '╚══════════════════════════════════════════════════════════════╝',
    );

    debugPrint(
      'TITLE: $title',
    );

    debugPrint('');

    debugPrint(sql);

    debugPrint('');

    debugPrint(
      '──────────────────────────────────────────────────────────────',
    );
  }

  //=================================================================
  // DATE
  //=================================================================

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

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
  // DATE RANGE
  //=================================================================

  List<DateTime> _buildDateRange({
    required String startDate,
    required String endDate,
  }) {
    final start = DateTime.tryParse(
      startDate,
    );

    final end = DateTime.tryParse(
      endDate,
    );

    if (start == null || end == null) {
      return [];
    }

    final result = <DateTime>[];

    var current = DateTime(
      start.year,
      start.month,
      start.day,
    );

    final last = DateTime(
      end.year,
      end.month,
      end.day,
    );

    while (!current.isAfter(last)) {
      result.add(current);

      current = current.add(
        const Duration(days: 1),
      );
    }

    return result;
  }

  //=================================================================
  // STRING
  //=================================================================

  String? _stringValue(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  //=================================================================
  // DATE PARSER
  //=================================================================

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return DateTime.tryParse(
      text,
    );
  }

  //=================================================================
  // DOUBLE
  //=================================================================

  double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(
      text,
    );
  }

  //=================================================================
  // INT
  //=================================================================

  int _parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    ) ??
        0;
  }

  //=================================================================
  // BOOL
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

    final text = value.toString().trim().toLowerCase();

    return text == 'true' ||
        text == '1' ||
        text == 'yes' ||
        text == 'y';
  }

  //=================================================================
  // FIRST NON NULL
  //=================================================================

  dynamic _firstNonNullValue(
      Map<String, dynamic> json,
      List<String> keys,
      ) {
    for (final key in keys) {
      if (!json.containsKey(key)) {
        continue;
      }

      final value = json[key];

      if (value == null) {
        continue;
      }

      if (value is String && value.trim().isEmpty) {
        continue;
      }

      return value;
    }

    return null;
  }

  //=================================================================
  // LOCATION
  //=================================================================

  Map<String, dynamic>? _parseLocationMap(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    if (value is String) {
      final text = value.trim();

      if (text.isEmpty) {
        return null;
      }

      try {
        final decoded = jsonDecode(
          text,
        );

        if (decoded is Map) {
          return Map<String, dynamic>.from(
            decoded,
          );
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  dynamic _nestedLocationValue(
      Map<String, dynamic>? location,
      List<String> keys,
      ) {
    if (location == null) {
      return null;
    }

    for (final key in keys) {
      final value = location[key];

      if (value == null) {
        continue;
      }

      if (value is String && value.trim().isEmpty) {
        continue;
      }

      return value;
    }

    return null;
  }

  void _normalizeLocationData(
      Map<String, dynamic> json,
      ) {
    //===============================================================
    // CHECK IN
    //===============================================================

    final directInLat = _firstNonNullValue(
      json,
      [
        'check_in_latitude',
        'checkin_latitude',
        'check_in_lat',
        'checkin_lat',
        'in_latitude',
        'in_lat',
      ],
    );

    final directInLng = _firstNonNullValue(
      json,
      [
        'check_in_longitude',
        'checkin_longitude',
        'check_in_lng',
        'checkin_lng',
        'in_longitude',
        'in_lng',
      ],
    );

    final directInAddress = _firstNonNullValue(
      json,
      [
        'check_in_address',
        'checkin_address',
        'in_address',
      ],
    );

    final directInAccuracy = _firstNonNullValue(
      json,
      [
        'check_in_accuracy',
        'checkin_accuracy',
        'in_accuracy',
      ],
    );

    final inLocation = _parseLocationMap(
      _firstNonNullValue(
        json,
        [
          'check_in_location',
          'checkin_location',
          'in_location',
        ],
      ),
    );

    json['check_in_latitude'] =
        directInLat ??
            _nestedLocationValue(
              inLocation,
              [
                'latitude',
                'lat',
                'check_in_latitude',
                'checkin_latitude',
              ],
            );

    json['check_in_longitude'] =
        directInLng ??
            _nestedLocationValue(
              inLocation,
              [
                'longitude',
                'lng',
                'lon',
                'check_in_longitude',
                'checkin_longitude',
              ],
            );

    json['check_in_address'] =
        directInAddress ??
            _nestedLocationValue(
              inLocation,
              [
                'address',
                'location_address',
                'check_in_address',
                'checkin_address',
              ],
            );

    json['check_in_accuracy'] =
        directInAccuracy ??
            _nestedLocationValue(
              inLocation,
              [
                'accuracy',
                'check_in_accuracy',
                'checkin_accuracy',
              ],
            );

    //===============================================================
    // CHECK OUT
    //===============================================================

    final directOutLat = _firstNonNullValue(
      json,
      [
        'check_out_latitude',
        'checkout_latitude',
        'check_out_lat',
        'checkout_lat',
        'out_latitude',
        'out_lat',
      ],
    );

    final directOutLng = _firstNonNullValue(
      json,
      [
        'check_out_longitude',
        'checkout_longitude',
        'check_out_lng',
        'checkout_lng',
        'out_longitude',
        'out_lng',
      ],
    );

    final directOutAddress = _firstNonNullValue(
      json,
      [
        'check_out_address',
        'checkout_address',
        'out_address',
      ],
    );

    final directOutAccuracy = _firstNonNullValue(
      json,
      [
        'check_out_accuracy',
        'checkout_accuracy',
        'out_accuracy',
      ],
    );

    final outLocation = _parseLocationMap(
      _firstNonNullValue(
        json,
        [
          'check_out_location',
          'checkout_location',
          'out_location',
        ],
      ),
    );

    json['check_out_latitude'] =
        directOutLat ??
            _nestedLocationValue(
              outLocation,
              [
                'latitude',
                'lat',
                'check_out_latitude',
                'checkout_latitude',
              ],
            );

    json['check_out_longitude'] =
        directOutLng ??
            _nestedLocationValue(
              outLocation,
              [
                'longitude',
                'lng',
                'lon',
                'check_out_longitude',
                'checkout_longitude',
              ],
            );

    json['check_out_address'] =
        directOutAddress ??
            _nestedLocationValue(
              outLocation,
              [
                'address',
                'location_address',
                'check_out_address',
                'checkout_address',
              ],
            );

    json['check_out_accuracy'] =
        directOutAccuracy ??
            _nestedLocationValue(
              outLocation,
              [
                'accuracy',
                'check_out_accuracy',
                'checkout_accuracy',
              ],
            );
  }

  //=================================================================
  // TIME PARSER
  //=================================================================

  Duration? _parseTimeOfDay(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    final parts = text.split(':');

    if (parts.length < 2) {
      return null;
    }

    final hour = int.tryParse(
      parts[0],
    );

    final minute = int.tryParse(
      parts[1],
    );

    final second = parts.length >= 3
        ? int.tryParse(
      parts[2].split('.').first,
    ) ??
        0
        : 0;

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        second < 0 ||
        second > 59) {
      return null;
    }

    return Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
    );
  }

  //=================================================================
  // SHIFT DATETIME
  //=================================================================

  DateTime? _buildShiftDateTime({
    required DateTime attendanceDate,
    required dynamic timeValue,
  }) {
    final duration = _parseTimeOfDay(
      timeValue,
    );

    if (duration == null) {
      return null;
    }

    return DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
    ).add(duration);
  }

  //=================================================================
  // SHIFT END
  //=================================================================

  DateTime? _resolveShiftEndDateTime({
    required DateTime attendanceDate,
    required dynamic startTime,
    required dynamic endTime,
    required bool isNightShift,
  }) {
    final start = _buildShiftDateTime(
      attendanceDate: attendanceDate,
      timeValue: startTime,
    );

    final end = _buildShiftDateTime(
      attendanceDate: attendanceDate,
      timeValue: endTime,
    );

    if (end == null) {
      return null;
    }

    if (start != null && !end.isAfter(start)) {
      return end.add(
        const Duration(days: 1),
      );
    }

    if (isNightShift &&
        start != null &&
        !end.isAfter(start)) {
      return end.add(
        const Duration(days: 1),
      );
    }

    return end;
  }

  //=================================================================
  // LATE
  //=================================================================

  int _calculateLateMinutes({
    required DateTime? checkIn,
    required DateTime? shiftStart,
    required int graceMinutes,
  }) {
    if (checkIn == null || shiftStart == null) {
      return 0;
    }

    final grace = graceMinutes < 0
        ? 0
        : graceMinutes;

    final allowedStart = shiftStart.add(
      Duration(
        minutes: grace,
      ),
    );

    final difference = checkIn.difference(
      allowedStart,
    );

    return difference.inMinutes > 0
        ? difference.inMinutes
        : 0;
  }

  //=================================================================
  // EARLY OUT
  //=================================================================

  int _calculateEarlyLeaveMinutes({
    required DateTime? checkOut,
    required DateTime? shiftEnd,
    required int graceMinutes,
  }) {
    if (checkOut == null || shiftEnd == null) {
      return 0;
    }

    final grace = graceMinutes < 0
        ? 0
        : graceMinutes;

    final allowedEnd = shiftEnd.subtract(
      Duration(
        minutes: grace,
      ),
    );

    final difference = allowedEnd.difference(
      checkOut,
    );

    return difference.inMinutes > 0
        ? difference.inMinutes
        : 0;
  }

  //=================================================================
  // OVERTIME
  //=================================================================

  int _calculateOvertimeMinutes({
    required DateTime? checkOut,
    required DateTime? shiftEnd,
  }) {
    if (checkOut == null || shiftEnd == null) {
      return 0;
    }

    final difference = checkOut.difference(
      shiftEnd,
    );

    return difference.inMinutes > 0
        ? difference.inMinutes
        : 0;
  }

  //=================================================================
  // ACTUAL WORK
  //=================================================================

  int _calculateActualWorkMinutes({
    required DateTime? checkIn,
    required DateTime? checkOut,
    required int breakMinutes,
  }) {
    if (checkIn == null || checkOut == null) {
      return 0;
    }

    final difference = checkOut.difference(
      checkIn,
    );

    if (difference.inMinutes <= 0) {
      return 0;
    }

    final breakValue =
    breakMinutes < 0
        ? 0
        : breakMinutes;

    final actual =
        difference.inMinutes -
            breakValue;

    return actual > 0
        ? actual
        : 0;
  }

  //=================================================================
  // HOURS
  //=================================================================

  double _minutesToHours(
      int minutes,
      ) {
    if (minutes <= 0) {
      return 0;
    }

    return minutes / 60.0;
  }

  //=================================================================
  // STATUS
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
      return checkOut != null
          ? 'PRESENT'
          : 'CHECKED IN';
    }

    return attendanceStatus.isEmpty
        ? 'ABSENT'
        : attendanceStatus;
  }

  //=================================================================
  // SUPERVISOR RECORD
  //=================================================================

  Future<String?> _resolveSupervisorRecordId({
    required String companyId,
    required String supervisorId,
  }) async {
    final company = companyId.trim();

    final input = supervisorId.trim();

    if (company.isEmpty || input.isEmpty) {
      return null;
    }

    _debugSection(
      'RESOLVE SUPERVISOR',
    );

    _debugValue(
      'Company ID',
      company,
    );

    _debugValue(
      'Input Supervisor ID',
      input,
    );

    try {
      //=============================================================
      // BY supervisors.id
      //=============================================================

      _debugSql(
        title: 'SUPERVISOR BY RECORD ID',
        sql: '''
SELECT
    id,
    employee_id,
    company_id,
    department_id,
    is_active
FROM supervisors
WHERE id = ${_sqlString(input)}
  AND company_id = ${_sqlString(company)}
  AND is_active = true
LIMIT 1;
''',
      );

      final byRecordId = await _supabase
          .from(_supervisorsTable)
          .select(
        '''
id,
employee_id,
company_id,
department_id,
is_active
''',
      )
          .eq(
        'id',
        input,
      )
          .eq(
        'company_id',
        company,
      )
          .eq(
        'is_active',
        true,
      )
          .maybeSingle();

      _debugJson(
        'SUPERVISOR BY RECORD ID RESPONSE',
        byRecordId,
      );

      if (byRecordId != null) {
        final id = _stringValue(
          byRecordId['id'],
        );

        if (id != null) {
          return id;
        }
      }

      //=============================================================
      // BY EMPLOYEE ID
      //=============================================================

      _debugSql(
        title: 'SUPERVISOR BY EMPLOYEE ID',
        sql: '''
SELECT
    id,
    employee_id,
    company_id,
    department_id,
    is_active
FROM supervisors
WHERE employee_id = ${_sqlString(input)}
  AND company_id = ${_sqlString(company)}
  AND is_active = true
LIMIT 1;
''',
      );

      final byEmployeeId = await _supabase
          .from(_supervisorsTable)
          .select(
        '''
id,
employee_id,
company_id,
department_id,
is_active
''',
      )
          .eq(
        'employee_id',
        input,
      )
          .eq(
        'company_id',
        company,
      )
          .eq(
        'is_active',
        true,
      )
          .maybeSingle();

      _debugJson(
        'SUPERVISOR BY EMPLOYEE ID RESPONSE',
        byEmployeeId,
      );

      if (byEmployeeId != null) {
        final id = _stringValue(
          byEmployeeId['id'],
        );

        if (id != null) {
          return id;
        }
      }

      return null;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Resolve supervisor',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // ASSIGNED DEPARTMENTS
  //=================================================================

  Future<List<String>> _getAssignedDepartmentIds({
    required String companyId,
    required String supervisorId,
  }) async {
    final company = companyId.trim();

    final supervisor = supervisorId.trim();

    if (company.isEmpty || supervisor.isEmpty) {
      return [];
    }

    final actualSupervisorId =
    await _resolveSupervisorRecordId(
      companyId: company,
      supervisorId: supervisor,
    );

    if (actualSupervisorId == null) {
      _debug(
        'Supervisor record could not be resolved.',
      );

      return [];
    }

    try {
      _debugSql(
        title: 'ASSIGNED DEPARTMENTS',
        sql: '''
SELECT
    department_id
FROM supervisor_departments
WHERE supervisor_id = ${_sqlString(actualSupervisorId)}
ORDER BY department_id ASC;
''',
      );

      final response = await _supabase
          .from(_supervisorDepartmentsTable)
          .select(
        'department_id',
      )
          .eq(
        'supervisor_id',
        actualSupervisorId,
      )
          .order(
        'department_id',
        ascending: true,
      );

      final ids = <String>[];

      for (final item in response) {
        if (item is! Map) {
          continue;
        }

        final id = _stringValue(
          item['department_id'],
        );

        if (id != null) {
          ids.add(id);
        }
      }

      final uniqueIds =
      ids.toSet().toList();

      _debugValue(
        'Assigned Department IDs',
        uniqueIds,
      );

      return uniqueIds;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Get assigned departments',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // LOAD COMPANY WORKING DAYS
  //=================================================================
  //
  // NEW
  //
  // company_working_days
  //
  // day_of_week:
  //     1 = Monday
  //     2 = Tuesday
  //     3 = Wednesday
  //     4 = Thursday
  //     5 = Friday
  //     6 = Saturday
  //     7 = Sunday
  //
  // is_working_day:
  //     true  = working day
  //     false = weekend / off-day
  //
  //=================================================================

  Future<Map<int, Map<String, dynamic>>> _loadCompanyWorkingDays({
    required String companyId,
  }) async {
    final map =
    <int, Map<String, dynamic>>{};

    final company =
    companyId.trim();

    if (company.isEmpty) {
      return map;
    }

    _debugSection(
      'LOAD COMPANY WORKING DAYS',
    );

    _debugValue(
      'Company ID',
      company,
    );

    try {
      _debugSql(
        title: 'COMPANY WORKING DAYS QUERY',
        sql: '''
SELECT
    company_id,
    day_of_week,
    is_working_day
FROM company_working_days
WHERE company_id = ${_sqlString(company)}
ORDER BY day_of_week ASC;
''',
      );

      final response = await _supabase
          .from(_companyWorkingDaysTable)
          .select(
        '''
company_id,
day_of_week,
is_working_day
''',
      )
          .eq(
        'company_id',
        company,
      )
          .order(
        'day_of_week',
        ascending: true,
      );

      for (final row in response) {
        if (row is! Map) {
          continue;
        }

        final item =
        Map<String, dynamic>.from(row);

        final dayOfWeek =
        _parseInt(
          item['day_of_week'],
        );

        if (dayOfWeek < 1 ||
            dayOfWeek > 7) {
          continue;
        }

        map[dayOfWeek] = item;
      }

      _debugValue(
        'Working day rows',
        map.length,
      );

      _debugJson(
        'COMPANY WORKING DAYS',
        map,
      );

      return map;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation:
        'Load company working days',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // LOAD ATTENDANCE
  //=================================================================
  //
  // CHANGED
  //
  // Attendance alone cannot generate ABSENT rows.
  //
  // Therefore:
  //
  // 1. Load attendance.
  // 2. Load employees from assigned departments.
  // 3. Load company working days.
  // 4. Build employee × date matrix locally.
  // 5. Merge attendance row where available.
  //
  // This gives us a row even when attendance does not exist.
  //
  //=================================================================

  Future<List<Map<String, dynamic>>> _loadAttendance({
    required String companyId,
    required String startDate,
    required String endDate,
    required List<String> assignedDepartmentIds,
    String? departmentId,
  }) async {
    _debugSection(
      'LOAD ATTENDANCE + WORKING DAYS',
    );

    _debugValue(
      'Company ID',
      companyId,
    );

    _debugValue(
      'Start Date',
      startDate,
    );

    _debugValue(
      'End Date',
      endDate,
    );

    _debugValue(
      'Assigned Departments',
      assignedDepartmentIds,
    );

    _debugValue(
      'Selected Department',
      departmentId ?? 'ALL',
    );

    if (assignedDepartmentIds.isEmpty) {
      return [];
    }

    //===============================================================
    // DEPARTMENT ACCESS
    //===============================================================

    final selectedDepartment =
    departmentId?.trim();

    List<String> targetDepartmentIds;

    if (selectedDepartment != null &&
        selectedDepartment.isNotEmpty) {
      if (!assignedDepartmentIds.contains(
        selectedDepartment,
      )) {
        _debug(
          'ACCESS DENIED\n'
              'Selected department: $selectedDepartment\n'
              'Allowed: $assignedDepartmentIds',
        );

        return [];
      }

      targetDepartmentIds = [
        selectedDepartment,
      ];
    } else {
      targetDepartmentIds =
      List<String>.from(
        assignedDepartmentIds,
      );
    }

    //===============================================================
    // DATE RANGE
    //===============================================================

    final dates = _buildDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    if (dates.isEmpty) {
      _debug(
        'No dates found for requested range.',
      );

      return [];
    }

    _debugValue(
      'Date Count',
      dates.length,
    );

    //===============================================================
    // LOAD EMPLOYEES
    //===============================================================

    _debugSql(
      title: 'EMPLOYEES FOR ATTENDANCE MATRIX',
      sql: '''
SELECT
    id,
    company_id,
    department_id,
    designation_id,
    shift_id,
    employee_code,
    full_name,
    mobile,
    email,
    photo_url
FROM employees
WHERE company_id = ${_sqlString(companyId)}
  AND department_id IN (
    ${targetDepartmentIds.map(_sqlString).join(', ')}
  )
ORDER BY full_name ASC;
''',
    );

    final employeeResponse = await _supabase
        .from(_employeesTable)
        .select(
      '''
id,
company_id,
department_id,
designation_id,
shift_id,
employee_code,
full_name,
mobile,
email,
photo_url
''',
    )
        .eq(
      'company_id',
      companyId,
    )
        .inFilter(
      'department_id',
      targetDepartmentIds,
    )
        .order(
      'full_name',
      ascending: true,
    );

    final employeeRows =
    <Map<String, dynamic>>[];

    for (final row in employeeResponse) {
      if (row is! Map) {
        continue;
      }

      employeeRows.add(
        Map<String, dynamic>.from(row),
      );
    }

    _debugValue(
      'Employees for matrix',
      employeeRows.length,
    );

    if (employeeRows.isEmpty) {
      _debug(
        'No employees found in assigned department(s).',
      );

      return [];
    }

    //===============================================================
    // LOAD COMPANY WORKING DAYS
    //===============================================================

    final workingDays =
    await _loadCompanyWorkingDays(
      companyId: companyId,
    );

    //===============================================================
    // LOAD REAL ATTENDANCE
    //===============================================================

    dynamic attendanceQuery = _supabase
        .from(_attendanceTable)
        .select(
      '''
id,
company_id,
employee_id,
department_id,
designation_id,
shift_id,
attendance_no,
attendance_date,
check_in_time,
check_out_time,
attendance_status,

check_in_latitude,
check_in_longitude,
check_in_address,
check_in_accuracy,

check_out_latitude,
check_out_longitude,
check_out_address,
check_out_accuracy,

device_name,
device_id,
ip_address,
remarks,
is_active,
attendance_source,
attendance_type,
device_platform,
app_version,
battery_level,
network_type,
last_location_at,
photo_url
''',
    )
        .eq(
      'company_id',
      companyId,
    )
        .gte(
      'attendance_date',
      startDate,
    )
        .lte(
      'attendance_date',
      endDate,
    );

    if (selectedDepartment != null &&
        selectedDepartment.isNotEmpty) {
      attendanceQuery =
          attendanceQuery.eq(
            'department_id',
            selectedDepartment,
          );
    } else {
      attendanceQuery =
          attendanceQuery.inFilter(
            'department_id',
            targetDepartmentIds,
          );
    }

    _debugSql(
      title: 'FINAL ATTENDANCE QUERY',
      sql: '''
SELECT
    id,
    company_id,
    employee_id,
    department_id,
    designation_id,
    shift_id,
    attendance_no,
    attendance_date,
    check_in_time,
    check_out_time,
    attendance_status,
    check_in_latitude,
    check_in_longitude,
    check_in_address,
    check_in_accuracy,
    check_out_latitude,
    check_out_longitude,
    check_out_address,
    check_out_accuracy,
    device_name,
    device_id,
    ip_address,
    remarks,
    is_active,
    attendance_source,
    attendance_type,
    device_platform,
    app_version,
    battery_level,
    network_type,
    last_location_at,
    photo_url
FROM attendance
WHERE company_id = ${_sqlString(companyId)}
  AND attendance_date >= ${_sqlString(startDate)}
  AND attendance_date <= ${_sqlString(endDate)}
  AND department_id IN (
    ${targetDepartmentIds.map(_sqlString).join(', ')}
  )
ORDER BY attendance_date ASC, check_in_time ASC;
''',
    );

    final attendanceResponse = await attendanceQuery
        .order(
      'attendance_date',
      ascending: true,
    )
        .order(
      'check_in_time',
      ascending: true,
    );

    final realAttendanceRows =
    <Map<String, dynamic>>[];

    for (final row in attendanceResponse) {
      if (row is Map) {
        realAttendanceRows.add(
          Map<String, dynamic>.from(row),
        );
      }
    }

    _debugValue(
      'Real attendance rows',
      realAttendanceRows.length,
    );

    //===============================================================
    // INDEX ATTENDANCE
    //===============================================================

    final attendanceByEmployeeDate =
    <String, Map<String, dynamic>>{};

    for (final row in realAttendanceRows) {
      final employeeId =
      _stringValue(
        row['employee_id'],
      );

      final attendanceDate =
      _parseDateTime(
        row['attendance_date'],
      );

      if (employeeId == null ||
          attendanceDate == null) {
        continue;
      }

      final dateKey =
      _formatDate(
        attendanceDate,
      );

      final key =
          '$employeeId|$dateKey';

      // Keep the first attendance row for
      // employee + date.
      //
      // If your attendance table can contain
      // multiple valid sessions per day, we
      // will handle that separately later.

      attendanceByEmployeeDate.putIfAbsent(
        key,
            () => row,
      );
    }

    _debugValue(
      'Indexed attendance rows',
      attendanceByEmployeeDate.length,
    );

    //===============================================================
    // BUILD EMPLOYEE × DATE MATRIX
    //===============================================================

    final mergedRows =
    <Map<String, dynamic>>[];

    for (final employee in employeeRows) {
      final employeeId =
      _stringValue(
        employee['id'],
      );

      if (employeeId == null) {
        continue;
      }

      final employeeDepartmentId =
      _stringValue(
        employee['department_id'],
      );

      if (employeeDepartmentId == null ||
          !targetDepartmentIds.contains(
            employeeDepartmentId,
          )) {
        continue;
      }

      for (final date in dates) {
        final dateKey =
        _formatDate(
          date,
        );

        final dayOfWeek =
            date.weekday;

        final workingDay =
        workingDays[dayOfWeek];

        //===========================================================
        // WORKING DAY
        //===========================================================

        final isWorkingDay =
        workingDay == null
            ? true
            : _parseBool(
          workingDay[
          'is_working_day'
          ],
        );

        final key =
            '$employeeId|$dateKey';

        final attendance =
        attendanceByEmployeeDate[key];

        //===========================================================
        // REAL ATTENDANCE EXISTS
        //===========================================================

        if (attendance != null) {
          final row =
          Map<String, dynamic>.from(
            attendance,
          );

          row['day_of_week'] =
              dayOfWeek;

          row['is_working_day'] =
              isWorkingDay;

          row['is_weekend'] =
          !isWorkingDay;

          row['company_working_day_found'] =
              workingDay != null;

          row['report_date'] =
              dateKey;

          mergedRows.add(
            row,
          );

          continue;
        }

        //===========================================================
        // NO ATTENDANCE
        //
        // Create synthetic row.
        //
        // We are NOT deciding final UI status here.
        //
        // We only attach the working-day information.
        //
        // The next step will make:
        //
        // OFFDAY  -> if !isWorkingDay
        // ABSENT  -> if isWorkingDay
        //
        //===========================================================

        final syntheticRow =
        <String, dynamic>{
          'id': null,

          'company_id':
          employee['company_id'] ??
              companyId,

          'employee_id':
          employeeId,

          'department_id':
          employeeDepartmentId,

          'designation_id':
          employee['designation_id'],

          'shift_id':
          employee['shift_id'],

          'attendance_no':
          null,

          'attendance_date':
          dateKey,

          'check_in_time':
          null,

          'check_out_time':
          null,

          'attendance_status':
          null,

          'check_in_latitude':
          null,

          'check_in_longitude':
          null,

          'check_in_address':
          null,

          'check_in_accuracy':
          null,

          'check_out_latitude':
          null,

          'check_out_longitude':
          null,

          'check_out_address':
          null,

          'check_out_accuracy':
          null,

          'device_name':
          null,

          'device_id':
          null,

          'ip_address':
          null,

          'remarks':
          null,

          'is_active':
          true,

          'attendance_source':
          null,

          'attendance_type':
          null,

          'device_platform':
          null,

          'app_version':
          null,

          'battery_level':
          null,

          'network_type':
          null,

          'last_location_at':
          null,

          'photo_url':
          null,

          //=========================================================
          // EMPLOYEE DATA
          //=========================================================

          'employee_code':
          employee['employee_code'],

          'employee_name':
          employee['full_name'],

          'employee_phone':
          employee['mobile'],

          'employee_email':
          employee['email'],

          'employee_profile_photo':
          employee['photo_url'],

          //=========================================================
          // WORKING DAY DATA
          //=========================================================

          'day_of_week':
          dayOfWeek,

          'is_working_day':
          isWorkingDay,

          'is_weekend':
          !isWorkingDay,

          'company_working_day_found':
          workingDay != null,

          'report_date':
          dateKey,
        };

        mergedRows.add(
          syntheticRow,
        );
      }
    }

    //===============================================================
    // DEBUG MERGED RESULT
    //===============================================================

    _debugSection(
      'EMPLOYEE × DATE MERGE RESULT',
    );

    _debugValue(
      'Employees',
      employeeRows.length,
    );

    _debugValue(
      'Dates',
      dates.length,
    );

    _debugValue(
      'Expected Matrix Rows',
      employeeRows.length *
          dates.length,
    );

    _debugValue(
      'Actual Merged Rows',
      mergedRows.length,
    );

    final offDayRows =
        mergedRows.where(
              (row) =>
          row['is_working_day'] == false,
        ).length;

    final noAttendanceRows =
        mergedRows.where(
              (row) =>
          row['check_in_time'] == null &&
              row['check_out_time'] == null,
        ).length;

    _debugValue(
      'Off-day rows',
      offDayRows,
    );

    _debugValue(
      'No-attendance rows',
      noAttendanceRows,
    );

    if (mergedRows.isNotEmpty) {
      _debugJson(
        'FIRST MERGED ROW',
        mergedRows.first,
      );
    }

    //===============================================================
    // SORT
    //===============================================================

    mergedRows.sort(
          (a, b) {
        final dateA =
            _stringValue(
              a['attendance_date'],
            ) ??
                '';

        final dateB =
            _stringValue(
              b['attendance_date'],
            ) ??
                '';

        final dateCompare =
        dateA.compareTo(
          dateB,
        );

        if (dateCompare != 0) {
          return dateCompare;
        }

        final nameA =
            _stringValue(
              a['employee_name'],
            )?.toLowerCase() ??
                '';

        final nameB =
            _stringValue(
              b['employee_name'],
            )?.toLowerCase() ??
                '';

        return nameA.compareTo(
          nameB,
        );
      },
    );

    return mergedRows;
  }

  //=================================================================
  // LOAD EMPLOYEES
  //=================================================================

  Future<Map<String, Map<String, dynamic>>> _loadEmployees({
    required String companyId,
    required List<String> employeeIds,
  }) async {
    final map =
    <String, Map<String, dynamic>>{};

    final ids = employeeIds
        .map(
          (e) => e.trim(),
    )
        .where(
          (e) => e.isNotEmpty,
    )
        .toSet()
        .toList();

    if (ids.isEmpty) {
      return map;
    }

    _debugSection(
      'LOAD EMPLOYEES',
    );

    _debugValue(
      'Employee IDs',
      ids,
    );

    try {
      final response = await _supabase
          .from(_employeesTable)
          .select(
        '''
id,
company_id,
department_id,
designation_id,
shift_id,
employee_code,
full_name,
mobile,
email,
photo_url
''',
      )
          .eq(
        'company_id',
        companyId,
      )
          .inFilter(
        'id',
        ids,
      );

      for (final row in response) {
        if (row is! Map) {
          continue;
        }

        final item =
        Map<String, dynamic>.from(
          row,
        );

        final id =
        _stringValue(
          item['id'],
        );

        if (id != null) {
          map[id] = item;
        }
      }

      _debugValue(
        'Employees loaded',
        map.length,
      );

      if (map.isNotEmpty) {
        _debugJson(
          'EMPLOYEE SAMPLE',
          map.values.first,
        );
      }

      return map;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Load employees',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // LOAD DEPARTMENTS
  //=================================================================

  Future<Map<String, Map<String, dynamic>>> _loadDepartments({
    required List<String> departmentIds,
  }) async {
    final map =
    <String, Map<String, dynamic>>{};

    final ids = departmentIds
        .map(
          (e) => e.trim(),
    )
        .where(
          (e) => e.isNotEmpty,
    )
        .toSet()
        .toList();

    if (ids.isEmpty) {
      return map;
    }

    _debugSection(
      'LOAD DEPARTMENTS',
    );

    try {
      final response = await _supabase
          .from(_departmentsTable)
          .select(
        '''
id,
name
''',
      )
          .inFilter(
        'id',
        ids,
      );

      for (final row in response) {
        if (row is! Map) {
          continue;
        }

        final item =
        Map<String, dynamic>.from(
          row,
        );

        final id =
        _stringValue(
          item['id'],
        );

        if (id != null) {
          map[id] = item;
        }
      }

      _debugValue(
        'Departments loaded',
        map.length,
      );

      return map;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Load departments',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // LOAD DESIGNATIONS
  //=================================================================

  Future<Map<String, Map<String, dynamic>>> _loadDesignations({
    required List<String> designationIds,
  }) async {
    final map =
    <String, Map<String, dynamic>>{};

    final ids = designationIds
        .map(
          (e) => e.trim(),
    )
        .where(
          (e) => e.isNotEmpty,
    )
        .toSet()
        .toList();

    if (ids.isEmpty) {
      return map;
    }

    _debugSection(
      'LOAD DESIGNATIONS',
    );

    try {
      final response = await _supabase
          .from(_designationsTable)
          .select(
        '''
id,
name
''',
      )
          .inFilter(
        'id',
        ids,
      );

      for (final row in response) {
        if (row is! Map) {
          continue;
        }

        final item =
        Map<String, dynamic>.from(
          row,
        );

        final id =
        _stringValue(
          item['id'],
        );

        if (id != null) {
          map[id] = item;
        }
      }

      _debugValue(
        'Designations loaded',
        map.length,
      );

      return map;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Load designations',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // LOAD SHIFTS
  //=================================================================

  Future<Map<String, Map<String, dynamic>>> _loadShifts({
    required String companyId,
    required List<String> shiftIds,
  }) async {
    final map =
    <String, Map<String, dynamic>>{};

    final ids = shiftIds
        .map(
          (e) => e.trim(),
    )
        .where(
          (e) => e.isNotEmpty,
    )
        .toSet()
        .toList();

    if (ids.isEmpty) {
      return map;
    }

    _debugSection(
      'LOAD SHIFTS',
    );

    _debugValue(
      'Shift IDs',
      ids,
    );

    try {
      final response = await _supabase
          .from(_shiftsTable)
          .select(
        '''
id,
company_id,
code,
name,
description,
start_time,
end_time,
break_minutes,
grace_in_minutes,
grace_out_minutes,
is_night_shift,
is_flexible,
is_active,
minimum_working_hours,
check_in_required,
check_out_required
''',
      )
          .eq(
        'company_id',
        companyId,
      )
          .inFilter(
        'id',
        ids,
      );

      for (final row in response) {
        if (row is! Map) {
          continue;
        }

        final item =
        Map<String, dynamic>.from(
          row,
        );

        final id =
        _stringValue(
          item['id'],
        );

        if (id != null) {
          map[id] = item;
        }
      }

      _debugValue(
        'Shifts loaded',
        map.length,
      );

      if (map.isNotEmpty) {
        _debugJson(
          'SHIFT SAMPLE',
          map.values.first,
        );
      }

      return map;
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation: 'Load shifts',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // ENRICH ATTENDANCE ROWS
  //=================================================================

  Future<List<Map<String, dynamic>>> _enrichRows({
    required String companyId,
    required List<Map<String, dynamic>> attendanceRows,
  }) async {
    if (attendanceRows.isEmpty) {
      return [];
    }

    //===============================================================
    // COLLECT IDS
    //===============================================================

    final employeeIds =
    <String>{};

    final departmentIds =
    <String>{};

    final designationIds =
    <String>{};

    final shiftIds =
    <String>{};

    for (final row in attendanceRows) {
      final employeeId =
      _stringValue(
        row['employee_id'],
      );

      final departmentId =
      _stringValue(
        row['department_id'],
      );

      final designationId =
      _stringValue(
        row['designation_id'],
      );

      final shiftId =
      _stringValue(
        row['shift_id'],
      );

      if (employeeId != null) {
        employeeIds.add(
          employeeId,
        );
      }

      if (departmentId != null) {
        departmentIds.add(
          departmentId,
        );
      }

      if (designationId != null) {
        designationIds.add(
          designationId,
        );
      }

      if (shiftId != null) {
        shiftIds.add(
          shiftId,
        );
      }
    }

    _debugSection(
      'COLLECT RELATED IDS',
    );

    _debugValue(
      'Employee IDs',
      employeeIds.toList(),
    );

    _debugValue(
      'Department IDs',
      departmentIds.toList(),
    );

    _debugValue(
      'Designation IDs',
      designationIds.toList(),
    );

    _debugValue(
      'Shift IDs',
      shiftIds.toList(),
    );

    //===============================================================
    // LOAD ALL RELATED DATA
    //===============================================================

    final employeesFuture =
    _loadEmployees(
      companyId: companyId,
      employeeIds: employeeIds.toList(),
    );

    final departmentsFuture =
    _loadDepartments(
      departmentIds:
      departmentIds.toList(),
    );

    final designationsFuture =
    _loadDesignations(
      designationIds:
      designationIds.toList(),
    );

    final shiftsFuture =
    _loadShifts(
      companyId: companyId,
      shiftIds: shiftIds.toList(),
    );

    final results = await Future.wait(
      [
        employeesFuture,
        departmentsFuture,
        designationsFuture,
        shiftsFuture,
      ],
    );

    final employees =
    results[0]
    as Map<String, Map<String, dynamic>>;

    final departments =
    results[1]
    as Map<String, Map<String, dynamic>>;

    final designations =
    results[2]
    as Map<String, Map<String, dynamic>>;

    final shifts =
    results[3]
    as Map<String, Map<String, dynamic>>;

    //===============================================================
    // MERGE
    //===============================================================

    for (final row in attendanceRows) {
      //=============================================================
      // EMPLOYEE
      //=============================================================

      final employeeId =
      _stringValue(
        row['employee_id'],
      );

      if (employeeId != null) {
        final employee =
        employees[employeeId];

        if (employee != null) {
          row['employee_code'] =
          employee['employee_code'];

          row['employee_name'] =
          employee['full_name'];

          row['employee_phone'] =
          employee['mobile'];

          row['employee_email'] =
          employee['email'];

          row['employee_profile_photo'] =
          employee['photo_url'];

          row['department_id'] ??=
          employee['department_id'];

          row['designation_id'] ??=
          employee['designation_id'];

          row['shift_id'] ??=
          employee['shift_id'];

          row['company_id'] ??=
          employee['company_id'];
        }
      }

      //=============================================================
      // DEPARTMENT
      //=============================================================

      final departmentId =
      _stringValue(
        row['department_id'],
      );

      if (departmentId != null) {
        final department =
        departments[departmentId];

        if (department != null) {
          row['department_name'] =
          department['name'];
        }
      }

      //=============================================================
      // DESIGNATION
      //=============================================================

      final designationId =
      _stringValue(
        row['designation_id'],
      );

      if (designationId != null) {
        final designation =
        designations[designationId];

        if (designation != null) {
          row['designation_name'] =
          designation['name'];
        }
      }

      //=============================================================
      // SHIFT
      //=============================================================

      final shiftId =
      _stringValue(
        row['shift_id'],
      );

      if (shiftId != null) {
        final shift =
        shifts[shiftId];

        if (shift != null) {
          row['shift_code'] =
          shift['code'];

          row['shift_name'] =
          shift['name'];

          row['shift_description'] =
          shift['description'];

          row['shift_start_time'] =
          shift['start_time'];

          row['shift_end_time'] =
          shift['end_time'];

          row['break_minutes'] =
          shift['break_minutes'];

          row['grace_in_minutes'] =
          shift['grace_in_minutes'];

          row['grace_out_minutes'] =
          shift['grace_out_minutes'];

          row['minimum_working_hours'] =
          shift['minimum_working_hours'];

          row['check_in_required'] =
          shift['check_in_required'];

          row['check_out_required'] =
          shift['check_out_required'];

          row['is_night_shift'] =
          shift['is_night_shift'];

          row['is_flexible'] =
          shift['is_flexible'];

          row['shift_is_active'] =
          shift['is_active'];
        }
      }
    }

    return attendanceRows;
  }

  //=================================================================
  // BUILD REPORT
  //=================================================================

  CompanySupervisorMobileAttendanceReportModel _buildReport(
      Map<String, dynamic> json,
      ) {
    _normalizeLocationData(
      json,
    );

    //===============================================================
    // DATE
    //===============================================================

    final attendanceDate =
        _parseDateTime(
          json['attendance_date'],
        ) ??
            DateTime.now();

    //===============================================================
    // CHECK IN / OUT
    //===============================================================

    final checkIn =
    _parseDateTime(
      json['check_in_time'],
    );

    final checkOut =
    _parseDateTime(
      json['check_out_time'],
    );

    //===============================================================
    // SHIFT
    //===============================================================

    final shiftStart =
    _buildShiftDateTime(
      attendanceDate:
      attendanceDate,
      timeValue:
      json['shift_start_time'],
    );

    final isNightShift =
    _parseBool(
      json['is_night_shift'],
    );

    final shiftEnd =
    _resolveShiftEndDateTime(
      attendanceDate:
      attendanceDate,
      startTime:
      json['shift_start_time'],
      endTime:
      json['shift_end_time'],
      isNightShift:
      isNightShift,
    );

    final breakMinutes =
    _parseInt(
      json['break_minutes'],
    );

    //===============================================================
    // GRACE
    //===============================================================

    final graceInMinutes =
    _parseInt(
      json['grace_in_minutes'],
    );

    final graceOutMinutes =
    _parseInt(
      json['grace_out_minutes'],
    );

    //===============================================================
    // MINIMUM WORKING HOURS
    //===============================================================

    final minimumWorkingHours =
        _parseDouble(
          json['minimum_working_hours'],
        ) ??
            0;

    final minimumWorkingMinutes =
    (minimumWorkingHours * 60)
        .round();

    //===============================================================
    // SHIFT HOURS
    //===============================================================

    int shiftWorkingMinutes = 0;

    if (shiftStart != null &&
        shiftEnd != null) {
      final shiftDuration =
          shiftEnd
              .difference(
            shiftStart,
          )
              .inMinutes;

      shiftWorkingMinutes =
      shiftDuration > 0
          ? shiftDuration -
          breakMinutes
          : 0;

      if (shiftWorkingMinutes < 0) {
        shiftWorkingMinutes = 0;
      }
    }

    //===============================================================
    // CALCULATED VALUES
    //===============================================================

    final calculatedLateMinutes =
    _calculateLateMinutes(
      checkIn:
      checkIn,
      shiftStart:
      shiftStart,
      graceMinutes:
      graceInMinutes,
    );

    final calculatedEarlyLeaveMinutes =
    _calculateEarlyLeaveMinutes(
      checkOut:
      checkOut,
      shiftEnd:
      shiftEnd,
      graceMinutes:
      graceOutMinutes,
    );

    final calculatedOvertimeMinutes =
    _calculateOvertimeMinutes(
      checkOut:
      checkOut,
      shiftEnd:
      shiftEnd,
    );

    final calculatedActualWorkMinutes =
    _calculateActualWorkMinutes(
      checkIn:
      checkIn,
      checkOut:
      checkOut,
      breakMinutes:
      breakMinutes,
    );

    //===============================================================
    // STORED VALUES
    //===============================================================

    final storedLateMinutes =
    _parseInt(
      json['late_minutes'],
    );

    final storedEarlyLeaveMinutes =
    _parseInt(
      json['early_leave_minutes'],
    );

    final storedOvertimeMinutes =
    _parseInt(
      json['overtime_minutes'],
    );

    final storedActualWorkMinutes =
    _parseInt(
      json['actual_work_minutes'],
    );

    //===============================================================
    // FINAL VALUES
    //===============================================================

    final lateMinutes =
    storedLateMinutes > 0
        ? storedLateMinutes
        : calculatedLateMinutes;

    final earlyLeaveMinutes =
    storedEarlyLeaveMinutes > 0
        ? storedEarlyLeaveMinutes
        : calculatedEarlyLeaveMinutes;

    final overtimeMinutes =
    storedOvertimeMinutes > 0
        ? storedOvertimeMinutes
        : calculatedOvertimeMinutes;

    final actualWorkMinutes =
    storedActualWorkMinutes > 0
        ? storedActualWorkMinutes
        : calculatedActualWorkMinutes;

    //===============================================================
    // AH / WH / OT
    //===============================================================

    final actualHours =
    _minutesToHours(
      actualWorkMinutes,
    );

    final workingHours =
    _minutesToHours(
      shiftWorkingMinutes,
    );

    final overtimeHours =
    _minutesToHours(
      overtimeMinutes,
    );

    //===============================================================
    // LOCATION
    //===============================================================

    final checkInLatitude =
    _parseDouble(
      json['check_in_latitude'],
    );

    final checkInLongitude =
    _parseDouble(
      json['check_in_longitude'],
    );

    final checkInAddress =
    _stringValue(
      json['check_in_address'],
    );

    final checkInAccuracy =
    _parseDouble(
      json['check_in_accuracy'],
    );

    final checkOutLatitude =
    _parseDouble(
      json['check_out_latitude'],
    );

    final checkOutLongitude =
    _parseDouble(
      json['check_out_longitude'],
    );

    final checkOutAddress =
    _stringValue(
      json['check_out_address'],
    );

    final checkOutAccuracy =
    _parseDouble(
      json['check_out_accuracy'],
    );

    //===============================================================
    // STATUS
    //
    // NOTE:
    // Final OFFDAY / ABSENT status handling will be changed
    // in the next step.
    //
    //===============================================================

    final rawStatus =
    _stringValue(
      json['attendance_status'],
    )?.toUpperCase();

    final normalizedStatus =
    rawStatus == null ||
        rawStatus.isEmpty
        ? 'PRESENT'
        : rawStatus;

    //===============================================================
    // FLAGS
    //===============================================================

    final isPresent =
        _parseBool(
          json['is_present'],
        ) ||
            normalizedStatus == 'PRESENT' ||
            normalizedStatus == 'CHECKED IN';

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

    final isHoliday =
    _parseBool(
      json['is_holiday'],
    );

    //===============================================================
    // REPORT STATUS
    //===============================================================

    final storedReportStatus =
    _stringValue(
      json['report_status'],
    );

    final reportStatus =
    storedReportStatus != null
        ? storedReportStatus
        : _resolveReportStatus(
      attendanceStatus:
      normalizedStatus,
      isHoliday:
      isHoliday,
      isAbsent:
      isAbsent,
      isPresent:
      isPresent,
      isLate:
      isLate,
      isEarlyOut:
      isEarlyOut,
      checkIn:
      checkIn,
      checkOut:
      checkOut,
    );

    //===============================================================
    // DEBUG FINAL VALUES
    //===============================================================

    _debugSection(
      'FINAL REPORT VALUES',
    );

    _debugValue(
      'Employee',
      json['employee_name'],
    );

    _debugValue(
      'Employee Code',
      json['employee_code'],
    );

    _debugValue(
      'Department',
      json['department_name'],
    );

    _debugValue(
      'Designation',
      json['designation_name'],
    );

    _debugValue(
      'Shift',
      json['shift_name'],
    );

    _debugValue(
      'Attendance Date',
      attendanceDate,
    );

    _debugValue(
      'Day Of Week',
      json['day_of_week'],
    );

    _debugValue(
      'Is Working Day',
      json['is_working_day'],
    );

    _debugValue(
      'Is Weekend',
      json['is_weekend'],
    );

    _debugValue(
      'Check In',
      checkIn,
    );

    _debugValue(
      'Check Out',
      checkOut,
    );

    _debugValue(
      'Report Status',
      reportStatus,
    );

    _debugValue(
      'AH Minutes',
      actualWorkMinutes,
    );

    _debugValue(
      'AH Hours',
      actualHours,
    );

    _debugValue(
      'WH Minutes',
      shiftWorkingMinutes,
    );

    _debugValue(
      'WH Hours',
      workingHours,
    );

    _debugValue(
      'OT Minutes',
      overtimeMinutes,
    );

    _debugValue(
      'OT Hours',
      overtimeHours,
    );

    _debugValue(
      'Late Minutes',
      lateMinutes,
    );

    _debugValue(
      'Early Out Minutes',
      earlyLeaveMinutes,
    );

    //===============================================================
    // MODEL
    //===============================================================

    return CompanySupervisorMobileAttendanceReportModel(
      attendanceDate:
      attendanceDate,

      attendanceId:
      _stringValue(
        json['id'],
      ),

      attendanceNo:
      _stringValue(
        json['attendance_no'],
      ),

      companyId:
      _stringValue(
        json['company_id'],
      ),

      employeeId:
      _stringValue(
        json['employee_id'],
      ),

      departmentId:
      _stringValue(
        json['department_id'],
      ),

      designationId:
      _stringValue(
        json['designation_id'],
      ),

      shiftId:
      _stringValue(
        json['shift_id'],
      ),

      attendanceStatus:
      normalizedStatus,

      employeeCode:
      _stringValue(
        json['employee_code'],
      ),

      employeeName:
      _stringValue(
        json['employee_name'],
      ),

      employeeEmail:
      _stringValue(
        json['employee_email'],
      ),

      employeePhone:
      _stringValue(
        json['employee_phone'],
      ),

      employeeProfilePhoto:
      _stringValue(
        json['employee_profile_photo'],
      ),

      departmentName:
      _stringValue(
        json['department_name'],
      ),

      designationName:
      _stringValue(
        json['designation_name'],
      ),

      //=============================================================
      // SHIFT
      //=============================================================

      shiftName:
      _stringValue(
        json['shift_name'],
      ),

      shiftCode:
      _stringValue(
        json['shift_code'],
      ),

      shiftStartTime:
      _stringValue(
        json['shift_start_time'],
      ),

      shiftEndTime:
      _stringValue(
        json['shift_end_time'],
      ),

      breakMinutes:
      breakMinutes,

      graceInMinutes:
      graceInMinutes,

      graceOutMinutes:
      graceOutMinutes,

      minimumWorkingMinutes:
      minimumWorkingMinutes,

      isNightShift:
      isNightShift,

      isFlexible:
      _parseBool(
        json['is_flexible'],
      ),

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

      //=============================================================
      // CHECK IN
      //=============================================================

      checkInTime:
      checkIn,

      checkInLatitude:
      checkInLatitude,

      checkInLongitude:
      checkInLongitude,

      checkInAddress:
      checkInAddress,

      checkInAccuracy:
      checkInAccuracy,

      //=============================================================
      // CHECK OUT
      //=============================================================

      checkOutTime:
      checkOut,

      checkOutLatitude:
      checkOutLatitude,

      checkOutLongitude:
      checkOutLongitude,

      checkOutAddress:
      checkOutAddress,

      checkOutAccuracy:
      checkOutAccuracy,

      //=============================================================
      // STATUS
      //=============================================================

      reportStatus:
      reportStatus,

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
  // CONVERT RESPONSE
  //=================================================================

  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> _convertResponse(
      String companyId,
      List<Map<String, dynamic>> attendanceRows,
      ) async {
    _debugSection(
      'CONVERT RESPONSE',
    );

    _debugValue(
      'Attendance rows',
      attendanceRows.length,
    );

    if (attendanceRows.isEmpty) {
      return [];
    }

    final enrichedRows =
    await _enrichRows(
      companyId:
      companyId,
      attendanceRows:
      attendanceRows,
    );

    final reports =
    <CompanySupervisorMobileAttendanceReportEntity>[];

    for (var index = 0;
    index < enrichedRows.length;
    index++) {
      final row =
      enrichedRows[index];

      _debugSection(
        'BUILD REPORT ROW ${index + 1}',
      );

      _debugValue(
        'Attendance ID',
        row['id'],
      );

      _debugValue(
        'Employee ID',
        row['employee_id'],
      );

      _debugValue(
        'Employee Name',
        row['employee_name'],
      );

      _debugValue(
        'Attendance Date',
        row['attendance_date'],
      );

      _debugValue(
        'Is Working Day',
        row['is_working_day'],
      );

      _debugValue(
        'Is Weekend',
        row['is_weekend'],
      );

      final report =
      _buildReport(
        row,
      );

      reports.add(
        report,
      );
    }

    //===============================================================
    // SORT
    //===============================================================

    reports.sort(
          (a, b) {
        final dateA =
            a.attendanceDate;

        final dateB =
            b.attendanceDate;

        final dateCompare =
        dateA.compareTo(
          dateB,
        );

        if (dateCompare != 0) {
          return dateCompare;
        }

        final nameA =
            a.employeeName
                ?.trim()
                .toLowerCase() ??
                '';

        final nameB =
            b.employeeName
                ?.trim()
                .toLowerCase() ??
                '';

        final nameCompare =
        nameA.compareTo(
          nameB,
        );

        if (nameCompare != 0) {
          return nameCompare;
        }

        final checkInA =
            a.checkInTime;

        final checkInB =
            b.checkInTime;

        if (checkInA == null &&
            checkInB == null) {
          return 0;
        }

        if (checkInA == null) {
          return 1;
        }

        if (checkInB == null) {
          return -1;
        }

        return checkInA.compareTo(
          checkInB,
        );
      },
    );

    _debugValue(
      'Final report count',
      reports.length,
    );

    return reports;
  }

  //=================================================================
  // GET TODAY REPORTS
  //=================================================================

  @override
  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> getTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    final company =
    companyId.trim();

    final supervisor =
    supervisorId.trim();

    if (company.isEmpty ||
        supervisor.isEmpty) {
      return [];
    }

    final today =
    _formatDate(
      DateTime.now(),
    );

    _debugSection(
      'GET TODAY REPORTS',
    );

    _debugValue(
      'Company ID',
      company,
    );

    _debugValue(
      'Supervisor ID',
      supervisor,
    );

    _debugValue(
      'Department ID',
      departmentId ?? 'ALL',
    );

    _debugValue(
      'Today',
      today,
    );

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId:
        company,
        supervisorId:
        supervisor,
      );

      if (assignedDepartments.isEmpty) {
        _debug(
          'No assigned departments.',
        );

        return [];
      }

      final attendanceRows =
      await _loadAttendance(
        companyId:
        company,
        startDate:
        today,
        endDate:
        today,
        assignedDepartmentIds:
        assignedDepartments,
        departmentId:
        departmentId,
      );

      return _convertResponse(
        company,
        attendanceRows,
      );
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation:
        'Get today reports',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // GET REPORTS BY DATE
  //=================================================================

  @override
  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> getReportsByDate({
    required String companyId,
    required String supervisorId,
    required DateTime date,
    String? departmentId,
  }) async {
    final company =
    companyId.trim();

    final supervisor =
    supervisorId.trim();

    if (company.isEmpty ||
        supervisor.isEmpty) {
      return [];
    }

    final selectedDate =
    _formatDate(
      date,
    );

    _debugSection(
      'GET REPORTS BY DATE',
    );

    _debugValue(
      'Company ID',
      company,
    );

    _debugValue(
      'Supervisor ID',
      supervisor,
    );

    _debugValue(
      'Date',
      selectedDate,
    );

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId:
        company,
        supervisorId:
        supervisor,
      );

      if (assignedDepartments.isEmpty) {
        return [];
      }

      final attendanceRows =
      await _loadAttendance(
        companyId:
        company,
        startDate:
        selectedDate,
        endDate:
        selectedDate,
        assignedDepartmentIds:
        assignedDepartments,
        departmentId:
        departmentId,
      );

      return _convertResponse(
        company,
        attendanceRows,
      );
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation:
        'Get reports by date',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // GET REPORTS BY DATE RANGE
  //=================================================================

  @override
  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> getReportsByDateRange({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final company =
    companyId.trim();

    final supervisor =
    supervisorId.trim();

    if (company.isEmpty ||
        supervisor.isEmpty) {
      return [];
    }

    final start =
    _startOfDay(
      startDate,
    );

    final end =
    _endOfDay(
      endDate,
    );

    if (start.isAfter(end)) {
      throw Exception(
        'Start date cannot be after end date.',
      );
    }

    final formattedStart =
    _formatDate(
      start,
    );

    final formattedEnd =
    _formatDate(
      end,
    );

    _debugSection(
      'GET REPORTS BY DATE RANGE',
    );

    _debugValue(
      'Company ID',
      company,
    );

    _debugValue(
      'Supervisor ID',
      supervisor,
    );

    _debugValue(
      'Start Date',
      formattedStart,
    );

    _debugValue(
      'End Date',
      formattedEnd,
    );

    _debugValue(
      'Department ID',
      departmentId ?? 'ALL',
    );

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId:
        company,
        supervisorId:
        supervisor,
      );

      if (assignedDepartments.isEmpty) {
        return [];
      }

      final attendanceRows =
      await _loadAttendance(
        companyId:
        company,
        startDate:
        formattedStart,
        endDate:
        formattedEnd,
        assignedDepartmentIds:
        assignedDepartments,
        departmentId:
        departmentId,
      );

      return _convertResponse(
        company,
        attendanceRows,
      );
    } on PostgrestException catch (e) {
      _debugPostgrestError(
        operation:
        'Get reports by date range',
        error: e,
      );

      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // CURRENT MONTH
  //=================================================================

  @override
  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> getCurrentMonthReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    final now =
    DateTime.now();

    final startDate =
    DateTime(
      now.year,
      now.month,
      1,
    );

    final endDate =
    DateTime(
      now.year,
      now.month + 1,
      0,
    );

    return getReportsByDateRange(
      companyId:
      companyId,
      supervisorId:
      supervisorId,
      startDate:
      startDate,
      endDate:
      endDate,
      departmentId:
      departmentId,
    );
  }

  //=================================================================
  // SUMMARY
  //=================================================================

  @override
  Future<Map<String, dynamic>> getReportSummary({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final reports =
    await getReportsByDateRange(
      companyId:
      companyId,
      supervisorId:
      supervisorId,
      startDate:
      startDate,
      endDate:
      endDate,
      departmentId:
      departmentId,
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
          .trim()
          .toUpperCase() ==
          'LEAVE') {
        leave++;
      }

      totalLateMinutes +=
          report.lateMinutes;

      totalEarlyLeaveMinutes +=
          report.earlyLeaveMinutes;
    }

    final attendanceRate =
    workingDays <= 0
        ? 0.0
        : (present /
        workingDays) *
        100;

    final summary = {
      'company_id':
      companyId,

      'supervisor_id':
      supervisorId,

      'department_id':
      departmentId,

      'start_date':
      _formatDate(
        startDate,
      ),

      'end_date':
      _formatDate(
        endDate,
      ),

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
        attendanceRate
            .toStringAsFixed(2),
      ),
    };

    _debugJson(
      'REPORT SUMMARY',
      summary,
    );

    return summary;
  }

  //=================================================================
  // REFRESH TODAY
  //=================================================================

  @override
  Future<
      List<
          CompanySupervisorMobileAttendanceReportEntity>> refreshTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    _debugSection(
      'REFRESH TODAY REPORTS',
    );

    final result =
    await getTodayReports(
      companyId:
      companyId,
      supervisorId:
      supervisorId,
      departmentId:
      departmentId,
    );

    _debugValue(
      'Refresh rows',
      result.length,
    );

    return result;
  }
}