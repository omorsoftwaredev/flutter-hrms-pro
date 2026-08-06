import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_account_repository_impl.dart';
import 'employee_account_notifier.dart';
import 'employee_account_state.dart';

final employeeAccountRepositoryProvider =
Provider<EmployeeAccountRepositoryImpl>(
      (ref) {
    return EmployeeAccountRepositoryImpl();
  },
);

final employeeAccountProvider = StateNotifierProvider<
    EmployeeAccountNotifier,
    EmployeeAccountState>(
      (ref) {
    return EmployeeAccountNotifier(
      ref.read(
        employeeAccountRepositoryProvider,
      ),
    );
  },
);