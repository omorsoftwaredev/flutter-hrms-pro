/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Data Provider
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_model.dart';
import '../repositories/dashboard_repository.dart';
import '../repositories/dashboard_repository_impl.dart';

/// ===============================================================
/// Repository Provider
/// ===============================================================

final dashboardRepositoryProvider =
Provider<DashboardRepository>(
      (ref) => DashboardRepositoryImpl(),
);

/// ===============================================================
/// Dashboard Data Notifier
/// ===============================================================

class DashboardDataNotifier
    extends StateNotifier<AsyncValue<DashboardModel>> {
  DashboardDataNotifier(this._repository)
      : super(
    AsyncData(
      DashboardModel.empty(),
    ),
  );

  final DashboardRepository _repository;

  /// =============================================================
  /// Load Dashboard
  /// =============================================================

  Future<void> load() async {
    try {
      state = const AsyncLoading();

      final dashboard =
      await _repository.loadDashboard();

      state = AsyncData(dashboard);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }

  /// =============================================================
  /// Refresh Dashboard
  /// =============================================================

  Future<void> refresh() async {
    await load();
  }

  /// =============================================================
  /// Clear Dashboard
  /// =============================================================

  void clear() {
    state = AsyncData(
      DashboardModel.empty(),
    );
  }
}

/// ===============================================================
/// Dashboard Provider
/// ===============================================================

final dashboardDataProvider = StateNotifierProvider<
    DashboardDataNotifier,
    AsyncValue<DashboardModel>>(
      (ref) {
    return DashboardDataNotifier(
      ref.watch(
        dashboardRepositoryProvider,
      ),
    );
  },
);