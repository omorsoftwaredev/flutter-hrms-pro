/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Status Page
///
/// File:
/// supervisor_department_status_page.dart
///
/// Version : 1.0.0
///
/// Purpose:
/// - Select company
/// - Show departments without supervisor assignment
/// - Show supervisor-wise assigned departments
/// - Show supervisor name
/// - Show assigned department names
/// - Refresh status
///
/// Existing Supervisor Provider / Notifier is used.
/// No existing Supervisor CRUD page is modified.
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

class SupervisorDepartmentStatusPage extends ConsumerStatefulWidget {
  const SupervisorDepartmentStatusPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorDepartmentStatusPage> createState() =>
      _SupervisorDepartmentStatusPageState();
}

class _SupervisorDepartmentStatusPageState
    extends ConsumerState<SupervisorDepartmentStatusPage>
    with SingleTickerProviderStateMixin {
  // =============================================================
  // SELECTED COMPANY
  // =============================================================

  String? _selectedCompanyId;

  // =============================================================
  // LOADING STATUS DATA
  // =============================================================

  bool _isLoadingStatus = false;

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

  List<Map<String, dynamic>> _supervisorStatus = [];

  // =============================================================
  // NOT ASSIGNED DEPARTMENTS
  // =============================================================

  List<Map<String, dynamic>> _notAssignedDepartments = [];

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

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    Future.microtask(() async {
      await ref
          .read(supervisorProvider.notifier)
          .loadCompanies();
    });
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
  // COMPANY CHANGE
  // =============================================================

  Future<void> _onCompanyChanged(
      String? companyId,
      ) async {
    if (companyId == null || companyId.trim().isEmpty) {
      setState(() {
        _selectedCompanyId = null;
        _clearStatusData();
      });

      return;
    }

    setState(() {
      _selectedCompanyId = companyId;
      _clearStatusData();
    });

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);

    if (!mounted) {
      return;
    }

    await _loadStatus();
  }

  // =============================================================
  // CLEAR STATUS DATA
  // =============================================================

  void _clearStatusData() {
    _supervisorStatus = [];
    _notAssignedDepartments = [];
  }

  // =============================================================
  // LOAD STATUS
  // =============================================================

  Future<void> _loadStatus() async {
    final companyId = _selectedCompanyId;

    if (companyId == null || companyId.trim().isEmpty) {
      return;
    }

    final state = ref.read(supervisorProvider);

    setState(() {
      _isLoadingStatus = true;
      _clearStatusData();
    });

    try {
      // ===========================================================
      // CREATE DEPARTMENT MAP
      //
      // departmentId -> department object
      // ===========================================================

      final Map<String, Map<String, dynamic>> departmentMap = {};

      for (final department in state.departments) {
        final id = department['id']?.toString().trim();

        if (id == null || id.isEmpty) {
          continue;
        }

        departmentMap[id] = department;
      }

      // ===========================================================
      // SUPERVISOR STATUS
      // ===========================================================

      final List<Map<String, dynamic>> supervisorStatus = [];

      // ===========================================================
      // ALL ASSIGNED DEPARTMENT IDS
      //
      // Used later to find departments without supervisor.
      // ===========================================================

      final Set<String> assignedDepartmentIds = {};

      // ===========================================================
      // LOOP THROUGH SUPERVISORS
      // ===========================================================

      for (final supervisor in state.supervisors) {
        final supervisorId =
        supervisor['id']?.toString().trim();

        if (supervisorId == null || supervisorId.isEmpty) {
          continue;
        }

        // ---------------------------------------------------------
        // SUPERVISOR NAME
        // ---------------------------------------------------------

        final supervisorName = _supervisorName(
          supervisor,
        );

        // ---------------------------------------------------------
        // LOAD ASSIGNMENTS
        // ---------------------------------------------------------

        final assignments = await ref
            .read(supervisorProvider.notifier)
            .loadSupervisorDepartmentAssignments(
          companyId: companyId,
          supervisorId: supervisorId,
        );

        // ---------------------------------------------------------
        // ASSIGNED DEPARTMENT IDS
        // ---------------------------------------------------------

        final List<String> departmentIds = [];

        final List<String> departmentNames = [];

        for (final assignment in assignments) {
          final departmentId =
          assignment['department_id']?.toString().trim();

          if (departmentId == null ||
              departmentId.isEmpty) {
            continue;
          }

          // -------------------------------------------------------
          // UNIQUE
          // -------------------------------------------------------

          if (!departmentIds.contains(departmentId)) {
            departmentIds.add(departmentId);
          }

          assignedDepartmentIds.add(
            departmentId,
          );

          // -------------------------------------------------------
          // FIND DEPARTMENT NAME
          // -------------------------------------------------------

          final department =
          departmentMap[departmentId];

          final departmentName =
          department?['name']?.toString().trim();

          if (departmentName != null &&
              departmentName.isNotEmpty &&
              !departmentNames.contains(
                departmentName,
              )) {
            departmentNames.add(
              departmentName,
            );
          }
        }

        // ---------------------------------------------------------
        // ADD SUPERVISOR STATUS
        // ---------------------------------------------------------

        supervisorStatus.add({
          'supervisor_id': supervisorId,
          'supervisor_name': supervisorName,
          'department_ids': departmentIds,
          'department_names': departmentNames,
        });
      }

      // ===========================================================
      // FIND NOT ASSIGNED DEPARTMENTS
      // ===========================================================

      final List<Map<String, dynamic>> notAssigned = [];

      for (final department in state.departments) {
        final departmentId =
        department['id']?.toString().trim();

        if (departmentId == null ||
            departmentId.isEmpty) {
          continue;
        }

        // ---------------------------------------------------------
        // NOT ASSIGNED
        // ---------------------------------------------------------

        if (!assignedDepartmentIds.contains(
          departmentId,
        )) {
          notAssigned.add(
            department,
          );
        }
      }

      // ===========================================================
      // UPDATE UI
      // ===========================================================

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

      _showMessage(
        'Unable to load supervisor department status.',
      );
    }
  }

  // =============================================================
  // SUPERVISOR NAME
  // =============================================================

  String _supervisorName(
      Map<String, dynamic> supervisor,
      ) {
    final employee =
    _nestedMap(
      supervisor,
      'employees',
    );

    if (employee == null) {
      return 'Unknown Supervisor';
    }

    // -----------------------------------------------------------
    // FULL NAME
    // -----------------------------------------------------------

    final fullName =
    employee['full_name']
        ?.toString()
        .trim();

    if (fullName != null &&
        fullName.isNotEmpty) {
      return fullName;
    }

    // -----------------------------------------------------------
    // FIRST NAME
    // -----------------------------------------------------------

    final firstName =
        employee['first_name']
            ?.toString()
            .trim() ??
            '';

    // -----------------------------------------------------------
    // LAST NAME
    // -----------------------------------------------------------

    final lastName =
        employee['last_name']
            ?.toString()
            .trim() ??
            '';

    final name =
    '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'Unknown Supervisor';
    }

    return name;
  }

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return null;
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    if (_selectedCompanyId == null ||
        _selectedCompanyId!.trim().isEmpty) {
      await ref
          .read(supervisorProvider.notifier)
          .loadCompanies();

      return;
    }

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(
      _selectedCompanyId!,
    );

    if (!mounted) {
      return;
    }

    await _loadStatus();
  }

  // =============================================================
  // SHOW MESSAGE
  // =============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final state =
    ref.watch(supervisorProvider);

    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F8FC),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,

        title: const Text(
          'Supervisor Department Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            _isLoadingStatus
                ? null
                : _refresh,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: _buildBody(
          state,
        ),
      ),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
      SupervisorState state,
      ) {
    // -----------------------------------------------------------
    // INITIAL LOADING
    // -----------------------------------------------------------

    if (state.isLoading &&
        state.companies.isEmpty) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    // -----------------------------------------------------------
    // ERROR
    // -----------------------------------------------------------

    if (state.hasError &&
        state.companies.isEmpty) {
      return _buildError(
        state,
      );
    }

    return SingleChildScrollView(
      padding:
      const EdgeInsets.all(
        16,
      ),

      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth: 950,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // =================================================
              // COMPANY SELECTOR
              // =================================================

              _buildCompanySelector(
                state,
              ),

              // =================================================
              // STATUS
              // =================================================

              if (_selectedCompanyId != null) ...[
                const SizedBox(
                  height: 16,
                ),

                _buildStatusSection(
                  state,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // COMPANY SELECTOR
  // =============================================================

  Widget _buildCompanySelector(
      SupervisorState state,
      ) {
    return _card(
      child:
      DropdownButtonFormField<String>(
        value: _selectedCompanyId,
        isExpanded: true,

        decoration:
        _inputDecoration(
          label: 'Company',
          icon:
          Icons.business_outlined,
        ),

        items:
        state.companies
            .map(
              (company) {
            final id =
            company['id']
                ?.toString();

            final name =
            company['name']
                ?.toString()
                .trim();

            if (id == null ||
                id.isEmpty) {
              return null;
            }

            return DropdownMenuItem<
                String>(
              value: id,

              child: Text(
                name == null ||
                    name.isEmpty
                    ? 'Unnamed Company'
                    : name,

                overflow:
                TextOverflow.ellipsis,
              ),
            );
          },
        )
            .whereType<
            DropdownMenuItem<
                String>>()
            .toList(),

        onChanged:
        _isLoadingStatus
            ? null
            : _onCompanyChanged,
      ),
    );
  }

  // =============================================================
  // STATUS SECTION
  // =============================================================

  Widget _buildStatusSection(
      SupervisorState state,
      ) {
    return _card(
      padding:
      const EdgeInsets.all(
        16,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xFF2196F3,
                  ).withValues(
                    alpha: .08,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),

                child: const Icon(
                  Icons.analytics_outlined,
                  color:
                  Color(
                    0xFF2196F3,
                  ),
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Department Assignment Status',
                      style:
                      TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Check supervisor and department assignments.',
                      style:
                      TextStyle(
                        fontSize: 11,
                        color:
                        Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // SUMMARY
          // =====================================================

          _buildSummary(
            state,
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // TABS
          // =====================================================

          Container(
            decoration:
            BoxDecoration(
              color:
              const Color(
                0xFFF1F3F7,
              ),

              borderRadius:
              BorderRadius.circular(
                11,
              ),
            ),

            child:
            TabBar(
              controller:
              _tabController,

              labelColor:
              const Color(
                0xFF2196F3,
              ),

              unselectedLabelColor:
              Colors.black54,

              indicator:
              BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  9,
                ),
              ),

              indicatorSize:
              TabBarIndicatorSize.tab,

              dividerColor:
              Colors.transparent,

              tabs: [
                Tab(
                  text:
                  'Not Assigned (${_notAssignedDepartments.length})',
                ),

                Tab(
                  text:
                  'Supervisor Departments (${_supervisorStatus.length})',
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // TAB CONTENT
          // =====================================================

          AnimatedBuilder(
            animation:
            _tabController,

            builder:
                (
                context,
                child,
                ) {
              if (_isLoadingStatus) {
                return const Padding(
                  padding:
                  EdgeInsets.all(
                    35,
                  ),

                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                );
              }

              if (_tabController.index ==
                  0) {
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

  Widget _buildSummary(
      SupervisorState state,
      ) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon:
            Icons.apartment_outlined,
            title:
            'Departments',
            value:
            state.departments.length
                .toString(),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: _summaryCard(
            icon:
            Icons.supervisor_account_outlined,
            title:
            'Supervisors',
            value:
            state.supervisors.length
                .toString(),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: _summaryCard(
            icon:
            Icons.warning_amber_outlined,
            title:
            'Not Assigned',
            value:
            _notAssignedDepartments
                .length
                .toString(),
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
      padding:
      const EdgeInsets.all(
        12,
      ),

      decoration:
      BoxDecoration(
        color:
        const Color(
          0xFFF9FAFC,
        ),

        borderRadius:
        BorderRadius.circular(
          12,
        ),

        border:
        Border.all(
          color:
          Colors.black12,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 20,
            color:
            const Color(
              0xFF2196F3,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,
            style:
            const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style:
            const TextStyle(
              fontSize: 10,
              color:
              Colors.black54,
            ),
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
        icon:
        Icons.check_circle_outline,
        title:
        'All departments are assigned',
        subtitle:
        'Every department has at least one supervisor.',
        iconColor:
        Colors.green,
      );
    }

    return Column(
      children:
      _notAssignedDepartments
          .map(
            (department) {
          final name =
          department['name']
              ?.toString()
              .trim();

          return Container(
            width:
            double.infinity,

            margin:
            const EdgeInsets.only(
              bottom: 8,
            ),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            decoration:
            BoxDecoration(
              color:
              Colors.orange
                  .withValues(
                alpha: .05,
              ),

              borderRadius:
              BorderRadius.circular(
                12,
              ),

              border:
              Border.all(
                color:
                Colors.orange
                    .withValues(
                  alpha: .20,
                ),
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.orange
                        .withValues(
                      alpha: .10,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),

                  child:
                  const Icon(
                    Icons
                        .apartment_outlined,
                    color:
                    Colors.orange,
                    size: 20,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [
                      Text(
                        name == null ||
                            name.isEmpty
                            ? 'Unnamed Department'
                            : name,

                        style:
                        const TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      const Text(
                        'No supervisor assigned',
                        style:
                        TextStyle(
                          fontSize: 10,
                          color:
                          Colors.orange,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons
                      .warning_amber_outlined,
                  color:
                  Colors.orange,
                  size: 20,
                ),
              ],
            ),
          );
        },
      )
          .toList(),
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
        icon:
        Icons.supervisor_account_outlined,
        title:
        'No supervisors found',
        subtitle:
        'There are no supervisors for this company.',
        iconColor:
        Colors.grey,
      );
    }

    return Column(
      children:
      _supervisorStatus
          .map(
            (item) {
          return _buildSupervisorCard(
            item,
          );
        },
      )
          .toList(),
    );
  }

  // =============================================================
  // SUPERVISOR CARD
  // =============================================================

  Widget _buildSupervisorCard(
      Map<String, dynamic> item,
      ) {
    final supervisorName =
        item['supervisor_name']
            ?.toString()
            .trim() ??
            'Unknown Supervisor';

    final departmentNames =
        (item['department_names']
        as List?)
            ?.map(
              (e) => e.toString(),
        )
            .toList() ??
            [];

    return Container(
      width:
      double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
      const EdgeInsets.all(
        14,
      ),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          13,
        ),

        border:
        Border.all(
          color:
          Colors.black12,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =====================================================
          // SUPERVISOR HEADER
          // =====================================================

          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xFF2196F3,
                  ).withValues(
                    alpha: .09,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),

                child:
                const Icon(
                  Icons
                      .supervisor_account_outlined,
                  color:
                  Color(
                    0xFF2196F3,
                  ),
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      supervisorName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      '${departmentNames.length} department(s) assigned',

                      style:
                      const TextStyle(
                        fontSize: 10,
                        color:
                        Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          const Divider(
            height: 1,
          ),

          const SizedBox(
            height: 12,
          ),

          // =====================================================
          // DEPARTMENTS
          // =====================================================

          if (departmentNames.isEmpty)
            Container(
              width:
              double.infinity,

              padding:
              const EdgeInsets.all(
                12,
              ),

              decoration:
              BoxDecoration(
                color:
                Colors.grey.shade50,

                borderRadius:
                BorderRadius.circular(
                  10,
                ),

                border:
                Border.all(
                  color:
                  Colors.black12,
                ),
              ),

              child:
              const Row(
                children: [
                  Icon(
                    Icons
                        .info_outline,
                    size: 18,
                    color:
                    Colors.black45,
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child:
                    Text(
                      'No department assigned.',
                      style:
                      TextStyle(
                        fontSize: 11,
                        color:
                        Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,

              children:
              departmentNames
                  .map(
                    (name) {
                  return Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal:
                      10,
                      vertical:
                      7,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      Colors.green
                          .withValues(
                        alpha: .08,
                      ),

                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),

                      border:
                      Border.all(
                        color:
                        Colors.green
                            .withValues(
                          alpha: .20,
                        ),
                      ),
                    ),

                    child:
                    Row(
                      mainAxisSize:
                      MainAxisSize.min,

                      children: [
                        const Icon(
                          Icons
                              .apartment_outlined,
                          size: 14,
                          color:
                          Colors.green,
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Text(
                          name,
                          style:
                          const TextStyle(
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  .toList(),
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
      width:
      double.infinity,

      padding:
      const EdgeInsets.all(
        28,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.grey.shade50,

        borderRadius:
        BorderRadius.circular(
          12,
        ),

        border:
        Border.all(
          color:
          Colors.black12,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            size: 42,
            color:
            iconColor,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,
            textAlign:
            TextAlign.center,

            style:
            const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            subtitle,
            textAlign:
            TextAlign.center,

            style:
            const TextStyle(
              fontSize: 11,
              color:
              Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width:
      double.infinity,

      padding:
      padding ??
          const EdgeInsets.all(
            14,
          ),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          14,
        ),

        border:
        Border.all(
          color:
          Colors.black12,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black
                .withValues(
              alpha: .03,
            ),

            blurRadius: 8,

            offset:
            const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: child,
    );
  }

  // =============================================================
  // INPUT DECORATION
  // =============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText:
      label,

      prefixIcon:
      Icon(
        icon,
        size: 20,
      ),

      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),

        borderSide:
        const BorderSide(
          color:
          Colors.black12,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),

        borderSide:
        const BorderSide(
          color:
          Color(
            0xFF2196F3,
          ),

          width: 1.4,
        ),
      ),

      filled: true,

      fillColor:
      const Color(
        0xFFFAFBFD,
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError(
      SupervisorState state,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline,
              size: 52,
              color:
              Colors.red,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              state.errorMessage ??
                  'Something went wrong.',

              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed:
              _refresh,

              icon:
              const Icon(
                Icons.refresh,
              ),

              label:
              const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}