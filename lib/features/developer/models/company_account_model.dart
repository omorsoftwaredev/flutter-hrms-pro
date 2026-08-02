/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Model
///
/// Version : 1.0.0
/// ===============================================================

class CompanyAccountModel {
  final String? id;

  final String companyId;

  final String username;

  final String email;

  final String mobile;

  final String password;

  final bool isActive;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const CompanyAccountModel({
    this.id,
    required this.companyId,
    required this.username,
    required this.email,
    required this.mobile,
    required this.password,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyAccountModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return CompanyAccountModel(
      id: map['id']?.toString(),
      companyId: map['company_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      password: map['password'] ?? '',
      isActive: map['is_active'] ?? true,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'username': username,
      'email': email,
      'mobile': mobile,
      'password': password,
      'is_active': isActive,
      'created_at':
      createdAt?.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }

  CompanyAccountModel copyWith({
    String? id,
    String? companyId,
    String? username,
    String? email,
    String? mobile,
    String? password,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyAccountModel(
      id: id ?? this.id,
      companyId:
      companyId ?? this.companyId,
      username:
      username ?? this.username,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password:
      password ?? this.password,
      isActive:
      isActive ?? this.isActive,
      createdAt:
      createdAt ?? this.createdAt,
      updatedAt:
      updatedAt ?? this.updatedAt,
    );
  }
}