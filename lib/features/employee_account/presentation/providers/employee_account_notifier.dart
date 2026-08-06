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
  // Load Accounts
  //==============================================================

  Future<void> loadAccounts() async {

    state = state.copyWith(
      isLoading: true,
      error: null,
    );


    try {

      final accounts =
      await _repository.getAccounts();


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
  // Get By ID
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



  void clearSelection() {

    state = state.copyWith(
      selectedAccount: null,
    );

  }



  //==============================================================
  // Create
  //==============================================================

  Future<void> createAccount(
      EmployeeAccountEntity account,
      ) async {


    state = state.copyWith(
      isSaving: true,
      error: null,
    );


    try {

      await _repository.createAccount(account);


      await loadAccounts();


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



  //==============================================================
  // Update
  //==============================================================

  Future<void> updateAccount(
      EmployeeAccountEntity account,
      ) async {


    state = state.copyWith(
      isSaving: true,
      error: null,
    );


    try {

      await _repository.updateAccount(account);


      await loadAccounts();


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


      rethrow;

    }

  }





  //==============================================================
  // Toggle Active
  //==============================================================

  Future<void> toggleActive(
      EmployeeAccountEntity account,
      ) async {


    final updated =
    account.copyWith(

      isActive:
      !account.isActive,

      updatedAt:
      DateTime.now(),

    );


    await updateAccount(updated);

  }





  //==============================================================
  // Toggle Login Permission
  //==============================================================

  Future<void> toggleCanLogin(
      EmployeeAccountEntity account,
      ) async {


    final updated =
    account.copyWith(

      canLogin:
      !account.canLogin,

      updatedAt:
      DateTime.now(),

    );


    await updateAccount(updated);

  }





  //==============================================================
  // Toggle Lock
  //==============================================================

  Future<void> toggleLock(
      EmployeeAccountEntity account,
      ) async {


    final locked =
    !account.isLocked;


    final updated =
    account.copyWith(

      isLocked: locked,


      accountLockedAt:
      locked
          ? DateTime.now()
          : null,


      updatedAt:
      DateTime.now(),

    );


    await updateAccount(updated);

  }





  //==============================================================
  // Search
  //==============================================================

  void search(
      String keyword,
      ) {


    final value =
    keyword
        .trim()
        .toLowerCase();



    if (value.isEmpty) {


      state = state.copyWith(

        search: '',

        filteredAccounts:
        state.accounts,

      );


      return;

    }





    final filtered =
    state.accounts.where((e) {


      final username =
      e.username.toLowerCase();



      final employeeId =
      e.employeeId.toLowerCase();



      final employeeName =
          e.employeeName
              ?.toLowerCase()
              ?? '';



      final departmentName =
          e.departmentName
              ?.toLowerCase()
              ?? '';



      final companyName =
          e.companyName
              ?.toLowerCase()
              ?? '';




      return username.contains(value) ||

          employeeId.contains(value) ||

          employeeName.contains(value) ||

          departmentName.contains(value) ||

          companyName.contains(value);



    }).toList();




    state = state.copyWith(

      search: keyword,

      filteredAccounts:
      filtered,

    );

  }

}