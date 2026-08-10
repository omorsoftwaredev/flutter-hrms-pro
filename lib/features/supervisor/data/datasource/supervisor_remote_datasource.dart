/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Remote DataSource
///
/// Version : 4.1.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class SupervisorRemoteDataSource {
  // =============================================================
  // CLIENT
  // =============================================================

  final _client = SupabaseService.client;

  // =============================================================
  // COMPANIES
  // =============================================================

  Future<List<Map<String, dynamic>>> getCompanies() async {
    final response = await _client
        .from('companies')
        .select('*')
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }

  // =============================================================
  // DEPARTMENTS BY COMPANY
  // =============================================================

  Future<List<Map<String, dynamic>>> getDepartments(
      String companyId,
      ) async {
    final response = await _client
        .from('departments')
        .select('''
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
        ''')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }

  // =============================================================
  // EMPLOYEES BY COMPANY + DEPARTMENT
  // =============================================================

  Future<List<Map<String, dynamic>>> getEmployees({
    required String companyId,
    required String departmentId,
  }) async {
    final response = await _client
        .from('employees')
        .select('''
          id,
          company_id,
          department_id,
          employee_code,
          first_name,
          last_name,
          full_name,
          email,
          mobile,
          employee_status,
          is_active
        ''')
        .eq('company_id', companyId)
        .eq('department_id', departmentId)
        .eq('is_active', true)
        .order('full_name');

    return List<Map<String, dynamic>>.from(response);
  }

  // =============================================================
  // GET SUPERVISOR BY ID
  // =============================================================

  Future<Map<String, dynamic>> getSupervisorById(
      String supervisorId,
      ) async {
    final response = await _client
        .from('supervisors')
        .select('''
          id,
          company_id,
          department_id,
          employee_id,
          is_active,
          created_at,
          updated_at,

          departments:department_id (
            id,
            company_id,
            code,
            name
          ),

          employees:employee_id (
            id,
            company_id,
            department_id,
            employee_code,
            first_name,
            last_name,
            full_name,
            email,
            mobile
          )
        ''')
        .eq('id', supervisorId)
        .maybeSingle();

    if (response == null) {
      throw Exception(
        'Supervisor not found.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  // =============================================================
// GET SUPERVISOR DEPARTMENT ASSIGNMENTS
// =============================================================

  Future<List<Map<String, dynamic>>>
  getSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
  }) async {
    final response = await Supabase.instance.client
        .from('supervisor_departments')
        .select('''
        id,
        company_id,
        supervisor_id,
        department_id,
        created_at,
        departments (
          id,
          name
        )
      ''')
        .eq(
      'company_id',
      companyId,
    )
        .eq(
      'supervisor_id',
      supervisorId,
    )
        .order(
      'created_at',
      ascending: true,
    );

    return List<Map<String, dynamic>>.from(
      response,
    );
  }
  // =============================================================
// UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS
//
// Final selected departments-এর সাথে database synchronize করবে.
//
// Existing:
// A B C D E
//
// New:
// A B C
//
// Result:
// D এবং E delete হবে.
//
// New department থাকলে সেটাও insert হবে.
// =============================================================

  Future<void> updateSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
    required List<String> departmentIds,
  }) async {
    final client =
        Supabase.instance.client;

    // ===========================================================
    // CURRENT ASSIGNMENTS
    // ===========================================================

    final currentResponse = await client
        .from('supervisor_departments')
        .select('''
        id,
        department_id
      ''')
        .eq(
      'company_id',
      companyId,
    )
        .eq(
      'supervisor_id',
      supervisorId,
    );

    final currentAssignments =
    List<Map<String, dynamic>>.from(
      currentResponse,
    );

    final currentDepartmentIds =
    currentAssignments
        .map(
          (item) =>
          item['department_id']?.toString(),
    )
        .whereType<String>()
        .toSet();

    final selectedDepartmentIds =
    departmentIds.toSet();

    // ===========================================================
    // DELETE
    //
    // Database-এ আছে কিন্তু নতুন selection-এ নেই
    // ===========================================================

    final departmentIdsToDelete =
    currentDepartmentIds
        .difference(
      selectedDepartmentIds,
    )
        .toList();

    for (final departmentId
    in departmentIdsToDelete) {
      await client
          .from('supervisor_departments')
          .delete()
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
      );
    }

    // ===========================================================
    // INSERT
    //
    // Selection-এ আছে কিন্তু database-এ নেই
    // ===========================================================

    final departmentIdsToInsert =
    selectedDepartmentIds
        .difference(
      currentDepartmentIds,
    )
        .toList();

    if (departmentIdsToInsert.isEmpty) {
      return;
    }

    final insertData =
    departmentIdsToInsert
        .map(
          (departmentId) {
        return {
          'company_id': companyId,
          'supervisor_id': supervisorId,
          'department_id':
          departmentId,
        };
      },
    )
        .toList();

    await client
        .from('supervisor_departments')
        .insert(
      insertData,
    );
  }
  // ===============================================================
// ASSIGN SUPERVISOR DEPARTMENTS
// ===============================================================

  Future<int> assignSupervisorDepartments({
    required String companyId,
    required String supervisorId,
    required List<String> departmentIds,
  }) async {
    if (companyId.trim().isEmpty) {
      throw Exception(
        'Company is required.',
      );
    }

    if (supervisorId.trim().isEmpty) {
      throw Exception(
        'Supervisor is required.',
      );
    }

    if (departmentIds.isEmpty) {
      throw Exception(
        'At least one department is required.',
      );
    }

    // =============================================================
    // REMOVE DUPLICATE DEPARTMENT IDS
    // =============================================================

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
        'At least one valid department is required.',
      );
    }

    // =============================================================
    // CHECK EXISTING ASSIGNMENTS
    //
    // Same supervisor + same department
    // must not be inserted twice.
    // =============================================================

    final existingRows = await _client
        .from('supervisor_departments')
        .select('department_id')
        .eq(
      'company_id',
      companyId,
    )
        .eq(
      'supervisor_id',
      supervisorId,
    )
        .inFilter(
      'department_id',
      uniqueDepartmentIds,
    );

    final existingDepartmentIds =
    (existingRows as List)
        .map(
          (row) =>
          row['department_id']
              ?.toString(),
    )
        .whereType<String>()
        .toSet();

    // =============================================================
    // ONLY NEW ASSIGNMENTS
    // =============================================================

    final newDepartmentIds =
    uniqueDepartmentIds
        .where(
          (departmentId) =>
      !existingDepartmentIds
          .contains(departmentId),
    )
        .toList();

    // =============================================================
    // EVERYTHING ALREADY ASSIGNED
    // =============================================================

    if (newDepartmentIds.isEmpty) {
      return 0;
    }

    // =============================================================
    // BUILD INSERT DATA
    // =============================================================

    final rows =
    newDepartmentIds
        .map(
          (departmentId) => {
        'company_id': companyId,
        'supervisor_id': supervisorId,
        'department_id': departmentId,
      },
    )
        .toList();

    // =============================================================
    // INSERT
    //
    // id + created_at are generated by database.
    // =============================================================

    await _client
        .from('supervisor_departments')
        .insert(rows);

    return newDepartmentIds.length;
  }

  // =============================================================
  // GET SUPERVISORS BY COMPANY
  // =============================================================

  // =============================================================
// GET SUPERVISORS BY COMPANY
// =============================================================

  Future<List<Map<String, dynamic>>> getSupervisors(
      String companyId,
      ) async {
    print('');
    print(
      '=====================================================',
    );
    print(
      'SUPABASE GET SUPERVISORS',
    );
    print(
      'COMPANY ID = $companyId',
    );
    print(
      '=====================================================',
    );

    try {
      final response = await _client
          .from('supervisors')
          .select('''
          id,
          company_id,
          department_id,
          employee_id,
          is_active,
          created_at,
          updated_at,

          companies:company_id (
            id,
            name
          ),

          departments:department_id (
            id,
            company_id,
            name,
            code
          ),

          employees:employee_id (
            id,
            company_id,
            department_id,
            employee_code,
            full_name,
            first_name,
            last_name,
            email,
            mobile
          )
        ''')
          .eq(
        'company_id',
        companyId,
      )
          .order(
        'created_at',
        ascending: false,
      );

      print('');
      print(
        '=====================================================',
      );
      print(
        'SUPABASE GET SUPERVISORS SUCCESS',
      );
      print(
        'SUPERVISOR COUNT = ${response.length}',
      );
      print(
        'SUPERVISOR DATA = $response',
      );
      print(
        '=====================================================',
      );

      return List<Map<String, dynamic>>.from(
        response,
      );
    } on PostgrestException catch (e) {
      print('');
      print(
        '=====================================================',
      );
      print(
        'SUPABASE GET SUPERVISORS ERROR',
      );
      print(
        'CODE = ${e.code}',
      );
      print(
        'MESSAGE = ${e.message}',
      );
      print(
        'DETAIL = ${e.details}',
      );
      print(
        'HINT = ${e.hint}',
      );
      print(
        '=====================================================',
      );

      rethrow;
    } catch (e) {
      print('');
      print(
        '=====================================================',
      );
      print(
        'GET SUPERVISORS UNKNOWN ERROR',
      );
      print(
        'ERROR = $e',
      );
      print(
        '=====================================================',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  Future<Map<String, dynamic>> createSupervisor({
    required String companyId,
    required String departmentId,
    required String employeeId,
  }) async {
    // ===========================================================
    // DEBUG
    // ===========================================================

    final insertData = <String, dynamic>{
      'company_id': companyId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'is_active': true,
    };

    print('');
    print(
      '=====================================================',
    );

    print(
      'SUPABASE SUPERVISOR INSERT START',
    );

    print(
      'SUPABASE SUPERVISOR INSERT DATA = $insertData',
    );

    print(
      '=====================================================',
    );

    // ===========================================================
    // INSERT
    // ===========================================================

    try {
      final response = await _client
          .from('supervisors')
          .insert(insertData)
          .select('''
            id,
            company_id,
            department_id,
            employee_id,
            is_active,
            created_at,
            updated_at,

            departments:department_id (
              id,
              name,
              code
            ),

            employees:employee_id (
              id,
              employee_code,
              full_name,
              first_name,
              last_name,
              email,
              mobile
            )
          ''')
          .single();

      // =========================================================
      // SUCCESS
      // =========================================================

      print('');
      print(
        '=====================================================',
      );

      print(
        'SUPABASE SUPERVISOR INSERT SUCCESS',
      );

      print(
        'SUPERVISOR RESPONSE = $response',
      );

      print(
        '=====================================================',
      );

      return Map<String, dynamic>.from(
        response,
      );
    } on PostgrestException catch (e) {
      print('SUPABASE SUPERVISOR INSERT ERROR = $e');
      rethrow;
    }
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
    final updateData = <String, dynamic>{
      'company_id': companyId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'is_active': isActive,
      'updated_at':
      DateTime.now()
          .toUtc()
          .toIso8601String(),
    };

    print('');
    print(
      '=====================================================',
    );

    print(
      'SUPABASE SUPERVISOR UPDATE',
    );

    print(
      'SUPERVISOR ID = $supervisorId',
    );

    print(
      'UPDATE DATA = $updateData',
    );

    print(
      '=====================================================',
    );

    try {
      final response = await _client
          .from('supervisors')
          .update(updateData)
          .eq('id', supervisorId)
          .select('''
            id,
            company_id,
            department_id,
            employee_id,
            is_active,
            created_at,
            updated_at,

            departments:department_id (
              id,
              name,
              code
            ),

            employees:employee_id (
              id,
              employee_code,
              full_name,
              first_name,
              last_name,
              email,
              mobile
            )
          ''')
          .single();

      return Map<String, dynamic>.from(
        response,
      );
    } catch (e) {
      print(
        'SUPABASE SUPERVISOR UPDATE ERROR = $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE SUPERVISOR
  // =============================================================

  Future<void> deleteSupervisor(
      String supervisorId,
      ) async {
    print('');
    print(
      'SUPABASE SUPERVISOR DELETE',
    );

    print(
      'SUPERVISOR ID = $supervisorId',
    );

    try {
      await _client
          .from('supervisors')
          .delete()
          .eq('id', supervisorId);

      print(
        'SUPABASE SUPERVISOR DELETE SUCCESS',
      );
    } catch (e) {
      print(
        'SUPABASE SUPERVISOR DELETE ERROR = $e',
      );

      rethrow;
    }
  }
}