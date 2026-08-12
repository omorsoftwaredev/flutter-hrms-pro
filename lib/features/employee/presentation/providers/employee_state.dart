import '../../domain/entities/employee_entity.dart';

class EmployeeState {
  const EmployeeState({
    this.employees = const [],
    this.filteredEmployees = const [],
    this.selectedEmployee,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  // =============================================================
  // EMPLOYEES
  // =============================================================

  final List<EmployeeEntity> employees;

  // =============================================================
  // FILTERED EMPLOYEES
  // =============================================================

  final List<EmployeeEntity> filteredEmployees;

  // =============================================================
  // SELECTED EMPLOYEE
  // =============================================================

  final EmployeeEntity? selectedEmployee;

  // =============================================================
  // LOADING
  // =============================================================

  final bool isLoading;

  // =============================================================
  // SAVING
  // =============================================================

  final bool isSaving;

  // =============================================================
  // SEARCH
  // =============================================================

  final String search;

  // =============================================================
  // ERROR
  // =============================================================

  final String? error;

  // =============================================================
  // COPY WITH
  // =============================================================

  EmployeeState copyWith({
    List<EmployeeEntity>? employees,
    List<EmployeeEntity>? filteredEmployees,
    EmployeeEntity? selectedEmployee,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      filteredEmployees:
      filteredEmployees ?? this.filteredEmployees,
      selectedEmployee:
      selectedEmployee ?? this.selectedEmployee,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }
}