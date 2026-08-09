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