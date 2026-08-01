/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Provider
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/current_user.dart';

/// ===============================================================
/// Dashboard User Notifier
///
/// Holds the currently logged-in user.
/// Dashboard statistics should use a separate provider.
/// ===============================================================

class DashboardNotifier extends StateNotifier<CurrentUser?> {
  DashboardNotifier() : super(null);

  // =============================================================
  // User
  // =============================================================

  CurrentUser? get currentUser => state;

  bool get isLoggedIn => state != null;

  // =============================================================
  // Set User
  // =============================================================

  void setUser(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // Refresh User
  // =============================================================

  void refresh(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // Update User
  // =============================================================

  void update(CurrentUser user) {
    state = state?.copyWith(
      userId: user.userId,
      employeeId: user.employeeId,
      companyId: user.companyId,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
    ) ??
        user;
  }

  // =============================================================
  // Logout
  // =============================================================

  void clearUser() {
    state = null;
  }
}

/// ===============================================================
/// Provider
/// ===============================================================

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, CurrentUser?>(
      (ref) => DashboardNotifier(),
);