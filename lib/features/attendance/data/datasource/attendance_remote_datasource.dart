import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/attendance_model.dart';

class AttendanceRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  //==============================================================
  // GET ALL
  //==============================================================

  Future<List<AttendanceModel>> getAll() async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceModel>(
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
  // GET TODAY ATTENDANCE
  //==============================================================

  Future<AttendanceModel?> getTodayAttendance(
      String employeeId,
      ) async {
    try {
      final today = DateTime.now()
          .toIso8601String()
          .split('T')
          .first;

      final response = await _client
          .from('attendance')
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

  Future<AttendanceModel?> getById(
      String id,
      ) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .eq(
        'id',
        id,
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
  //
  // IMPORTANT:
  //
  // এখানে id পাঠানো হচ্ছে না।
  //
  // Database:
  // id uuid NOT NULL DEFAULT gen_random_uuid()
  //
  // তাই PostgreSQL নিজে id generate করবে।
  //==============================================================

  Future<void> insert(
      AttendanceModel attendance,
      ) async {
    try {
      await _client
          .from('attendance')
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
  //
  // IMPORTANT:
  //
  // id ছাড়া অন্য data update হবে।
  //
  // WHERE id = attendance.id
  //==============================================================

  Future<void> update(
      AttendanceModel attendance,
      ) async {
    try {
      if (attendance.id == null ||
          attendance.id!.isEmpty) {
        throw Exception(
          'Attendance ID is required for update.',
        );
      }

      await _client
          .from('attendance')
          .update(
        attendance.toUpdateMap(),
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
      await _client
          .from('attendance')
          .delete()
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
  // SEARCH
  //==============================================================

  Future<List<AttendanceModel>> search(
      String keyword,
      ) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .or(
        'attendance_no.ilike.%$keyword%,'
            'remarks.ilike.%$keyword%',
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceModel>(
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

  Future<List<AttendanceModel>> byEmployee(
      String employeeId,
      ) async {
    try {
      final response = await _client
          .from('attendance')
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
          .map<AttendanceModel>(
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

  Future<List<AttendanceModel>> byStatus(
      String status,
      ) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .eq(
        'attendance_status',
        status,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceModel>(
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

  Future<List<AttendanceModel>> byDate(
      DateTime date,
      ) async {
    try {
      final selectedDate = date
          .toIso8601String()
          .split('T')
          .first;

      final response = await _client
          .from('attendance')
          .select()
          .eq(
        'attendance_date',
        selectedDate,
      );

      return response
          .map<AttendanceModel>(
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

  Future<List<AttendanceModel>> byDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final fromDate = from
          .toIso8601String()
          .split('T')
          .first;

      final toDate = to
          .toIso8601String()
          .split('T')
          .first;

      final response = await _client
          .from('attendance')
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
          .map<AttendanceModel>(
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
  // BY COMPANY
  //==============================================================

  Future<List<AttendanceModel>> byCompany(
      String companyId,
      ) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .eq(
        'company_id',
        companyId,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceModel>(
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

  Future<List<AttendanceModel>> byDepartment(
      String departmentId,
      ) async {
    try {
      final response = await _client
          .from('attendance')
          .select()
          .eq(
        'department_id',
        departmentId,
      )
          .order(
        'attendance_date',
        ascending: false,
      );

      return response
          .map<AttendanceModel>(
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