/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Provider
///
/// Version : 3.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'supervisor_notifier.dart';
import 'supervisor_state.dart';

final supervisorProvider =
StateNotifierProvider<
    SupervisorNotifier,
    SupervisorState>(
      (ref) {
    return SupervisorNotifier(ref);
  },
);