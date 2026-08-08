/// ===============================================================
/// Flutter HRMS Pro
/// Current User Provider
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_user.dart';
import 'user_type.dart';

class CurrentUserNotifier
    extends StateNotifier<CurrentUser?> {
  CurrentUserNotifier()
      : super(null);

  // =============================================================
  // Current User
  // =============================================================

  CurrentUser? get currentUser =>
      state;

  bool get isLoggedIn =>
      state != null;

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
  // Update
  // =============================================================

  void update(CurrentUser user) {
    state = user;
  }

  // =============================================================
  // User Type
  // =============================================================

  bool get isDeveloper =>
      state?.userType ==
          UserType.developer;

  bool get isCompany =>
      state?.userType ==
          UserType.company;

  bool get isHr =>
      state?.userType ==
          UserType.hr;

  bool get isSupervisor =>
      state?.userType ==
          UserType.supervisor;

  bool get isEmployee =>
      state?.userType ==
          UserType.employee;

  // =============================================================
  // Login User
  // =============================================================

  String get loginUser {
    if (state == null) {
      return '';
    }

    return state!.loginUser;
  }

  // =============================================================
  // Login Name
  // =============================================================

  String get loginName {
    return state?.loginName ?? '';
  }

  // =============================================================
  // Role
  // =============================================================

  String get role {
    return state?.role.name ?? '';
  }

  // =============================================================
  // Employee
  // =============================================================

  String get employeeId {
    return state?.employeeId ?? '';
  }

  // =============================================================
  // Company
  // =============================================================

  String get companyId {
    return state?.companyId ?? '';
  }
}

// ===============================================================
// Provider
// ===============================================================

final currentUserProvider =
StateNotifierProvider<
    CurrentUserNotifier,
    CurrentUser?>(
      (ref) {
    return CurrentUserNotifier();
  },
);