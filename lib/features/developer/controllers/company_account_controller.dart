/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Controller
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_account_model.dart';
import '../providers/company_account_provider.dart';

/// ===============================================================
/// Loading
/// ===============================================================

final companyAccountLoadingProvider =
StateProvider<bool>(
      (ref) => false,
);

/// ===============================================================
/// Controller
/// ===============================================================

final companyAccountControllerProvider =
Provider<CompanyAccountController>(
      (ref) => CompanyAccountController(ref),
);

class CompanyAccountController {
  final Ref ref;

  CompanyAccountController(this.ref);

  // =============================================================
  // Create
  // =============================================================

  Future<void> createAccount(
      CompanyAccountModel account,
      ) async {
    ref
        .read(companyAccountLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyAccountRepositoryProvider)
          .createAccount(account);

      ref.invalidate(
        companyAccountListProvider,
      );

      ref.invalidate(
        companyAccountsProvider(
          account.companyId,
        ),
      );
    } finally {
      ref
          .read(companyAccountLoadingProvider.notifier)
          .state = false;
    }
  }

  // =============================================================
  // Update
  // =============================================================

  Future<void> updateAccount(
      CompanyAccountModel account,
      ) async {
    ref
        .read(companyAccountLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyAccountRepositoryProvider)
          .updateAccount(account);

      ref.invalidate(
        companyAccountProvider(
          account.id!,
        ),
      );

      ref.invalidate(
        companyAccountListProvider,
      );

      ref.invalidate(
        companyAccountsProvider(
          account.companyId,
        ),
      );
    } finally {
      ref
          .read(companyAccountLoadingProvider.notifier)
          .state = false;
    }
  }

  // =============================================================
  // Delete
  // =============================================================

  Future<void> deleteAccount(
      String id,
      String companyId,
      ) async {
    ref
        .read(companyAccountLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyAccountRepositoryProvider)
          .deleteAccount(id);

      ref.invalidate(
        companyAccountListProvider,
      );

      ref.invalidate(
        companyAccountsProvider(
          companyId,
        ),
      );
    } finally {
      ref
          .read(companyAccountLoadingProvider.notifier)
          .state = false;
    }
  }
}