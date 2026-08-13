/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Status Page
///
/// File:
/// supervisor_department_status_page.dart
///
/// Version : 2.0.0
///
/// Purpose:
/// - Company is NOT selected manually
/// - Company ID comes from logged-in user
/// - SelectCompany is automatically called using current user's companyId
/// - Show departments without supervisor assignment
/// - Show supervisor-wise assigned departments
/// - Show supervisor name
/// - Show assigned department names
/// - Refresh status
///
/// Company source:
/// currentUserProvider -> CurrentUser.companyId
///
/// Existing Supervisor Provider / Notifier is used.
/// No existing Supervisor CRUD page is modified.
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

class SupervisorDepartmentStatusPage extends ConsumerStatefulWidget {
  const SupervisorDepartmentStatusPage({super.key});

  @override
  ConsumerState<SupervisorDepartmentStatusPage> createState() =>
      _SupervisorDepartmentStatusPageState();
}

class _SupervisorDepartmentStatusPageState
    extends ConsumerState<SupervisorDepartmentStatusPage>
    with SingleTickerProviderStateMixin {
  // =============================================================
  // LOADING STATUS DATA
  // =============================================================

  bool _isLoadingStatus = false;

  // =============================================================
  // INITIALIZATION
  // =============================================================

  bool _isInitialized = false;

  // =============================================================
  // CURRENT COMPANY ID
  //
  // Company ID NEVER comes from a dropdown.
  //
  // It always comes from:
  // currentUserProvider -> user.companyId
  // =============================================================

  String? get _companyId {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      return null;
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      return null;
    }

    return companyId;
  }

  // =============================================================
  // SUPERVISOR STATUS DATA
  //
  // Example:
  //
  // {
  //   supervisorId: "...",
  //   supervisorName: "Rahim",
  //   departmentIds: [...],
  //   departmentNames: [...]
  // }
  // =============================================================

  List<Map<String, dynamic>> _supervisorStatus = <Map<String, dynamic>>[];

  // =============================================================
  // NOT ASSIGNED DEPARTMENTS
  // =============================================================

  List<Map<String, dynamic>> _notAssignedDepartments = <Map<String, dynamic>>[];

  // =============================================================
  // TAB CONTROLLER
  // =============================================================

  late TabController _tabController;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(_initialize);
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  // =============================================================
  // INITIALIZE
  //
  // Logged-in user's company ID is used automatically.
  // =============================================================

  Future<void> _initialize() async {
    if (!mounted) {
      return;
    }

    final companyId = _companyId;

    // -----------------------------------------------------------
    // USER NOT READY
    // -----------------------------------------------------------

    if (companyId == null || companyId.isEmpty) {
      return;
    }

    // -----------------------------------------------------------
    // PREVENT DUPLICATE INITIALIZATION
    // -----------------------------------------------------------

    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    // -----------------------------------------------------------
    // LOAD COMPANY-SCOPED DATA
    // -----------------------------------------------------------

    await ref.read(supervisorProvider.notifier).selectCompany(companyId);

    if (!mounted) {
      return;
    }

    // -----------------------------------------------------------
    // LOAD STATUS
    // -----------------------------------------------------------

    await _loadStatus();
  }

  // =============================================================
  // CLEAR STATUS DATA
  // =============================================================

  void _clearStatusData() {
    _supervisorStatus = <Map<String, dynamic>>[];

    _notAssignedDepartments = <Map<String, dynamic>>[];
  }

  // =============================================================
  // LOAD STATUS
  // =============================================================

  Future<void> _loadStatus() async {
    final companyId = _companyId;

    // -----------------------------------------------------------
    // COMPANY VALIDATION
    // -----------------------------------------------------------

    if (companyId == null || companyId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
          _clearStatusData();
        });
      }

      return;
    }

    final state = ref.read(supervisorProvider);

    if (mounted) {
      setState(() {
        _isLoadingStatus = true;
        _clearStatusData();
      });
    }

    try {
      // =========================================================
      // CREATE DEPARTMENT MAP
      //
      // departmentId -> department object
      // =========================================================

      final Map<String, Map<String, dynamic>> departmentMap =
          <String, Map<String, dynamic>>{};

      for (final department in state.departments) {
        final id = department['id']?.toString().trim();

        if (id == null || id.isEmpty) {
          continue;
        }

        departmentMap[id] = department;
      }

      // =========================================================
      // SUPERVISOR STATUS
      // =========================================================

      final List<Map<String, dynamic>> supervisorStatus =
          <Map<String, dynamic>>[];

      // =========================================================
      // ALL ASSIGNED DEPARTMENT IDS
      //
      // Used later to find departments without supervisor.
      // =========================================================

      final Set<String> assignedDepartmentIds = <String>{};

      // =========================================================
      // LOOP THROUGH SUPERVISORS
      // =========================================================

      for (final supervisor in state.supervisors) {
        final supervisorId = supervisor['id']?.toString().trim();

        if (supervisorId == null || supervisorId.isEmpty) {
          continue;
        }

        // -------------------------------------------------------
        // SUPERVISOR NAME
        // -------------------------------------------------------

        final supervisorName = _supervisorName(supervisor);

        // -------------------------------------------------------
        // LOAD ASSIGNMENTS
        //
        // Company ID automatically comes from logged-in user.
        // -------------------------------------------------------

        final assignments = await ref
            .read(supervisorProvider.notifier)
            .loadSupervisorDepartmentAssignments(
              companyId: companyId,
              supervisorId: supervisorId,
            );

        // -------------------------------------------------------
        // ASSIGNED DEPARTMENT IDS
        // -------------------------------------------------------

        final List<String> departmentIds = <String>[];

        final List<String> departmentNames = <String>[];

        for (final assignment in assignments) {
          final departmentId = assignment['department_id']?.toString().trim();

          if (departmentId == null || departmentId.isEmpty) {
            continue;
          }

          // -----------------------------------------------------
          // UNIQUE DEPARTMENT ID
          // -----------------------------------------------------

          if (!departmentIds.contains(departmentId)) {
            departmentIds.add(departmentId);
          }

          // -----------------------------------------------------
          // GLOBAL ASSIGNED DEPARTMENT SET
          // -----------------------------------------------------

          assignedDepartmentIds.add(departmentId);

          // -----------------------------------------------------
          // FIND DEPARTMENT NAME
          // -----------------------------------------------------

          final department = departmentMap[departmentId];

          final departmentName = department?['name']?.toString().trim();

          if (departmentName != null &&
              departmentName.isNotEmpty &&
              !departmentNames.contains(departmentName)) {
            departmentNames.add(departmentName);
          }
        }

        // -------------------------------------------------------
        // ADD SUPERVISOR STATUS
        // -------------------------------------------------------

        supervisorStatus.add(<String, dynamic>{
          'supervisor_id': supervisorId,
          'supervisor_name': supervisorName,
          'department_ids': departmentIds,
          'department_names': departmentNames,
        });
      }

      // =========================================================
      // FIND NOT ASSIGNED DEPARTMENTS
      // =========================================================

      final List<Map<String, dynamic>> notAssigned = <Map<String, dynamic>>[];

      for (final department in state.departments) {
        final departmentId = department['id']?.toString().trim();

        if (departmentId == null || departmentId.isEmpty) {
          continue;
        }

        // -------------------------------------------------------
        // NOT ASSIGNED
        // -------------------------------------------------------

        if (!assignedDepartmentIds.contains(departmentId)) {
          notAssigned.add(department);
        }
      }

      // =========================================================
      // UPDATE UI
      // =========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _supervisorStatus = supervisorStatus;

        _notAssignedDepartments = notAssigned;

        _isLoadingStatus = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingStatus = false;
      });

      _showMessage('Unable to load supervisor department status.');
    }
  }

  // =============================================================
  // SUPERVISOR NAME
  // =============================================================

  String _supervisorName(Map<String, dynamic> supervisor) {
    final employee = _nestedMap(supervisor, 'employees');

    if (employee == null) {
      return 'Unknown Supervisor';
    }

    // -----------------------------------------------------------
    // FULL NAME
    // -----------------------------------------------------------

    final fullName = employee['full_name']?.toString().trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    // -----------------------------------------------------------
    // FIRST NAME
    // -----------------------------------------------------------

    final firstName = employee['first_name']?.toString().trim() ?? '';

    // -----------------------------------------------------------
    // LAST NAME
    // -----------------------------------------------------------

    final lastName = employee['last_name']?.toString().trim() ?? '';

    final name = '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'Unknown Supervisor';
    }

    return name;
  }

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // REFRESH
  //
  // Same logged-in user's company is used.
  // No company selection.
  // =============================================================

  Future<void> _refresh() async {
    final companyId = _companyId;

    if (companyId == null || companyId.isEmpty) {
      _showMessage('Company information was not found for the logged-in user.');

      return;
    }

    if (_isLoadingStatus) {
      return;
    }

    // -----------------------------------------------------------
    // CLEAR OLD STATUS
    // -----------------------------------------------------------

    if (mounted) {
      setState(() {
        _clearStatusData();
      });
    }

    // -----------------------------------------------------------
    // RELOAD COMPANY-SCOPED DATA
    // -----------------------------------------------------------

    await ref.read(supervisorProvider.notifier).selectCompany(companyId);

    if (!mounted) {
      return;
    }

    // -----------------------------------------------------------
    // RELOAD STATUS
    // -----------------------------------------------------------

    await _loadStatus();
  }

  // =============================================================
  // SHOW MESSAGE
  // =============================================================

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supervisorProvider);

    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supervisor Department Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              'Department assignment status',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _isLoadingStatus || user == null ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(child: _buildBody(state, user)),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(SupervisorState state, dynamic user) {
    // -----------------------------------------------------------
    // CURRENT USER LOADING
    // -----------------------------------------------------------

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // -----------------------------------------------------------
    // COMPANY ID VALIDATION
    // -----------------------------------------------------------

    final companyId = user.companyId?.toString().trim() ?? '';

    if (companyId.isEmpty) {
      return _buildNoCompanyState();
    }

    // -----------------------------------------------------------
    // INITIAL DATA LOADING
    // -----------------------------------------------------------

    if ((state.isLoading || _isLoadingStatus) &&
        state.departments.isEmpty &&
        state.supervisors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // -----------------------------------------------------------
    // CONTENT
    // -----------------------------------------------------------

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // PAGE HEADER
              // =================================================
              const Text(
                'Department Assignment Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 5),

              const Text(
                'View supervisor and department assignments for your company.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const SizedBox(height: 18),

              // =================================================
              // STATUS
              // =================================================
              _buildStatusSection(state),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // NO COMPANY STATE
  // =============================================================

  Widget _buildNoCompanyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.business_outlined, size: 52, color: Colors.orange),

            const SizedBox(height: 12),

            const Text(
              'Company information not found.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 6),

            const Text(
              'The logged-in user is not associated with a company.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _initialize,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // STATUS SECTION
  // =============================================================

  Widget _buildStatusSection(SupervisorState state) {
    return _card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF2196F3),
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department Assignment Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Check supervisor and department assignments.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =====================================================
          // SUMMARY
          // =====================================================
          _buildSummary(state),

          const SizedBox(height: 16),

          // =====================================================
          // TABS
          // =====================================================
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F7),
              borderRadius: BorderRadius.circular(11),
            ),
            child: TabBar(
              controller: _tabController,

              labelColor: const Color(0xFF2196F3),

              unselectedLabelColor: Colors.black54,

              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),

              indicatorSize: TabBarIndicatorSize.tab,

              dividerColor: Colors.transparent,

              tabs: [
                Tab(text: 'Not Assigned (${_notAssignedDepartments.length})'),

                Tab(
                  text: 'Supervisor Departments (${_supervisorStatus.length})',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // TAB CONTENT
          // =====================================================
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              if (_isLoadingStatus) {
                return const Padding(
                  padding: EdgeInsets.all(35),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_tabController.index == 0) {
                return _buildNotAssignedTab();
              }

              return _buildSupervisorDepartmentsTab();
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUMMARY
  // =============================================================

  Widget _buildSummary(SupervisorState state) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon: Icons.apartment_outlined,
            title: 'Departments',
            value: state.departments.length.toString(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _summaryCard(
            icon: Icons.supervisor_account_outlined,
            title: 'Supervisors',
            value: state.supervisors.length.toString(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _summaryCard(
            icon: Icons.warning_amber_outlined,
            title: 'Not Assigned',
            value: _notAssignedDepartments.length.toString(),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SUMMARY CARD
  // =============================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2196F3)),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TAB 1
  //
  // NOT ASSIGNED SUPERVISOR DEPARTMENT
  // =============================================================

  Widget _buildNotAssignedTab() {
    if (_notAssignedDepartments.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'All departments are assigned',
        subtitle: 'Every department has at least one supervisor.',
        iconColor: Colors.green,
      );
    }

    return Column(
      children: _notAssignedDepartments.map((department) {
        final name = department['name']?.toString().trim();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withValues(alpha: .20)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.apartment_outlined,
                  color: Colors.orange,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name == null || name.isEmpty
                          ? 'Unnamed Department'
                          : name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'No supervisor assigned',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.warning_amber_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // =============================================================
  // TAB 2
  //
  // SUPERVISOR DEPARTMENTS
  // =============================================================

  Widget _buildSupervisorDepartmentsTab() {
    if (_supervisorStatus.isEmpty) {
      return _buildEmptyState(
        icon: Icons.supervisor_account_outlined,
        title: 'No supervisors found',
        subtitle: 'There are no supervisors for this company.',
        iconColor: Colors.grey,
      );
    }

    return Column(
      children: _supervisorStatus.map((item) {
        return _buildSupervisorCard(item);
      }).toList(),
    );
  }

  // =============================================================
  // SUPERVISOR CARD
  // =============================================================

  Widget _buildSupervisorCard(Map<String, dynamic> item) {
    final supervisorName =
        item['supervisor_name']?.toString().trim() ?? 'Unknown Supervisor';

    final departmentNames =
        (item['department_names'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // SUPERVISOR HEADER
          // =====================================================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.supervisor_account_outlined,
                  color: Color(0xFF2196F3),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supervisorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '${departmentNames.length} department(s) assigned',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(height: 1),

          const SizedBox(height: 12),

          // =====================================================
          // DEPARTMENTS
          // =====================================================
          if (departmentNames.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.black45),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'No department assigned.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: departmentNames.map((name) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: .20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.apartment_outlined,
                        size: 14,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: iconColor),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError(SupervisorState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 52, color: Colors.red),

            const SizedBox(height: 12),

            Text(
              state.errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
