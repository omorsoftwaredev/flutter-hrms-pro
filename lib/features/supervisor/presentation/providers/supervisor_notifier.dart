/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Notifier
///
/// Version : 4.0.0
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

  SupervisorNotifier(
      Ref ref,
      )  : _ref = ref,
        _remoteDataSource = SupervisorRemoteDataSource(),
        super(
        const SupervisorState(),
      ) {
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

    state = state.copyWith(
      currentUser: user,
    );
  }

  // =============================================================
  // LOAD COMPANIES
  // =============================================================

  Future<void> loadCompanies() async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      final companies =
      await _remoteDataSource.getCompanies();

      state = state.copyWith(
        isLoading: false,
        companies: companies,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
  }

  // =============================================================
  // SELECT COMPANY
  //
  // Company select করলে:
  //
  // 1. selectedCompanyId save হবে
  // 2. পুরোনো department clear হবে
  // 3. পুরোনো employee clear হবে
  // 4. পুরোনো supervisor clear হবে
  // 5. নতুন department load হবে
  // 6. নতুন company-এর supervisor load হবে
  // =============================================================

  Future<void> selectCompany(
      String companyId,
      ) async {
    // ===========================================================
    // SET SELECTED COMPANY
    // ===========================================================
// ===============================================================
// TOGGLE SUPERVISOR STATUS
// ===============================================================

    Future<bool> toggleSupervisor(
        Map<String, dynamic> supervisor,
        ) async {
      final supervisorId =
      supervisor['id']?.toString();

      final companyId =
      supervisor['company_id']?.toString();

      final departmentId =
      supervisor['department_id']?.toString();

      final employeeId =
      supervisor['employee_id']?.toString();

      final currentStatus =
          supervisor['is_active'] == true;

      if (supervisorId == null ||
          supervisorId.isEmpty ||
          companyId == null ||
          companyId.isEmpty ||
          departmentId == null ||
          departmentId.isEmpty ||
          employeeId == null ||
          employeeId.isEmpty) {
        setError(
          'Invalid supervisor data.',
        );

        return false;
      }

      return updateSupervisor({
        'id': supervisorId,
        'company_id': companyId,
        'department_id': departmentId,
        'employee_id': employeeId,
        'is_active': !currentStatus,
      });
    }
    Future<bool> deleteSupervisor(
        String supervisorId,
        ) async {
      try {
        state = state.copyWith(
          isDeleting: true,
          clearError: true,
          clearSuccess: true,
        );

        await _remoteDataSource.deleteSupervisor(
          supervisorId,
        );

        final list =
        state.supervisors.where(
              (item) {
            return item['id']?.toString() !=
                supervisorId;
          },
        ).toList();

        state = state.copyWith(
          isDeleting: false,
          supervisors: list,
          successMessage:
          'Supervisor deleted successfully.',
        );

        return true;
      } on PostgrestException catch (e) {
        setError(
          DatabaseErrorHelper.getMessage(e),
        );

        return false;
      } catch (e) {
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
    state = state.copyWith(
      selectedCompanyId: companyId,

      departments: const [],
      employees: const [],
      supervisors: const [],

      clearSelectedSupervisor: true,
      clearError: true,
      clearSuccess: true,
    );

    // ===========================================================
    // LOAD DEPARTMENTS
    // ===========================================================

    await loadDepartments(companyId);

    // ===========================================================
    // LOAD SUPERVISORS
    // ===========================================================

    await loadSupervisors(companyId);
  }

  // =============================================================
  // CLEAR SUPERVISORS
  // =============================================================

  void clearSupervisors() {
    state = state.copyWith(
      supervisors: const [],
    );
  }

  // =============================================================
  // LOAD DEPARTMENTS
  // =============================================================

  Future<void> loadDepartments(
      String companyId,
      ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        departments: const [],
        employees: const [],
        clearError: true,
      );

      final departments =
      await _remoteDataSource.getDepartments(
        companyId,
      );

      state = state.copyWith(
        isLoading: false,
        departments: departments,
      );
    } catch (e) {
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
    // -----------------------------------------------------------
    // Clear old employees
    // -----------------------------------------------------------

    state = state.copyWith(
      employees: const [],
      clearError: true,
    );

    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return;
    }

    await loadEmployees(
      companyId: companyId,
      departmentId: departmentId,
    );
  }

  // =============================================================
  // LOAD EMPLOYEES
  // =============================================================

  Future<void> loadEmployees({
    required String companyId,
    required String departmentId,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        employees: const [],
        clearError: true,
      );

      final employees =
      await _remoteDataSource.getEmployees(
        companyId: companyId,
        departmentId: departmentId,
      );

      state = state.copyWith(
        isLoading: false,
        employees: employees,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
  }

  // =============================================================
  // LOAD SUPERVISORS
  //
  // এখানে শুধুমাত্র selected company-এর supervisor আসবে
  // =============================================================

  Future<void> loadSupervisors(
      String companyId,
      ) async {
    if (companyId.trim().isEmpty) {
      return;
    }

    try {
      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('LOAD SUPERVISORS');
      debugPrint('COMPANY ID = $companyId');
      debugPrint('=====================================================');

      final supervisors =
      await _remoteDataSource.getSupervisors(
        companyId,
      );

      debugPrint('');
      debugPrint('SUPERVISORS FOUND = ${supervisors.length}');

      for (final supervisor in supervisors) {
        debugPrint(
          'SUPERVISOR = $supervisor',
        );
      }

      debugPrint('=====================================================');

      state = state.copyWith(
        supervisors: supervisors,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('LOAD SUPERVISORS ERROR');
      debugPrint('ERROR = $e');
      debugPrint('=====================================================');

      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e),
      );
    }
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  Future<bool> createSupervisor(
      Map<String, dynamic> data,
      ) async {
    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      // =========================================================
      // DATA
      // =========================================================

      final companyId =
      data['company_id']?.toString();

      final departmentId =
      data['department_id']?.toString();

      final employeeId =
      data['employee_id']?.toString();

      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('SUPERVISOR CREATE DATA');
      debugPrint('$data');
      debugPrint('=====================================================');

      // =========================================================
      // VALIDATION
      // =========================================================

      if (companyId == null ||
          companyId.isEmpty) {
        setError(
          'Company is required.',
        );
        return false;
      }

      if (departmentId == null ||
          departmentId.isEmpty) {
        setError(
          'Department is required.',
        );
        return false;
      }

      if (employeeId == null ||
          employeeId.isEmpty) {
        setError(
          'Employee is required.',
        );
        return false;
      }

      // =========================================================
      // CREATE
      // =========================================================

      final supervisor =
      await _remoteDataSource.createSupervisor(
        companyId: companyId,
        departmentId: departmentId,
        employeeId: employeeId,
      );

      // =========================================================
      // IMPORTANT
      //
      // Database insert successful হলে local list-এ add করছি।
      // =========================================================

      final updatedList = [
        supervisor,
        ...state.supervisors,
      ];

      state = state.copyWith(
        isSaving: false,
        supervisors: updatedList,
        selectedCompanyId: companyId,
        successMessage:
        'Supervisor created successfully.',
      );

      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('SUPERVISOR CREATED SUCCESSFULLY');
      debugPrint('SUPERVISOR = $supervisor');
      debugPrint('TOTAL SUPERVISORS = ${updatedList.length}');
      debugPrint('=====================================================');

      return true;
    }

    // ===========================================================
    // DATABASE ERROR
    // ===========================================================

    on PostgrestException catch (e) {
      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('SUPERVISOR CREATE DATABASE ERROR');
      debugPrint('CODE = ${e.code}');
      debugPrint('MESSAGE = ${e.message}');
      debugPrint('DETAILS = ${e.details}');
      debugPrint('HINT = ${e.hint}');
      debugPrint('=====================================================');

      // ---------------------------------------------------------
      // DUPLICATE
      // ---------------------------------------------------------

      if (e.code == '23505') {
        setError(
          'This employee is already assigned as a supervisor.',
        );

        return false;
      }

      // ---------------------------------------------------------
      // OTHER DATABASE ERROR
      // ---------------------------------------------------------

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    }

    // ===========================================================
    // OTHER ERROR
    // ===========================================================

    catch (e) {
      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('SUPERVISOR CREATE ERROR');
      debugPrint('ERROR = $e');
      debugPrint('=====================================================');

      setError(
        'Something went wrong. Please try again.',
      );

      return false;
    }

    // ===========================================================
    // FINALLY
    // ===========================================================

    finally {
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

      final supervisorId =
      data['id']?.toString();

      final companyId =
      data['company_id']?.toString();

      final departmentId =
      data['department_id']?.toString();

      final employeeId =
      data['employee_id']?.toString();

      final isActive =
          data['is_active'] == true;

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
        setError(
          'Invalid supervisor data.',
        );

        return false;
      }

      // ---------------------------------------------------------
      // UPDATE DATABASE
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

      final list =
      state.supervisors.map(
            (item) {
          if (item['id']?.toString() ==
              supervisorId) {
            return updated;
          }

          return item;
        },
      ).toList();

      state = state.copyWith(
        isSaving: false,
        supervisors: list,
        successMessage:
        'Supervisor updated successfully.',
      );

      return true;
    }

    // ===========================================================
    // DATABASE ERROR
    // ===========================================================

    on PostgrestException catch (e) {
      if (e.code == '23505') {
        setError(
          'This employee is already assigned as a supervisor.',
        );

        return false;
      }

      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    }

    // ===========================================================
    // OTHER ERROR
    // ===========================================================

    catch (e) {
      setError(
        _cleanError(e),
      );

      return false;
    }

    // ===========================================================
    // FINALLY
    // ===========================================================

    finally {
      state = state.copyWith(
        isSaving: false,
      );
    }
  }

  // =============================================================
  // DELETE SUPERVISOR
  // =============================================================

  Future<bool> deleteSupervisor(
      String supervisorId,
      ) async {
    try {
      state = state.copyWith(
        isDeleting: true,
        clearError: true,
        clearSuccess: true,
      );

      await _remoteDataSource.deleteSupervisor(
        supervisorId,
      );

      // ---------------------------------------------------------
      // REMOVE FROM LOCAL LIST
      // ---------------------------------------------------------

      final list =
      state.supervisors.where(
            (item) {
          return item['id']?.toString() !=
              supervisorId;
        },
      ).toList();

      state = state.copyWith(
        isDeleting: false,
        supervisors: list,
        successMessage:
        'Supervisor deleted successfully.',
      );

      return true;
    }

    // ===========================================================
    // DATABASE ERROR
    // ===========================================================

    on PostgrestException catch (e) {
      setError(
        DatabaseErrorHelper.getMessage(e),
      );

      return false;
    }

    // ===========================================================
    // OTHER ERROR
    // ===========================================================

    catch (e) {
      setError(
        _cleanError(e),
      );

      return false;
    }

    // ===========================================================
    // FINALLY
    // ===========================================================

    finally {
      state = state.copyWith(
        isDeleting: false,
      );
    }
  }

  // =============================================================
  // LOADING
  // =============================================================

  void setLoading(
      bool value,
      ) {
    state = state.copyWith(
      isLoading: value,
    );
  }

  // =============================================================
  // SAVING
  // =============================================================

  void setSaving(
      bool value,
      ) {
    state = state.copyWith(
      isSaving: value,
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  void setError(
      String message,
      ) {
    state = state.copyWith(
      errorMessage: message,
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
  // RESET
  // =============================================================

  void reset() {
    final user =
    _ref.read(
      currentUserProvider,
    );

    state = SupervisorState(
      currentUser: user,
    );
  }

  // =============================================================
  // ERROR CLEANER
  // =============================================================

  String _cleanError(
      Object error,
      ) {
    final text =
    error.toString();

    if (text.startsWith(
      'Exception: ',
    )) {
      return text.substring(
        11,
      );
    }

    return text;
  }
}