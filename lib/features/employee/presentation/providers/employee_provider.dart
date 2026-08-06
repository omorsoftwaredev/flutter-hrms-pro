import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_repository_impl.dart';
import 'employee_notifier.dart';
import 'employee_state.dart';

final employeeRepositoryProvider =
Provider<EmployeeRepositoryImpl>(
      (ref) => EmployeeRepositoryImpl(),
);

final employeeProvider = StateNotifierProvider<
    EmployeeNotifier,
    EmployeeState>(
      (ref) => EmployeeNotifier(
    ref.read(employeeRepositoryProvider),
  ),
);