/// ===============================================================
/// Flutter HRMS Pro
/// Current User Provider
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_user.dart';
import 'roles.dart';

/// ===============================================================
/// Current User Notifier
/// ===============================================================

class CurrentUserNotifier extends StateNotifier<CurrentUser?> {
  CurrentUserNotifier() : super(null);

  // =============================================================
  // Current User
  // =============================================================

  CurrentUser? get currentUser => state;

  bool get isLoggedIn => state != null;

  // =============================================================
  // Login
  // =============================================================

  void login(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // Logout
  // =============================================================

  void logout() {
    state = null;
  }

  // =============================================================
  // Refresh
  // =============================================================

  void refresh(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // Update Profile
  // =============================================================

  void update(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // Helpers
  // =============================================================

  bool get isDeveloper =>
      state?.role == UserRole.developer;

  bool get isSuperAdmin =>
      state?.role == UserRole.superAdmin;

  bool get isCompanyOwner =>
      state?.role == UserRole.companyOwner;

  bool get isSupervisor =>
      state?.role == UserRole.supervisor;

  bool get isEmployee =>
      state?.role == UserRole.employee;
}

/// ===============================================================
/// Provider
/// ===============================================================

final currentUserProvider =
StateNotifierProvider<CurrentUserNotifier, CurrentUser?>(
      (ref) => CurrentUserNotifier(),
);