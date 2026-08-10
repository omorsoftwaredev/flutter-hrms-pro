/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Notifier
///
/// Version : 5.0.0
///
/// Responsibilities:
/// - Company loading
/// - Department loading
/// - Employee loading
/// - Supervisor CRUD
/// - Supervisor status toggle
/// - Supervisor department assignment
/// - Supervisor department assignment edit
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/helpers/database_error_helper.dart';
import '../../data/datasource/supervisor_remote_datasource.dart';
import 'supervisor_state.dart';

class SupervisorNotifier extends StateNotifier<SupervisorState> {
  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  SupervisorNotifier(Ref ref)
    : _ref = ref,
      _remoteDataSource = SupervisorRemoteDataSource(),
      super(const SupervisorState()) {
    _loadCurrentUser();
  }

  // =============================================================
  // REF
  // =============================================================

  final Ref _ref;

  // =============================================================
  // DATASOURCE
  // =============================================================

  final SupervisorRemoteDataSource _remoteDataSource;

  // =============================================================
  // CURRENT USER
  // =============================================================

  void _loadCurrentUser() {
    final user = _ref.read(currentUserProvider);

    state = state.copyWith(currentUser: user);
  }

  // =============================================================
  // LOAD COMPANIES
  // =============================================================

  Future<void> loadCompanies() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final companies = await _remoteDataSource.getCompanies();

      state = state.copyWith(isLoading: false, companies: companies);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _cleanError(e));
    }
  }

  // =============================================================
  // SELECT COMPANY
  //
  // Company change হলে:
  //
  // 1. Company save
  // 2. Old departments clear
  // 3. Old employees clear
  // 4. Old supervisors clear
  // 5. New departments load
  // 6. New supervisors load
  // =============================================================

  Future<void> selectCompany(String companyId) async {
    // -----------------------------------------------------------
    // CLEAN COMPANY ID
    // -----------------------------------------------------------

    final id = companyId.trim();

    // -----------------------------------------------------------
    // CLEAR OLD DATA
    // -----------------------------------------------------------

    state = state.copyWith(
      selectedCompanyId: id,
      departments: const [],
      employees: const [],
      supervisors: const [],
      clearSelectedSupervisor: true,
      clearError: true,
      clearSuccess: true,
    );

    // -----------------------------------------------------------
    // INVALID COMPANY
    // -----------------------------------------------------------

    if (id.isEmpty) {
      return;
    }

    // -----------------------------------------------------------
    // LOAD DEPARTMENTS
    // -----------------------------------------------------------

    await loadDepartments(id);

    // -----------------------------------------------------------
    // LOAD SUPERVISORS
    // -----------------------------------------------------------

    await loadSupervisors(id);
  }

  // =============================================================
  // LOAD DEPARTMENTS
  // =============================================================

  Future<void> loadDepartments(String companyId) async {
    final id = companyId.trim();

    if (id.isEmpty) {
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        departments: const [],
        employees: const [],
        clearError: true,
      );

      final departments = await _remoteDataSource.getDepartments(id);

      state = state.copyWith(isLoading: false, departments: departments);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _cleanError(e));
    }
  }

  // =============================================================
  // SELECT DEPARTMENT
  // =============================================================

  Future<void> selectDepartment({
    required String companyId,
    required String? departmentId,
  }) async {
    // -----------------------------------------------------------
    // CLEAR OLD EMPLOYEES
    // -----------------------------------------------------------

    state = state.copyWith(employees: const [], clearError: true);

    // -----------------------------------------------------------
    // NO DEPARTMENT
    // -----------------------------------------------------------

    if (departmentId == null || departmentId.trim().isEmpty) {
      return;
    }

    // -----------------------------------------------------------
    // LOAD EMPLOYEES
    // -----------------------------------------------------------

    await loadEmployees(companyId: companyId, departmentId: departmentId);
  }

  // =============================================================
  // LOAD EMPLOYEES
  // =============================================================

  Future<void> loadEmployees({
    required String companyId,
    required String departmentId,
  }) async {
    final company = companyId.trim();
    final department = departmentId.trim();

    if (company.isEmpty || department.isEmpty) {
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        employees: const [],
        clearError: true,
      );

      final employees = await _remoteDataSource.getEmployees(
        companyId: company,
        departmentId: department,
      );

      state = state.copyWith(isLoading: false, employees: employees);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _cleanError(e));
    }
  }

  // =============================================================
  // LOAD SUPERVISORS
  // =============================================================

  Future<void> loadSupervisors(String companyId) async {
    final id = companyId.trim();

    if (id.isEmpty) {
      return;
    }

    try {
      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('LOAD SUPERVISORS');
      debugPrint('COMPANY ID = $id');
      debugPrint('=====================================================');

      final supervisors = await _remoteDataSource.getSupervisors(id);

      debugPrint('SUPERVISORS FOUND = ${supervisors.length}');

      state = state.copyWith(supervisors: supervisors, isLoading: false);

      debugPrint('=====================================================');
    } catch (e) {
      debugPrint('LOAD SUPERVISORS ERROR = $e');

      state = state.copyWith(isLoading: false, errorMessage: _cleanError(e));
    }
  }

  // =============================================================
  // CLEAR SUPERVISORS
  // =============================================================

  void clearSupervisors() {
    state = state.copyWith(
      supervisors: const [],
      clearSelectedSupervisor: true,
    );
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  Future<bool> createSupervisor(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // DATA
      // ---------------------------------------------------------

      final companyId = data['company_id']?.toString().trim();

      final departmentId = data['department_id']?.toString().trim();

      final employeeId = data['employee_id']?.toString().trim();

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      if (companyId == null || companyId.isEmpty) {
        throw Exception('Company is required.');
      }

      if (departmentId == null || departmentId.isEmpty) {
        throw Exception('Department is required.');
      }

      if (employeeId == null || employeeId.isEmpty) {
        throw Exception('Employee is required.');
      }

      // ---------------------------------------------------------
      // DATABASE INSERT
      // ---------------------------------------------------------

      final supervisor = await _remoteDataSource.createSupervisor(
        companyId: companyId,
        departmentId: departmentId,
        employeeId: employeeId,
      );

      // ---------------------------------------------------------
      // UPDATE LOCAL LIST
      // ---------------------------------------------------------

      final updatedList = [supervisor, ...state.supervisors];

      state = state.copyWith(
        isSaving: false,
        supervisors: updatedList,
        selectedCompanyId: companyId,
        successMessage: 'Supervisor created successfully.',
      );

      return true;
    } on PostgrestException catch (e) {
      debugPrint('CREATE SUPERVISOR DB ERROR = $e');

      if (e.code == '23505') {
        setError('This employee is already assigned as a supervisor.');

        return false;
      }

      setError(DatabaseErrorHelper.getMessage(e));

      return false;
    } catch (e) {
      setError(_cleanError(e));

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  // =============================================================
  // UPDATE SUPERVISOR
  // =============================================================

  Future<bool> updateSupervisor(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // DATA
      // ---------------------------------------------------------

      final supervisorId = data['id']?.toString().trim();

      final companyId = data['company_id']?.toString().trim();

      final departmentId = data['department_id']?.toString().trim();

      final employeeId = data['employee_id']?.toString().trim();

      final isActive = data['is_active'] == true;

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      if (supervisorId == null ||
          supervisorId.isEmpty ||
          companyId == null ||
          companyId.isEmpty ||
          departmentId == null ||
          departmentId.isEmpty ||
          employeeId == null ||
          employeeId.isEmpty) {
        throw Exception('Invalid supervisor data.');
      }

      // ---------------------------------------------------------
      // DATABASE UPDATE
      // ---------------------------------------------------------

      final updated = await _remoteDataSource.updateSupervisor(
        supervisorId: supervisorId,
        companyId: companyId,
        departmentId: departmentId,
        employeeId: employeeId,
        isActive: isActive,
      );

      // ---------------------------------------------------------
      // UPDATE LOCAL LIST
      // ---------------------------------------------------------

      final list = state.supervisors.map((item) {
        if (item['id']?.toString() == supervisorId) {
          return updated;
        }

        return item;
      }).toList();

      state = state.copyWith(
        isSaving: false,
        supervisors: list,
        successMessage: 'Supervisor updated successfully.',
      );

      return true;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        setError('This employee is already assigned as a supervisor.');

        return false;
      }

      setError(DatabaseErrorHelper.getMessage(e));

      return false;
    } catch (e) {
      setError(_cleanError(e));

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  // =============================================================
  // TOGGLE SUPERVISOR STATUS
  // =============================================================

  Future<bool> toggleSupervisor(Map<String, dynamic> supervisor) async {
    final supervisorId = supervisor['id']?.toString();

    final companyId = supervisor['company_id']?.toString();

    final departmentId = supervisor['department_id']?.toString();

    final employeeId = supervisor['employee_id']?.toString();

    final currentStatus = supervisor['is_active'] == true;

    // -----------------------------------------------------------
    // VALIDATION
    // -----------------------------------------------------------

    if (supervisorId == null ||
        supervisorId.isEmpty ||
        companyId == null ||
        companyId.isEmpty ||
        departmentId == null ||
        departmentId.isEmpty ||
        employeeId == null ||
        employeeId.isEmpty) {
      setError('Invalid supervisor data.');

      return false;
    }

    // -----------------------------------------------------------
    // UPDATE
    // -----------------------------------------------------------

    return updateSupervisor({
      'id': supervisorId,
      'company_id': companyId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'is_active': !currentStatus,
    });
  }

  // =============================================================
  // DELETE SUPERVISOR
  // =============================================================

  Future<bool> deleteSupervisor(String supervisorId) async {
    final id = supervisorId.trim();

    if (id.isEmpty) {
      setError('Invalid supervisor ID.');

      return false;
    }

    try {
      state = state.copyWith(
        isDeleting: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // DATABASE DELETE
      // ---------------------------------------------------------

      await _remoteDataSource.deleteSupervisor(id);

      // ---------------------------------------------------------
      // REMOVE LOCAL ITEM
      // ---------------------------------------------------------

      final list = state.supervisors.where((item) {
        return item['id']?.toString() != id;
      }).toList();

      state = state.copyWith(
        isDeleting: false,
        supervisors: list,
        successMessage: 'Supervisor deleted successfully.',
      );

      return true;
    } on PostgrestException catch (e) {
      setError(DatabaseErrorHelper.getMessage(e));

      return false;
    } catch (e) {
      setError(_cleanError(e));

      return false;
    } finally {
      state = state.copyWith(isDeleting: false);
    }
  }

  // =============================================================
  // ASSIGN SUPERVISOR DEPARTMENTS
  //
  // নতুন assignment:
  //
  // Supervisor = A
  // Departments = [IT, HR, Accounts]
  //
  // Database:
  // INSERT IT
  // INSERT HR
  // INSERT Accounts
  // =============================================================

  Future<bool> assignSupervisorDepartments({
    required String companyId,
    required String supervisorId,
    required List departmentIds,
  }) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      if (company.isEmpty) {
        throw Exception('Company is required.');
      }

      if (supervisor.isEmpty) {
        throw Exception('Supervisor is required.');
      }

      if (departmentIds.isEmpty) {
        throw Exception('Please select at least one department.');
      }

      // ---------------------------------------------------------
      // CLEAN + UNIQUE IDS
      // ---------------------------------------------------------

      final uniqueDepartmentIds = departmentIds
          .map((id) => id.toString().trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      if (uniqueDepartmentIds.isEmpty) {
        throw Exception('Please select at least one valid department.');
      }

      // ---------------------------------------------------------
      // DATABASE INSERT
      // ---------------------------------------------------------

      final insertedCount = await _remoteDataSource.assignSupervisorDepartments(
        companyId: company,
        supervisorId: supervisor,
        departmentIds: uniqueDepartmentIds,
      );

      // ---------------------------------------------------------
      // NOTHING NEW
      // ---------------------------------------------------------

      if (insertedCount == 0) {
        state = state.copyWith(
          isSaving: false,
          successMessage: 'Selected departments are already assigned.',
        );

        return true;
      }

      // ---------------------------------------------------------
      // SUCCESS
      // ---------------------------------------------------------

      state = state.copyWith(
        isSaving: false,
        successMessage: '$insertedCount department(s) assigned successfully.',
      );

      return true;
    } on PostgrestException catch (e) {
      debugPrint('ASSIGN SUPERVISOR DEPARTMENT DB ERROR = $e');

      setError(DatabaseErrorHelper.getMessage(e));

      return false;
    } catch (e) {
      setError(_cleanError(e));

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  // =============================================================
  // LOAD SUPERVISOR DEPARTMENT ASSIGNMENTS
  //
  // কাজ:
  //
  // Company select
  //      ↓
  // Supervisor select
  //      ↓
  // এই method database থেকে বের করবে:
  //
  // IT
  // HR
  // Accounts
  //
  // অর্থাৎ selected supervisor-এর বর্তমানে
  // কোন department assigned আছে।
  // =============================================================

  Future<List<Map<String, dynamic>>> loadSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
  }) async {
    try {
      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      if (company.isEmpty) {
        throw Exception('Company is required.');
      }

      if (supervisor.isEmpty) {
        throw Exception('Supervisor is required.');
      }

      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('LOAD SUPERVISOR DEPARTMENT ASSIGNMENTS');
      debugPrint('COMPANY ID = $company');
      debugPrint('SUPERVISOR ID = $supervisor');
      debugPrint('=====================================================');

      // ---------------------------------------------------------
      // DATABASE LOAD
      // ---------------------------------------------------------

      final assignments = await _remoteDataSource
          .getSupervisorDepartmentAssignments(
            companyId: company,
            supervisorId: supervisor,
          );

      debugPrint('ASSIGNMENTS FOUND = ${assignments.length}');

      for (final item in assignments) {
        debugPrint('ASSIGNMENT = $item');
      }

      debugPrint('=====================================================');

      return assignments;
    } on PostgrestException catch (e) {
      debugPrint('LOAD ASSIGNMENTS DB ERROR = $e');

      setError(DatabaseErrorHelper.getMessage(e));

      return [];
    } catch (e) {
      debugPrint('LOAD ASSIGNMENTS ERROR = $e');

      setError(_cleanError(e));

      return [];
    }
  }

  // =============================================================
  // UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS
  //
  // IMPORTANT:
  //
  // এই method পুরো assignment list-কে final state হিসেবে ধরে।
  //
  // Example:
  //
  // আগে database:
  //
  // IT
  // HR
  // Accounts
  // Finance
  // Admin
  //
  // User এখন select করলো:
  //
  // IT
  // HR
  // Accounts
  //
  // তাহলে:
  //
  // Finance -> DELETE
  // Admin   -> DELETE
  //
  // নতুন কিছু থাকলে:
  //
  // নতুন -> INSERT
  //
  // অর্থাৎ UI-তে final selected list
  // database-এর final state হবে।
  // =============================================================

  Future<bool> updateSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
    required List departmentIds,
  }) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      if (company.isEmpty) {
        throw Exception('Company is required.');
      }

      if (supervisor.isEmpty) {
        throw Exception('Supervisor is required.');
      }

      // ---------------------------------------------------------
      // CLEAN IDS
      //
      // Empty থাকলে বাদ যাবে।
      // Duplicate থাকলে বাদ যাবে।
      //
      // Empty list allowed.
      //
      // কারণ user যদি সব department remove করে,
      // তাহলে database-এ সব assignment DELETE হবে।
      // ---------------------------------------------------------

      final uniqueDepartmentIds = departmentIds
          .map((id) => id.toString().trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS');
      debugPrint('COMPANY ID = $company');
      debugPrint('SUPERVISOR ID = $supervisor');
      debugPrint('FINAL DEPARTMENT IDS = $uniqueDepartmentIds');
      debugPrint('=====================================================');

      // ---------------------------------------------------------
      // DATABASE UPDATE
      // ---------------------------------------------------------

      await _remoteDataSource.updateSupervisorDepartmentAssignments(
        companyId: company,
        supervisorId: supervisor,
        departmentIds: uniqueDepartmentIds,
      );

      // ---------------------------------------------------------
      // SUCCESS
      // ---------------------------------------------------------

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Supervisor departments updated successfully.',
      );

      debugPrint('SUPERVISOR DEPARTMENT ASSIGNMENTS UPDATED SUCCESSFULLY');

      return true;
    } on PostgrestException catch (e) {
      debugPrint('UPDATE ASSIGNMENTS DB ERROR = $e');

      setError(DatabaseErrorHelper.getMessage(e));

      return false;
    } catch (e) {
      debugPrint('UPDATE ASSIGNMENTS ERROR = $e');

      setError(_cleanError(e));

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  // =============================================================
  // LOADING
  // =============================================================

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  // =============================================================
  // SAVING
  // =============================================================

  void setSaving(bool value) {
    state = state.copyWith(isSaving: value);
  }

  // =============================================================
  // ERROR
  // =============================================================

  void setError(String message) {
    state = state.copyWith(errorMessage: message, clearSuccess: true);
  }

  // =============================================================
  // CLEAR ERROR
  // =============================================================

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // =============================================================
  // CLEAR SUCCESS
  // =============================================================

  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }

  // =============================================================
  // CLEAR MESSAGES
  // =============================================================

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  // =============================================================
  // RESET
  // =============================================================

  void reset() {
    final user = _ref.read(currentUserProvider);

    state = SupervisorState(currentUser: user);
  }

  // =============================================================
  // ERROR CLEANER
  // =============================================================

  String _cleanError(Object error) {
    final text = error.toString();

    if (text.startsWith('Exception: ')) {
      return text.substring(11);
    }

    return text;
  }
}
