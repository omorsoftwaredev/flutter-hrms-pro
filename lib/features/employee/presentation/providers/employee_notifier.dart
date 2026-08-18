import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import 'employee_state.dart';

class EmployeeNotifier
    extends StateNotifier<EmployeeState> {
  EmployeeNotifier(this._repository)
      : super(EmployeeState());

  final EmployeeRepository _repository;

  // ===========================================================
  // LOAD EMPLOYEES
  // ===========================================================

  Future<void> loadEmployees() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final employees =
      await _repository.getEmployees();

      state = state.copyWith(
        employees: employees,
        filteredEmployees: employees,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ===========================================================
  // GET EMPLOYEE BY ID
  // ===========================================================

  Future<void> getEmployeeById(
      String id,
      ) async {
    try {
      final employee =
      await _repository.getEmployeeById(id);

      state = state.copyWith(
        selectedEmployee: employee,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // ===========================================================
  // CREATE EMPLOYEE
  // ===========================================================

  Future<void> createEmployee(
      EmployeeEntity employee,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createEmployee(
        employee,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadEmployees();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // ===========================================================
  // UPDATE EMPLOYEE
  // ===========================================================

  Future<void> updateEmployee(
      EmployeeEntity employee,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateEmployee(
        employee,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadEmployees();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // ===========================================================
  // TOGGLE EMPLOYEE STATUS
  // ===========================================================

  Future<void> toggleEmployeeStatus(
      EmployeeEntity employee,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      final updatedEmployee =
      employee.copyWith(
        isActive: !employee.isActive,
        updatedAt: DateTime.now(),
      );

      await _repository.updateEmployee(
        updatedEmployee,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadEmployees();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // ===========================================================
  // DELETE EMPLOYEE
  // ===========================================================

  Future<void> deleteEmployee(
      String id,
      ) async {
    try {
      state = state.copyWith(
        error: null,
      );

      await _repository.deleteEmployee(id);

      await loadEmployees();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  // ===========================================================
  // SEARCH
  // ===========================================================

  void search(String keyword) {
    final query =
    keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredEmployees:
        state.employees,
      );

      return;
    }

    final filtered =
    state.employees.where((employee) {
      return employee.fullName
          .toLowerCase()
          .contains(query) ||
          (employee.mobile ?? '')
              .toLowerCase()
              .contains(query) ||
          (employee.email ?? '')
              .toLowerCase()
              .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredEmployees: filtered,
    );
  }

  // ===========================================================
  // REFRESH
  // ===========================================================

  Future<void> refresh() async {
    await loadEmployees();
  }

  // ===========================================================
  // CLEAR SELECTION
  // ===========================================================

  void clearSelection() {
    state = state.copyWith(
      selectedEmployee: null,
    );
  }
}