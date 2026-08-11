import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';

class SupervisorAttendanceRepository {
  SupervisorAttendanceRepository();

  final SupabaseClient _supabase =
      SupabaseService.client;

  // ===========================================================
  // GET SUPERVISOR
  //
  // Logged-in user's employee_id দিয়ে supervisors table check.
  // ===========================================================

  Future<Map<String, dynamic>?> getSupervisorByEmployeeId(
      String employeeId,
      ) async {
    try {
      final response = await _supabase
          .from('supervisors')
          .select(
        'id, employee_id, company_id, is_active',
      )
          .eq(
        'employee_id',
        employeeId,
      )
          .eq(
        'is_active',
        true,
      )
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // GET SUPERVISOR DEPARTMENT IDS
  //
  // supervisor_departments table থেকে শুধু assigned
  // department IDs নেওয়া হবে।
  // ===========================================================

  Future<List<String>> getSupervisorDepartmentIds(
      String supervisorId,
      ) async {
    try {
      final response = await _supabase
          .from('supervisor_departments')
          .select('department_id')
          .eq(
        'supervisor_id',
        supervisorId,
      );

      return response
          .map<String>(
            (row) => row['department_id'].toString(),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // GET ASSIGNED DEPARTMENTS
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getSupervisorDepartments(
      String supervisorId,
      ) async {
    try {
      final response = await _supabase
          .from('supervisor_departments')
          .select(
        '''
            department_id,
            departments (
              id,
              company_id,
              code,
              name,
              description,
              manager_name,
              phone,
              email,
              location,
              is_active,
              created_at,
              updated_at
            )
            ''',
      )
          .eq(
        'supervisor_id',
        supervisorId,
      );

      return response
          .map<Map<String, dynamic>>(
            (row) {
          final department =
          row['departments'];

          if (department is Map<String, dynamic>) {
            return department;
          }

          return <String, dynamic>{
            'id': row['department_id'],
          };
        },
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // GET EMPLOYEES BY DEPARTMENT
  //
  // Supervisor-এর assigned department-এর মধ্যেই employee
  // পাওয়া যাবে।
  // ===========================================================

  // =============================================================
// GET EMPLOYEES BY DEPARTMENT
// =============================================================

  Future<List<Map<String, dynamic>>>
  getEmployeesByDepartment(
      String departmentId,
      ) async {
    final response = await _supabase
        .from('employees')
        .select(
      '''
        id,
        employee_code,
        first_name,
        last_name,
        full_name,
        department_id,
        is_active,
        departments (
          id,
          name
        )
        ''',
    )
        .eq(
      'department_id',
      departmentId,
    )
        .eq(
      'is_active',
      true,
    )
        .order(
      'employee_code',
      ascending: true,
    );

    return response
        .map<Map<String, dynamic>>(
          (row) => Map<String, dynamic>.from(row),
    )
        .toList();
  }

  // ===========================================================
  // GET TODAY ATTENDANCE
  //
  // All Employees mode-এর জন্য।
  //
  // এখানে selected department-এর আজকের attendance
  // নেওয়া হবে।
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getDepartmentTodayAttendance(
      String departmentId,
      ) async {
    try {
      final today = DateTime.now()
          .toIso8601String()
          .split('T')
          .first;

      final response = await _supabase
          .from('attendance')
          .select(
        '''
            *,
            employees!inner(
              id,
              employee_code,
              first_name,
              last_name,
              full_name,
              department_id
            )
            ''',
      )
          .eq(
        'employees.department_id',
        departmentId,
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
          .map<Map<String, dynamic>>(
            (row) => Map<String, dynamic>.from(row),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // GET EMPLOYEE ATTENDANCE
  //
  // Selected Employee mode-এর জন্য।
  //
  // Existing getEmployeeAttendanceReport() touch করা হচ্ছে না।
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getEmployeeAttendance(
      String employeeId, {
        required DateTime from,
        required DateTime to,
      }) async {
    try {
      final fromDate =
      _formatDate(from);

      final toDate =
      _formatDate(to);

      final response = await _supabase
          .from('attendance')
          .select()
          .eq(
        'employee_id',
        employeeId,
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
          .map<Map<String, dynamic>>(
            (row) => Map<String, dynamic>.from(row),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // CHECK EMPLOYEE BELONGS TO SUPERVISOR DEPARTMENT
  //
  // Selected employee access validation.
  // ===========================================================

  Future<bool> isEmployeeUnderSupervisor({
    required String supervisorId,
    required String employeeId,
  }) async {
    try {
      final departments =
      await getSupervisorDepartmentIds(
        supervisorId,
      );

      if (departments.isEmpty) {
        return false;
      }

      final employee =
      await _supabase
          .from('employees')
          .select(
        'id, department_id',
      )
          .eq(
        'id',
        employeeId,
      )
          .maybeSingle();

      if (employee == null) {
        return false;
      }

      final employeeDepartmentId =
      employee['department_id']?.toString();

      if (employeeDepartmentId == null) {
        return false;
      }

      return departments.contains(
        employeeDepartmentId,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  // ===========================================================
  // DATE
  // ===========================================================

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}