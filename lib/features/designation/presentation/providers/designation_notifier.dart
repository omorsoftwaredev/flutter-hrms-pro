import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/designation_entity.dart';
import '../../domain/repositories/designation_repository.dart';
import 'designation_state.dart';

class DesignationNotifier
    extends StateNotifier<DesignationState> {
  DesignationNotifier(this._repository)
      : super(const DesignationState());

  final DesignationRepository _repository;

  // =============================================================
  // LOAD DESIGNATIONS
  // =============================================================

  Future<void> loadDesignations() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final designations =
      await _repository.getDesignations();

      state = state.copyWith(
        designations: designations,
        filteredDesignations: designations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // CREATE DESIGNATION
  // =============================================================

  Future<void> createDesignation(
      DesignationEntity designation,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createDesignation(
        designation,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // UPDATE DESIGNATION
  // =============================================================

  Future<void> updateDesignation(
      DesignationEntity designation,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateDesignation(
        designation,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // TOGGLE DESIGNATION STATUS
  // =============================================================

  Future<void> toggleDesignationStatus(
      DesignationEntity designation,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateDesignationStatus(
        id: designation.id,
        isActive: !designation.isActive,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // DELETE DESIGNATION
  // =============================================================

  Future<void> deleteDesignation(
      String id,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.deleteDesignation(id);

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // GET DESIGNATION BY ID
  // =============================================================

  Future<void> getDesignationById(
      String id,
      ) async {
    try {
      final designation =
      await _repository.getDesignationById(id);

      state = state.copyWith(
        selectedDesignation: designation,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // SEARCH
  // =============================================================

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredDesignations: state.designations,
      );

      return;
    }

    final filtered =
    state.designations.where((designation) {
      return designation.name
          .toLowerCase()
          .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredDesignations: filtered,
    );
  }

  // =============================================================
  // CLEAR SELECTION
  // =============================================================

  void clearSelection() {
    state = state.copyWith(
      selectedDesignation: null,
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> refresh() async {
    await loadDesignations();
  }
}