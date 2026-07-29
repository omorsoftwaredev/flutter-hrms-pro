import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/shift_repository_impl.dart';
import 'shift_notifier.dart';
import 'shift_state.dart';

final shiftProvider =
StateNotifierProvider<
    ShiftNotifier,
    ShiftState>(
      (ref) => ShiftNotifier(
    ShiftRepositoryImpl(),
  ),
);