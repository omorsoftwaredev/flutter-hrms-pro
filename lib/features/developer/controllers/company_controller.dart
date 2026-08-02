/// ===============================================================
/// Flutter HRMS Pro
/// Company Controller
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_model.dart';
import '../providers/company_provider.dart';

/// ===============================================================
/// Loading
/// ===============================================================

final companyLoadingProvider =
StateProvider<bool>(
      (ref) => false,
);

/// ===============================================================
/// Controller
/// ===============================================================

final companyControllerProvider =
Provider<CompanyController>(
      (ref) => CompanyController(ref),
);

class CompanyController {
  final Ref ref;

  CompanyController(this.ref);

  // =============================================================
  // Create
  // =============================================================

  Future<void> createCompany(
      CompanyModel company,
      ) async {
    ref
        .read(companyLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyRepositoryProvider)
          .createCompany(company);

      ref.invalidate(companyListProvider);
      ref.invalidate(totalCompanyProvider);
    } finally {
      ref
          .read(companyLoadingProvider.notifier)
          .state = false;
    }
  }

  // =============================================================
  // Update
  // =============================================================

  Future<void> updateCompany(
      CompanyModel company,
      ) async {
    ref
        .read(companyLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyRepositoryProvider)
          .updateCompany(company);

      ref.invalidate(companyListProvider);
      ref.invalidate(companyProvider(company.id!));
    } finally {
      ref
          .read(companyLoadingProvider.notifier)
          .state = false;
    }
  }

  // =============================================================
  // Delete
  // =============================================================

  Future<void> deleteCompany(
      String id,
      ) async {
    ref
        .read(companyLoadingProvider.notifier)
        .state = true;

    try {
      await ref
          .read(companyRepositoryProvider)
          .deleteCompany(id);

      ref.invalidate(companyListProvider);
      ref.invalidate(totalCompanyProvider);
    } finally {
      ref
          .read(companyLoadingProvider.notifier)
          .state = false;
    }
  }
}