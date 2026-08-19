import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';

import '../../../shift/data/models/shift_model.dart';

import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_report_entity.dart';

import '../models/attendance_model.dart';
import '../models/attendance_report_model.dart';

class AttendanceRepository {
  //==============================================================
  // CLIENT
  //==============================================================

  final SupabaseClient _supabase = SupabaseService.client;

  static const String _table = 'attendance';

  //==============================================================
  // FORMAT DATE
  //==============================================================

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  //==============================================================
  // GET SHIFT BY ID
  //==============================================================

  Future<ShiftModel?> _getShiftById(
      String? shiftId,
      ) async {
    try {
      final id = shiftId?.trim();

      if (id == null || id.isEmpty) {
        return null;
      }

      final response = await _supabase
          .from('shifts')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ShiftModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET EMPLOYEE ATTENDANCE REPORT
  //==============================================================

  Future<List<AttendanceReportModel>>
  getEmployeeAttendanceReport({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      //============================================================
      // NORMALIZE DATE
      //============================================================

      final fromDate = DateTime(
        from.year,
        from.month,
        from.day,
      );

      final toDate = DateTime(
        to.year,
        to.month,
        to.day,
      );

      //============================================================
      // GET ATTENDANCE
      //============================================================

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'employee_id',
        employee,
      )
          .gte(
        'attendance_date',
        _formatDate(fromDate),
      )
          .lte(
        'attendance_date',
        _formatDate(toDate),
      )
          .order(
        'attendance_date',
        ascending: true,
      );

      //============================================================
      // CONVERT TO MODEL
      //============================================================

      final rows = response
          .map<AttendanceModel>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();

      //============================================================
      // ATTENDANCE MAP
      //============================================================

      final Map<String, AttendanceModel> attendanceMap = {};

      for (final attendance in rows) {
        attendanceMap[
        _formatDate(
          attendance.attendanceDate,
        )
        ] = attendance;
      }

      //============================================================
      // RESULT
      //============================================================

      final List<AttendanceReportModel> result = [];

      DateTime current = fromDate;

      //============================================================
      // DATE LOOP
      //============================================================

      while (!current.isAfter(toDate)) {
        final key = _formatDate(current);

        final attendance = attendanceMap[key];

        //==========================================================
        // WEEKEND
        // Bangladesh:
        // Friday + Saturday
        //==========================================================

        final isWeekend =
            current.weekday == DateTime.friday ||
                current.weekday == DateTime.saturday;

        //==========================================================
        // NO ATTENDANCE
        //==========================================================

        if (attendance == null) {
          final status = isWeekend
              ? AttendanceReportStatus.dayOff
              : AttendanceReportStatus.absent;

          result.add(
            AttendanceReportModel(
              date: current,
              status: status,
              isWeekend: isWeekend,
            ),
          );

          current = current.add(
            const Duration(days: 1),
          );

          continue;
        }

        //==========================================================
        // GET SHIFT
        //==========================================================

        final shift = await _getShiftById(
          attendance.shiftId,
        );

        //==========================================================
        // CALCULATE LATE
        //==========================================================

        final lateMinutes = _calculateLateMinutes(
          attendance: attendance,
          shift: shift,
        );

        //==========================================================
        // CALCULATE EARLY EXIT
        //==========================================================

        final earlyExitMinutes =
        _calculateEarlyExitMinutes(
          attendance: attendance,
          shift: shift,
        );

        //==========================================================
        // STATUS
        //==========================================================

        AttendanceReportStatus status;

        // ---------------------------------------------------------
        // EARLY OUT
        // ---------------------------------------------------------
        //
        // যদি employee shift শেষ হওয়ার আগে checkout করে
        // এবং grace period-এর পরেও early হয়,
        // তাহলে Early Out.
        //
        // ---------------------------------------------------------

        if (earlyExitMinutes > 0) {
          status = AttendanceReportStatus.earlyOut;
        }

        // ---------------------------------------------------------
        // LATE
        // ---------------------------------------------------------

        else if (lateMinutes > 0) {
          status = AttendanceReportStatus.late;
        }

        // ---------------------------------------------------------
        // PRESENT
        // ---------------------------------------------------------

        else {
          status = AttendanceReportStatus.present;
        }

        //==========================================================
        // ADD REPORT
        //==========================================================

        result.add(
          AttendanceReportModel(
            date: current,

            status: status,

            checkInTime:
            attendance.checkInTime,

            checkOutTime:
            attendance.checkOutTime,

            checkInAddress:
            attendance.checkInAddress,

            checkOutAddress:
            attendance.checkOutAddress,

            lateMinutes:
            lateMinutes,

            earlyExitMinutes:
            earlyExitMinutes,

            workMinutes:
            attendance.workMinutes,

            isWeekend:
            isWeekend,
          ),
        );

        //==========================================================
        // NEXT DATE
        //==========================================================

        current = current.add(
          const Duration(days: 1),
        );
      }

      return result;
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // CALCULATE LATE MINUTES
  //==============================================================

  int _calculateLateMinutes({
    required AttendanceModel attendance,
    required ShiftModel? shift,
  }) {
    final checkIn = attendance.checkInTime;

    // No check-in
    if (checkIn == null) {
      return 0;
    }

    // No shift
    if (shift == null) {
      return 0;
    }

    // Flexible shift
    if (shift.isFlexible) {
      return 0;
    }

    //============================================================
    // SHIFT START
    //============================================================

    final shiftStart = _combineDateAndTime(
      attendance.attendanceDate,
      shift.startTime,
    );

    if (shiftStart == null) {
      return 0;
    }

    //============================================================
    // CHECK-IN
    //============================================================

    final actualCheckIn = checkIn.toLocal();

    //============================================================
    // NIGHT SHIFT
    //============================================================

    DateTime expectedStart = shiftStart;

    if (shift.isNightShift) {
      final shiftEnd = _combineDateAndTime(
        attendance.attendanceDate,
        shift.endTime,
      );

      if (shiftEnd != null) {
        if (!shiftEnd.isAfter(shiftStart)) {
          // Start today
          // End tomorrow
          expectedStart = shiftStart;
        }
      }
    }

    //============================================================
    // DIFFERENCE
    //============================================================

    final difference = actualCheckIn.difference(
      expectedStart,
    );

    final minutes = difference.inMinutes;

    if (minutes <= 0) {
      return 0;
    }

    //============================================================
    // GRACE IN
    //============================================================

    final effectiveLateMinutes =
        minutes - shift.graceInMinutes;

    if (effectiveLateMinutes <= 0) {
      return 0;
    }

    //============================================================
    // LATE THRESHOLD
    //============================================================

    if (effectiveLateMinutes <
        shift.lateAfterMinutes) {
      return 0;
    }

    return effectiveLateMinutes;
  }

  //==============================================================
  // CALCULATE EARLY EXIT MINUTES
  //==============================================================

  int _calculateEarlyExitMinutes({
    required AttendanceModel attendance,
    required ShiftModel? shift,
  }) {
    final checkOut = attendance.checkOutTime;

    // No checkout
    if (checkOut == null) {
      return 0;
    }

    // No shift
    if (shift == null) {
      return 0;
    }

    // Flexible shift
    if (shift.isFlexible) {
      return 0;
    }

    //============================================================
    // SHIFT START
    //============================================================

    final shiftStart = _combineDateAndTime(
      attendance.attendanceDate,
      shift.startTime,
    );

    //============================================================
    // SHIFT END
    //============================================================

    final shiftEnd = _combineDateAndTime(
      attendance.attendanceDate,
      shift.endTime,
    );

    if (shiftStart == null || shiftEnd == null) {
      return 0;
    }

    //============================================================
    // EXPECTED END
    //============================================================

    DateTime expectedEnd = shiftEnd;

    //============================================================
    // NIGHT SHIFT
    //============================================================

    if (shift.isNightShift) {
      if (!shiftEnd.isAfter(shiftStart)) {
        expectedEnd = shiftEnd.add(
          const Duration(days: 1),
        );
      }
    }

    //============================================================
    // ACTUAL CHECKOUT
    //============================================================

    final actualCheckOut = checkOut.toLocal();

    //============================================================
    // DIFFERENCE
    //============================================================

    final difference = expectedEnd.difference(
      actualCheckOut,
    );

    final minutes = difference.inMinutes;

    // Checkout at/after shift end
    if (minutes <= 0) {
      return 0;
    }

    //============================================================
    // GRACE OUT
    //============================================================

    final effectiveEarlyMinutes =
        minutes - shift.graceOutMinutes;

    if (effectiveEarlyMinutes <= 0) {
      return 0;
    }

    return effectiveEarlyMinutes;
  }

  //==============================================================
  // COMBINE DATE + TIME
  //==============================================================

  DateTime? _combineDateAndTime(
      DateTime date,
      String time,
      ) {
    try {
      final value = time.trim();

      if (value.isEmpty) {
        return null;
      }

      final parts = value.split(':');

      if (parts.length < 2) {
        return null;
      }

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    } catch (_) {
      return null;
    }
  }

  //==============================================================
  // SUPERVISOR
  // TODAY ATTENDANCE BY EMPLOYEES
  //==============================================================

  Future<List<AttendanceEntity>>
  getTodayAttendanceByEmployees(
      List<String> employeeIds,
      ) async {
    try {
      final ids = employeeIds
          .map(
            (id) => id.trim(),
      )
          .where(
            (id) => id.isNotEmpty,
      )
          .toSet()
          .toList();

      if (ids.isEmpty) {
        return [];
      }

      final today = _formatDate(
        DateTime.now(),
      );

      final response = await _supabase
          .from(_table)
          .select()
          .inFilter(
        'employee_id',
        ids,
      )
          .eq(
        'attendance_date',
        today,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // TODAY ATTENDANCE BY COMPANY + DEPARTMENT
  //==============================================================

  Future<List<AttendanceEntity>>
  getSupervisorTodayAttendance({
    required String companyId,
    required String departmentId,
  }) async {
    try {
      final company = companyId.trim();
      final department = departmentId.trim();

      if (company.isEmpty) {
        throw Exception(
          'Company ID is required.',
        );
      }

      if (department.isEmpty) {
        throw Exception(
          'Department ID is required.',
        );
      }

      final today = _formatDate(
        DateTime.now(),
      );

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'company_id',
        company,
      )
          .eq(
        'department_id',
        department,
      )
          .eq(
        'attendance_date',
        today,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // EMPLOYEE ATTENDANCE DATE RANGE
  //==============================================================

  Future<List<AttendanceEntity>>
  getSupervisorEmployeeAttendance({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'employee_id',
        employee,
      )
          .gte(
        'attendance_date',
        fromDate,
      )
          .lte(
        'attendance_date',
        toDate,
      )
          .order(
        'attendance_date',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // DEPARTMENT DATE RANGE
  //==============================================================

  Future<List<AttendanceEntity>>
  getSupervisorDepartmentAttendance({
    required String companyId,
    required String departmentId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final company = companyId.trim();
      final department = departmentId.trim();

      if (company.isEmpty) {
        throw Exception(
          'Company ID is required.',
        );
      }

      if (department.isEmpty) {
        throw Exception(
          'Department ID is required.',
        );
      }

      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'company_id',
        company,
      )
          .eq(
        'department_id',
        department,
      )
          .gte(
        'attendance_date',
        fromDate,
      )
          .lte(
        'attendance_date',
        toDate,
      )
          .order(
        'attendance_date',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET ALL
  //==============================================================

  Future<List<AttendanceEntity>> getAll() async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET BY ID
  //==============================================================

  Future<AttendanceEntity?> getById(
      String id,
      ) async {
    try {
      final attendanceId = id.trim();

      if (attendanceId.isEmpty) {
        return null;
      }

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'id',
        attendanceId,
      )
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return AttendanceModel.fromMap(
        response,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // INSERT
  //==============================================================

  Future<void> insert(
      AttendanceModel attendance,
      ) async {
    try {
      await _supabase
          .from(_table)
          .insert(
        attendance.toInsertMap(),
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // UPDATE
  //==============================================================

  Future<void> update(
      AttendanceEntity attendance,
      ) async {
    try {
      if (attendance.id == null ||
          attendance.id!.trim().isEmpty) {
        throw Exception(
          'Attendance ID is required for update.',
        );
      }

      final model = AttendanceModel.fromEntity(
        attendance,
      );

      await _supabase
          .from(_table)
          .update(
        model.toUpdateMap(),
      )
          .eq(
        'id',
        attendance.id!,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // DELETE
  //==============================================================

  Future<void> delete(
      String id,
      ) async {
    try {
      final attendanceId = id.trim();

      if (attendanceId.isEmpty) {
        throw Exception(
          'Attendance ID is required.',
        );
      }

      await _supabase
          .from(_table)
          .delete()
          .eq(
        'id',
        attendanceId,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SEARCH
  //==============================================================

  Future<List<AttendanceEntity>> search(
      String keyword,
      ) async {
    try {
      final value = keyword.trim();

      if (value.isEmpty) {
        return getAll();
      }

      final response = await _supabase
          .from(_table)
          .select()
          .or(
        'attendance_no.ilike.%$value%,'
            'shift_name.ilike.%$value%,'
            'attendance_status.ilike.%$value%',
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY EMPLOYEE
  //==============================================================

  Future<List<AttendanceEntity>>
  getEmployeeAttendance(
      String employeeId,
      ) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'employee_id',
        employee,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // TODAY ATTENDANCE
  //==============================================================

  Future<List<AttendanceEntity>>
  todayAttendance() async {
    try {
      final today = _formatDate(
        DateTime.now(),
      );

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'attendance_date',
        today,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // CHECK-IN
  //==============================================================

  Future<void> checkIn({
    required String attendanceId,
    required DateTime checkInTime,
    double? latitude,
    double? longitude,
    String? deviceName,
    String? deviceId,
    String? address,
    double? accuracy,
  }) async {
    try {
      final id = attendanceId.trim();

      if (id.isEmpty) {
        throw Exception(
          'Attendance ID is required.',
        );
      }

      await _supabase
          .from(_table)
          .update({
        'check_in_time':
        checkInTime.toIso8601String(),
        'check_in_latitude': latitude,
        'check_in_longitude': longitude,
        'check_in_address': address,
        'check_in_accuracy': accuracy,
        'device_name': deviceName,
        'device_id': deviceId,
      })
          .eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // CHECK-OUT
  //==============================================================

  Future<void> checkOut({
    required String attendanceId,
    required DateTime checkOutTime,
    double? latitude,
    double? longitude,
    String? address,
    double? accuracy,
  }) async {
    try {
      final id = attendanceId.trim();

      if (id.isEmpty) {
        throw Exception(
          'Attendance ID is required.',
        );
      }

      await _supabase
          .from(_table)
          .update({
        'check_out_time':
        checkOutTime.toIso8601String(),
        'check_out_latitude': latitude,
        'check_out_longitude': longitude,
        'check_out_address': address,
        'check_out_accuracy': accuracy,
      })
          .eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // PRESENT TODAY
  //==============================================================

  Future<int> totalPresentToday() async {
    try {
      final today = _formatDate(
        DateTime.now(),
      );

      final response = await _supabase
          .from(_table)
          .select('id')
          .eq(
        'attendance_date',
        today,
      )
          .eq(
        'attendance_status',
        'PRESENT',
      );

      return response.length;
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // ATTENDANCE HISTORY
  //==============================================================

  Future<List<AttendanceEntity>>
  getAttendanceHistory() async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (json) => AttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // TODAY'S ATTENDANCE BY EMPLOYEE
  //==============================================================

  Future<AttendanceEntity?> getTodayAttendance(
      String employeeId,
      ) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        return null;
      }

      final today = _formatDate(
        DateTime.now(),
      );

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'employee_id',
        employee,
      )
          .eq(
        'attendance_date',
        today,
      )
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return AttendanceModel.fromMap(
        response,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // ALREADY CHECKED IN
  //==============================================================

  Future<bool> alreadyCheckedIn(
      String employeeId,
      ) async {
    final attendance =
    await getTodayAttendance(
      employeeId,
    );

    return attendance != null;
  }

  //==============================================================
  // ALREADY CHECKED OUT
  //==============================================================

  Future<bool> alreadyCheckedOut(
      String employeeId,
      ) async {
    final attendance =
    await getTodayAttendance(
      employeeId,
    );

    if (attendance == null) {
      return false;
    }

    return attendance.checkOutTime != null;
  }

  //==============================================================
  // REFRESH TODAY ATTENDANCE
  //==============================================================

  Future<AttendanceEntity?>
  refreshTodayAttendance(
      String employeeId,
      ) async {
    return getTodayAttendance(
      employeeId,
    );
  }

  //==============================================================
  // BY COMPANY
  //==============================================================

  Future<List<AttendanceEntity>> byCompany(
      String companyId,
      ) async {
    try {
      final company = companyId.trim();

      if (company.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'company_id',
        company,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DEPARTMENT
  //==============================================================

  Future<List<AttendanceEntity>>
  byDepartment(
      String departmentId,
      ) async {
    try {
      final department = departmentId.trim();

      if (department.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'department_id',
        department,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY STATUS
  //==============================================================

  Future<List<AttendanceEntity>> byStatus(
      String status,
      ) async {
    try {
      final value = status.trim();

      if (value.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'attendance_status',
        value,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DATE
  //==============================================================

  Future<List<AttendanceEntity>> byDate(
      DateTime date,
      ) async {
    try {
      final selectedDate = _formatDate(date);

      final response = await _supabase
          .from(_table)
          .select()
          .eq(
        'attendance_date',
        selectedDate,
      )
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DATE RANGE
  //==============================================================

  Future<List<AttendanceEntity>>
  byDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from(_table)
          .select()
          .gte(
        'attendance_date',
        fromDate,
      )
          .lte(
        'attendance_date',
        toDate,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceEntity>(
            (e) => AttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }
}