// lib/features/company/presentation/providers/company_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import 'company_state.dart';

class CompanyNotifier extends StateNotifier<CompanyState> {
  CompanyNotifier(this._repository)
      : super(const CompanyState());

  final CompanyRepository _repository;
  Future<void> toggleCompanyStatus(
      CompanyEntity company,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateCompanyStatus(
        id: company.id,
        isActive: !company.isActive,
      );

      state = state.copyWith(
        isSaving: false,
      );

      await loadCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }


  Future<void> loadCompanies() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final companies =
      await _repository.getCompanies();

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

  Future<void> refresh() async {
    await loadCompanies();
  }

  Future<void> createCompany(
      CompanyEntity company,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createCompany(company);

      state = state.copyWith(
        isSaving: false,
      );

      await loadCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateCompany(
      CompanyEntity company,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateCompany(company);

      state = state.copyWith(
        isSaving: false,
      );

      await loadCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteCompany(
      String id,
      ) async {
    try {
      await _repository.deleteCompany(id);

      await loadCompanies();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> getCompanyById(
      String id,
      ) async {
    try {
      final company =
      await _repository.getCompanyById(id);

      state = state.copyWith(
        selectedCompany: company,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

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
      return company.name
          .toLowerCase()
          .contains(query) ||
          company.email
              .toLowerCase()
              .contains(query) ||
          company.phone
              .toLowerCase()
              .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredCompanies: filtered,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedCompany: null,
    );
  }
}