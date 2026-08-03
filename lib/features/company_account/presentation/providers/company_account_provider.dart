// ===============================================================
// Flutter HRMS Pro
// Company Account Provider
//
// Version : 1.0.0
// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/company_account_repository_impl.dart';
import '../../domain/repositories/company_account_repository.dart';
import 'company_account_notifier.dart';
import 'company_account_state.dart';

final companyAccountRepositoryProvider =
Provider<CompanyAccountRepository>(
      (ref) => CompanyAccountRepositoryImpl(),
);

final companyAccountProvider =
StateNotifierProvider<
    CompanyAccountNotifier,
    CompanyAccountState>(
      (ref) => CompanyAccountNotifier(
    ref.read(companyAccountRepositoryProvider),
  ),
);