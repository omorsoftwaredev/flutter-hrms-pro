/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Provider
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_account_model.dart';
import '../repositories/company_account_repository.dart';

/// ===============================================================
/// Repository
/// ===============================================================

final companyAccountRepositoryProvider =
Provider<CompanyAccountRepository>(
      (ref) => CompanyAccountRepository(),
);

/// ===============================================================
/// Account List
/// ===============================================================

final companyAccountListProvider =
FutureProvider<List<CompanyAccountModel>>(
      (ref) async {
    return ref
        .read(companyAccountRepositoryProvider)
        .getAccounts();
  },
);

/// ===============================================================
/// Company Account List
/// ===============================================================

final companyAccountsProvider =
FutureProvider.family<
    List<CompanyAccountModel>,
    String>(
      (ref, companyId) async {
    return ref
        .read(companyAccountRepositoryProvider)
        .getCompanyAccounts(companyId);
  },
);

/// ===============================================================
/// Account Details
/// ===============================================================

final companyAccountProvider =
FutureProvider.family<
    CompanyAccountModel?,
    String>(
      (ref, id) async {
    return ref
        .read(companyAccountRepositoryProvider)
        .getAccount(id);
  },
);

/// ===============================================================
/// Username Exists
/// ===============================================================

final usernameExistsProvider =
FutureProvider.family<bool, String>(
      (ref, username) async {
    return ref
        .read(companyAccountRepositoryProvider)
        .usernameExists(username);
  },
);

/// ===============================================================
/// Email Exists
/// ===============================================================

final emailExistsProvider =
FutureProvider.family<bool, String>(
      (ref, email) async {
    return ref
        .read(companyAccountRepositoryProvider)
        .emailExists(email);
  },
);