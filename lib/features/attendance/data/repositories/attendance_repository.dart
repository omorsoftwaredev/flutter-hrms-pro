import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

import '../../domain/entities/attendance_entity.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final _supabase = SupabaseService.client;

  static const String _table = 'attendance';

  ///========================================
  /// GET ALL
  ///========================================

  Future<List<AttendanceEntity>> getAll() async {
    final response = await _supabase
        .from(_table)
        .select()
        .order('attendance_date', ascending: false);

    return response
        .map<AttendanceEntity>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  ///========================================
  /// GET BY ID
  ///========================================

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

  ///========================================
  /// INSERT
  ///========================================

  Future<void> insert(
      AttendanceEntity attendance,
      ) async {
    final model =
    AttendanceModel.fromEntity(attendance);

    await _supabase
        .from(_table)
        .insert(model.toMap());
  }

  ///========================================
  /// UPDATE
  ///========================================

  Future<void> update(
      AttendanceEntity attendance,
      ) async {
    final model =
    AttendanceModel.fromEntity(attendance);

    await _supabase
        .from(_table)
        .update(model.toMap())
        .eq('id', attendance.id!);
  }

  ///========================================
  /// DELETE
  ///========================================

  Future<void> delete(
      String id,
      ) async {
    await _supabase
        .from(_table)
        .delete()
        .eq('id', id);
  }

  ///========================================
  /// SEARCH
  ///========================================

  Future<List<AttendanceEntity>>
  search(String keyword) async {
    final response = await _supabase
        .from(_table)
        .select()
        .or(
      'attendance_no.ilike.%$keyword%,shift_name.ilike.%$keyword%,attendance_status.ilike.%$keyword%',
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

  ///========================================
  /// BY EMPLOYEE
  ///========================================

  Future<List<AttendanceEntity>>
  getEmployeeAttendance(
      String employeeId,
      ) async {
    final response = await _supabase
        .from(_table)
        .select()
        .eq('employee_id', employeeId)
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

  ///========================================
  /// TODAY ATTENDANCE
  ///========================================

  Future<List<AttendanceEntity>>
  todayAttendance() async {
    final today =
        DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from(_table)
        .select()
        .eq('attendance_date', today)
        .order('check_in_time');

    return response
        .map<AttendanceEntity>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  ///========================================
  /// CHECK-IN
  ///========================================

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
      'check_in_latitude': latitude,
      'check_in_longitude': longitude,
      'device_name': deviceName,
      'device_id': deviceId,
    })
        .eq('id', attendanceId);
  }

  ///========================================
  /// CHECK-OUT
  ///========================================

  Future<void> checkOut({
    required String attendanceId,
    required DateTime checkOutTime,
    double? latitude,
    double? longitude,
  }) async {
    await _supabase
        .from('attendance')
        .update({
      'check_out_time': checkOutTime.toIso8601String(),
      'check_out_latitude': latitude,
      'check_out_longitude': longitude,
    })
        .eq('id', attendanceId);
  }

  ///========================================
  /// PRESENT TODAY
  ///========================================

  Future<int> totalPresentToday() async {
    final today =
        DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from(_table)
        .select('id')
        .eq('attendance_date', today)
        .eq('attendance_status', 'PRESENT');

    return response.length;
  }
  ///==============================
  /// Attendance History
  ///==============================

  Future<List<AttendanceEntity>> getAttendanceHistory() async {
    final response = await _supabase
        .from('attendance')
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
  }

  ///==============================
  /// Today's Attendance
  ///==============================

  Future<AttendanceEntity?> getTodayAttendance(
      String employeeId,
      ) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from(_table)
        .select()
        .eq('employee_id', employeeId)
        .eq('attendance_date', today)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return AttendanceModel.fromMap(response);
  }


  ///==============================
  /// Already Checked In ?
  ///==============================

  Future<bool> alreadyCheckedIn(
      String employeeId,
      ) async {
    final attendance = await getTodayAttendance(employeeId);

    return attendance != null;
  }

  ///==============================
  /// Already Checked Out ?
  ///==============================

  Future<bool> alreadyCheckedOut(
      String employeeId,
      ) async {
    final attendance = await getTodayAttendance(employeeId);

    if (attendance == null) {
      return false;
    }

    return attendance.checkOutTime != null;
  }
  ///==============================
  /// Refresh Today Attendance
  ///==============================

  Future<AttendanceEntity?> refreshTodayAttendance(
      String employeeId,
      ) async {
    return await getTodayAttendance(employeeId);
  }
}