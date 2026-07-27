import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/company_repository_impl.dart';
import '../../domain/repositories/company_repository.dart';
import 'company_notifier.dart';
import 'company_state.dart';

final companyRepositoryProvider =
Provider<CompanyRepository>(
      (ref) => CompanyRepositoryImpl(),
);

final companyProvider =
StateNotifierProvider<
    CompanyNotifier,
    CompanyState>(
      (ref) {
    return CompanyNotifier(
      ref.read(companyRepositoryProvider),
    );
  },
);