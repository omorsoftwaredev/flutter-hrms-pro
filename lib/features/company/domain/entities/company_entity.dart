import 'package:flutter/foundation.dart';

@immutable
class CompanyEntity {
  const CompanyEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.logoUrl,
    required this.website,
    required this.contactPerson,
    required this.taxNumber,
    required this.registrationNumber,
    required this.notes,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;

  final String name;

  final String email;

  final String phone;

  final String address;

  final String logoUrl;

  final String website;

  final String contactPerson;

  final String taxNumber;

  final String registrationNumber;

  final String notes;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;

  CompanyEntity copyWith({
    String? id,
    String? name,
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
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      contactPerson: contactPerson ?? this.contactPerson,
      taxNumber: taxNumber ?? this.taxNumber,
      registrationNumber:
      registrationNumber ?? this.registrationNumber,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CompanyEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CompanyEntity(id: $id, name: $name)';
  }
}