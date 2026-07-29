import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/designation_entity.dart';
import '../../domain/repositories/designation_repository.dart';

import 'designation_state.dart';

class DesignationNotifier
    extends StateNotifier<
        DesignationState> {
  DesignationNotifier(
      this._repository)
      : super(
    const DesignationState(),
  );

  final DesignationRepository
  _repository;

  Future<void> loadDesignations() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final list =
      await _repository
          .getDesignations();

      state = state.copyWith(
        designations: list,
        filteredDesignations: list,
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
    await loadDesignations();
  }

  Future<void> createDesignation(
      DesignationEntity entity) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository
          .createDesignation(entity);

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> updateDesignation(
      DesignationEntity entity) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository
          .updateDesignation(entity);

      state = state.copyWith(
        isSaving: false,
      );

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> deleteDesignation(
      String id) async {
    try {
      await _repository
          .deleteDesignation(id);

      await loadDesignations();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> getDesignationById(
      String id) async {
    try {
      final item =
      await _repository
          .getDesignationById(id);

      state = state.copyWith(
        selectedDesignation: item,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  void clearSelection() {
    state = state.copyWith(
      selectedDesignation: null,
    );
  }

  void search(String keyword) {
    final query =
    keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredDesignations:
        state.designations,
      );
      return;
    }

    final filtered = state.designations
        .where(
          (designation) =>
      designation.name
          .toLowerCase()
          .contains(query) ||
          designation.code
              .toLowerCase()
              .contains(query),
    )
        .toList();

    state = state.copyWith(
      search: query,
      filteredDesignations: filtered,
    );
  }
}