import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/shift_repository_impl.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_notifier.dart';
import 'shift_state.dart';

final shiftRepositoryProvider =
Provider<ShiftRepository>(
      (ref) => ShiftRepositoryImpl(),
);

final shiftProvider =
StateNotifierProvider<
    ShiftNotifier,
    ShiftState>(
      (ref) {
    return ShiftNotifier(
      ref.read(shiftRepositoryProvider),
    );
  },
);