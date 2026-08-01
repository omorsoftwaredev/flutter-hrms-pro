/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Repository
///
/// Version : 0.7.0
/// ===============================================================

import '../models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<DashboardModel> loadDashboard();
}