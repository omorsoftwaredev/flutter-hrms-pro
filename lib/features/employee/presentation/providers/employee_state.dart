import '../../domain/entities/employee_entity.dart';

class EmployeeState {
  final bool isLoading;
  final bool isSaving;

  final List<EmployeeEntity> employees;
  final List<EmployeeEntity> filteredEmployees;

  final String search;

  final String? error;

  const EmployeeState({
    this.isLoading = false,
    this.isSaving = false,
    this.employees = const [],
    this.filteredEmployees = const [],
    this.search = '',
    this.error,
  });

  EmployeeState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<EmployeeEntity>? employees,
    List<EmployeeEntity>? filteredEmployees,
    String? search,
    String? error,
  }) {
    return EmployeeState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      employees: employees ?? this.employees,
      filteredEmployees:
      filteredEmployees ??
          this.filteredEmployees,
      search: search ?? this.search,
      error: error,
    );
  }

  factory EmployeeState.initial() {
    return const EmployeeState(
      isLoading: false,
      isSaving: false,
      employees: [],
      filteredEmployees: [],
      search: '',
      error: null,
    );
  }
}