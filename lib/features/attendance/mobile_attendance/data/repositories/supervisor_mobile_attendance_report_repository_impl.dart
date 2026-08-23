import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/helpers/database_error_helper.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../domain/entities/supervisor_mobile_attendance_report_entity.dart';
import '../models/supervisor_mobile_attendance_report_model.dart';
import 'supervisor_mobile_attendance_report_repository.dart';

class SupervisorMobileAttendanceReportRepositoryImpl
    implements SupervisorMobileAttendanceReportRepository {
  //=================================================================
  // SUPABASE
  //=================================================================

  final SupabaseClient _supabase = SupabaseService.client;

  static const String _attendanceTable = 'attendance';

  static const String _supervisorDepartmentsTable =
      'supervisor_departments';

  static const String _supervisorsTable = 'supervisors';

  //=================================================================
  // DEBUG
  //=================================================================

  void _debug(String message) {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('============================================================');
    debugPrint('SUPERVISOR MOBILE ATTENDANCE REPORT DEBUG');
    debugPrint('============================================================');
    debugPrint(message);
    debugPrint('============================================================');
    debugPrint('');
  }

  //=================================================================
  // DEBUG SQL
  //=================================================================

  void _debugSql({
    required String title,
    required String sql,
  }) {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint(
      '################################################################',
    );
    debugPrint(
      '######################## SQL DEBUG ############################',
    );
    debugPrint(
      '################################################################',
    );
    debugPrint('TITLE: $title');
    debugPrint('');
    debugPrint(sql);
    debugPrint('');
    debugPrint(
      '################################################################',
    );
    debugPrint('');
  }

  //=================================================================
  // SQL STRING
  //=================================================================

  String _sqlString(String value) {
    return "'${value.replaceAll("'", "''")}'";
  }

  //=================================================================
  // SQL STRING LIST
  //=================================================================

  String _sqlStringList(List<String> values) {
    if (values.isEmpty) return '';

    return values.map(_sqlString).join(', ');
  }

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
  // PARSE DATETIME
  //=================================================================

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  //=================================================================
  // PARSE DOUBLE
  //=================================================================

  double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  //=================================================================
  // PARSE INT
  //=================================================================

  int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  //=================================================================
  // PARSE BOOL
  //=================================================================

  bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value.toString().trim().toLowerCase();

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
  // DETECT OVERNIGHT SHIFT
  //=================================================================

  bool _isOvernightShift({
    required String? shiftStartTime,
    required String? shiftEndTime,
    required bool isNightShift,
  }) {
    if (isNightShift) {
      return true;
    }

    final start = _timeToMinutes(shiftStartTime);
    final end = _timeToMinutes(shiftEndTime);

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

    final difference = checkOut.difference(checkIn).inMinutes;

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
      Duration(minutes: lateGraceMinutes),
    );

    if (!checkIn.isAfter(allowedStart)) {
      return 0;
    }

    return checkIn.difference(scheduledStart).inMinutes;
  }

  //=================================================================
  // EARLY LEAVE MINUTES
  //=================================================================

  int _calculateEarlyLeaveMinutes({
    required DateTime attendanceDate,
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
      Duration(minutes: earlyLeaveGraceMinutes),
    );

    if (!checkOut.isBefore(allowedEnd)) {
      return 0;
    }

    return scheduledEnd.difference(checkOut).inMinutes;
  }

  //=================================================================
  // OVERTIME MINUTES
  //=================================================================

  int _calculateOvertimeMinutes({
    required DateTime attendanceDate,
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

    return checkOut.difference(scheduledEnd).inMinutes;
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
      return checkOut != null ? 'PRESENT' : 'CHECKED IN';
    }

    return attendanceStatus.isEmpty ? 'ABSENT' : attendanceStatus;
  }

  //=================================================================
  // MERGE EMPLOYEE DATA
  //=================================================================

  void _mergeEmployeeData(Map<String, dynamic> json) {
    final employee = json['employees'];

    if (employee is! Map) {
      return;
    }

    final employeeMap = Map<String, dynamic>.from(employee);

    json['employee_code'] ??= employeeMap['employee_code'];
    json['employee_name'] ??= employeeMap['full_name'];
    json['employee_email'] ??= employeeMap['email'];
    json['employee_phone'] ??= employeeMap['phone'];
    json['employee_profile_photo'] ??= employeeMap['profile_photo'];
    json['department_id'] ??= employeeMap['department_id'];
    json['designation_id'] ??= employeeMap['designation_id'];
    json['designation_name'] ??= employeeMap['designation_name'];
  }

  //=================================================================
  // MERGE DEPARTMENT DATA
  //=================================================================

  void _mergeDepartmentData(Map<String, dynamic> json) {
    final department = json['departments'];

    if (department is! Map) {
      return;
    }

    final departmentMap = Map<String, dynamic>.from(department);

    json['department_name'] ??= departmentMap['name'];
  }

  //=================================================================
  // MERGE SHIFT DATA
  //=================================================================

  void _mergeShiftData(Map<String, dynamic> json) {
    final shift = json['shifts'];

    if (shift is! Map) {
      return;
    }

    final shiftMap = Map<String, dynamic>.from(shift);

    json['shift_name'] ??= shiftMap['name'];
    json['shift_code'] ??= shiftMap['code'];
    json['shift_start_time'] ??= shiftMap['start_time'];
    json['shift_end_time'] ??= shiftMap['end_time'];
    json['break_minutes'] ??= shiftMap['break_minutes'];
    json['late_grace_minutes'] ??= shiftMap['late_grace_minutes'];
    json['early_leave_grace_minutes'] ??=
    shiftMap['early_leave_grace_minutes'];
    json['is_night_shift'] ??= shiftMap['is_night_shift'];
    json['is_flexible'] ??= shiftMap['is_flexible'];
    json['check_in_required'] ??= shiftMap['check_in_required'];
    json['check_out_required'] ??= shiftMap['check_out_required'];
  }

  //=================================================================
  // BUILD REPORT
  //=================================================================

  SupervisorMobileAttendanceReportModel _buildReport(
      Map<String, dynamic> json,
      ) {
    final attendanceDate =
        _parseDateTime(json['attendance_date']) ?? DateTime.now();

    final checkIn = _parseDateTime(json['check_in_time']);

    final checkOut = _parseDateTime(json['check_out_time']);

    final shiftStartTime = json['shift_start_time']?.toString();

    final shiftEndTime = json['shift_end_time']?.toString();

    final breakMinutes = _parseInt(json['break_minutes']);

    final lateGraceMinutes = _parseInt(
      json['late_grace_minutes'],
    );

    final earlyLeaveGraceMinutes = _parseInt(
      json['early_leave_grace_minutes'],
    );

    final minimumWorkingMinutes = _parseInt(
      json['minimum_working_minutes'],
    );

    final halfDayThresholdMinutes = _parseInt(
      json['half_day_threshold_minutes'],
    );

    final isNightShift = _parseBool(
      json['is_night_shift'],
    );

    final isFlexible = _parseBool(
      json['is_flexible'],
    );

    final storedActualWorkMinutes = _parseInt(
      json['actual_work_minutes'],
    );

    final actualWorkMinutes = storedActualWorkMinutes > 0
        ? storedActualWorkMinutes
        : _calculateActualWorkMinutes(
      checkIn: checkIn,
      checkOut: checkOut,
      breakMinutes: breakMinutes,
    );

    final storedLateMinutes = _parseInt(
      json['late_minutes'],
    );

    final lateMinutes = storedLateMinutes > 0
        ? storedLateMinutes
        : _calculateLateMinutes(
      attendanceDate: attendanceDate,
      checkIn: checkIn,
      shiftStartTime: shiftStartTime,
      lateGraceMinutes: lateGraceMinutes,
    );

    final storedEarlyLeaveMinutes = _parseInt(
      json['early_leave_minutes'],
    );

    final earlyLeaveMinutes = storedEarlyLeaveMinutes > 0
        ? storedEarlyLeaveMinutes
        : _calculateEarlyLeaveMinutes(
      attendanceDate: attendanceDate,
      checkOut: checkOut,
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      earlyLeaveGraceMinutes: earlyLeaveGraceMinutes,
      isNightShift: isNightShift,
    );

    final storedOvertimeMinutes = _parseInt(
      json['overtime_minutes'],
    );

    final overtimeMinutes = storedOvertimeMinutes > 0
        ? storedOvertimeMinutes
        : _calculateOvertimeMinutes(
      attendanceDate: attendanceDate,
      checkOut: checkOut,
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      isNightShift: isNightShift,
    );

    final rawStatus = json['attendance_status']
        ?.toString()
        .trim()
        .toUpperCase();

    final normalizedStatus =
    rawStatus == null || rawStatus.isEmpty ? 'PRESENT' : rawStatus;

    final isPresent =
        _parseBool(json['is_present']) || normalizedStatus == 'PRESENT';

    final isAbsent =
        _parseBool(json['is_absent']) || normalizedStatus == 'ABSENT';

    final isLate =
        _parseBool(json['is_late']) || lateMinutes > 0;

    final isEarlyOut =
        _parseBool(json['is_early_out']) ||
            earlyLeaveMinutes > 0;

    final isHoliday = _parseBool(
      json['is_holiday'],
    );

    final reportStatus =
    json['report_status']?.toString().trim().isNotEmpty == true
        ? json['report_status'].toString().trim()
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

    return SupervisorMobileAttendanceReportModel(
      attendanceDate: attendanceDate,

      attendanceId:
      json['attendance_id']?.toString() ??
          json['id']?.toString(),

      attendanceNo: json['attendance_no']?.toString(),

      companyId: json['company_id']?.toString(),

      employeeId:
      json['employee_id']?.toString() ??
          json['id']?.toString(),

      departmentId: json['department_id']?.toString(),

      designationId: json['designation_id']?.toString(),

      shiftId: json['shift_id']?.toString(),

      attendanceStatus: normalizedStatus,

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

      shiftStartTime: shiftStartTime,

      shiftEndTime: shiftEndTime,

      breakMinutes: breakMinutes,

      lateGraceMinutes: lateGraceMinutes,

      earlyLeaveGraceMinutes: earlyLeaveGraceMinutes,

      minimumWorkingMinutes: minimumWorkingMinutes,

      halfDayThresholdMinutes: halfDayThresholdMinutes,

      isNightShift: isNightShift,

      isFlexible: isFlexible,

      checkInRequired: json['check_in_required'] == null
          ? true
          : _parseBool(json['check_in_required']),

      checkOutRequired: json['check_out_required'] == null
          ? true
          : _parseBool(json['check_out_required']),

      dayOfWeek: _parseInt(json['day_of_week']) > 0
          ? _parseInt(json['day_of_week'])
          : attendanceDate.weekday,

      isWorkingDay: json['is_working_day'] == null
          ? true
          : _parseBool(json['is_working_day']),

      checkInTime: checkIn,

      checkInLatitude:
      _parseDouble(json['check_in_latitude']),

      checkInLongitude:
      _parseDouble(json['check_in_longitude']),

      checkInAddress:
      json['check_in_address']?.toString(),

      checkInAccuracy:
      _parseDouble(json['check_in_accuracy']),

      checkOutTime: checkOut,

      checkOutLatitude:
      _parseDouble(json['check_out_latitude']),

      checkOutLongitude:
      _parseDouble(json['check_out_longitude']),

      checkOutAddress:
      json['check_out_address']?.toString(),

      checkOutAccuracy:
      _parseDouble(json['check_out_accuracy']),

      reportStatus: reportStatus,

      lateMinutes: lateMinutes,

      earlyLeaveMinutes: earlyLeaveMinutes,

      actualWorkMinutes: actualWorkMinutes,

      overtimeMinutes: overtimeMinutes,

      isLate: isLate,

      isEarlyOut: isEarlyOut,

      isAbsent: isAbsent,

      isHoliday: isHoliday,

      isPresent: isPresent,
    );
  }

  //=================================================================
  // RESOLVE SUPERVISOR
  //
  // UI supervisorId = employee ID
  //
  // supervisors.employee_id
  //        +
  // supervisors.company_id
  //        ↓
  // supervisors.id
  //=================================================================

  Future<String?> _resolveSupervisorRecordId({
    required String companyId,
    required String supervisorId,
  }) async {
    final company = companyId.trim();
    final employee = supervisorId.trim();

    if (company.isEmpty || employee.isEmpty) {
      return null;
    }

    try {
      _debugSql(
        title: 'RESOLVE SUPERVISOR RECORD',
        sql: '''
SELECT
    id,
    employee_id,
    company_id,
    department_id,
    is_active
FROM supervisors
WHERE employee_id = ${_sqlString(employee)}
  AND company_id = ${_sqlString(company)}
  AND is_active = true
LIMIT 1;
''',
      );

      final response = await _supabase
          .from(_supervisorsTable)
          .select('''
            id,
            employee_id,
            company_id,
            department_id,
            is_active
          ''')
          .eq('employee_id', employee)
          .eq('company_id', company)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) {
        _debug(
          'Supervisor not found.\n'
              'companyId: $company\n'
              'employeeId: $employee',
        );

        return null;
      }

      final id = response['id']?.toString().trim();

      if (id == null || id.isEmpty) {
        return null;
      }

      return id;
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // GET ASSIGNED DEPARTMENT IDS
  //=================================================================

  Future<List<String>> _getAssignedDepartmentIds({
    required String companyId,
    required String supervisorId,
  }) async {
    final company = companyId.trim();
    final employee = supervisorId.trim();

    if (company.isEmpty || employee.isEmpty) {
      return [];
    }

    final actualSupervisorId =
    await _resolveSupervisorRecordId(
      companyId: company,
      supervisorId: employee,
    );

    if (actualSupervisorId == null) {
      return [];
    }

    try {
      _debugSql(
        title: 'GET ASSIGNED DEPARTMENT IDS',
        sql: '''
SELECT
    department_id
FROM supervisor_departments
WHERE supervisor_id = ${_sqlString(actualSupervisorId)}
ORDER BY department_id;
''',
      );

      final response = await _supabase
          .from(_supervisorDepartmentsTable)
          .select('department_id')
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

        final id = item['department_id']?.toString().trim();

        if (id != null && id.isNotEmpty) {
          ids.add(id);
        }
      }

      return ids.toSet().toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // BUILD ATTENDANCE QUERY
  //=================================================================

  dynamic _buildAttendanceQuery() {
    return _supabase
        .from(_attendanceTable)
        .select('''
          *,
          employees (
            id,
            company_id,
            department_id,
            employee_code,
            full_name,
            email,
            phone,
            designation_name,
            profile_photo,
            is_active
          ),
          departments (
            id,
            name
          ),
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
        ''');
  }

  //=================================================================
  // APPLY DEPARTMENT FILTER
  //=================================================================

  dynamic _applyDepartmentFilter(
      dynamic query, {
        required String? departmentId,
        required List<String> assignedDepartmentIds,
      }) {
    final selected = departmentId?.trim();

    if (selected != null && selected.isNotEmpty) {
      if (!assignedDepartmentIds.contains(selected)) {
        return null;
      }

      return query.eq(
        'department_id',
        selected,
      );
    }

    if (assignedDepartmentIds.isEmpty) {
      return null;
    }

    return query.inFilter(
      'department_id',
      assignedDepartmentIds,
    );
  }

  //=================================================================
  // CONVERT RESPONSE
  //=================================================================

  List<SupervisorMobileAttendanceReportEntity> _convertResponse(
      List<dynamic> response,
      ) {
    final reports =
    <SupervisorMobileAttendanceReportEntity>[];

    for (final item in response) {
      if (item is! Map) {
        continue;
      }

      final json = Map<String, dynamic>.from(item);

      _mergeEmployeeData(json);
      _mergeDepartmentData(json);
      _mergeShiftData(json);

      reports.add(
        _buildReport(json),
      );
    }

    reports.sort(
          (a, b) {
        final nameA =
            a.employeeName?.trim().toLowerCase() ?? '';

        final nameB =
            b.employeeName?.trim().toLowerCase() ?? '';

        final nameCompare = nameA.compareTo(nameB);

        if (nameCompare != 0) {
          return nameCompare;
        }

        final checkInA = a.checkInTime;
        final checkInB = b.checkInTime;

        if (checkInA == null && checkInB == null) {
          return 0;
        }

        if (checkInA == null) {
          return 1;
        }

        if (checkInB == null) {
          return -1;
        }

        return checkInA.compareTo(checkInB);
      },
    );

    return reports;
  }

  //=================================================================
  // GET TODAY REPORTS
  //=================================================================

  @override
  Future<List<SupervisorMobileAttendanceReportEntity>>
  getTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty || supervisor.isEmpty) {
      return [];
    }

    final today = _formatDate(DateTime.now());

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId: company,
        supervisorId: supervisor,
      );

      if (assignedDepartments.isEmpty) {
        return [];
      }

      dynamic query = _buildAttendanceQuery();

      query = query.eq(
        'company_id',
        company,
      );

      query = _applyDepartmentFilter(
        query,
        departmentId: departmentId,
        assignedDepartmentIds: assignedDepartments,
      );

      if (query == null) {
        return [];
      }

      final response = await query
          .eq(
        'attendance_date',
        today,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      _debug(
        'TODAY REPORT\n'
            'companyId: $company\n'
            'supervisorId: $supervisor\n'
            'departmentId: ${departmentId ?? 'ALL'}\n'
            'rows: ${response.length}',
      );

      return _convertResponse(response);
    } on PostgrestException catch (e) {
      _debug(
        'getTodayReports error: ${e.message}',
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
  Future<List<SupervisorMobileAttendanceReportEntity>>
  getReportsByDate({
    required String companyId,
    required String supervisorId,
    required DateTime date,
    String? departmentId,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty || supervisor.isEmpty) {
      return [];
    }

    final selectedDate = _formatDate(date);

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId: company,
        supervisorId: supervisor,
      );

      if (assignedDepartments.isEmpty) {
        return [];
      }

      dynamic query = _buildAttendanceQuery();

      query = query.eq(
        'company_id',
        company,
      );

      query = _applyDepartmentFilter(
        query,
        departmentId: departmentId,
        assignedDepartmentIds: assignedDepartments,
      );

      if (query == null) {
        return [];
      }

      final response = await query
          .eq(
        'attendance_date',
        selectedDate,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      return _convertResponse(response);
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // GET REPORTS BY DATE RANGE
  //=================================================================

  @override
  Future<List<SupervisorMobileAttendanceReportEntity>>
  getReportsByDateRange({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty || supervisor.isEmpty) {
      return [];
    }

    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);

    if (start.isAfter(end)) {
      throw Exception(
        'Start date cannot be after end date.',
      );
    }

    final formattedStart = _formatDate(start);
    final formattedEnd = _formatDate(end);

    try {
      final assignedDepartments =
      await _getAssignedDepartmentIds(
        companyId: company,
        supervisorId: supervisor,
      );

      if (assignedDepartments.isEmpty) {
        return [];
      }

      dynamic query = _buildAttendanceQuery();

      query = query.eq(
        'company_id',
        company,
      );

      query = _applyDepartmentFilter(
        query,
        departmentId: departmentId,
        assignedDepartmentIds: assignedDepartments,
      );

      if (query == null) {
        return [];
      }

      final response = await query
          .gte(
        'attendance_date',
        formattedStart,
      )
          .lte(
        'attendance_date',
        formattedEnd,
      )
          .order(
        'attendance_date',
        ascending: true,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      _debug(
        'DATE RANGE REPORT\n'
            'companyId: $company\n'
            'supervisorId: $supervisor\n'
            'start: $formattedStart\n'
            'end: $formattedEnd\n'
            'rows: ${response.length}',
      );

      return _convertResponse(response);
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //=================================================================
  // GET CURRENT MONTH REPORTS
  //=================================================================

  @override
  Future<List<SupervisorMobileAttendanceReportEntity>>
  getCurrentMonthReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
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
      companyId: companyId,
      supervisorId: supervisorId,
      startDate: startDate,
      endDate: endDate,
      departmentId: departmentId,
    );
  }

  //=================================================================
  // GET REPORT SUMMARY
  //=================================================================

  @override
  Future<Map<String, dynamic>> getReportSummary({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final reports = await getReportsByDateRange(
      companyId: companyId,
      supervisorId: supervisorId,
      startDate: startDate,
      endDate: endDate,
      departmentId: departmentId,
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

      if (report.attendanceStatus.trim().toUpperCase() ==
          'LEAVE') {
        leave++;
      }

      totalLateMinutes += report.lateMinutes;

      totalEarlyLeaveMinutes +=
          report.earlyLeaveMinutes;

      totalActualWorkMinutes +=
          report.actualWorkMinutes;

      totalOvertimeMinutes +=
          report.overtimeMinutes;
    }

    final attendanceRate = workingDays <= 0
        ? 0.0
        : (present / workingDays) * 100;

    return {
      'company_id': companyId,
      'supervisor_id': supervisorId,
      'department_id': departmentId,
      'start_date': _formatDate(startDate),
      'end_date': _formatDate(endDate),
      'total_records': reports.length,
      'working_days': workingDays,
      'present_days': present,
      'absent_days': absent,
      'late_days': late,
      'early_out_days': earlyOut,
      'holiday_days': holiday,
      'leave_days': leave,
      'total_late_minutes': totalLateMinutes,
      'total_early_leave_minutes':
      totalEarlyLeaveMinutes,
      'total_actual_work_minutes':
      totalActualWorkMinutes,
      'total_overtime_minutes':
      totalOvertimeMinutes,
      'attendance_rate': double.parse(
        attendanceRate.toStringAsFixed(2),
      ),
    };
  }

  //=================================================================
  // REFRESH TODAY REPORTS
  //=================================================================

  @override
  Future<List<SupervisorMobileAttendanceReportEntity>>
  refreshTodayReports({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    return getTodayReports(
      companyId: companyId,
      supervisorId: supervisorId,
      departmentId: departmentId,
    );
  }
}