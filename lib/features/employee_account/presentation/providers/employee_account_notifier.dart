import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/employee_account_entity.dart';
import '../../domain/repositories/employee_account_repository.dart';
import 'employee_account_state.dart';

class EmployeeAccountNotifier
    extends StateNotifier<EmployeeAccountState> {
  EmployeeAccountNotifier(this._repository)
      : super(EmployeeAccountState.initial());

  final EmployeeAccountRepository _repository;

  //==============================================================
  // LOAD ACCOUNTS
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

  //==============================================================
  // REFRESH
  //==============================================================

  Future<void> refresh() async {
    await loadAccounts();
  }

  //==============================================================
  // GET ACCOUNT BY ID
  //==============================================================

  Future<void> getAccountById(
      String id,
      ) async {
    try {
      final account = await _repository.getAccountById(
        id.trim(),
      );

      state = state.copyWith(
        selectedAccount: account,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================================================
  // CLEAR SELECTION
  //==============================================================

  void clearSelection() {
    state = state.copyWith(
      selectedAccount: null,
    );
  }

  //==============================================================
  // CREATE ACCOUNT
  //==============================================================

  Future<void> createAccount(
      EmployeeAccountEntity account,
      ) async {
    try {
      state = state.copyWith(
        isSaving: true,
        error: null,
      );

      await _repository.createAccount(account);

      state = state.copyWith(
        isSaving: false,
      );

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================================================
  // UPDATE ACCOUNT
  //==============================================================

  Future<void> updateAccount(
      EmployeeAccountEntity account,
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

      rethrow;
    }
  }

  //==============================================================
  // DELETE ACCOUNT
  //==============================================================

  Future<void> deleteAccount(
      String id,
      ) async {
    try {
      final accountId = id.trim();

      if (accountId.isEmpty) {
        throw Exception(
          'Employee account ID is required.',
        );
      }

      state = state.copyWith(
        error: null,
      );

      await _repository.deleteAccount(
        accountId,
      );

      await loadAccounts();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );

      rethrow;
    }
  }

  //==============================================================
  // TOGGLE ACTIVE
  //==============================================================

  Future<void> toggleActive(
      EmployeeAccountEntity account,
      ) async {
    final updated = account.copyWith(
      isActive: !account.isActive,
      updatedAt: DateTime.now(),
    );

    await updateAccount(updated);
  }

  //==============================================================
  // TOGGLE LOGIN PERMISSION
  //==============================================================

  Future<void> toggleCanLogin(
      EmployeeAccountEntity account,
      ) async {
    final updated = account.copyWith(
      canLogin: !account.canLogin,
      updatedAt: DateTime.now(),
    );

    await updateAccount(updated);
  }

  //==============================================================
  // TOGGLE ACCOUNT LOCK
  //==============================================================

  Future<void> toggleLock(
      EmployeeAccountEntity account,
      ) async {
    final shouldLock = !account.isLocked;

    final updated = account.copyWith(
      isLocked: shouldLock,
      accountLockedAt:
      shouldLock ? DateTime.now() : account.accountLockedAt,
      updatedAt: DateTime.now(),
    );

    await updateAccount(updated);
  }

  //==============================================================
  // SEARCH
  //==============================================================

  void search(
      String keyword,
      ) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      state = state.copyWith(
        search: '',
        filteredAccounts: state.accounts,
      );

      return;
    }

    final filtered = state.accounts.where(
          (account) {
        final username =
        account.username.toLowerCase();

        final employeeId =
        account.employeeId.toLowerCase();

        final employeeName =
            account.employeeName
                ?.toLowerCase() ??
                '';

        final departmentName =
            account.departmentName
                ?.toLowerCase() ??
                '';

        final companyName =
            account.companyName
                ?.toLowerCase() ??
                '';

        return username.contains(query) ||
            employeeId.contains(query) ||
            employeeName.contains(query) ||
            departmentName.contains(query) ||
            companyName.contains(query);
      },
    ).toList();

    state = state.copyWith(
      search: query,
      filteredAccounts: filtered,
    );
  }
}