import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/repositories/employee_repository.dart';
import 'employee_notifier.dart';
import 'employee_state.dart';

// =============================================================
// EMPLOYEE REPOSITORY PROVIDER
// =============================================================

final employeeRepositoryProvider =
Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(ref);
});

// =============================================================
// EMPLOYEE PROVIDER
// =============================================================

final employeeProvider = StateNotifierProvider<
    EmployeeNotifier,
    EmployeeState>((ref) {
  return EmployeeNotifier(
    ref.read(employeeRepositoryProvider),
  );
});