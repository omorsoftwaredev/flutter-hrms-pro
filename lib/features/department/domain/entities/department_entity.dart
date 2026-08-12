import 'package:flutter/foundation.dart';

@immutable
class DepartmentEntity {
  const DepartmentEntity({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.phone,
    required this.email,
    required this.location,
    required this.isActive,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  final String id;
  final String companyId;

  final String name;
  final String description;
  final String phone;
  final String email;
  final String location;

  final bool isActive;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final String? createdBy;
  final String? updatedBy;

  DepartmentEntity copyWith({
    String? id,
    String? companyId,
    String? name,
    String? description,
    String? phone,
    String? email,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DepartmentEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DepartmentEntity('
        'id: $id, '
        'companyId: $companyId, '
        'name: $name, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy'
        ')';
  }
}