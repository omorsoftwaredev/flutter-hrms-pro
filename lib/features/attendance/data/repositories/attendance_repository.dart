import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';

import '../../domain/entities/attendance_entity.dart';
import '../models/attendance_model.dart';
import '../models/attendance_report_model.dart';
import '../../domain/entities/attendance_report_entity.dart';
class AttendanceRepository {
  final SupabaseClient _supabase =
      SupabaseService.client;

  static const String _table = 'attendance';
  Future<List<AttendanceReportModel>> getEmployeeAttendanceReport({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    final fromDate =
    DateTime(from.year, from.month, from.day);

    final toDate =
    DateTime(to.year, to.month, to.day);

    final response = await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
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

    final rows = response
        .map<AttendanceModel>(
          (json) => AttendanceModel.fromMap(json),
    )
        .toList();

    final Map<String, AttendanceModel> attendanceMap = {};

    for (final attendance in rows) {
      attendanceMap[_formatDate(attendance.attendanceDate)] =
          attendance;
    }

    final List<AttendanceReportModel> result = [];

    DateTime current = fromDate;

    while (!current.isAfter(toDate)) {
      final key = _formatDate(current);

      final attendance = attendanceMap[key];

      // Weekend
      final isWeekend =
          current.weekday == DateTime.friday ||
              current.weekday == DateTime.saturday;

      // ------------------------------------------------
      // Attendance exists
      // ------------------------------------------------

      if (attendance != null) {
        AttendanceReportStatus status;

        if (attendance.isLeave) {
          status = AttendanceReportStatus.leave;
        } else if (attendance.isHoliday) {
          status = AttendanceReportStatus.holiday;
        } else if (attendance.lateMinutes > 0 ||
            attendance.attendanceStatus.toUpperCase() ==
                'LATE') {
          status = AttendanceReportStatus.late;
        } else {
          status = AttendanceReportStatus.present;
        }

        result.add(
          AttendanceReportModel(
            date: current,
            status: status,
            checkInTime: attendance.checkInTime,
            checkOutTime: attendance.checkOutTime,
            checkInAddress: attendance.checkInAddress,
            checkOutAddress: attendance.checkOutAddress,
            lateMinutes: attendance.lateMinutes,
            earlyExitMinutes:
            attendance.earlyExitMinutes,
            workMinutes: attendance.workMinutes,
            isWeekend: attendance.isWeekend,
            isHoliday: attendance.isHoliday,
            isLeave: attendance.isLeave,
          ),
        );
      }

      // ------------------------------------------------
      // No attendance row
      // ------------------------------------------------

      else {
        AttendanceReportStatus status;

        if (isWeekend) {
          status = AttendanceReportStatus.dayOff;
        } else {
          status = AttendanceReportStatus.absent;
        }

        result.add(
          AttendanceReportModel(
            date: current,
            status: status,
            isWeekend: isWeekend,
          ),
        );
      }

      current =
          current.add(const Duration(days: 1));
    }

    return result;
  }
//==============================================================
// SUPERVISOR - TODAY ATTENDANCE BY EMPLOYEES
//==============================================================
//
// Existing employee report method untouched.
//
// This method is used by Supervisor Attendance Report
// for "All Employees -> Today Attendance".
//
// employeeIds:
// Supervisor-এর selected department-এর employee IDs.
//
//==============================================================

  Future<List<AttendanceEntity>> getTodayAttendanceByEmployees(
      List<String> employeeIds,
      ) async {
    if (employeeIds.isEmpty) {
      return [];
    }

    final today = DateTime.now()
        .toIso8601String()
        .split('T')
        .first;

    final response = await _supabase
        .from(_table)
        .select()
        .inFilter(
      'employee_id',
      employeeIds,
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
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
  //==============================================================
  // GET ALL
  //==============================================================

  Future<List<AttendanceEntity>> getAll() async {
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
  }

  //==============================================================
  // GET BY ID
  //==============================================================

  Future<AttendanceEntity?> getById(
      String id,
      ) async {
    final response = await _supabase
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return AttendanceModel.fromMap(response);
  }

  //==============================================================
  // INSERT
  //
  // IMPORTANT:
  // id পাঠানো হচ্ছে না।
  // Supabase:
  // gen_random_uuid()
  // দিয়ে id তৈরি করবে।
  //==============================================================

  Future<void> insert(
      AttendanceModel attendance,
      ) async {
    try {
      await _supabase
          .from('attendance')
          .insert(
        attendance.toInsertMap(),
      );
    } on PostgrestException catch (e) {
      final message =
      DatabaseErrorHelper.getMessage(e);

      throw Exception(message);
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
    if (attendance.id == null ||
        attendance.id!.isEmpty) {
      throw Exception(
        'Attendance ID is required for update.',
      );
    }

    final model =
    AttendanceModel.fromEntity(
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
  }

  //==============================================================
  // DELETE
  //==============================================================

  Future<void> delete(
      String id,
      ) async {
    await _supabase
        .from(_table)
        .delete()
        .eq('id', id);
  }

  //==============================================================
  // SEARCH
  //==============================================================

  Future<List<AttendanceEntity>> search(
      String keyword,
      ) async {
    final response = await _supabase
        .from(_table)
        .select()
        .or(
      'attendance_no.ilike.%$keyword%,'
          'shift_name.ilike.%$keyword%,'
          'attendance_status.ilike.%$keyword%',
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
  }

  //==============================================================
  // BY EMPLOYEE
  //==============================================================

  Future<List<AttendanceEntity>>
  getEmployeeAttendance(
      String employeeId,
      ) async {
    final response = await _supabase
        .from(_table)
        .select()
        .eq(
      'employee_id',
      employeeId,
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
  }

  //==============================================================
  // TODAY ATTENDANCE
  //==============================================================

  Future<List<AttendanceEntity>>
  todayAttendance() async {
    final today = DateTime.now()
        .toIso8601String()
        .split('T')
        .first;

    final response = await _supabase
        .from(_table)
        .select()
        .eq(
      'attendance_date',
      today,
    )
        .order('check_in_time');

    return response
        .map<AttendanceEntity>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
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
  }) async {
    await _supabase
        .from(_table)
        .update({
      'check_in_time':
      checkInTime.toIso8601String(),
      'check_in_latitude':
      latitude,
      'check_in_longitude':
      longitude,
      'device_name':
      deviceName,
      'device_id':
      deviceId,
    })
        .eq(
      'id',
      attendanceId,
    );
  }

  //==============================================================
  // CHECK-OUT
  //==============================================================

  Future<void> checkOut({
    required String attendanceId,
    required DateTime checkOutTime,
    double? latitude,
    double? longitude,
  }) async {
    await _supabase
        .from(_table)
        .update({
      'check_out_time':
      checkOutTime.toIso8601String(),
      'check_out_latitude':
      latitude,
      'check_out_longitude':
      longitude,
    })
        .eq(
      'id',
      attendanceId,
    );
  }

  //==============================================================
  // PRESENT TODAY
  //==============================================================

  Future<int> totalPresentToday() async {
    final today = DateTime.now()
        .toIso8601String()
        .split('T')
        .first;

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
  }

  //==============================================================
  // ATTENDANCE HISTORY
  //==============================================================

  Future<List<AttendanceEntity>>
  getAttendanceHistory() async {
    final response = await _supabase
        .from(_table)
        .select()
        .order(
      'attendance_date',
      ascending: false,
    );

    return response
        .map<AttendanceEntity>(
          (json) =>
          AttendanceModel.fromMap(json),
    )
        .toList();
  }

  //==============================================================
  // TODAY'S ATTENDANCE BY EMPLOYEE
  //==============================================================

  Future<AttendanceEntity?>
  getTodayAttendance(
      String employeeId,
      ) async {
    final today = DateTime.now()
        .toIso8601String()
        .split('T')
        .first;

    final response = await _supabase
        .from(_table)
        .select()
        .eq(
      'employee_id',
      employeeId,
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
  }

  //==============================================================
  // ALREADY CHECKED IN?
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
  // ALREADY CHECKED OUT?
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
}