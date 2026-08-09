/// ===============================================================
/// Flutter HRMS Pro
/// Department Entity
///
/// Version : 1.0.0
/// ===============================================================

class Department {
  // =============================================================
  // BASIC
  // =============================================================

  final String id;

  final String companyId;

  final String name;

  final String? code;

  final String? description;

  // =============================================================
  // STATUS
  // =============================================================

  final bool isActive;

  // =============================================================
  // AUDIT
  // =============================================================

  final DateTime? createdAt;

  final DateTime? updatedAt;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const Department({
    required this.id,
    required this.companyId,
    required this.name,
    this.code,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // =============================================================
  // EMPTY
  // =============================================================

  const Department.empty()
      : id = '',
        companyId = '',
        name = '',
        code = null,
        description = null,
        isActive = true,
        createdAt = null,
        updatedAt = null;

  // =============================================================
  // FROM MAP
  // =============================================================

  factory Department.fromMap(
      Map<String, dynamic> map,
      ) {
    return Department(
      id: map['id']?.toString() ?? '',

      companyId:
      map['company_id']?.toString() ?? '',

      name:
      map['name']?.toString() ??
          map['department_name']?.toString() ??
          '',

      code:
      map['code']?.toString() ??
          map['department_code']?.toString(),

      description:
      map['description']?.toString(),

      isActive:
      map['is_active'] as bool? ?? true,

      createdAt:
      _parseDateTime(
        map['created_at'],
      ),

      updatedAt:
      _parseDateTime(
        map['updated_at'],
      ),
    );
  }

  // =============================================================
  // TO MAP
  // =============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'code': code,
      'description': description,
      'is_active': isActive,
      'created_at':
      createdAt?.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }

  // =============================================================
  // DISPLAY HELPERS
  // =============================================================

  String get displayName {
    return name.trim().isEmpty
        ? '-'
        : name;
  }

  String get displayCode {
    return code == null ||
        code!.trim().isEmpty
        ? '-'
        : code!;
  }

  // =============================================================
  // COPY WITH
  // =============================================================

  Department copyWith({
    String? id,
    String? companyId,
    String? name,
    String? code,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      companyId:
      companyId ?? this.companyId,
      name: name ?? this.name,
      code: code ?? this.code,
      description:
      description ?? this.description,
      isActive:
      isActive ?? this.isActive,
      createdAt:
      createdAt ?? this.createdAt,
      updatedAt:
      updatedAt ?? this.updatedAt,
    );
  }

  // =============================================================
  // VALIDATION
  // =============================================================

  bool get isValid {
    return id.isNotEmpty &&
        companyId.isNotEmpty &&
        name.trim().isNotEmpty;
  }

  // =============================================================
  // DATETIME
  // =============================================================

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return '''
Department(
  id: $id,
  companyId: $companyId,
  name: $name,
  code: $code,
  isActive: $isActive,
)
''';
  }
}