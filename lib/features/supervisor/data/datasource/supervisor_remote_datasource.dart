/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Remote DataSource
///
/// Version : 6.0.0
///
/// Responsibilities:
/// - Load departments by company
/// - Load employees by company + department
/// - Load supervisors by company
/// - Create supervisor
/// - Update supervisor
/// - Delete supervisor
/// - Supervisor department assignments
///
/// IMPORTANT:
/// - No unnecessary database fields are requested.
/// - Base tables use select() where possible.
/// - Related department/employee data is loaded safely.
/// ===============================================================

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class SupervisorRemoteDataSource {
  // =============================================================
  // CLIENT
  // =============================================================

  final SupabaseClient _client = SupabaseService.client;

  // =============================================================
  // GET DEPARTMENTS
  //
  // শুধু actual department rows load করা হবে।
  //
  // Explicit non-existing fields যেমন:
  // manager_name
  // phone
  // email
  // location
  //
  // request করা হবে না।
  // =============================================================

  Future<List<Map<String, dynamic>>> getDepartments(
      String companyId,
      ) async {
    final id = companyId.trim();

    if (id.isEmpty) {
      throw Exception(
        'Company ID is required.',
      );
    }

    debugPrint(
      '[SupervisorRemoteDataSource] GET DEPARTMENTS',
    );

    debugPrint(
      '[SupervisorRemoteDataSource] COMPANY ID = $id',
    );

    final response = await _client
        .from('departments')
        .select()
        .eq(
      'company_id',
      id,
    )
        .eq(
      'is_active',
      true,
    )
        .order(
      'name',
    );

    final result =
    List<Map<String, dynamic>>.from(
      response,
    );

    debugPrint(
      '[SupervisorRemoteDataSource] DEPARTMENTS FOUND = ${result.length}',
    );

    return result;
  }

  // =============================================================
  // GET EMPLOYEES
  //
  // Department অনুযায়ী active employees load হবে।
  // =============================================================

  Future<List<Map<String, dynamic>>> getEmployees({
    required String companyId,
    required String departmentId,
  }) async {
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

    debugPrint(
      '[SupervisorRemoteDataSource] GET EMPLOYEES',
    );

    debugPrint(
      '[SupervisorRemoteDataSource] COMPANY ID = $company',
    );

    debugPrint(
      '[SupervisorRemoteDataSource] DEPARTMENT ID = $department',
    );

    final response = await _client
        .from('employees')
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
      'is_active',
      true,
    )
        .order(
      'full_name',
    );

    final result =
    List<Map<String, dynamic>>.from(
      response,
    );

    debugPrint(
      '[SupervisorRemoteDataSource] EMPLOYEES FOUND = ${result.length}',
    );

    return result;
  }

  // =============================================================
  // GET SUPERVISORS
  //
  // প্রথমে supervisor base rows।
  // তারপর department + employee information আলাদাভাবে
  // load করে local map-এর মধ্যে attach করা হচ্ছে।
  //
  // এতে Supabase relation syntax-এর উপর dependency কমে যায়।
  // =============================================================

  Future<List<Map<String, dynamic>>> getSupervisors(
      String companyId,
      ) async {
    final id = companyId.trim();

    if (id.isEmpty) {
      throw Exception(
        'Company ID is required.',
      );
    }

    debugPrint('');
    debugPrint(
      '=====================================================',
    );
    debugPrint(
      'SUPERVISOR GET START',
    );
    debugPrint(
      'COMPANY ID = $id',
    );
    debugPrint(
      '=====================================================',
    );

    // -----------------------------------------------------------
    // SUPERVISOR BASE DATA
    // -----------------------------------------------------------

    final response = await _client
        .from('supervisors')
        .select()
        .eq(
      'company_id',
      id,
    )
        .order(
      'created_at',
      ascending: false,
    );

    final supervisors =
    List<Map<String, dynamic>>.from(
      response,
    );

    debugPrint(
      'SUPERVISOR BASE COUNT = ${supervisors.length}',
    );

    if (supervisors.isEmpty) {
      debugPrint(
        'NO SUPERVISORS FOUND',
      );

      return [];
    }

    // -----------------------------------------------------------
    // DEPARTMENT IDS
    // -----------------------------------------------------------

    final departmentIds = supervisors
        .map(
          (item) =>
          item['department_id']?.toString(),
    )
        .where(
          (id) =>
      id != null &&
          id.trim().isNotEmpty,
    )
        .map(
          (id) => id!.trim(),
    )
        .toSet()
        .toList();

    // -----------------------------------------------------------
    // EMPLOYEE IDS
    // -----------------------------------------------------------

    final employeeIds = supervisors
        .map(
          (item) =>
          item['employee_id']?.toString(),
    )
        .where(
          (id) =>
      id != null &&
          id.trim().isNotEmpty,
    )
        .map(
          (id) => id!.trim(),
    )
        .toSet()
        .toList();

    // -----------------------------------------------------------
    // LOAD DEPARTMENTS
    // -----------------------------------------------------------

    final Map<String, Map<String, dynamic>>
    departmentMap = {};

    if (departmentIds.isNotEmpty) {
      final departmentResponse =
      await _client
          .from('departments')
          .select()
          .eq(
        'company_id',
        id,
      )
          .inFilter(
        'id',
        departmentIds,
      );

      for (final item
      in List<Map<String, dynamic>>.from(
        departmentResponse,
      )) {
        final departmentId =
        item['id']?.toString();

        if (departmentId != null &&
            departmentId.isNotEmpty) {
          departmentMap[departmentId] =
              item;
        }
      }
    }

    // -----------------------------------------------------------
    // LOAD EMPLOYEES
    // -----------------------------------------------------------

    final Map<String, Map<String, dynamic>>
    employeeMap = {};

    if (employeeIds.isNotEmpty) {
      final employeeResponse =
      await _client
          .from('employees')
          .select()
          .eq(
        'company_id',
        id,
      )
          .inFilter(
        'id',
        employeeIds,
      );

      for (final item
      in List<Map<String, dynamic>>.from(
        employeeResponse,
      )) {
        final employeeId =
        item['id']?.toString();

        if (employeeId != null &&
            employeeId.isNotEmpty) {
          employeeMap[employeeId] =
              item;
        }
      }
    }

    // -----------------------------------------------------------
    // ATTACH RELATED DATA
    // -----------------------------------------------------------

    final result =
    supervisors.map(
          (supervisor) {
        final map =
        Map<String, dynamic>.from(
          supervisor,
        );

        final departmentId =
        supervisor['department_id']
            ?.toString();

        final employeeId =
        supervisor['employee_id']
            ?.toString();

        map['departments'] =
        departmentId == null
            ? null
            : departmentMap[
        departmentId
        ];

        map['employees'] =
        employeeId == null
        ? null
            : employeeMap[
        employeeId
        ];

        return map;
      },
    ).toList();

    debugPrint(
      'SUPERVISOR FINAL COUNT = ${result.length}',
    );

    debugPrint(
      'SUPERVISOR GET SUCCESS',
    );

    return result;
  }

  // =============================================================
  // GET SUPERVISOR BY ID
  // =============================================================

  Future<Map<String, dynamic>> getSupervisorById(
      String supervisorId,
      ) async {
    final id = supervisorId.trim();

    if (id.isEmpty) {
      throw Exception(
        'Supervisor ID is required.',
      );
    }

    final response = await _client
        .from('supervisors')
        .select()
        .eq(
      'id',
      id,
    )
        .maybeSingle();

    if (response == null) {
      throw Exception(
        'Supervisor not found.',
      );
    }

    final supervisor =
    Map<String, dynamic>.from(
      response,
    );

    final companyId =
    supervisor['company_id']?.toString();

    final departmentId =
    supervisor['department_id']?.toString();

    final employeeId =
    supervisor['employee_id']?.toString();

    if (companyId != null &&
        departmentId != null) {
      final departmentResponse =
      await _client
          .from('departments')
          .select()
          .eq(
        'id',
        departmentId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .maybeSingle();

      supervisor['departments'] =
          departmentResponse;
    }

    if (companyId != null &&
        employeeId != null) {
      final employeeResponse =
      await _client
          .from('employees')
          .select()
          .eq(
        'id',
        employeeId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .maybeSingle();

      supervisor['employees'] =
          employeeResponse;
    }

    return supervisor;
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  Future<Map<String, dynamic>> createSupervisor({
    required String companyId,
    required String departmentId,
    required String employeeId,
  }) async {
    final company = companyId.trim();
    final department = departmentId.trim();
    final employee = employeeId.trim();

    if (company.isEmpty) {
      throw Exception(
        'Company is required.',
      );
    }

    if (department.isEmpty) {
      throw Exception(
        'Department is required.',
      );
    }

    if (employee.isEmpty) {
      throw Exception(
        'Employee is required.',
      );
    }

    final insertData = {
      'company_id': company,
      'department_id': department,
      'employee_id': employee,
      'is_active': true,
    };

    debugPrint(
      'CREATE SUPERVISOR DATA = $insertData',
    );

    final response = await _client
        .from('supervisors')
        .insert(
      insertData,
    )
        .select()
        .single();

    return _buildSupervisorWithRelations(
      Map<String, dynamic>.from(
        response,
      ),
    );
  }

  // =============================================================
  // UPDATE SUPERVISOR
  // =============================================================

  Future<Map<String, dynamic>> updateSupervisor({
    required String supervisorId,
    required String companyId,
    required String departmentId,
    required String employeeId,
    required bool isActive,
  }) async {
    final id = supervisorId.trim();
    final company = companyId.trim();
    final department = departmentId.trim();
    final employee = employeeId.trim();

    if (id.isEmpty) {
      throw Exception(
        'Supervisor ID is required.',
      );
    }

    if (company.isEmpty ||
        department.isEmpty ||
        employee.isEmpty) {
      throw Exception(
        'Invalid supervisor data.',
      );
    }

    final updateData = {
      'company_id': company,
      'department_id': department,
      'employee_id': employee,
      'is_active': isActive,
    };

    debugPrint(
      'UPDATE SUPERVISOR ID = $id',
    );

    debugPrint(
      'UPDATE SUPERVISOR DATA = $updateData',
    );

    final response = await _client
        .from('supervisors')
        .update(
      updateData,
    )
        .eq(
      'id',
      id,
    )
        .select()
        .single();

    return _buildSupervisorWithRelations(
      Map<String, dynamic>.from(
        response,
      ),
    );
  }

  // =============================================================
  // DELETE SUPERVISOR
  // =============================================================

  Future<void> deleteSupervisor(
      String supervisorId,
      ) async {
    final id = supervisorId.trim();

    if (id.isEmpty) {
      throw Exception(
        'Supervisor ID is required.',
      );
    }

    await _client
        .from('supervisors')
        .delete()
        .eq(
      'id',
      id,
    );
  }

  // =============================================================
  // BUILD SUPERVISOR WITH RELATIONS
  // =============================================================

  Future<Map<String, dynamic>>
  _buildSupervisorWithRelations(
      Map<String, dynamic> supervisor,
      ) async {
    final companyId =
    supervisor['company_id']?.toString();

    final departmentId =
    supervisor['department_id']?.toString();

    final employeeId =
    supervisor['employee_id']?.toString();

    if (companyId != null &&
        departmentId != null) {
      supervisor['departments'] =
      await _client
          .from('departments')
          .select()
          .eq(
        'id',
        departmentId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .maybeSingle();
    }

    if (companyId != null &&
        employeeId != null) {
      supervisor['employees'] =
      await _client
          .from('employees')
          .select()
          .eq(
        'id',
        employeeId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .maybeSingle();
    }

    return supervisor;
  }

  // =============================================================
  // GET SUPERVISOR DEPARTMENT ASSIGNMENTS
  // =============================================================

  Future<List<Map<String, dynamic>>>
  getSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty) {
      throw Exception(
        'Company is required.',
      );
    }

    if (supervisor.isEmpty) {
      throw Exception(
        'Supervisor is required.',
      );
    }

    final response = await _client
        .from('supervisor_departments')
        .select()
        .eq(
      'company_id',
      company,
    )
        .eq(
      'supervisor_id',
      supervisor,
    )
        .order(
      'created_at',
      ascending: true,
    );

    final assignments =
    List<Map<String, dynamic>>.from(
      response,
    );

    // -----------------------------------------------------------
    // LOAD DEPARTMENT DETAILS
    // -----------------------------------------------------------

    for (final assignment in assignments) {
      final departmentId =
      assignment['department_id']
          ?.toString();

      if (departmentId == null ||
          departmentId.isEmpty) {
        continue;
      }

      final department =
      await _client
          .from('departments')
          .select()
          .eq(
        'id',
        departmentId,
      )
          .maybeSingle();

      assignment['departments'] =
          department;
    }

    return assignments;
  }

  // =============================================================
  // ASSIGN SUPERVISOR DEPARTMENTS
  // =============================================================

  Future<int> assignSupervisorDepartments({
    required String companyId,
    required String supervisorId,
    required List<String> departmentIds,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty) {
      throw Exception(
        'Company is required.',
      );
    }

    if (supervisor.isEmpty) {
      throw Exception(
        'Supervisor is required.',
      );
    }

    final uniqueDepartmentIds =
    departmentIds
        .map(
          (id) => id.trim(),
    )
        .where(
          (id) => id.isNotEmpty,
    )
        .toSet()
        .toList();

    if (uniqueDepartmentIds.isEmpty) {
      throw Exception(
        'Please select at least one department.',
      );
    }

    final existingRows =
    await _client
        .from('supervisor_departments')
        .select(
      'department_id',
    )
        .eq(
      'company_id',
      company,
    )
        .eq(
      'supervisor_id',
      supervisor,
    )
        .inFilter(
      'department_id',
      uniqueDepartmentIds,
    );

    final existingIds =
    List<Map<String, dynamic>>.from(
      existingRows,
    )
        .map(
          (row) =>
          row['department_id']
              ?.toString(),
    )
        .whereType<String>()
        .toSet();

    final newIds =
    uniqueDepartmentIds
        .where(
          (id) =>
      !existingIds.contains(id),
    )
        .toList();

    if (newIds.isEmpty) {
      return 0;
    }

    final rows =
    newIds
        .map(
          (departmentId) => {
        'company_id': company,
        'supervisor_id': supervisor,
        'department_id': departmentId,
      },
    )
        .toList();

    await _client
        .from('supervisor_departments')
        .insert(
      rows,
    );

    return newIds.length;
  }

  // =============================================================
  // UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS
  // =============================================================

  Future<void>
  updateSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
    required List<String> departmentIds,
  }) async {
    final company = companyId.trim();
    final supervisor = supervisorId.trim();

    if (company.isEmpty) {
      throw Exception(
        'Company is required.',
      );
    }

    if (supervisor.isEmpty) {
      throw Exception(
        'Supervisor is required.',
      );
    }

    final selectedIds =
    departmentIds
        .map(
          (id) => id.trim(),
    )
        .where(
          (id) => id.isNotEmpty,
    )
        .toSet();

    final currentResponse =
    await _client
        .from('supervisor_departments')
        .select(
      'id, department_id',
    )
        .eq(
      'company_id',
      company,
    )
        .eq(
      'supervisor_id',
      supervisor,
    );

    final currentRows =
    List<Map<String, dynamic>>.from(
      currentResponse,
    );

    final currentIds =
    currentRows
        .map(
          (row) =>
          row['department_id']
              ?.toString(),
    )
        .whereType<String>()
        .toSet();

    // -----------------------------------------------------------
    // DELETE REMOVED DEPARTMENTS
    // -----------------------------------------------------------

    final deleteIds =
    currentIds.difference(
      selectedIds,
    );

    for (final departmentId
    in deleteIds) {
      await _client
          .from('supervisor_departments')
          .delete()
          .eq(
        'company_id',
        company,
      )
          .eq(
        'supervisor_id',
        supervisor,
      )
          .eq(
        'department_id',
        departmentId,
      );
    }

    // -----------------------------------------------------------
    // INSERT NEW DEPARTMENTS
    // -----------------------------------------------------------

    final insertIds =
    selectedIds.difference(
      currentIds,
    );

    if (insertIds.isEmpty) {
      return;
    }

    final rows =
    insertIds
        .map(
          (departmentId) => {
        'company_id': company,
        'supervisor_id': supervisor,
        'department_id': departmentId,
      },
    )
        .toList();

    await _client
        .from('supervisor_departments')
        .insert(
      rows,
    );
  }
}