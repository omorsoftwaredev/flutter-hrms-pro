import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/entities/employee_entity.dart';
import 'employee_state.dart';

class EmployeeNotifier
    extends StateNotifier<EmployeeState> {
  EmployeeNotifier(this._repository)
      : super(EmployeeState.initial());

  final EmployeeRepositoryImpl _repository;

  Future<void> loadEmployees() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final employees =
      await _repository.getEmployees();

      state = state.copyWith(
        isLoading: false,
        employees: employees,
        filteredEmployees: employees,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createEmployee(
      EmployeeEntity employee,
      ) async {
    state = state.copyWith(
      isSaving: true,
      error: null,
    );

    try {
      await _repository.createEmployee(
        employee,
      );

      await loadEmployees();

      state = state.copyWith(
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> updateEmployee(
      EmployeeEntity employee,
      ) async {
    state = state.copyWith(
      isSaving: true,
      error: null,
    );

    try {
      await _repository.updateEmployee(
        employee,
      );

      await loadEmployees();

      state = state.copyWith(
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> deleteEmployee(
      String id,
      ) async {
    try {
      await _repository.deleteEmployee(id);

      final updated =
      state.employees
          .where((e) => e.id != id)
          .toList();

      state = state.copyWith(
        employees: updated,
        filteredEmployees: updated,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  void search(String keyword) {
    final value =
    keyword.trim().toLowerCase();

    if (value.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredEmployees:
        state.employees,
      );

      return;
    }

    final result =
    state.employees.where((employee) {
      return employee.employeeCode
          .toLowerCase()
          .contains(value) ||
          employee.fullName
              .toLowerCase()
              .contains(value) ||
          (employee.mobile ?? '')
              .toLowerCase()
              .contains(value) ||
          (employee.email ?? '')
              .toLowerCase()
              .contains(value);
    }).toList();

    state = state.copyWith(
      search: keyword,
      filteredEmployees: result,
    );
  }

  Future<void> refresh() async {
    await loadEmployees();
  }
}