import '../../domain/entities/shift_entity.dart';

class ShiftState {
  const ShiftState({
    this.shifts = const [],
    this.filteredShifts = const [],
    this.selectedShift,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  // =============================================================
  // DATA
  // =============================================================

  final List<ShiftEntity> shifts;

  final List<ShiftEntity> filteredShifts;

  final ShiftEntity? selectedShift;

  // =============================================================
  // STATUS
  // =============================================================

  final bool isLoading;

  final bool isSaving;

  // =============================================================
  // SEARCH
  // =============================================================

  final String search;

  // =============================================================
  // ERROR
  // =============================================================

  final String? error;

  // =============================================================
  // COPY WITH
  // =============================================================

  ShiftState copyWith({
    List<ShiftEntity>? shifts,
    List<ShiftEntity>? filteredShifts,
    ShiftEntity? selectedShift,

    bool clearSelectedShift = false,

    bool? isLoading,
    bool? isSaving,

    String? search,

    String? error,
    bool clearError = false,
  }) {
    return ShiftState(
      // -----------------------------------------------------------
      // SHIFTS
      // -----------------------------------------------------------

      shifts:
      shifts ?? this.shifts,

      // -----------------------------------------------------------
      // FILTERED SHIFTS
      // -----------------------------------------------------------

      filteredShifts:
      filteredShifts ?? this.filteredShifts,

      // -----------------------------------------------------------
      // SELECTED SHIFT
      // -----------------------------------------------------------

      selectedShift:
      clearSelectedShift
          ? null
          : selectedShift ?? this.selectedShift,

      // -----------------------------------------------------------
      // LOADING
      // -----------------------------------------------------------

      isLoading:
      isLoading ?? this.isLoading,

      // -----------------------------------------------------------
      // SAVING
      // -----------------------------------------------------------

      isSaving:
      isSaving ?? this.isSaving,

      // -----------------------------------------------------------
      // SEARCH
      // -----------------------------------------------------------

      search:
      search ?? this.search,

      // -----------------------------------------------------------
      // ERROR
      // -----------------------------------------------------------

      error:
      clearError
          ? null
          : error ?? this.error,
    );
  }
}