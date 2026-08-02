/// ===============================================================
/// Flutter HRMS Pro
/// Company Model
///
/// Version : 1.0.0
/// ===============================================================

class CompanyModel {
  final String? id;

  final String code;
  final String name;

  final String? phone;
  final String? email;
  final String? website;
  final String? address;

  final String? contactPerson;
  final String? logoUrl;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompanyModel({
    this.id,
    required this.code,
    required this.name,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.contactPerson,
    this.logoUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return CompanyModel(
      id: map['id']?.toString(),
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      address: map['address'],
      contactPerson: map['contact_person'],
      logoUrl: map['logo_url'],
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
      'code': code,
      'name': name,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'contact_person': contactPerson,
      'logo_url': logoUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CompanyModel copyWith({
    String? id,
    String? code,
    String? name,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? contactPerson,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      contactPerson:
      contactPerson ?? this.contactPerson,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}