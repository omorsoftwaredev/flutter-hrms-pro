import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/department_repository_impl.dart';
import '../../domain/repositories/department_repository.dart';
import 'department_notifier.dart';
import 'department_state.dart';

final departmentRepositoryProvider =
Provider<DepartmentRepository>(
      (ref) => DepartmentRepositoryImpl(),
);

final departmentProvider = StateNotifierProvider<
    DepartmentNotifier,
    DepartmentState>(
      (ref) {
    return DepartmentNotifier(
      ref.read(departmentRepositoryProvider),
    );
  },
);