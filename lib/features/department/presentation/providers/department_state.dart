import '../../domain/entities/department_entity.dart';

class DepartmentState {
  const DepartmentState({
    this.departments = const [],
    this.filteredDepartments = const [],
    this.selectedDepartment,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<DepartmentEntity> departments;

  final List<DepartmentEntity> filteredDepartments;

  final DepartmentEntity? selectedDepartment;

  final bool isLoading;

  final bool isSaving;

  final String search;

  final String? error;

  DepartmentState copyWith({
    List<DepartmentEntity>? departments,
    List<DepartmentEntity>? filteredDepartments,
    DepartmentEntity? selectedDepartment,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return DepartmentState(
      departments: departments ?? this.departments,
      filteredDepartments:
      filteredDepartments ?? this.filteredDepartments,
      selectedDepartment:
      selectedDepartment ?? this.selectedDepartment,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }
}