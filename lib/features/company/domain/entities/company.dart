// lib/features/company/domain/entities/company.dart

class Company {
  const Company({
    required this.id,
    required this.name,
    required this.code,
    required this.email,
    required this.phone,
    required this.address,
    required this.isActive,
  });

  final String id;
  final String name;
  final String code;
  final String email;
  final String phone;
  final String address;
  final bool isActive;
}