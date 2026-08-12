import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/employee_account_repository_impl.dart';
import '../../domain/repositories/employee_account_repository.dart';
import 'employee_account_notifier.dart';
import 'employee_account_state.dart';

//===============================================================
// EMPLOYEE ACCOUNT REPOSITORY PROVIDER
//===============================================================

final employeeAccountRepositoryProvider =
Provider<EmployeeAccountRepository>((ref) {
  return EmployeeAccountRepositoryImpl(ref);
});

//===============================================================
// EMPLOYEE ACCOUNT PROVIDER
//===============================================================

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