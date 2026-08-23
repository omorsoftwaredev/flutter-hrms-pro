import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/helpers/database_error_helper.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../../../shift/data/models/shift_model.dart';
import '../../domain/entities/mobile_attendance_entity.dart';
import '../models/mobile_attendance_model.dart';

class MobileAttendanceRepository {
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

  Future<ShiftModel?> getShiftById(String? shiftId) async {
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
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET SHIFT NAME BY ID
  //==============================================================

  Future<String?> getShiftNameById(String? shiftId) async {
    final shift = await getShiftById(shiftId);

    if (shift == null) {
      return null;
    }

    final name = shift.name.trim();

    if (name.isEmpty) {
      return null;
    }

    return name;
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

  Future<List<MobileAttendanceEntity>>
  getTodayAttendanceByEmployees(
      List<String> employeeIds,
      ) async {
    try {
      final ids = employeeIds
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (ids.isEmpty) {
        return [];
      }

      final today = _formatDate(DateTime.now());

      final response = await _supabase
          .from(_table)
          .select()
          .inFilter('employee_id', ids)
          .eq('attendance_date', today)
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<MobileAttendanceEntity>(
            (json) => MobileAttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // TODAY ATTENDANCE BY COMPANY + DEPARTMENT
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  getSupervisorTodayAttendance({
    required String companyId,
    required String departmentId,
  }) async {
    try {
      final company = companyId.trim();
      final department = departmentId.trim();

      if (company.isEmpty) {
        throw Exception('Company ID is required.');
      }

      if (department.isEmpty) {
        throw Exception('Department ID is required.');
      }

      final today = _formatDate(DateTime.now());

      final response = await _supabase
          .from(_table)
          .select()
          .eq('company_id', company)
          .eq('department_id', department)
          .eq('attendance_date', today)
          .order(
        'check_in_time',
        ascending: true,
      );

      return response
          .map<MobileAttendanceEntity>(
            (json) => MobileAttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // EMPLOYEE ATTENDANCE DATE RANGE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  getSupervisorEmployeeAttendance({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        throw Exception('Employee ID is required.');
      }

      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from(_table)
          .select()
          .eq('employee_id', employee)
          .gte('attendance_date', fromDate)
          .lte('attendance_date', toDate)
          .order(
        'attendance_date',
        ascending: true,
      );

      return response
          .map<MobileAttendanceEntity>(
            (json) => MobileAttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SUPERVISOR
  // DEPARTMENT DATE RANGE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
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
        throw Exception('Company ID is required.');
      }

      if (department.isEmpty) {
        throw Exception('Department ID is required.');
      }

      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from(_table)
          .select()
          .eq('company_id', company)
          .eq('department_id', department)
          .gte('attendance_date', fromDate)
          .lte('attendance_date', toDate)
          .order(
        'attendance_date',
        ascending: true,
      );

      return response
          .map<MobileAttendanceEntity>(
            (json) => MobileAttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET ALL
  //==============================================================

  Future<List<MobileAttendanceEntity>> getAll() async {
    try {
      final response = await _supabase
          .from(_table)
          .select()
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // GET BY ID
  //==============================================================

  Future<MobileAttendanceEntity?> getById(
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
          .eq('id', attendanceId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return MobileAttendanceModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // INSERT
  //==============================================================

  Future<void> insert(
      MobileAttendanceModel attendance,
      ) async {
    try {
      await _supabase
          .from(_table)
          .insert(
        attendance.toInsertMap(),
      );
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // UPDATE
  //==============================================================

  Future<void> update(
      MobileAttendanceEntity attendance,
      ) async {
    try {
      if (attendance.id == null ||
          attendance.id!.trim().isEmpty) {
        throw Exception(
          'Attendance ID is required for update.',
        );
      }

      final model =
      MobileAttendanceModel.fromEntity(attendance);

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
      throw Exception(DatabaseErrorHelper.getMessage(e));
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
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // SEARCH
  //==============================================================

  Future<List<MobileAttendanceEntity>> search(
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
            'attendance_status.ilike.%$value%',
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY EMPLOYEE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // TODAY ATTENDANCE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  todayAttendance() async {
    try {
      final today = _formatDate(DateTime.now());

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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
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
        'check_in_latitude':
        latitude,
        'check_in_longitude':
        longitude,
        'check_in_address':
        address,
        'check_in_accuracy':
        accuracy,
        'device_name':
        deviceName,
        'device_id':
        deviceId,
      }).eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
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

      final attendance =
      await _supabase
          .from(_table)
          .select(
        'check_in_time, check_out_time',
      )
          .eq(
        'id',
        id,
      )
          .maybeSingle();

      if (attendance == null) {
        throw Exception(
          'Attendance record not found.',
        );
      }

      final checkOutExisting =
      attendance['check_out_time'];

      if (checkOutExisting != null) {
        throw Exception(
          'You have already checked out today.',
        );
      }

      final checkInValue =
      attendance['check_in_time'];

      if (checkInValue == null) {
        throw Exception(
          'Check-in time not found.',
        );
      }

      final checkInTime =
      DateTime.tryParse(
        checkInValue.toString(),
      );

      if (checkInTime == null) {
        throw Exception(
          'Invalid check-in time.',
        );
      }


      await _supabase
          .from(_table)
          .update({
        'check_out_time':
        checkOutTime.toIso8601String(),
        'check_out_latitude':
        latitude,
        'check_out_longitude':
        longitude,
        'check_out_address':
        address,
        'check_out_accuracy':
        accuracy,
        'updated_at':
        DateTime.now().toIso8601String(),
      }).eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // PRESENT TODAY
  //==============================================================

  Future<int> totalPresentToday() async {
    try {
      final today = _formatDate(DateTime.now());

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
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // ATTENDANCE HISTORY
  //==============================================================

  Future<List<MobileAttendanceEntity>>
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
          .map<MobileAttendanceEntity>(
            (json) =>
            MobileAttendanceModel.fromMap(json),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // TODAY'S ATTENDANCE BY EMPLOYEE
  //==============================================================

  Future<MobileAttendanceEntity?>
  getTodayAttendance(
      String employeeId,
      ) async {
    try {
      final employee = employeeId.trim();

      if (employee.isEmpty) {
        return null;
      }

      final today = _formatDate(DateTime.now());

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

      return MobileAttendanceModel.fromMap(
        response,
      );
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
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
    await getTodayAttendance(employeeId);

    return attendance != null;
  }

  //==============================================================
  // ALREADY CHECKED OUT
  //==============================================================

  Future<bool> alreadyCheckedOut(
      String employeeId,
      ) async {
    final attendance =
    await getTodayAttendance(employeeId);

    if (attendance == null) {
      return false;
    }

    return attendance.checkOutTime != null;
  }

  //==============================================================
  // REFRESH TODAY ATTENDANCE
  //==============================================================

  Future<MobileAttendanceEntity?>
  refreshTodayAttendance(
      String employeeId,
      ) async {
    return getTodayAttendance(employeeId);
  }

  //==============================================================
  // BY COMPANY
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  byCompany(
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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DEPARTMENT
  //==============================================================

  Future<List<MobileAttendanceEntity>>
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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY STATUS
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  byStatus(
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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DATE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
  byDate(
      DateTime date,
      ) async {
    try {
      final selectedDate =
      _formatDate(date);

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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  //==============================================================
  // BY DATE RANGE
  //==============================================================

  Future<List<MobileAttendanceEntity>>
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
          .map<MobileAttendanceEntity>(
            (e) => MobileAttendanceModel.fromMap(e),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }
}