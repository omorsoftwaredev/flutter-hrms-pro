/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Notifier
///
/// Version : 6.0.0
///
/// Responsibilities:
/// - Current user
/// - Company selection
/// - Department loading
/// - Employee loading
/// - Supervisor loading
/// - Supervisor CRUD
/// - Supervisor status toggle
/// - Supervisor department assignment
/// - Supervisor department assignment update
/// - Error / success handling
/// ===============================================================

import 'package:flutter/foundation.dart';
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
  // =============================================================
  // REF
  // =============================================================

  final Ref _ref;
  SupervisorNotifier(Ref ref)
      : _ref = ref,
        _remoteDataSource = SupervisorRemoteDataSource(),
        super(const SupervisorState()) {
    _loadCurrentUser();
  }



  // =============================================================
  // DATASOURCE
  // =============================================================

  final SupervisorRemoteDataSource _remoteDataSource;

  // =============================================================
  // CURRENT USER
  // =============================================================

  void _loadCurrentUser() {
    final user = _ref.read(currentUserProvider);

    state = state.copyWith(
      currentUser: user,
    );
  }

  // =============================================================
  // SELECT COMPANY
  // =============================================================

  Future<void> selectCompany(String companyId) async {
    final id = companyId.trim();

    // -----------------------------------------------------------
    // RESET COMPANY DEPENDENT DATA
    // -----------------------------------------------------------

    state = state.copyWith(
      selectedCompanyId: id,
      departments: const [],
      employees: const [],
      supervisors: const [],
      assignments: const [],
      clearSelectedSupervisor: true,
      clearError: true,
      clearSuccess: true,
    );

    // -----------------------------------------------------------
    // EMPTY COMPANY
    // -----------------------------------------------------------

    if (id.isEmpty) {
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      _log('SELECT COMPANY: $id');

      // ---------------------------------------------------------
      // LOAD DEPARTMENTS
      // ---------------------------------------------------------

      final departments =
      await _remoteDataSource.getDepartments(id);

      // ---------------------------------------------------------
      // LOAD SUPERVISORS
      // ---------------------------------------------------------

      final supervisors =
      await _remoteDataSource.getSupervisors(id);

      // ---------------------------------------------------------
      // CHECK CURRENT COMPANY
      // ---------------------------------------------------------

      if (state.selectedCompanyId != id) {
        _log('COMPANY CHANGED. IGNORING OLD RESPONSE.');
        return;
      }

      // ---------------------------------------------------------
      // UPDATE STATE
      // ---------------------------------------------------------

      state = state.copyWith(
        isLoading: false,
        departments: departments,
        supervisors: supervisors,
        clearError: true,
      );

      _log(
        'COMPANY LOADED: departments=${departments.length}, '
            'supervisors=${supervisors.length}',
      );
    } on PostgrestException catch (e) {
      _log('SELECT COMPANY DB ERROR: ${e.message}');

      state = state.copyWith(
        isLoading: false,
        errorMessage: DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      _log('SELECT COMPANY ERROR: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
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

      _log('LOAD DEPARTMENTS: $id');

      final departments =
      await _remoteDataSource.getDepartments(id);

      // ---------------------------------------------------------
      // PREVENT OLD RESPONSE
      // ---------------------------------------------------------

      if (state.selectedCompanyId != id) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        departments: departments,
      );

      _log(
        'DEPARTMENTS FOUND: ${departments.length}',
      );
    } on PostgrestException catch (e) {
      _log('LOAD DEPARTMENTS DB ERROR: ${e.message}');

      state = state.copyWith(
        isLoading: false,
        errorMessage: DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      _log('LOAD DEPARTMENTS ERROR: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
  }

  // =============================================================
  // SELECT DEPARTMENT
  // =============================================================

  Future<void> selectDepartment({
    required String companyId,
    required String? departmentId,
  }) async {
    state = state.copyWith(
      employees: const [],
      clearError: true,
    );

    final department = departmentId?.trim();

    if (department == null || department.isEmpty) {
      return;
    }

    await loadEmployees(
      companyId: companyId,
      departmentId: department,
    );
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

      _log(
        'LOAD EMPLOYEES: company=$company, '
            'department=$department',
      );

      final employees =
      await _remoteDataSource.getEmployees(
        companyId: company,
        departmentId: department,
      );

      state = state.copyWith(
        isLoading: false,
        employees: employees,
      );

      _log(
        'EMPLOYEES FOUND: ${employees.length}',
      );
    } on PostgrestException catch (e) {
      _log('LOAD EMPLOYEES DB ERROR: ${e.message}');

      state = state.copyWith(
        isLoading: false,
        errorMessage: DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      _log('LOAD EMPLOYEES ERROR: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
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
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      _log('LOAD SUPERVISORS');
      _log('COMPANY ID: $id');

      final supervisors =
      await _remoteDataSource.getSupervisors(id);

      // ---------------------------------------------------------
      // PREVENT OLD RESPONSE
      // ---------------------------------------------------------

      if (state.selectedCompanyId != id) {
        _log('COMPANY CHANGED. IGNORING SUPERVISOR RESPONSE.');
        return;
      }

      state = state.copyWith(
        isLoading: false,
        supervisors: supervisors,
      );

      _log(
        'SUPERVISORS FOUND: ${supervisors.length}',
      );
    } on PostgrestException catch (e) {
      _log(
        'LOAD SUPERVISORS DB ERROR: ${e.message}',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      _log(
        'LOAD SUPERVISORS ERROR: $e',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
  }

  // =============================================================
  // SELECT SUPERVISOR
  // =============================================================

  void selectSupervisor(
      Map<String, dynamic>? supervisor,
      ) {
    state = state.copyWith(
      selectedSupervisor: supervisor,
      assignments: const [],
      clearError: true,
      clearSuccess: true,
    );

    _log(
      'SELECTED SUPERVISOR: '
          '${supervisor?['id']}',
    );
  }

  // =============================================================
  // CLEAR SUPERVISORS
  // =============================================================

  void clearSupervisors() {
    state = state.copyWith(
      supervisors: const [],
      assignments: const [],
      clearSelectedSupervisor: true,
    );
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  Future<bool> createSupervisor(
      Map<String, dynamic> data,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // READ DATA
      // ---------------------------------------------------------

      final companyId =
      data['company_id']?.toString().trim();

      final departmentId =
      data['department_id']?.toString().trim();

      final employeeId =
      data['employee_id']?.toString().trim();

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      if (companyId == null || companyId.isEmpty) {
        throw Exception(
          'Company is required.',
        );
      }

      if (departmentId == null || departmentId.isEmpty) {
        throw Exception(
          'Department is required.',
        );
      }

      if (employeeId == null || employeeId.isEmpty) {
        throw Exception(
          'Employee is required.',
        );
      }

      _log(
        'CREATE SUPERVISOR: '
            'company=$companyId, '
            'department=$departmentId, '
            'employee=$employeeId',
      );

      // ---------------------------------------------------------
      // DATABASE
      // ---------------------------------------------------------

      final supervisor =
      await _remoteDataSource.createSupervisor(
        companyId: companyId,
        departmentId: departmentId,
        employeeId: employeeId,
      );

      // ---------------------------------------------------------
      // UPDATE LOCAL LIST
      // ---------------------------------------------------------

      final updatedList = <Map<String, dynamic>>[
        supervisor,
        ...state.supervisors,
      ];

      state = state.copyWith(
        isSaving: false,
        supervisors: updatedList,
        selectedCompanyId: companyId,
        clearError: true,
        successMessage:
        'Supervisor created successfully.',
      );

      _log('SUPERVISOR CREATED');

      return true;
    } on PostgrestException catch (e) {
      _log(
        'CREATE SUPERVISOR DB ERROR: '
            '${e.message}',
      );

      if (e.code == '23505') {
        setError(
          'This employee is already assigned as a supervisor.',
        );
      } else {
        setError(
          DatabaseErrorHelper.getMessage(e),
        );
      }

      return false;
    } catch (e) {
      _log('CREATE SUPERVISOR ERROR: $e');

      setError(
        _cleanError(e),
      );

      return false;
    } finally {
      state = state.copyWith(
        isSaving: false,
      );
    }
  }

  // =============================================================
  // UPDATE SUPERVISOR
  // =============================================================

  Future<bool> updateSupervisor(
      Map<String, dynamic> data,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      );

      // ---------------------------------------------------------
      // READ DATA
      // ---------------------------------------------------------

      final supervisorId =
      data['id']?.toString().trim();

      final companyId =
      data['company_id']?.toString().trim();

      final departmentId =
      data['department_id']?.toString().trim();

      final employeeId =
      data['employee_id']?.toString().trim();

      final isActive =
          data['is_active'] == true;

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      if (supervisorId == null ||
          supervisorId.isEmpty) {
        throw Exception(
          'Invalid supervisor ID.',
        );
      }

      if (companyId == null || companyId.isEmpty) {
        throw Exception(
          'Company is required.',
        );
      }

      if (departmentId == null || departmentId.isEmpty) {
        throw Exception(
          'Department is required.',
        );
      }

      if (employeeId == null || employeeId.isEmpty) {
        throw Exception(
          'Employee is required.',
        );
      }

      _log(
        'UPDATE SUPERVISOR: $supervisorId',
      );

      // ---------------------------------------------------------
      // DATABASE
      // ---------------------------------------------------------

      final updated =
      await _remoteDataSource.updateSupervisor(
        supervisorId: supervisorId,
        companyId: companyId,
        departmentId: departmentId,
        employeeId: employeeId,
        isActive: isActive,
      );

      // ---------------------------------------------------------
      // UPDATE LOCAL LIST
      // ---------------------------------------------------------

      final updatedList =
      state.supervisors.map(
            (item) {
          if (item['id']?.toString() == supervisorId) {
            return updated;
          }

          return item;
        },
      ).toList();

      // ---------------------------------------------------------
      // UPDATE SELECTED SUPERVISOR
      // ---------------------------------------------------------

      final selected =
          state.selectedSupervisor;

      final updatedSelected =
      selected != null &&
          selected['id']?.toString() == supervisorId
          ? updated
          : selected;

      // ---------------------------------------------------------
      // UPDATE STATE
      // ---------------------------------------------------------

      state = state.copyWith(
        isSaving: false,
        supervisors: updatedList,
        selectedSupervisor: updatedSelected,
        successMessage:
        'Supervisor updated successfully.',
      );

      _log('SUPERVISOR UPDATED');

      return true;
    } on PostgrestException catch (e) {
      _log(
        'UPDATE SUPERVISOR DB ERROR: '
            '${e.message}',
      );

      if (e.code == '23505') {
        setError(
          'This employee is already assigned as a supervisor.',
        );
      } else {
        setError(
          DatabaseErrorHelper.getMessage(e),
        );
      }

      return false;
    } catch (e) {
      _log('UPDATE SUPERVISOR ERROR: $e');

      setError(
        _cleanError(e),
      );

      return false;
    } finally {
      state = state.copyWith(
        isSaving: false,
      );
    }
  }

  // =============================================================
  // TOGGLE SUPERVISOR STATUS
  // =============================================================

  Future<bool> toggleSupervisor(
      Map<String, dynamic> supervisor,
      ) async {
    final supervisorId =
    supervisor['id']?.toString().trim();

    final companyId =
    supervisor['company_id']?.toString().trim();

    final departmentId =
    supervisor['department_id']?.toString().trim();

    final employeeId =
    supervisor['employee_id']?.toString().trim();

    final currentStatus =
        supervisor['is_active'] == true;

    // -----------------------------------------------------------
    // VALIDATION
    // -----------------------------------------------------------

    if (supervisorId == null ||
        supervisorId.isEmpty) {
      setError(
        'Invalid supervisor ID.',
      );

      return false;
    }

    if (companyId == null || companyId.isEmpty) {
      setError(
        'Company is required.',
      );

      return false;
    }

    if (departmentId == null || departmentId.isEmpty) {
      setError(
        'Department is required.',
      );

      return false;
    }

    if (employeeId == null || employeeId.isEmpty) {
      setError(
        'Employee is required.',
      );

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

  Future<bool> deleteSupervisor(
      String supervisorId,
      ) async {
    final id = supervisorId.trim();

    if (id.isEmpty) {
      setError(
        'Invalid supervisor ID.',
      );

      return false;
    }

    try {
      state = state.copyWith(
        isDeleting: true,
        clearError: true,
        clearSuccess: true,
      );

      _log('DELETE SUPERVISOR: $id');

      // ---------------------------------------------------------
      // DATABASE
      // ---------------------------------------------------------

      await _remoteDataSource.deleteSupervisor(id);

      // ---------------------------------------------------------
      // REMOVE FROM LOCAL LIST
      // ---------------------------------------------------------

      final updatedList =
      state.supervisors.where(
            (item) {
          return item['id']?.toString() != id;
        },
      ).toList();

      // ---------------------------------------------------------
      // CHECK SELECTED
      // ---------------------------------------------------------

      final selected =
          state.selectedSupervisor;

      final shouldClearSelected =
          selected != null &&
              selected['id']?.toString() == id;

      // ---------------------------------------------------------
      // UPDATE STATE
      // ---------------------------------------------------------

      state = state.copyWith(
        isDeleting: false,
        supervisors: updatedList,
        assignments: shouldClearSelected
            ? const []
            : state.assignments,
        clearSelectedSupervisor:
        shouldClearSelected,
        successMessage:
        'Supervisor deleted successfully.',
      );

      _log('SUPERVISOR DELETED');

      return true;
    } on PostgrestException catch (e) {
      _log(
        'DELETE SUPERVISOR DB ERROR: '
            '${e.message}',
      );

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    } catch (e) {
      _log('DELETE SUPERVISOR ERROR: $e');

      setError(
        _cleanError(e),
      );

      return false;
    } finally {
      state = state.copyWith(
        isDeleting: false,
      );
    }
  }

  // =============================================================
  // ASSIGN SUPERVISOR DEPARTMENTS
  //
  // Adds new department assignments.
  // Existing assignments should not be duplicated.
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

      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

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
            (id) => id.toString().trim(),
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

      _log(
        'ASSIGN SUPERVISOR DEPARTMENTS',
      );

      _log(
        'COMPANY: $company',
      );

      _log(
        'SUPERVISOR: $supervisor',
      );

      _log(
        'DEPARTMENTS: $uniqueDepartmentIds',
      );

      // ---------------------------------------------------------
      // INSERT
      // ---------------------------------------------------------

      final insertedCount =
      await _remoteDataSource
          .assignSupervisorDepartments(
        companyId: company,
        supervisorId: supervisor,
        departmentIds: uniqueDepartmentIds,
      );

      // ---------------------------------------------------------
      // RELOAD
      // ---------------------------------------------------------

      final assignments =
      await _remoteDataSource
          .getSupervisorDepartmentAssignments(
        companyId: company,
        supervisorId: supervisor,
      );

      // ---------------------------------------------------------
      // NO NEW ASSIGNMENT
      // ---------------------------------------------------------

      if (insertedCount == 0) {
        state = state.copyWith(
          isSaving: false,
          assignments: assignments,
          successMessage:
          'Selected departments are already assigned.',
        );

        return true;
      }

      // ---------------------------------------------------------
      // SUCCESS
      // ---------------------------------------------------------

      state = state.copyWith(
        isSaving: false,
        assignments: assignments,
        successMessage:
        '$insertedCount department(s) assigned successfully.',
      );

      return true;
    } on PostgrestException catch (e) {
      _log(
        'ASSIGN DEPARTMENTS DB ERROR: '
            '${e.message}',
      );

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    } catch (e) {
      _log(
        'ASSIGN DEPARTMENTS ERROR: $e',
      );

      setError(
        _cleanError(e),
      );

      return false;
    } finally {
      state = state.copyWith(
        isSaving: false,
      );
    }
  }

  // =============================================================
  // LOAD SUPERVISOR DEPARTMENT ASSIGNMENTS
  // =============================================================

  Future<List<Map<String, dynamic>>>
  loadSupervisorDepartmentAssignments({
    required String companyId,
    required String supervisorId,
  }) async {
    try {
      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

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

      _log(
        'LOAD SUPERVISOR DEPARTMENT ASSIGNMENTS',
      );

      _log(
        'COMPANY: $company',
      );

      _log(
        'SUPERVISOR: $supervisor',
      );

      // ---------------------------------------------------------
      // DATABASE
      // ---------------------------------------------------------

      final assignments =
      await _remoteDataSource
          .getSupervisorDepartmentAssignments(
        companyId: company,
        supervisorId: supervisor,
      );

      // ---------------------------------------------------------
      // STATE
      // ---------------------------------------------------------

      state = state.copyWith(
        assignments: assignments,
        clearError: true,
      );

      _log(
        'ASSIGNMENTS FOUND: ${assignments.length}',
      );

      return assignments;
    } on PostgrestException catch (e) {
      _log(
        'LOAD ASSIGNMENTS DB ERROR: '
            '${e.message}',
      );

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return [];
    } catch (e) {
      _log(
        'LOAD ASSIGNMENTS ERROR: $e',
      );

      setError(
        _cleanError(e),
      );

      return [];
    }
  }

  // =============================================================
  // UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS
  //
  // Empty departmentIds = remove all assignments.
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

      final company = companyId.trim();
      final supervisor = supervisorId.trim();

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

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

      // ---------------------------------------------------------
      // CLEAN IDS
      // ---------------------------------------------------------

      final uniqueDepartmentIds =
      departmentIds
          .map(
            (id) => id.toString().trim(),
      )
          .where(
            (id) => id.isNotEmpty,
      )
          .toSet()
          .toList();

      _log(
        'UPDATE SUPERVISOR DEPARTMENT ASSIGNMENTS',
      );

      _log(
        'COMPANY: $company',
      );

      _log(
        'SUPERVISOR: $supervisor',
      );

      _log(
        'FINAL DEPARTMENT IDS: '
            '$uniqueDepartmentIds',
      );

      // ---------------------------------------------------------
      // DATABASE UPDATE
      // ---------------------------------------------------------

      await _remoteDataSource
          .updateSupervisorDepartmentAssignments(
        companyId: company,
        supervisorId: supervisor,
        departmentIds: uniqueDepartmentIds,
      );

      // ---------------------------------------------------------
      // RELOAD DATABASE STATE
      // ---------------------------------------------------------

      final assignments =
      await _remoteDataSource
          .getSupervisorDepartmentAssignments(
        companyId: company,
        supervisorId: supervisor,
      );

      // ---------------------------------------------------------
      // UPDATE STATE
      // ---------------------------------------------------------

      state = state.copyWith(
        isSaving: false,
        assignments: assignments,
        successMessage:
        'Supervisor departments updated successfully.',
      );

      _log(
        'SUPERVISOR DEPARTMENT ASSIGNMENTS '
            'UPDATED SUCCESSFULLY',
      );

      return true;
    } on PostgrestException catch (e) {
      _log(
        'UPDATE ASSIGNMENTS DB ERROR: '
            '${e.message}',
      );

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    } catch (e) {
      _log(
        'UPDATE ASSIGNMENTS ERROR: $e',
      );

      setError(
        _cleanError(e),
      );

      return false;
    } finally {
      state = state.copyWith(
        isSaving: false,
      );
    }
  }

  // =============================================================
  // SET LOADING
  // =============================================================

  void setLoading(bool value) {
    state = state.copyWith(
      isLoading: value,
    );
  }

  // =============================================================
  // SET SAVING
  // =============================================================

  void setSaving(bool value) {
    state = state.copyWith(
      isSaving: value,
    );
  }

  // =============================================================
  // SET ERROR
  // =============================================================

  void setError(String message) {
    final cleanMessage = message.trim();

    state = state.copyWith(
      errorMessage: cleanMessage,
      clearSuccess: true,
    );
  }

  // =============================================================
  // CLEAR ERROR
  // =============================================================

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }

  // =============================================================
  // CLEAR SUCCESS
  // =============================================================

  void clearSuccess() {
    state = state.copyWith(
      clearSuccess: true,
    );
  }

  // =============================================================
  // CLEAR MESSAGES
  // =============================================================

  void clearMessages() {
    state = state.copyWith(
      clearError: true,
      clearSuccess: true,
    );
  }

  // =============================================================
  // CLEAR ASSIGNMENTS
  // =============================================================

  void clearAssignments() {
    state = state.copyWith(
      assignments: const [],
    );
  }

  // =============================================================
  // RESET
  // =============================================================

  void reset() {
    final user =
    _ref.read(currentUserProvider);

    state = SupervisorState(
      currentUser: user,
    );
  }

  // =============================================================
  // ERROR CLEANER
  // =============================================================

  String _cleanError(Object error) {
    final text = error.toString();

    if (text.startsWith('Exception: ')) {
      return text.substring(
        'Exception: '.length,
      );
    }

    return text;
  }

  // =============================================================
  // DEBUG LOGGER
  // =============================================================

  void _log(String message) {
    if (kDebugMode) {
      debugPrint(
        '[SupervisorNotifier] $message',
      );
    }
  }
}