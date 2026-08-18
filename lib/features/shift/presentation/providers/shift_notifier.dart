import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_state.dart';

class ShiftNotifier
    extends StateNotifier<ShiftState> {
  ShiftNotifier(this._repository)
      : super(const ShiftState());

  final ShiftRepository _repository;

  // =============================================================
  // LOAD SHIFTS
  // =============================================================

  Future<void> loadShifts() async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      final shifts =
      await _repository.getShifts();

      state = state.copyWith(
        shifts: shifts,
        filteredShifts: _filterShifts(
          shifts,
          state.search,
        ),
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // CREATE SHIFT
  // =============================================================

  Future<void> createShift(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
      );

      await _repository.createShift(
        shift,
      );

      state = state.copyWith(
        isSaving: false,
        clearError: true,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      // ---------------------------------------------------------
      // IMPORTANT
      // ---------------------------------------------------------
      // FormPage যেন বুঝতে পারে save failed হয়েছে।
      // ---------------------------------------------------------

      rethrow;
    }
  }

  // =============================================================
  // UPDATE SHIFT
  // =============================================================

  Future<void> updateShift(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
      );

      await _repository.updateShift(
        shift,
      );

      state = state.copyWith(
        isSaving: false,
        clearError: true,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // TOGGLE SHIFT STATUS
  // =============================================================

  Future<void> toggleShiftStatus(
      ShiftEntity shift,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
      );

      await _repository.updateShiftStatus(
        id: shift.id,
        isActive: !shift.isActive,
      );

      state = state.copyWith(
        isSaving: false,
        clearError: true,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE SHIFT
  // =============================================================

  Future<void> deleteShift(
      String id,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        clearError: true,
      );

      await _repository.deleteShift(
        id,
      );

      state = state.copyWith(
        isSaving: false,
        clearError: true,
      );

      await loadShifts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // GET SHIFT BY ID
  // =============================================================

  Future<void> getShiftById(
      String id,
      ) async {
    try {
      state = state.copyWith(
        clearError: true,
      );

      final shift =
      await _repository.getShiftById(
        id,
      );

      state = state.copyWith(
        selectedShift: shift,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  // =============================================================
  // SEARCH
  // =============================================================

  void search(
      String keyword,
      ) {
    final query =
    keyword.trim().toLowerCase();

    final filtered =
    _filterShifts(
      state.shifts,
      query,
    );

    state = state.copyWith(
      search: query,
      filteredShifts: filtered,
    );
  }

  // =============================================================
  // FILTER
  // =============================================================

  List<ShiftEntity> _filterShifts(
      List<ShiftEntity> shifts,
      String query,
      ) {
    if (query.trim().isEmpty) {
      return List<ShiftEntity>.from(
        shifts,
      );
    }

    final normalized =
    query.trim().toLowerCase();

    return shifts.where(
          (shift) {
        return shift.name
            .toLowerCase()
            .contains(normalized) ||
            shift.code
                .toLowerCase()
                .contains(normalized) ||
            shift.description
                .toLowerCase()
                .contains(normalized);
      },
    ).toList();
  }

  // =============================================================
  // CLEAR SELECTION
  // =============================================================

  void clearSelection() {
    state = state.copyWith(
      clearSelectedShift: true,
    );
  }

  // =============================================================
  // CLEAR ERROR
  // =============================================================

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> refresh() async {
    await loadShifts();
  }
}