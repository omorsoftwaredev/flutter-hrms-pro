import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_state.dart';

class ShiftNotifier extends StateNotifier<ShiftState> {
  ShiftNotifier(this._repository)
      : super(const ShiftState());

  final ShiftRepository _repository;

  Future<void> loadShifts() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final shifts = await _repository.getShifts();

      state = state.copyWith(
        shifts: shifts,
        filteredShifts: shifts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadShifts();
  }

  Future<void> createShift(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createShift(shift);

      state = state.copyWith(
        isSaving: false,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateShift(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateShift(shift);

      state = state.copyWith(
        isSaving: false,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteShift(
      String id,
      ) async {
    try {
      await _repository.deleteShift(id);

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> getShiftById(
      String id,
      ) async {
    try {
      final shift =
      await _repository.getShiftById(id);

      state = state.copyWith(
        selectedShift: shift,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> toggleShiftStatus(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateShiftStatus(
        id: shift.id,
        isActive: !shift.isActive,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredShifts: state.shifts,
      );
      return;
    }

    final filtered = state.shifts.where((shift) {
      return shift.name
          .toLowerCase()
          .contains(query) ||
          shift.code
              .toLowerCase()
              .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredShifts: filtered,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedShift: null,
    );
  }
}