import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.code,
    required super.email,
    required super.phone,
    required super.address,
    required super.logoUrl,
    required super.website,
    required super.contactPerson,
    required super.taxNumber,
    required super.registrationNumber,
    required super.notes,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      website: json['website'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      taxNumber: json['tax_number'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      notes: json['notes'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'email': email,
      'phone': phone,
      'address': address,
      'logo_url': logoUrl,
      'website': website,
      'contact_person': contactPerson,
      'tax_number': taxNumber,
      'registration_number': registrationNumber,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CompanyEntity toEntity() => this;
}