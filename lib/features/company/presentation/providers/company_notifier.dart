import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import 'company_state.dart';

class CompanyNotifier extends StateNotifier<CompanyState> {
  CompanyNotifier(this._repository)
      : super(const CompanyState());

  final CompanyRepository _repository;

  //==============================
  // Load Companies
  //==============================

  Future<void> loadCompanies() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final companies = await _repository.getCompanies();

      state = state.copyWith(
        companies: companies,
        filteredCompanies: companies,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  //==============================
  // Search
  //==============================

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredCompanies: state.companies,
      );
      return;
    }

    final filtered = state.companies.where((company) {
      return company.name.toLowerCase().contains(query) ||
          (company.code ?? '').toLowerCase().contains(query) ||
          (company.phone ?? '').toLowerCase().contains(query) ||
          (company.email ?? '').toLowerCase().contains(query);
    }).toList();

    state = state.copyWith(
      search: keyword,
      filteredCompanies: filtered,
    );
  }

  //==============================
  // Create Company
  //==============================

  Future<void> createCompany(
      CompanyEntity company,
      ) async {
    state = state.copyWith(
      isSaving: true,
      error: null,
    );

    try {
      await _repository.createCompany(company);

      await loadCompanies();

      state = state.copyWith(
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================
  // Update Company
  //==============================

  Future<void> updateCompany(
      CompanyEntity company,
      ) async {
    state = state.copyWith(
      isSaving: true,
      error: null,
    );

    try {
      await _repository.updateCompany(company);

      await loadCompanies();

      state = state.copyWith(
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================
  // Delete Company
  //==============================

  Future<void> deleteCompany(
      String id,
      ) async {
    state = state.copyWith(
      isSaving: true,
      error: null,
    );

    try {
      await _repository.deleteCompany(id);

      await loadCompanies();

      state = state.copyWith(
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================
  // Select Company
  //==============================

  void selectCompany(
      CompanyEntity company,
      ) {
    state = state.copyWith(
      selectedCompany: company,
    );
  }

  //==============================
  // Clear Selection
  //==============================

  void clearSelection() {
    state = state.copyWith(
      selectedCompany: null,
    );
  }

  //==============================
  // Refresh
  //==============================

  Future<void> refresh() async {
    await loadCompanies();
  }
}