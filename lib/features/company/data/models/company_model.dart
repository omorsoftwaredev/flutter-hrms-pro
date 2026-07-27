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

  factory CompanyModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return CompanyModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      logoUrl: map['logo_url'] ?? '',
      website: map['website'] ?? '',
      contactPerson: map['contact_person'] ?? '',
      taxNumber: map['tax_number'] ?? '',
      registrationNumber:
      map['registration_number'] ?? '',
      notes: map['notes'] ?? '',
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(
        map['created_at'],
      ),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(
        map['updated_at'],
      )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
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
      'registration_number':
      registrationNumber,
      'notes': notes,
      'is_active': isActive,
      'created_at':
      createdAt.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }

  factory CompanyModel.fromEntity(
      CompanyEntity entity,
      ) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      logoUrl: entity.logoUrl,
      website: entity.website,
      contactPerson: entity.contactPerson,
      taxNumber: entity.taxNumber,
      registrationNumber:
      entity.registrationNumber,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id,
      name: name,
      code: code,
      email: email,
      phone: phone,
      address: address,
      logoUrl: logoUrl,
      website: website,
      contactPerson: contactPerson,
      taxNumber: taxNumber,
      registrationNumber:
      registrationNumber,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? code,
    String? email,
    String? phone,
    String? address,
    String? logoUrl,
    String? website,
    String? contactPerson,
    String? taxNumber,
    String? registrationNumber,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      contactPerson:
      contactPerson ?? this.contactPerson,
      taxNumber: taxNumber ?? this.taxNumber,
      registrationNumber:
      registrationNumber ??
          this.registrationNumber,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}