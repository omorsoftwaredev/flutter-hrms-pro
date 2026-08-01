/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Model
///
/// Version : 0.7.0
/// ===============================================================

class DashboardModel {
  final int companies;

  final int departments;

  final int employees;

  final int present;

  final int absent;

  final int late;

  const DashboardModel({
    required this.companies,
    required this.departments,
    required this.employees,
    required this.present,
    required this.absent,
    required this.late,
  });

  factory DashboardModel.empty() {
    return const DashboardModel(
      companies: 0,
      departments: 0,
      employees: 0,
      present: 0,
      absent: 0,
      late: 0,
    );
  }

  DashboardModel copyWith({
    int? companies,
    int? departments,
    int? employees,
    int? present,
    int? absent,
    int? late,
  }) {
    return DashboardModel(
      companies: companies ?? this.companies,
      departments: departments ?? this.departments,
      employees: employees ?? this.employees,
      present: present ?? this.present,
      absent: absent ?? this.absent,
      late: late ?? this.late,
    );
  }
}