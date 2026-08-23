import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/supervisor_department_entity.dart';
import 'supervisor_department_repository.dart';
import '../models/supervisor_department_model.dart';

class SupervisorDepartmentRepositoryImpl
    implements SupervisorDepartmentRepository {
  final SupabaseClient _supabase;

  SupervisorDepartmentRepositoryImpl({
    required SupabaseClient supabase,
  }) : _supabase = supabase;

  //=================================================================
  // DEBUG HEADER
  //=================================================================

  void _printHeader(String title) {
    debugPrint('');
    debugPrint('');
    debugPrint('============================================================');
    debugPrint(title);
    debugPrint('============================================================');
  }

  //=================================================================
  // DEBUG FOOTER
  //=================================================================

  void _printFooter() {
    debugPrint('============================================================');
    debugPrint('');
  }

  //=================================================================
  // DEBUG VALUE
  //=================================================================

  void _printValue(String key, dynamic value) {
    debugPrint('$key: $value');
  }

  //=================================================================
  // GET SUPERVISOR DEPARTMENTS
  //=================================================================

  @override
  Future<List<SupervisorDepartmentEntity>>
  getSupervisorDepartments({
    required String supervisorId,
    required String companyId,
  }) async {
    _printHeader(
      'SUPERVISOR DEPARTMENT REPOSITORY — getSupervisorDepartments()',
    );

    debugPrint('METHOD CALLED FROM PAGE');
    debugPrint('');

    _printValue('supervisorId', supervisorId);
    _printValue('companyId', companyId);

    //=================================================================
    // SQL DEBUG — STEP 1
    //=================================================================

    _printHeader(
      'SQL DEBUG — STEP 1 — FIND SUPERVISOR',
    );

    debugPrint('''
SELECT
    id,
    employee_id,
    company_id,
    is_active,
    department_id
FROM public.supervisors
WHERE employee_id = '$supervisorId'
  AND company_id = '$companyId'
LIMIT 1;
''');

    try {
      //===============================================================
      // STEP 1 — FIND SUPERVISOR
      //===============================================================

      final supervisorResponse = await _supabase
          .from('supervisors')
          .select('''
            id,
            employee_id,
            company_id,
            is_active,
            department_id
          ''')
          .eq('employee_id', supervisorId)
          .eq('company_id', companyId)
          .maybeSingle();

      _printHeader(
        'STEP 1 RESULT — supervisors',
      );

      _printValue(
        'Supervisor response',
        supervisorResponse,
      );

      if (supervisorResponse == null) {
        debugPrint(
          '❌ NO SUPERVISOR FOUND',
        );

        debugPrint('');
        debugPrint('Values used:');
        _printValue('employee_id', supervisorId);
        _printValue('company_id', companyId);

        debugPrint('');

        debugPrint('Run this SQL manually:');
        debugPrint('');

        debugPrint('''
SELECT
    id,
    employee_id,
    company_id,
    is_active,
    department_id
FROM public.supervisors
WHERE employee_id = '$supervisorId'
  AND company_id = '$companyId'
LIMIT 1;
''');

        _printFooter();

        return [];
      }

      //===============================================================
      // ACTUAL SUPERVISOR DATABASE ID
      //===============================================================

      final actualSupervisorId =
      supervisorResponse['id']?.toString();

      debugPrint('');
      debugPrint('✅ SUPERVISOR FOUND');

      _printValue(
        'Supervisor DB ID',
        actualSupervisorId,
      );

      _printValue(
        'Supervisor employee_id',
        supervisorResponse['employee_id'],
      );

      _printValue(
        'Supervisor company_id',
        supervisorResponse['company_id'],
      );

      _printValue(
        'Supervisor is_active',
        supervisorResponse['is_active'],
      );

      _printValue(
        'Supervisor department_id',
        supervisorResponse['department_id'],
      );

      //===============================================================
      // SAFETY
      //===============================================================

      if (actualSupervisorId == null ||
          actualSupervisorId.trim().isEmpty) {
        debugPrint('');
        debugPrint(
          '❌ actualSupervisorId IS NULL/EMPTY',
        );

        _printFooter();

        return [];
      }

      //=================================================================
      // SQL DEBUG — STEP 2
      //=================================================================

      _printHeader(
        'SQL DEBUG — STEP 2 — FIND ASSIGNED DEPARTMENTS',
      );

      debugPrint('''
SELECT
    sd.id,
    sd.company_id,
    sd.supervisor_id,
    sd.department_id,
    sd.created_at,
    d.id AS department_table_id,
    d.name AS department_name,
    d.code AS department_code,
    d.is_active AS department_is_active
FROM public.supervisor_departments sd
LEFT JOIN public.departments d
    ON d.id = sd.department_id
WHERE sd.company_id = '$companyId'
  AND sd.supervisor_id = '$actualSupervisorId'
ORDER BY sd.created_at ASC;
''');

      //===============================================================
      // STEP 2 — GET SUPERVISOR DEPARTMENTS
      //===============================================================

      final response = await _supabase
          .from('supervisor_departments')
          .select('''
            id,
            company_id,
            supervisor_id,
            department_id,
            created_at,
            departments (
              id,
              name,
              code,
              is_active
            )
          ''')
          .eq(
        'company_id',
        companyId,
      )
          .eq(
        'supervisor_id',
        actualSupervisorId,
      )
          .order(
        'created_at',
        ascending: true,
      );

      _printHeader(
        'STEP 2 RESULT — supervisor_departments',
      );

      _printValue(
        'Department rows count',
        response.length,
      );

      debugPrint('');

      for (var index = 0; index < response.length; index++) {
        debugPrint(
          '---------------- ROW ${index + 1} ----------------',
        );

        debugPrint(
          response[index].toString(),
        );
      }

      //=================================================================
      // SQL DEBUG — STEP 3
      //=================================================================

      _printHeader(
        'SQL DEBUG — STEP 3 — EMPLOYEES UNDER ASSIGNED DEPARTMENTS',
      );

      debugPrint('''
SELECT
    e.id AS employee_id,
    e.employee_code,
    e.full_name,
    e.company_id,
    e.department_id,
    d.name AS department_name,
    d.code AS department_code
FROM public.employees e
LEFT JOIN public.departments d
    ON d.id = e.department_id
WHERE e.company_id = '$companyId'
  AND e.department_id IN (
      SELECT sd.department_id
      FROM public.supervisor_departments sd
      WHERE sd.company_id = '$companyId'
        AND sd.supervisor_id = '$actualSupervisorId'
  )
  AND e.is_active = TRUE
ORDER BY e.full_name ASC;
''');

      //=================================================================
      // OPTIONAL EMPLOYEE DEBUG QUERY
      //=================================================================
      //
      // This is intentionally executed separately so we can see whether
      // the supervisor actually has employees in the assigned departments.
      //
      //=================================================================

      final employeeResponse = await _supabase
          .from('employees')
          .select('''
            id,
            employee_code,
            full_name,
            company_id,
            department_id,
            is_active,
            departments (
              id,
              name,
              code
            )
          ''')
          .eq(
        'company_id',
        companyId,
      )
          .eq(
        'is_active',
        true,
      );

      final assignedDepartmentIds = response
          .map(
            (item) => item['department_id']?.toString(),
      )
          .whereType<String>()
          .where(
            (value) => value.trim().isNotEmpty,
      )
          .toSet();

      final assignedEmployees = employeeResponse.where((employee) {
        final departmentId =
        employee['department_id']?.toString();

        if (departmentId == null) {
          return false;
        }

        return assignedDepartmentIds.contains(departmentId);
      }).toList();

      _printHeader(
        'STEP 3 RESULT — EMPLOYEES',
      );

      _printValue(
        'All active employees fetched',
        employeeResponse.length,
      );

      _printValue(
        'Assigned department IDs',
        assignedDepartmentIds.toList(),
      );

      _printValue(
        'Employees under assigned departments',
        assignedEmployees.length,
      );

      debugPrint('');

      for (var index = 0;
      index < assignedEmployees.length;
      index++) {
        final employee = assignedEmployees[index];

        debugPrint(
          '---------------- EMPLOYEE ${index + 1} ----------------',
        );

        _printValue(
          'employee.id',
          employee['id'],
        );

        _printValue(
          'employee.employee_code',
          employee['employee_code'],
        );

        _printValue(
          'employee.full_name',
          employee['full_name'],
        );

        _printValue(
          'employee.company_id',
          employee['company_id'],
        );

        _printValue(
          'employee.department_id',
          employee['department_id'],
        );

        _printValue(
          'employee.is_active',
          employee['is_active'],
        );

        debugPrint(
          'department: ${employee['departments']}',
        );
      }

      //=================================================================
      // STEP 4 — PARSE SUPERVISOR DEPARTMENTS
      //=================================================================

      _printHeader(
        'STEP 4 — PARSING DEPARTMENT MODELS',
      );

      final result = response
          .map(
            (json) => SupervisorDepartmentModel.fromJson(
          Map<String, dynamic>.from(json),
        ),
      )
          .toList();

      _printValue(
        'Parsed department count',
        result.length,
      );

      debugPrint('');

      for (final department in result) {
        debugPrint(
          'Department:',
        );

        _printValue(
          'departmentId',
          department.departmentId,
        );

        _printValue(
          'departmentName',
          department.departmentName,
        );

        _printValue(
          'departmentCode',
          department.departmentCode,
        );
      }

      //=================================================================
      // FINAL SQL DEBUG — EXACT VALUES FOR SQL EDITOR
      //=================================================================

      _printHeader(
        'COPY THIS SQL TO SUPABASE SQL EDITOR',
      );

      debugPrint('''
--===============================================================
-- SUPERVISOR DEPARTMENT DEBUG
--===============================================================

SELECT
    sd.id AS supervisor_department_id,
    sd.company_id,
    sd.supervisor_id,
    sd.department_id,

    d.id AS department_table_id,
    d.name AS department_name,
    d.code AS department_code,

    e.id AS employee_id,
    e.employee_code,
    e.full_name,
    e.company_id AS employee_company_id,
    e.department_id AS employee_department_id,

    a.id AS attendance_id,
    a.attendance_date,
    a.attendance_status,
    a.check_in_time,
    a.check_out_time

FROM public.supervisor_departments sd

LEFT JOIN public.departments d
    ON d.id = sd.department_id

LEFT JOIN public.employees e
    ON e.department_id = sd.department_id
    AND e.company_id = sd.company_id
    AND e.is_active = TRUE

LEFT JOIN public.mobile_attendance a
    ON a.employee_id = e.id
    AND a.company_id = e.company_id
    AND a.department_id = e.department_id
    AND a.attendance_date = DATE '2026-08-22'

WHERE
    sd.company_id = '$companyId'
    AND sd.supervisor_id = '$actualSupervisorId'

ORDER BY
    d.name ASC,
    e.full_name ASC;
''');

      //=================================================================
      // FINAL
      //=================================================================

      _printHeader(
        'SUPERVISOR DEPARTMENT DEBUG COMPLETE',
      );

      _printValue(
        'Input supervisorId',
        supervisorId,
      );

      _printValue(
        'Input companyId',
        companyId,
      );

      _printValue(
        'Actual supervisor DB ID',
        actualSupervisorId,
      );

      _printValue(
        'Assigned departments',
        result.length,
      );

      _printValue(
        'Assigned employees',
        assignedEmployees.length,
      );

      _printFooter();

      return result;
    } on PostgrestException catch (error) {
      //=================================================================
      // POSTGRES ERROR
      //=================================================================

      _printHeader(
        '❌ POSTGRES ERROR — getSupervisorDepartments()',
      );

      _printValue(
        'Message',
        error.message,
      );

      _printValue(
        'Code',
        error.code,
      );

      _printValue(
        'Details',
        error.details,
      );

      _printValue(
        'Hint',
        error.hint,
      );

      _printFooter();

      rethrow;
    } catch (error, stackTrace) {
      //=================================================================
      // UNKNOWN ERROR
      //=================================================================

      _printHeader(
        '❌ UNKNOWN ERROR — getSupervisorDepartments()',
      );

      _printValue(
        'Error',
        error,
      );

      debugPrint('');
      debugPrint('StackTrace:');
      debugPrint(stackTrace.toString());

      _printFooter();

      rethrow;
    }
  }

  //=================================================================
  // GET SINGLE SUPERVISOR DEPARTMENT
  //=================================================================

  @override
  Future<SupervisorDepartmentEntity?> getSupervisorDepartment({
    required String supervisorDepartmentId,
  }) async {
    _printHeader(
      'SUPERVISOR DEPARTMENT — getSupervisorDepartment()',
    );

    _printValue(
      'supervisorDepartmentId',
      supervisorDepartmentId,
    );

    debugPrint('');

    debugPrint('SQL DEBUG:');
    debugPrint('''
SELECT
    sd.id,
    sd.company_id,
    sd.supervisor_id,
    sd.department_id,
    d.id AS department_table_id,
    d.name AS department_name,
    d.code AS department_code
FROM public.supervisor_departments sd
LEFT JOIN public.departments d
    ON d.id = sd.department_id
WHERE sd.id = '$supervisorDepartmentId'
LIMIT 1;
''');

    try {
      final response = await _supabase
          .from('supervisor_departments')
          .select('''
            id,
            company_id,
            supervisor_id,
            department_id,
            departments (
              id,
              name,
              code
            )
          ''')
          .eq(
        'id',
        supervisorDepartmentId,
      )
          .maybeSingle();

      _printHeader(
        'getSupervisorDepartment() RESULT',
      );

      _printValue(
        'Response',
        response,
      );

      if (response == null) {
        debugPrint(
          '⚠️ No supervisor department found.',
        );

        _printFooter();

        return null;
      }

      final result =
      SupervisorDepartmentModel.fromJson(
        Map<String, dynamic>.from(response),
      );

      debugPrint(
        '✅ Supervisor department parsed successfully.',
      );

      _printValue(
        'departmentId',
        result.departmentId,
      );

      _printValue(
        'departmentName',
        result.departmentName,
      );

      _printValue(
        'departmentCode',
        result.departmentCode,
      );

      _printFooter();

      return result;
    } on PostgrestException catch (error) {
      _printHeader(
        '❌ POSTGRES ERROR — getSupervisorDepartment()',
      );

      _printValue(
        'Message',
        error.message,
      );

      _printValue(
        'Code',
        error.code,
      );

      _printValue(
        'Details',
        error.details,
      );

      _printValue(
        'Hint',
        error.hint,
      );

      _printFooter();

      rethrow;
    } catch (error, stackTrace) {
      _printHeader(
        '❌ UNKNOWN ERROR — getSupervisorDepartment()',
      );

      _printValue(
        'Error',
        error,
      );

      debugPrint(
        stackTrace.toString(),
      );

      _printFooter();

      rethrow;
    }
  }

  //=================================================================
  // CHECK DEPARTMENT ASSIGNMENT
  //=================================================================

  @override
  Future<bool> isDepartmentAssignedToSupervisor({
    required String supervisorId,
    required String departmentId,
    required String companyId,
  }) async {
    _printHeader(
      'SUPERVISOR DEPARTMENT — isDepartmentAssignedToSupervisor()',
    );

    _printValue(
      'supervisorId',
      supervisorId,
    );

    _printValue(
      'departmentId',
      departmentId,
    );

    _printValue(
      'companyId',
      companyId,
    );

    debugPrint('');

    debugPrint('SQL DEBUG:');
    debugPrint('''
SELECT
    id,
    company_id,
    supervisor_id,
    department_id
FROM public.supervisor_departments
WHERE company_id = '$companyId'
  AND supervisor_id = '$supervisorId'
  AND department_id = '$departmentId'
LIMIT 1;
''');

    try {
      final response = await _supabase
          .from('supervisor_departments')
          .select('''
            id,
            company_id,
            supervisor_id,
            department_id
          ''')
          .eq(
        'company_id',
        companyId,
      )
          .eq(
        'supervisor_id',
        supervisorId,
      )
          .eq(
        'department_id',
        departmentId,
      )
          .maybeSingle();

      _printHeader(
        'isDepartmentAssignedToSupervisor() RESULT',
      );

      _printValue(
        'Response',
        response,
      );

      final assigned = response != null;

      _printValue(
        'Is Assigned',
        assigned,
      );

      if (assigned) {
        debugPrint(
          '✅ Department is assigned to supervisor.',
        );
      } else {
        debugPrint(
          '❌ Department is NOT assigned to supervisor.',
        );
      }

      _printFooter();

      return assigned;
    } on PostgrestException catch (error) {
      _printHeader(
        '❌ POSTGRES ERROR — isDepartmentAssignedToSupervisor()',
      );

      _printValue(
        'Message',
        error.message,
      );

      _printValue(
        'Code',
        error.code,
      );

      _printValue(
        'Details',
        error.details,
      );

      _printValue(
        'Hint',
        error.hint,
      );

      _printFooter();

      rethrow;
    } catch (error, stackTrace) {
      _printHeader(
        '❌ UNKNOWN ERROR — isDepartmentAssignedToSupervisor()',
      );

      _printValue(
        'Error',
        error,
      );

      debugPrint(
        stackTrace.toString(),
      );

      _printFooter();

      rethrow;
    }
  }
}