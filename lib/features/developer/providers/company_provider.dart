/// ===============================================================
/// Flutter HRMS Pro
/// Company Provider
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_model.dart';
import '../repositories/company_repository.dart';

/// ===============================================================
/// Repository
/// ===============================================================

final companyRepositoryProvider =
Provider<CompanyRepository>(
      (ref) => CompanyRepository(),
);

/// ===============================================================
/// Company List
/// ===============================================================

final companyListProvider =
FutureProvider<List<CompanyModel>>(
      (ref) async {
    return ref
        .read(companyRepositoryProvider)
        .getCompanies();
  },
);

/// ===============================================================
/// Total Company
/// ===============================================================

final totalCompanyProvider =
FutureProvider<int>(
      (ref) async {
    return ref
        .read(companyRepositoryProvider)
        .totalCompanies();
  },
);

/// ===============================================================
/// Company Details
/// ===============================================================

final companyProvider =
FutureProvider.family<
    CompanyModel?,
    String>((ref, id) async {
  return ref
      .read(companyRepositoryProvider)
      .getCompany(id);
});