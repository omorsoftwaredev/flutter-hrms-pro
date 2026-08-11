import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../employee/data/models/employee_model.dart';
import '../../data/repositories/current_employee_repository.dart';

///======================================
/// Repository
///======================================

final currentEmployeeRepositoryProvider = Provider<CurrentEmployeeRepository>(
  (ref) => CurrentEmployeeRepository(),
);

///======================================
/// Current Employee
///======================================

final currentEmployeeProvider = FutureProvider<EmployeeModel?>((ref) async {
  return await ref.read(currentEmployeeRepositoryProvider).currentEmployee();
});
