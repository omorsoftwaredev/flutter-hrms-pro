import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_state.dart';

class ShiftNotifier
    extends StateNotifier<ShiftState> {
  ShiftNotifier(this._repository)
      : super(const ShiftState());

  final ShiftRepository _repository;

  Future<void> loadShifts() async {
    state = state.copyWith(
      isLoading: true,
    );

    try {
      final data =
      await _repository.getShifts();

      state = state.copyWith(
        shifts: data,
        filteredShifts: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void search(String keyword) {
    final query =
    keyword.toLowerCase();

    final result = state.shifts
        .where(
          (e) =>
      e.name
          .toLowerCase()
          .contains(query) ||
          e.code
              .toLowerCase()
              .contains(query),
    )
        .toList();

    state = state.copyWith(
      filteredShifts: result,
    );
  }

  Future<void> createShift(
      ShiftEntity shift) async {
    state = state.copyWith(
      isSaving: true,
    );

    await _repository.createShift(
        shift);

    state = state.copyWith(
      isSaving: false,
    );

    await loadShifts();
  }

  Future<void> updateShift(
      ShiftEntity shift) async {
    state = state.copyWith(
      isSaving: true,
    );

    await _repository.updateShift(
        shift);

    state = state.copyWith(
      isSaving: false,
    );

    await loadShifts();
  }

  Future<void> deleteShift(
      String id) async {
    await _repository.deleteShift(id);

    await loadShifts();
  }
}