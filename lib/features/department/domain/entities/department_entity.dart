import 'package:flutter/foundation.dart';

@immutable
class DepartmentEntity {
  const DepartmentEntity({
    required this.id,
    required this.companyId,
    required this.code,
    required this.name,
    required this.description,
    required this.managerName,
    required this.phone,
    required this.email,
    required this.location,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;

  final String companyId;

  final String code;

  final String name;

  final String description;

  final String managerName;

  final String phone;

  final String email;

  final String location;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;

  DepartmentEntity copyWith({
    String? id,
    String? companyId,
    String? code,
    String? name,
    String? description,
    String? managerName,
    String? phone,
    String? email,
    String? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DepartmentEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      managerName: managerName ?? this.managerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    return 'DepartmentEntity(id: $id, name: $name)';
  }
}