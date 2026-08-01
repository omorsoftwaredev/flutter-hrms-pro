/// ===============================================================
/// Flutter HRMS Pro
/// Current User Service
///
/// Version : 0.7.0
/// ===============================================================

import 'current_user.dart';

class CurrentUserService {
  CurrentUserService._();

  static CurrentUser? _currentUser;

  /// ===========================================================
  /// Current User
  /// ===========================================================

  static CurrentUser? get currentUser => _currentUser;

  /// ===========================================================
  /// Is Logged In
  /// ===========================================================

  static bool get isLoggedIn =>
      _currentUser != null &&
          _currentUser!.isLoggedIn;

  /// ===========================================================
  /// Set Current User
  /// ===========================================================

  static void setCurrentUser(CurrentUser user) {
    _currentUser = user;
  }

  /// ===========================================================
  /// Clear
  /// ===========================================================

  static void clear() {
    _currentUser = null;
  }

  /// ===========================================================
  /// Has User
  /// ===========================================================

  static bool get hasUser =>
      _currentUser != null;

  /// ===========================================================
  /// Company
  /// ===========================================================

  static String? get companyId =>
      _currentUser?.companyId;

  /// ===========================================================
  /// Employee
  /// ===========================================================

  static String? get employeeId =>
      _currentUser?.employeeId;

  /// ===========================================================
  /// User
  /// ===========================================================

  static String? get userId =>
      _currentUser?.userId;
}