/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor State
///
/// Version : 5.0.0
///
/// Responsibilities:
/// - Supervisor loading state
/// - Company state
/// - Department state
/// - Employee state
/// - Supervisor state
/// - Supervisor department assignments state
/// - Selected supervisor state
/// - Messages
/// - Current user
/// ===============================================================

import '../../../../core/auth/current_user.dart';

class SupervisorState {
  // =============================================================
  // LOADING
  // =============================================================

  final bool isLoading;

  // =============================================================
  // SAVING
  // =============================================================

  final bool isSaving;

  // =============================================================
  // DELETING
  // =============================================================

  final bool isDeleting;

  // =============================================================
  // DEPARTMENTS
  // =============================================================

  final List<Map<String, dynamic>> departments;

  // =============================================================
  // EMPLOYEES
  // =============================================================

  final List<Map<String, dynamic>> employees;

  // =============================================================
  // SUPERVISORS
  // =============================================================

  final List<Map<String, dynamic>> supervisors;

  // =============================================================
  // SUPERVISOR DEPARTMENT ASSIGNMENTS
  // =============================================================

  final List<Map<String, dynamic>> assignments;

  // =============================================================
  // SELECTED SUPERVISOR
  // =============================================================

  final Map<String, dynamic>? selectedSupervisor;

  // =============================================================
  // SELECTED COMPANY
  // =============================================================

  final String? selectedCompanyId;

  // =============================================================
  // ERROR
  // =============================================================

  final String? errorMessage;

  // =============================================================
  // SUCCESS
  // =============================================================

  final String? successMessage;

  // =============================================================
  // CURRENT USER
  // =============================================================

  final CurrentUser? currentUser;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const SupervisorState({
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.departments = const [],
    this.employees = const [],
    this.supervisors = const [],
    this.assignments = const [],

    this.selectedSupervisor,
    this.selectedCompanyId,

    this.errorMessage,
    this.successMessage,

    this.currentUser,
  });

  // =============================================================
  // COPY WITH
  // =============================================================

  SupervisorState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,

    List<Map<String, dynamic>>? companies,
    List<Map<String, dynamic>>? departments,
    List<Map<String, dynamic>>? employees,
    List<Map<String, dynamic>>? supervisors,
    List<Map<String, dynamic>>? assignments,

    Map<String, dynamic>? selectedSupervisor,
    bool clearSelectedSupervisor = false,

    String? selectedCompanyId,
    bool clearSelectedCompany = false,

    String? errorMessage,
    bool clearError = false,

    String? successMessage,
    bool clearSuccess = false,

    CurrentUser? currentUser,
  }) {
    return SupervisorState(
      // -----------------------------------------------------------
      // LOADING
      // -----------------------------------------------------------

      isLoading: isLoading ?? this.isLoading,

      // -----------------------------------------------------------
      // SAVING
      // -----------------------------------------------------------

      isSaving: isSaving ?? this.isSaving,

      // -----------------------------------------------------------
      // DELETING
      // -----------------------------------------------------------

      isDeleting: isDeleting ?? this.isDeleting,

      // -----------------------------------------------------------
      // DEPARTMENTS
      // -----------------------------------------------------------

      departments: departments ?? this.departments,

      // -----------------------------------------------------------
      // EMPLOYEES
      // -----------------------------------------------------------

      employees: employees ?? this.employees,

      // -----------------------------------------------------------
      // SUPERVISORS
      // -----------------------------------------------------------

      supervisors: supervisors ?? this.supervisors,

      // -----------------------------------------------------------
      // ASSIGNMENTS
      // -----------------------------------------------------------

      assignments: assignments ?? this.assignments,

      // -----------------------------------------------------------
      // SELECTED SUPERVISOR
      // -----------------------------------------------------------

      selectedSupervisor: clearSelectedSupervisor
          ? null
          : selectedSupervisor ?? this.selectedSupervisor,

      // -----------------------------------------------------------
      // SELECTED COMPANY
      // -----------------------------------------------------------

      selectedCompanyId: clearSelectedCompany
          ? null
          : selectedCompanyId ?? this.selectedCompanyId,

      // -----------------------------------------------------------
      // ERROR
      // -----------------------------------------------------------

      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,

      // -----------------------------------------------------------
      // SUCCESS
      // -----------------------------------------------------------

      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,

      // -----------------------------------------------------------
      // CURRENT USER
      // -----------------------------------------------------------

      currentUser: currentUser ?? this.currentUser,
    );
  }

  // =============================================================
  // HELPERS
  // =============================================================

  bool get hasDepartments => departments.isNotEmpty;

  bool get hasEmployees => employees.isNotEmpty;

  bool get hasSupervisors => supervisors.isNotEmpty;

  bool get hasAssignments => assignments.isNotEmpty;

  bool get hasSelectedSupervisor => selectedSupervisor != null;

  bool get hasSelectedCompany =>
      selectedCompanyId != null &&
          selectedCompanyId!.trim().isNotEmpty;

  bool get hasError =>
      errorMessage != null &&
          errorMessage!.trim().isNotEmpty;

  bool get hasSuccess =>
      successMessage != null &&
          successMessage!.trim().isNotEmpty;
}