import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/supervisor_department_repository_impl.dart';
import '../../domain/entities/supervisor_department_entity.dart';
import '../../domain/usecases/get_supervisor_department.dart';
import '../../domain/usecases/get_supervisor_departments.dart';
import '../../domain/usecases/is_department_assigned_to_supervisor.dart';

//=================================================================
// SUPABASE PROVIDER
//=================================================================

final supervisorDepartmentSupabaseProvider =
Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

//=================================================================
// REPOSITORY PROVIDER
//=================================================================

final supervisorDepartmentRepositoryProvider =
Provider<SupervisorDepartmentRepositoryImpl>((ref) {
  return SupervisorDepartmentRepositoryImpl(
    supabase: ref.read(
      supervisorDepartmentSupabaseProvider,
    ),
  );
});

//=================================================================
// USE CASE — GET SUPERVISOR DEPARTMENTS
//=================================================================

final getSupervisorDepartmentsProvider =
Provider<GetSupervisorDepartments>((ref) {
  return GetSupervisorDepartments(
    repository: ref.read(
      supervisorDepartmentRepositoryProvider,
    ),
  );
});

//=================================================================
// USE CASE — GET SINGLE SUPERVISOR DEPARTMENT
//=================================================================

final getSupervisorDepartmentProvider =
Provider<GetSupervisorDepartment>((ref) {
  return GetSupervisorDepartment(
    repository: ref.read(
      supervisorDepartmentRepositoryProvider,
    ),
  );
});

//=================================================================
// USE CASE — CHECK DEPARTMENT ASSIGNMENT
//=================================================================

final isDepartmentAssignedToSupervisorProvider =
Provider<IsDepartmentAssignedToSupervisor>((ref) {
  return IsDepartmentAssignedToSupervisor(
    repository: ref.read(
      supervisorDepartmentRepositoryProvider,
    ),
  );
});

//=================================================================
// SUPERVISOR DEPARTMENT PROVIDER
//=================================================================

final supervisorDepartmentProvider =
ChangeNotifierProvider<SupervisorDepartmentProvider>(
      (ref) {
    return SupervisorDepartmentProvider(
      getSupervisorDepartments: ref.read(
        getSupervisorDepartmentsProvider,
      ),
      getSupervisorDepartment: ref.read(
        getSupervisorDepartmentProvider,
      ),
      isDepartmentAssignedToSupervisor: ref.read(
        isDepartmentAssignedToSupervisorProvider,
      ),
      supabase: ref.read(
        supervisorDepartmentSupabaseProvider,
      ),
    );
  },
);

//=================================================================
// SUPERVISOR DEPARTMENT CHANGE NOTIFIER
//=================================================================

class SupervisorDepartmentProvider extends ChangeNotifier {
  final GetSupervisorDepartments _getSupervisorDepartments;

  final GetSupervisorDepartment _getSupervisorDepartment;

  final IsDepartmentAssignedToSupervisor
  _isDepartmentAssignedToSupervisor;

  final SupabaseClient _supabase;
//=================================================================
// CLEAR SELECTED DEPARTMENT
//=================================================================

  void clearSelection() {
    _selectedDepartment = null;
    notifyListeners();
  }
  SupervisorDepartmentProvider({
    required GetSupervisorDepartments getSupervisorDepartments,
    required GetSupervisorDepartment getSupervisorDepartment,
    required IsDepartmentAssignedToSupervisor
    isDepartmentAssignedToSupervisor,
    required SupabaseClient supabase,
  })  : _getSupervisorDepartments =
      getSupervisorDepartments,
        _getSupervisorDepartment =
            getSupervisorDepartment,
        _isDepartmentAssignedToSupervisor =
            isDepartmentAssignedToSupervisor,
        _supabase = supabase;

  //=================================================================
  // STATE
  //=================================================================

  List<SupervisorDepartmentEntity> _departments = [];

  List<SupervisorDepartmentEntity> _filteredDepartments = [];

  SupervisorDepartmentEntity? _selectedDepartment;

  bool _isLoading = false;

  bool _isCheckingAssignment = false;

  bool _isLoadingSupervisors = false;

  String? _error;

  String? _supervisorListError;

  String _searchKeyword = '';

  //=================================================================
  // SUPERVISOR LIST STATE
  //=================================================================

  List<dynamic> _supervisors = [];

  //=================================================================
  // GETTERS
  //=================================================================

  List<SupervisorDepartmentEntity> get departments =>
      List.unmodifiable(_departments);

  List<SupervisorDepartmentEntity> get filteredDepartments =>
      List.unmodifiable(_filteredDepartments);

  SupervisorDepartmentEntity? get selectedDepartment =>
      _selectedDepartment;

  //=================================================================
  // SUPERVISOR LIST GETTER
  //=================================================================

  List<dynamic> get supervisors =>
      List.unmodifiable(_supervisors);

  //=================================================================
  // SELECTED DEPARTMENT ID
  //=================================================================

  String? get selectedDepartmentId =>
      _selectedDepartment?.departmentId;

  //=================================================================
  // SELECTED SUPERVISOR-DEPARTMENT ROW ID
  //=================================================================

  String? get selectedSupervisorDepartmentId =>
      _selectedDepartment?.id;

  //=================================================================
  // LOADING
  //=================================================================

  bool get isLoading => _isLoading;

  //=================================================================
  // SUPERVISOR LIST LOADING
  //=================================================================

  bool get isLoadingSupervisors =>
      _isLoadingSupervisors;

  //=================================================================
  // ASSIGNMENT CHECKING
  //=================================================================

  bool get isCheckingAssignment =>
      _isCheckingAssignment;

  //=================================================================
  // ERROR
  //=================================================================

  String? get error => _error;

  bool get hasError =>
      _error != null && _error!.isNotEmpty;

  //=================================================================
  // SUPERVISOR LIST ERROR
  //=================================================================

  String? get supervisorListError =>
      _supervisorListError;

  bool get hasSupervisorListError =>
      _supervisorListError != null &&
          _supervisorListError!.isNotEmpty;

  //=================================================================
  // SEARCH
  //=================================================================

  String get searchKeyword =>
      _searchKeyword;

  //=================================================================
  // STATUS
  //=================================================================

  bool get hasDepartments =>
      _departments.isNotEmpty;

  bool get hasFilteredDepartments =>
      _filteredDepartments.isNotEmpty;

  bool get hasSelectedDepartment =>
      _selectedDepartment != null;

  //=================================================================
  // STATUS — SUPERVISORS
  //=================================================================

  bool get hasSupervisors =>
      _supervisors.isNotEmpty;

  //=================================================================
  // GET SUPERVISOR LIST
  //
  // SOURCE:
  // public.supervisors
  //
  // FILTER:
  // company_id = companyId
  // is_active = true
  //
  // RETURNS:
  // List<dynamic>
  //=================================================================

  Future<List<dynamic>> getSupervisorList({
    required String companyId,
  }) async {
    //=================================================================
    // DEBUG — START
    //=================================================================

    debugPrint('');
    debugPrint('============================================================');
    debugPrint('SUPERVISOR LIST QUERY DEBUG - START');
    debugPrint('============================================================');

    final normalizedCompanyId = companyId.trim();

    debugPrint(
      '[Supervisor] Original Company ID: "$companyId"',
    );

    debugPrint(
      '[Supervisor] Normalized Company ID: "$normalizedCompanyId"',
    );

    debugPrint(
      '[Supervisor] Company ID Length: ${normalizedCompanyId.length}',
    );

    //=================================================================
    // VALIDATE COMPANY ID
    //=================================================================

    if (normalizedCompanyId.isEmpty) {
      debugPrint(
        '[Supervisor] ERROR: Company ID is empty.',
      );

      _supervisorListError =
      'Company ID is required.';

      _supervisors = [];

      notifyListeners();

      debugPrint(
        '============================================================',
      );
      debugPrint(
        'SUPERVISOR LIST QUERY DEBUG - END',
      );
      debugPrint(
        '============================================================',
      );
      debugPrint('');

      return [];
    }

    //=================================================================
    // LOADING
    //=================================================================

    _isLoadingSupervisors = true;
    _supervisorListError = null;

    notifyListeners();

    //=================================================================
    // QUERY DEBUG
    //=================================================================

    debugPrint('');
    debugPrint(
      '[Supervisor] Supabase Table: supervisors',
    );

    debugPrint(
      '[Supervisor] SELECT columns:',
    );

    debugPrint(
      '''
    id,
    employee_id,
    company_id,
    department_id,
    supervisors_code,
    is_active,
    created_at,
    updated_at,
    created_by,
    updated_by
    ''',
    );

    debugPrint(
      '[Supervisor] WHERE company_id = "$normalizedCompanyId"',
    );

    debugPrint(
      '[Supervisor] WHERE is_active = true',
    );

    debugPrint(
      '[Supervisor] ORDER BY created_at ASC',
    );

    //=================================================================
    // EXECUTE QUERY
    //=================================================================

    try {
      debugPrint('');
      debugPrint(
        '[Supervisor] Executing Supabase query...',
      );

      final response = await _supabase
          .from('supervisors')
          .select(
        '''
      id,
      employee_id,
      company_id,
      department_id,
      supervisors_code,
      is_active,
      created_at,
      updated_at,
      created_by,
      updated_by
      ''',
      )
          .eq(
        'company_id',
        normalizedCompanyId,
      )
          .eq(
        'is_active',
        true,
      )
          .order(
        'created_at',
        ascending: true,
      );

      //=================================================================
      // RAW RESPONSE DEBUG
      //=================================================================

      debugPrint('');
      debugPrint(
        '[Supervisor] Supabase query completed successfully.',
      );

      debugPrint(
        '[Supervisor] Response runtime type: ${response.runtimeType}',
      );

      debugPrint(
        '[Supervisor] Response row count: ${response.length}',
      );

      debugPrint('');
      debugPrint(
        '[Supervisor] RAW RESPONSE:',
      );

      debugPrint(
        response.toString(),
      );

      //=================================================================
      // RESULT
      //=================================================================

      final result =
      List<dynamic>.from(response);

      debugPrint('');
      debugPrint(
        '[Supervisor] Converted result count: ${result.length}',
      );

      if (result.isEmpty) {
        debugPrint('');
        debugPrint(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
        );

        debugPrint(
          '[Supervisor] WARNING: No supervisor records found.',
        );

        debugPrint(
          '[Supervisor] Company ID used: "$normalizedCompanyId"',
        );

        debugPrint(
          '[Supervisor] is_active filter: true',
        );

        debugPrint(
          '[Supervisor] Possible causes:',
        );

        debugPrint(
          '1. No supervisor exists for this company.',
        );

        debugPrint(
          '2. company_id does not match.',
        );

        debugPrint(
          '3. is_active is false.',
        );

        debugPrint(
          '4. RLS policy is blocking the rows.',
        );

        debugPrint(
          '5. Current Supabase user does not have access.',
        );

        debugPrint(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
        );
      }

      //=================================================================
      // PRINT EACH SUPERVISOR
      //=================================================================

      if (result.isNotEmpty) {
        debugPrint('');
        debugPrint(
          '[Supervisor] SUPERVISOR RECORDS:',
        );

        for (int index = 0;
        index < result.length;
        index++) {
          final supervisor =
          result[index];

          debugPrint(
            '------------------------------------------------------------',
          );

          debugPrint(
            '[Supervisor][$index] $supervisor',
          );

          if (supervisor is Map) {
            debugPrint(
              '[Supervisor][$index] id: '
                  '${supervisor['id']}',
            );

            debugPrint(
              '[Supervisor][$index] employee_id: '
                  '${supervisor['employee_id']}',
            );

            debugPrint(
              '[Supervisor][$index] company_id: '
                  '${supervisor['company_id']}',
            );

            debugPrint(
              '[Supervisor][$index] department_id: '
                  '${supervisor['department_id']}',
            );

            debugPrint(
              '[Supervisor][$index] supervisors_code: '
                  '${supervisor['supervisors_code']}',
            );

            debugPrint(
              '[Supervisor][$index] is_active: '
                  '${supervisor['is_active']}',
            );
          }
        }

        debugPrint(
          '------------------------------------------------------------',
        );
      }

      //=================================================================
      // SAVE
      //=================================================================

      _supervisors = result;

      debugPrint('');
      debugPrint(
        '[Supervisor] _supervisors updated.',
      );

      debugPrint(
        '[Supervisor] Stored supervisor count: '
            '${_supervisors.length}',
      );

      return List<dynamic>.unmodifiable(
        _supervisors,
      );
    } catch (error, stackTrace) {
      //=================================================================
      // ERROR DEBUG
      //=================================================================

      debugPrint('');
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );

      debugPrint(
        '[Supervisor] SUPABASE QUERY ERROR',
      );

      debugPrint(
        '[Supervisor] Error type: ${error.runtimeType}',
      );

      debugPrint(
        '[Supervisor] Error: $error',
      );

      debugPrint(
        '[Supervisor] Company ID: "$normalizedCompanyId"',
      );

      debugPrint('');
      debugPrint(
        '[Supervisor] STACK TRACE:',
      );

      debugPrint(
        stackTrace.toString(),
      );

      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );

      _supervisorListError =
          _mapError(error);

      _supervisors = [];

      debugPrint(
        '[Supervisor] Mapped error: $_supervisorListError',
      );

      return [];
    } finally {
      _isLoadingSupervisors = false;

      notifyListeners();

      debugPrint('');
      debugPrint(
        '[Supervisor] Loading completed.',
      );

      debugPrint(
        '[Supervisor] Final supervisor count: '
            '${_supervisors.length}',
      );

      debugPrint(
        '============================================================',
      );

      debugPrint(
        'SUPERVISOR LIST QUERY DEBUG - END',
      );

      debugPrint(
        '============================================================',
      );

      debugPrint('');
    }
  }

  //=================================================================
  // CLEAR SUPERVISOR LIST
  //=================================================================

  void clearSupervisorList() {
    if (_supervisors.isEmpty &&
        _supervisorListError == null) {
      return;
    }

    _supervisors = [];

    _supervisorListError = null;

    notifyListeners();
  }

  //=================================================================
  // LOAD SUPERVISOR DEPARTMENTS
  //=================================================================

  Future<void> loadDepartments({
    required String supervisorId,
    required String companyId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result =
      await _getSupervisorDepartments(
        supervisorId: supervisorId,
        companyId: companyId,
      );

      _departments =
      List<SupervisorDepartmentEntity>.from(
        result,
      );

      _applySearch();

      //=============================================================
      // KEEP CURRENT SELECTION IF STILL AVAILABLE
      //=============================================================

      if (_selectedDepartment != null) {
        final selectedDepartmentId =
            _selectedDepartment!.departmentId;

        final stillExists =
        _departments.any(
              (department) =>
          department.departmentId ==
              selectedDepartmentId,
        );

        if (!stillExists) {
          _selectedDepartment = null;
        }
      }
    } catch (error) {
      _error = _mapError(error);

      _departments = [];

      _filteredDepartments = [];

      _selectedDepartment = null;

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD SINGLE SUPERVISOR DEPARTMENT
  //=================================================================

  Future<SupervisorDepartmentEntity?>
  loadDepartment({
    required String supervisorDepartmentId,
  }) async {
    _clearError();

    try {
      return await _getSupervisorDepartment(
        supervisorDepartmentId:
        supervisorDepartmentId,
      );
    } catch (error) {
      _error = _mapError(error);

      notifyListeners();

      return null;
    }
  }

  //=================================================================
  // SELECT DEPARTMENT
  //=================================================================

  void selectDepartment(
      SupervisorDepartmentEntity? department,
      ) {
    _selectedDepartment = department;

    notifyListeners();
  }

  //=================================================================
  // SELECT BY DEPARTMENT ID
  //=================================================================

  void selectDepartmentById(
      String departmentId,
      ) {
    final normalizedId =
    departmentId.trim();

    SupervisorDepartmentEntity? department;

    for (final item in _departments) {
      if (item.departmentId ==
          normalizedId) {
        department = item;
        break;
      }
    }

    _selectedDepartment = department;

    notifyListeners();
  }

  //=================================================================
  // SELECT BY SUPERVISOR-DEPARTMENT ROW ID
  //=================================================================

  void selectSupervisorDepartmentById(
      String supervisorDepartmentId,
      ) {
    final normalizedId =
    supervisorDepartmentId.trim();

    SupervisorDepartmentEntity? department;

    for (final item in _departments) {
      if (item.id == normalizedId) {
        department = item;
        break;
      }
    }

    _selectedDepartment = department;

    notifyListeners();
  }

  //=================================================================
  // CLEAR SELECTED DEPARTMENT
  //=================================================================

  void clearSelectedDepartment() {
    if (_selectedDepartment == null) {
      return;
    }

    _selectedDepartment = null;

    notifyListeners();
  }

  //=================================================================
  // SEARCH DEPARTMENTS
  //=================================================================

  void search(
      String keyword,
      ) {
    final normalizedKeyword =
    keyword.trim();

    if (_searchKeyword ==
        normalizedKeyword) {
      return;
    }

    _searchKeyword =
        normalizedKeyword;

    _applySearch();

    notifyListeners();
  }

  //=================================================================
  // CLEAR SEARCH
  //=================================================================

  void clearSearch() {
    if (_searchKeyword.isEmpty) {
      return;
    }

    _searchKeyword = '';

    _applySearch();

    notifyListeners();
  }

  //=================================================================
  // CHECK DEPARTMENT ASSIGNMENT
  //=================================================================

  Future<bool> isDepartmentAssigned({
    required String supervisorId,
    required String departmentId,
    required String companyId,
  }) async {
    _isCheckingAssignment = true;

    _clearError();

    notifyListeners();

    try {
      return await _isDepartmentAssignedToSupervisor(
        supervisorId: supervisorId,
        departmentId: departmentId,
        companyId: companyId,
      );
    } catch (error) {
      _error = _mapError(error);

      return false;
    } finally {
      _isCheckingAssignment = false;

      notifyListeners();
    }
  }

  //=================================================================
  // REFRESH DEPARTMENTS
  //=================================================================

  Future<void> refresh({
    required String supervisorId,
    required String companyId,
  }) async {
    await loadDepartments(
      supervisorId: supervisorId,
      companyId: companyId,
    );
  }

  //=================================================================
  // REFRESH SUPERVISORS
  //=================================================================

  Future<List<dynamic>> refreshSupervisorList({
    required String companyId,
  }) async {
    return await getSupervisorList(
      companyId: companyId,
    );
  }

  //=================================================================
  // RESET
  //=================================================================

  void reset() {
    _departments = [];

    _filteredDepartments = [];

    _selectedDepartment = null;

    _supervisors = [];

    _isLoading = false;

    _isLoadingSupervisors = false;

    _isCheckingAssignment = false;

    _error = null;

    _supervisorListError = null;

    _searchKeyword = '';

    notifyListeners();
  }

  //=================================================================
  // APPLY SEARCH
  //=================================================================

  void _applySearch() {
    if (_searchKeyword.isEmpty) {
      _filteredDepartments =
      List<SupervisorDepartmentEntity>.from(
        _departments,
      );

      return;
    }

    final query =
    _searchKeyword.toLowerCase();

    _filteredDepartments =
        _departments.where(
              (department) {
            final departmentName =
            department.departmentName
                .toLowerCase();

            final departmentCode =
            department.departmentCode
                .toLowerCase();

            return departmentName.contains(query) ||
                departmentCode.contains(query);
          },
        ).toList();
  }

  //=================================================================
  // SET LOADING
  //=================================================================

  void _setLoading(
      bool value,
      ) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  //=================================================================
  // PRIVATE CLEAR ERROR
  //=================================================================

  void _clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
  }

  //=================================================================
  // PUBLIC CLEAR ERROR
  //=================================================================

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;

    notifyListeners();
  }

  //=================================================================
  // CLEAR SUPERVISOR LIST ERROR
  //=================================================================

  void clearSupervisorListError() {
    if (_supervisorListError == null) {
      return;
    }

    _supervisorListError = null;

    notifyListeners();
  }

  //=================================================================
  // ERROR MAPPING
  //=================================================================

  String _mapError(
      Object error,
      ) {
    final message =
    error.toString().trim();

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    if (message.startsWith(
      'Exception:',
    )) {
      return message
          .replaceFirst(
        'Exception:',
        '',
      )
          .trim();
    }

    return message;
  }

  //=================================================================
  // DISPOSE
  //=================================================================

  @override
  void dispose() {
    super.dispose();
  }
}