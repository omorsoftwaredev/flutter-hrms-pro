import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_repository_impl.dart';
import 'employee_notifier.dart';
import 'employee_state.dart';

final employeeRepositoryProvider =
Provider<EmployeeRepositoryImpl>(
      (ref) {
    return EmployeeRepositoryImpl();
  },
);

final employeeProvider = StateNotifierProvider<
    EmployeeNotifier,
    EmployeeState>(
      (ref) {
    return EmployeeNotifier(
      ref.read(
        employeeRepositoryProvider,
      ),
    );
  },
);