// ===============================================================
// Flutter HRMS Pro
// Company Account Notifier
//
// Version : 2.0.0
// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_account_entity.dart';
import '../../domain/repositories/company_account_repository.dart';
import 'company_account_state.dart';

class CompanyAccountNotifier
    extends StateNotifier<CompanyAccountState> {
  CompanyAccountNotifier(this._repository)
      : super(const CompanyAccountState());

  final CompanyAccountRepository _repository;

  //==============================================================
  // Load Accounts
  //==============================================================

  Future<void> loadAccounts() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final accounts = await _repository.getAccounts();

      state = state.copyWith(
        isLoading: false,
        accounts: accounts,
        filteredAccounts: accounts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadAccounts();
  }

  //==============================================================
  // Create
  //==============================================================

  Future<void> createAccount(
      CompanyAccountEntity account,
      ) async {
    try {
      state = state.copyWith(isSaving: true);

      await _repository.createAccount(account);

      state = state.copyWith(isSaving: false);

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow; // <-- এটা যোগ করো
    }
  }
  //==============================================================
  // Update
  //==============================================================

  Future<void> updateAccount(
      CompanyAccountEntity account,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.updateAccount(account);

      state = state.copyWith(
        isSaving: false,
      );

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow; // <-- catch এর ভিতরে থাকবে
    }
  }

  //==============================================================
  // Delete
  //==============================================================

  Future<void> deleteAccount(
      String id,
      ) async {
    try {
      await _repository.deleteAccount(id);

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  //==============================================================
  // Active / Inactive
  //==============================================================

  Future<void> toggleAccountStatus(
      CompanyAccountEntity account,
      ) async {
    if (account.id == null) {
      state = state.copyWith(
        error: 'Account ID not found.',
      );
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      await _repository.updateAccountStatus(
        id: account.id!,
        isActive: !account.isActive,
      );

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  //==============================================================
  // Get By Id
  //==============================================================

  Future<void> getAccountById(
      String id,
      ) async {
    try {
      final account =
      await _repository.getAccountById(id);

      state = state.copyWith(
        selectedAccount: account,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  //==============================================================
  // Search
  //==============================================================

  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredAccounts: state.accounts,
      );
      return;
    }

    final filtered = state.accounts.where((account) {
      return account.username
          .toLowerCase()
          .contains(query);
    }).toList();

    state = state.copyWith(
      search: query,
      filteredAccounts: filtered,
    );
  }

  //==============================================================
  // Clear Selection
  //==============================================================

  void clearSelection() {
    state = state.copyWith(
      selectedAccount: null,
    );
  }
}