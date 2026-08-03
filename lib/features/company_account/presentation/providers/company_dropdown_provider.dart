//===============================================================
// lib/features/company_account/presentation/providers/company_dropdown_provider.dart
//===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';

final companyDropdownProvider = Provider((ref) {
  final state = ref.watch(companyProvider);

  return state.companies;
});