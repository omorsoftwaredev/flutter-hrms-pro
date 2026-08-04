import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/department_entity.dart';
import '../../domain/repositories/department_repository.dart';
import 'department_state.dart';

class DepartmentNotifier
    extends StateNotifier<DepartmentState> {
  DepartmentNotifier(this._repository)
      : super(const DepartmentState());

  final DepartmentRepository _repository;

  Future<void> loadDepartments() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final departments =
      await _repository.getDepartments();

      state = state.copyWith(
        departments: departments,
        filteredDepartments: departments,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  Future<void> toggleDepartmentStatus(
      DepartmentEntity department,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateDepartmentStatus(
        id: department.id,
        isActive: !department.isActive,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDepartments();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadDepartments();
  }

  Future<void> createDepartment(
      DepartmentEntity department,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createDepartment(
        department,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDepartments();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateDepartment(
      DepartmentEntity department,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateDepartment(
        department,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDepartments();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteDepartment(
      String id,
      ) async {
    try {
      await _repository.deleteDepartment(id);

      await loadDepartments();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> getDepartmentById(
      String id,
      ) async {
    try {
      final department =
      await _repository.getDepartmentById(id);

      state = state.copyWith(
        selectedDepartment: department,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredDepartments:
        state.departments,
      );
      return;
    }

    final filtered =
    state.departments.where((department) {
      return department.name
          .toLowerCase()
          .contains(query) ||
          department.code
              .toLowerCase()
              .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredDepartments: filtered,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedDepartment: null,
    );
  }
}