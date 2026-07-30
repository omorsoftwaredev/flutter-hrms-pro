import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/attendance_model.dart';

class AttendanceRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<AttendanceModel>> getAll() async {
    final response = await _client
        .from('attendance')
        .select()
        .order('attendance_date', ascending: false);

    return response
        .map<AttendanceModel>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  Future<AttendanceModel?> getById(String id) async {
    final response = await _client
        .from('attendance')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return AttendanceModel.fromMap(response);
  }

  Future<void> insert(
      AttendanceModel attendance,
      ) async {
    await _client
        .from('attendance')
        .insert(attendance.toMap());
  }

  Future<void> update(
      AttendanceModel attendance,
      ) async {
    await _client
        .from('attendance')
        .update(attendance.toMap())
        .eq('id', attendance.id!);
  }

  Future<void> delete(String id) async {
    await _client
        .from('attendance')
        .delete()
        .eq('id', id);
  }

  Future<List<AttendanceModel>> search(
      String keyword,
      ) async {
    final response = await _client
        .from('attendance')
        .select()
        .or(
      'attendance_no.ilike.%$keyword%,remarks.ilike.%$keyword%',
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
  }

  Future<List<AttendanceModel>> byEmployee(
      String employeeId,
      ) async {
    final response = await _client
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .order(
      'attendance_date',
      ascending: false,
    );

    return response
        .map<AttendanceModel>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  Future<List<AttendanceModel>> byStatus(
      String status,
      ) async {
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
  }

  Future<List<AttendanceModel>> byDate(
      DateTime date,
      ) async {
    final response = await _client
        .from('attendance')
        .select()
        .eq(
      'attendance_date',
      date.toIso8601String().split('T').first,
    );

    return response
        .map<AttendanceModel>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  Future<List<AttendanceModel>> byDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _client
        .from('attendance')
        .select()
        .gte(
      'attendance_date',
      from.toIso8601String().split('T').first,
    )
        .lte(
      'attendance_date',
      to.toIso8601String().split('T').first,
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
  }

  Future<List<AttendanceModel>> byCompany(
      String companyId,
      ) async {
    final response = await _client
        .from('attendance')
        .select()
        .eq('company_id', companyId)
        .order(
      'attendance_date',
      ascending: false,
    );

    return response
        .map<AttendanceModel>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }

  Future<List<AttendanceModel>> byDepartment(
      String departmentId,
      ) async {
    final response = await _client
        .from('attendance')
        .select()
        .eq('department_id', departmentId)
        .order(
      'attendance_date',
      ascending: false,
    );

    return response
        .map<AttendanceModel>(
          (e) => AttendanceModel.fromMap(e),
    )
        .toList();
  }
}