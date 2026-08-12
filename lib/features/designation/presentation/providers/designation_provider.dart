import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/designation_repository_impl.dart';
import '../../domain/repositories/designation_repository.dart';
import 'designation_notifier.dart';
import 'designation_state.dart';

final designationRepositoryProvider =
Provider<DesignationRepository>((ref) {
  return DesignationRepositoryImpl(ref);
});

final designationProvider =
StateNotifierProvider<
    DesignationNotifier,
    DesignationState>((ref) {
  return DesignationNotifier(
    ref.read(designationRepositoryProvider),
  );
});