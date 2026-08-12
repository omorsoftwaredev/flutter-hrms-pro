import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../employee/domain/entities/employee_entity.dart';
import '../../../employee/presentation/providers/employee_provider.dart';

//===============================================================
// ALL EMPLOYEE DROPDOWN
//===============================================================

final employeeDropdownProvider =
Provider<List<EmployeeEntity>>((ref) {
  final state = ref.watch(employeeProvider);

  final employees = state.employees.toList();

  employees.sort(
        (a, b) => a.fullName
        .toLowerCase()
        .compareTo(
      b.fullName.toLowerCase(),
    ),
  );

  return employees;
});

//===============================================================
// ACTIVE EMPLOYEE DROPDOWN
//===============================================================

final activeEmployeeDropdownProvider =
Provider<List<EmployeeEntity>>((ref) {
  final state = ref.watch(employeeProvider);

  final employees = state.employees
      .where(
        (employee) => employee.isActive,
  )
      .toList();

  employees.sort(
        (a, b) => a.fullName
        .toLowerCase()
        .compareTo(
      b.fullName.toLowerCase(),
    ),
  );

  return employees;
});

//===============================================================
// EMPLOYEE BY COMPANY
//===============================================================

final employeeByCompanyProvider =
Provider.family<List<EmployeeEntity>, String>(
      (ref, companyId) {
    final state = ref.watch(employeeProvider);

    final id = companyId.trim();

    if (id.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.companyId == id,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);

//===============================================================
// ACTIVE EMPLOYEE BY COMPANY
//===============================================================

final activeEmployeeByCompanyProvider =
Provider.family<List<EmployeeEntity>, String>(
      (ref, companyId) {
    final state = ref.watch(employeeProvider);

    final id = companyId.trim();

    if (id.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.companyId == id &&
          employee.isActive,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);

//===============================================================
// EMPLOYEE BY DEPARTMENT
//===============================================================

final employeeByDepartmentProvider =
Provider.family<List<EmployeeEntity>, String>(
      (ref, departmentId) {
    final state = ref.watch(employeeProvider);

    final id = departmentId.trim();

    if (id.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.departmentId == id,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);

//===============================================================
// ACTIVE EMPLOYEE BY DEPARTMENT
//===============================================================

final activeEmployeeByDepartmentProvider =
Provider.family<List<EmployeeEntity>, String>(
      (ref, departmentId) {
    final state = ref.watch(employeeProvider);

    final id = departmentId.trim();

    if (id.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.departmentId == id &&
          employee.isActive,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);

//===============================================================
// EMPLOYEE BY COMPANY + DEPARTMENT
//===============================================================

final employeeByCompanyDepartmentProvider =
Provider.family<
    List<EmployeeEntity>,
    ({
    String companyId,
    String departmentId,
    })>(
      (ref, data) {
    final state = ref.watch(employeeProvider);

    final companyId = data.companyId.trim();
    final departmentId = data.departmentId.trim();

    if (companyId.isEmpty ||
        departmentId.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.companyId == companyId &&
          employee.departmentId == departmentId,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);

//===============================================================
// ACTIVE EMPLOYEE BY COMPANY + DEPARTMENT
//===============================================================

final activeEmployeeByCompanyDepartmentProvider =
Provider.family<
    List<EmployeeEntity>,
    ({
    String companyId,
    String departmentId,
    })>(
      (ref, data) {
    final state = ref.watch(employeeProvider);

    final companyId = data.companyId.trim();
    final departmentId = data.departmentId.trim();

    if (companyId.isEmpty ||
        departmentId.isEmpty) {
      return const [];
    }

    final employees = state.employees
        .where(
          (employee) =>
      employee.companyId == companyId &&
          employee.departmentId == departmentId &&
          employee.isActive,
    )
        .toList();

    employees.sort(
          (a, b) => a.fullName
          .toLowerCase()
          .compareTo(
        b.fullName.toLowerCase(),
      ),
    );

    return employees;
  },
);