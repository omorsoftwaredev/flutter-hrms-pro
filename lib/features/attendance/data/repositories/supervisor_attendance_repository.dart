import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';

class SupervisorAttendanceRepository {
  SupervisorAttendanceRepository();

  final SupabaseClient _supabase =
      SupabaseService.client;

  // ===========================================================
  // GET SUPERVISOR
  // ===========================================================

  Future<Map<String, dynamic>?> getSupervisorByEmployeeId(
      String employeeId,
      ) async {
    try {
      final id = employeeId.trim();

      if (id.isEmpty) {
        return null;
      }

      final response = await _supabase
          .from('supervisors')
          .select()
          .eq(
        'employee_id',
        id,
      )
          .eq(
        'is_active',
        true,
      )
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Map<String, dynamic>.from(response);
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===========================================================
  // GET SUPERVISOR DEPARTMENT IDS
  // ===========================================================

  Future<List<String>> getSupervisorDepartmentIds(
      String supervisorId,
      ) async {
    try {
      final id = supervisorId.trim();

      if (id.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('supervisor_departments')
          .select('department_id')
          .eq(
        'supervisor_id',
        id,
      );

      return List<Map<String, dynamic>>.from(response)
          .map(
            (row) => row['department_id']?.toString(),
      )
          .whereType<String>()
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===========================================================
  // GET ASSIGNED DEPARTMENTS
  //
  // supervisor_departments
  //        ↓
  // department IDs
  //        ↓
  // departments
  //
  // No assumed department fields.
  // ===========================================================

  Future<List<Map<String, dynamic>>> getSupervisorDepartments(
      String supervisorId,
      ) async {
    try {
      final id = supervisorId.trim();

      if (id.isEmpty) {
        return [];
      }

      final assignmentResponse = await _supabase
          .from('supervisor_departments')
          .select()
          .eq(
        'supervisor_id',
        id,
      )
          .order(
        'created_at',
        ascending: true,
      );

      final assignments =
      List<Map<String, dynamic>>.from(
        assignmentResponse,
      );

      if (assignments.isEmpty) {
        return [];
      }

      final departmentIds = assignments
          .map(
            (row) => row['department_id']?.toString(),
      )
          .whereType<String>()
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (departmentIds.isEmpty) {
        return [];
      }

      final departmentResponse = await _supabase
          .from('departments')
          .select()
          .inFilter(
        'id',
        departmentIds,
      );

      final departments =
      List<Map<String, dynamic>>.from(
        departmentResponse,
      );

      final Map<String, Map<String, dynamic>>
      departmentMap = {};

      for (final department in departments) {
        final departmentId =
        department['id']?.toString();

        if (departmentId != null &&
            departmentId.trim().isNotEmpty) {
          departmentMap[departmentId.trim()] =
          Map<String, dynamic>.from(
            department,
          );
        }
      }

      final result = <Map<String, dynamic>>[];

      for (final assignment in assignments) {
        final departmentId =
        assignment['department_id']?.toString();

        if (departmentId == null ||
            departmentId.trim().isEmpty) {
          continue;
        }

        final department =
        departmentMap[departmentId.trim()];

        if (department != null) {
          result.add(department);
        }
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

  // ===========================================================
  // GET EMPLOYEES BY DEPARTMENT
  //
  // Department-এর active employees.
  //
  // select() ব্যবহার করা হচ্ছে যাতে unnecessary
  // schema dependency না থাকে।
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getEmployeesByDepartment(
      String departmentId,
      ) async {
    try {
      final id = departmentId.trim();

      if (id.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('employees')
          .select()
          .eq(
        'department_id',
        id,
      )
          .eq(
        'is_active',
        true,
      )
          .order(
        'employee_code',
        ascending: true,
      );

      return List<Map<String, dynamic>>.from(
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

  // ===========================================================
  // GET TODAY ATTENDANCE
  //
  // Supervisor-এর assigned department-এর
  // active employees-এর today's attendance.
  //
  // IMPORTANT:
  //
  // attendance -> employees relation ব্যবহার করা হচ্ছে না।
  //
  // Step 1:
  // employees থেকে employee IDs
  //
  // Step 2:
  // attendance থেকে today's attendance
  //
  // Step 3:
  // employee data local map দিয়ে attach
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getDepartmentTodayAttendance(
      String departmentId,
      ) async {
    try {
      final department = departmentId.trim();

      if (department.isEmpty) {
        return [];
      }

      final today = _formatDate(
        DateTime.now(),
      );

      // ---------------------------------------------------------
      // STEP 1
      // GET ACTIVE EMPLOYEES
      // ---------------------------------------------------------

      final employeeResponse = await _supabase
          .from('employees')
          .select()
          .eq(
        'department_id',
        department,
      )
          .eq(
        'is_active',
        true,
      );

      final employees =
      List<Map<String, dynamic>>.from(
        employeeResponse,
      );

      if (employees.isEmpty) {
        return [];
      }

      final employeeIds = employees
          .map(
            (employee) =>
            employee['id']?.toString(),
      )
          .whereType<String>()
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (employeeIds.isEmpty) {
        return [];
      }

      // ---------------------------------------------------------
      // STEP 2
      // GET TODAY ATTENDANCE
      // ---------------------------------------------------------

      final attendanceResponse = await _supabase
          .from('attendance')
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

      final attendance =
      List<Map<String, dynamic>>.from(
        attendanceResponse,
      );

      // ---------------------------------------------------------
      // STEP 3
      // EMPLOYEE MAP
      // ---------------------------------------------------------

      final Map<String, Map<String, dynamic>>
      employeeMap = {};

      for (final employee in employees) {
        final employeeId =
        employee['id']?.toString();

        if (employeeId != null &&
            employeeId.trim().isNotEmpty) {
          employeeMap[employeeId.trim()] =
          Map<String, dynamic>.from(
            employee,
          );
        }
      }

      // ---------------------------------------------------------
      // STEP 4
      // ATTACH EMPLOYEE DATA
      // ---------------------------------------------------------

      final result = <Map<String, dynamic>>[];

      for (final attendanceRow in attendance) {
        final map =
        Map<String, dynamic>.from(
          attendanceRow,
        );

        final employeeId =
        attendanceRow['employee_id']
            ?.toString();

        if (employeeId != null &&
            employeeId.trim().isNotEmpty) {
          map['employees'] =
          employeeMap[employeeId.trim()];
        } else {
          map['employees'] = null;
        }

        result.add(map);
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

  // ===========================================================
  // GET EMPLOYEE ATTENDANCE
  //
  // Selected Employee mode.
  // ===========================================================

  Future<List<Map<String, dynamic>>>
  getEmployeeAttendance(
      String employeeId, {
        required DateTime from,
        required DateTime to,
      }) async {
    try {
      final id = employeeId.trim();

      if (id.isEmpty) {
        return [];
      }

      final fromDate = _formatDate(from);
      final toDate = _formatDate(to);

      final response = await _supabase
          .from('attendance')
          .select()
          .eq(
        'employee_id',
        id,
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

      return List<Map<String, dynamic>>.from(
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

  // ===========================================================
  // CHECK EMPLOYEE BELONGS TO SUPERVISOR
  //
  // Supervisor-এর assigned department-এর বাইরে
  // employee access করতে পারবে না।
  // ===========================================================

  Future<bool> isEmployeeUnderSupervisor({
    required String supervisorId,
    required String employeeId,
  }) async {
    try {
      final supervisor =
      supervisorId.trim();

      final employee =
      employeeId.trim();

      if (supervisor.isEmpty ||
          employee.isEmpty) {
        return false;
      }

      final departmentIds =
      await getSupervisorDepartmentIds(
        supervisor,
      );

      if (departmentIds.isEmpty) {
        return false;
      }

      final employeeResponse =
      await _supabase
          .from('employees')
          .select(
        'id, department_id',
      )
          .eq(
        'id',
        employee,
      )
          .maybeSingle();

      if (employeeResponse == null) {
        return false;
      }

      final employeeDepartmentId =
      employeeResponse['department_id']
          ?.toString();

      if (employeeDepartmentId == null ||
          employeeDepartmentId.trim().isEmpty) {
        return false;
      }

      return departmentIds.contains(
        employeeDepartmentId.trim(),
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      rethrow;
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