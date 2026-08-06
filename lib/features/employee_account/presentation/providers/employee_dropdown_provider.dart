import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../employee/domain/entities/employee_entity.dart';
import '../../../employee/presentation/providers/employee_provider.dart';

final employeeDropdownProvider =
Provider<List<EmployeeEntity>>(
      (ref) {
    final state = ref.watch(employeeProvider);

    final employees = state.employees.toList();

    employees.sort(
          (a, b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return employees;
  },
);

final activeEmployeeDropdownProvider =
Provider<List<EmployeeEntity>>(
      (ref) {
    final state = ref.watch(employeeProvider);

    final employees = state.employees
        .where(
          (e) => e.isActive,
    )
        .toList();

    employees.sort(
          (a, b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return employees;
  },
);

final employeeByCompanyProvider =
Provider.family<
    List<EmployeeEntity>,
    String>(
      (ref, companyId) {
    final state = ref.watch(employeeProvider);

    final employees = state.employees
        .where(
          (e) => e.companyId == companyId,
    )
        .toList();

    employees.sort(
          (a, b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return employees;
  },
);

final employeeByDepartmentProvider =
Provider.family<
    List<EmployeeEntity>,
    String>(
      (ref, departmentId) {
    final state = ref.watch(employeeProvider);

    final employees = state.employees
        .where(
          (e) =>
      e.departmentId ==
          departmentId,
    )
        .toList();

    employees.sort(
          (a, b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return employees;
  },
);

final employeeByCompanyDepartmentProvider =
Provider.family<
    List<EmployeeEntity>,
    ({
    String companyId,
    String departmentId,
    })>(
      (ref, data) {
    final state = ref.watch(employeeProvider);

    final employees = state.employees
        .where(
          (e) =>
      e.companyId ==
          data.companyId &&
          e.departmentId ==
              data.departmentId,
    )
        .toList();

    employees.sort(
          (a, b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return employees;
  },
);