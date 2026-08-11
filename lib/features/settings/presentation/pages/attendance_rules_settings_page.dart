/// ===============================================================
/// Flutter HRMS Pro
///
/// Basic Attendance Rules Settings
///
/// Version : 1.0.0
///
/// Features:
/// - Company-wise attendance rules
/// - Logged-in company automatically detected
/// - No company dropdown
/// - Responsive UI
/// - Light / Dark theme compatible
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/services/supabase_service.dart';

class AttendanceRulesSettingsPage
    extends ConsumerStatefulWidget {
  const AttendanceRulesSettingsPage({
    super.key,
  });

  @override
  ConsumerState<AttendanceRulesSettingsPage>
  createState() =>
      _AttendanceRulesSettingsPageState();
}

class _AttendanceRulesSettingsPageState
    extends ConsumerState<
        AttendanceRulesSettingsPage> {
  static const Color primaryColor =
  Color(0xFF2196F3);

  final TextEditingController
  _lateGraceController =
  TextEditingController();

  final TextEditingController
  _earlyLeaveGraceController =
  TextEditingController();

  final TextEditingController
  _halfDayController =
  TextEditingController();

  final TextEditingController
  _minimumHoursController =
  TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  bool lateAttendanceAllowed = true;
  bool earlyLeaveAllowed = true;
  bool checkInRequired = true;
  bool checkOutRequired = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _loadRules();
    });
  }

  @override
  void dispose() {
    _lateGraceController.dispose();
    _earlyLeaveGraceController.dispose();
    _halfDayController.dispose();
    _minimumHoursController.dispose();

    super.dispose();
  }

  // =============================================================
  // LOAD
  // =============================================================

  Future<void> _loadRules() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final CurrentUser? user =
      ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      final companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      final response =
      await SupabaseService.client
          .from('company_attendance_rules')
          .select()
          .eq('company_id', companyId)
          .maybeSingle();

      if (response != null) {
        _lateGraceController.text =
        '${response['late_grace_minutes'] ?? 10}';

        _earlyLeaveGraceController.text =
        '${response['early_leave_grace_minutes'] ?? 10}';

        _halfDayController.text =
        '${response['half_day_threshold_hours'] ?? 4}';

        _minimumHoursController.text =
        '${response['minimum_working_hours'] ?? 8}';

        lateAttendanceAllowed =
            response['late_attendance_allowed'] == true;

        earlyLeaveAllowed =
            response['early_leave_allowed'] == true;

        checkInRequired =
            response['check_in_required'] == true;

        checkOutRequired =
            response['check_out_required'] == true;
      } else {
        _setDefaultValues();
      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _setDefaultValues() {
    _lateGraceController.text = '10';
    _earlyLeaveGraceController.text = '10';
    _halfDayController.text = '4';
    _minimumHoursController.text = '8';

    lateAttendanceAllowed = true;
    earlyLeaveAllowed = true;
    checkInRequired = true;
    checkOutRequired = true;
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _saveRules() async {
    if (isSaving) return;

    try {
      final lateGrace =
      int.tryParse(
        _lateGraceController.text.trim(),
      );

      final earlyGrace =
      int.tryParse(
        _earlyLeaveGraceController.text.trim(),
      );

      final halfDay =
      double.tryParse(
        _halfDayController.text.trim(),
      );

      final minimumHours =
      double.tryParse(
        _minimumHoursController.text.trim(),
      );

      if (lateGrace == null ||
          lateGrace < 0) {
        _showError(
          'Please enter a valid late grace period.',
        );
        return;
      }

      if (earlyGrace == null ||
          earlyGrace < 0) {
        _showError(
          'Please enter a valid early leave grace period.',
        );
        return;
      }

      if (halfDay == null || halfDay < 0) {
        _showError(
          'Please enter a valid half-day threshold.',
        );
        return;
      }

      if (minimumHours == null ||
          minimumHours < 0) {
        _showError(
          'Please enter valid minimum working hours.',
        );
        return;
      }

      final CurrentUser? user =
      ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      final companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      setState(() {
        isSaving = true;
        errorMessage = null;
      });

      await SupabaseService.client
          .from('company_attendance_rules')
          .upsert(
        {
          'company_id': companyId,
          'late_grace_minutes': lateGrace,
          'early_leave_grace_minutes':
          earlyGrace,
          'late_attendance_allowed':
          lateAttendanceAllowed,
          'early_leave_allowed':
          earlyLeaveAllowed,
          'half_day_threshold_hours':
          halfDay,
          'minimum_working_hours':
          minimumHours,
          'check_in_required':
          checkInRequired,
          'check_out_required':
          checkOutRequired,
          'updated_at':
          DateTime.now()
              .toUtc()
              .toIso8601String(),
        },
        onConflict: 'company_id',
      );

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Attendance rules saved successfully.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
        errorMessage = e.toString();
      });

      _showError(
        'Failed to save attendance rules.',
      );
    }
  }

  // =============================================================
  // ERROR
  // =============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme.of(context)
          .scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        Theme.of(context)
            .scaffoldBackgroundColor,
        foregroundColor:
        Theme.of(context)
            .colorScheme
            .onSurface,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Attendance Rules',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
          child:
          CircularProgressIndicator(),
        )
            : _buildBody(),
      ),

      bottomNavigationBar:
      SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16,
          ),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSaving
                  ? null
                  : _saveRules,
              icon: isSaving
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                  Colors.white,
                ),
              )
                  : const Icon(
                Icons.save_outlined,
              ),
              label: Text(
                isSaving
                    ? 'Saving...'
                    : 'Save Attendance Rules',
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                primaryColor,
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final isWide =
            constraints.maxWidth >= 700;

        return SingleChildScrollView(
          padding:
          EdgeInsets.symmetric(
            horizontal:
            isWide ? 24 : 14,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 760,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(
                    height: 16,
                  ),

                  if (errorMessage != null)
                    _buildError(),

                  _buildGracePeriodCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  _buildAttendancePermissionCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  _buildWorkingHoursCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  _buildInformationCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader() {
    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
        primary.withOpacity(.08),
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
            BoxDecoration(
              color:
              primary.withOpacity(.12),
              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              Icons.rule_outlined,
              color: primary,
              size: 27,
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Attendance Rules',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Configure the basic attendance behavior for your company.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    Theme.of(
                      context,
                    )
                        .colorScheme
                        .onSurface
                        .withOpacity(
                      .65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // GRACE PERIOD
  // =============================================================

  Widget _buildGracePeriodCard() {
    return _buildCard(
      title: 'Grace Period',
      icon:
      Icons.timer_outlined,
      children: [
        _buildNumberField(
          controller:
          _lateGraceController,
          label:
          'Late Grace Period',
          suffix: 'minutes',
          helper:
          'Late attendance will be allowed within this period.',
        ),

        const SizedBox(
          height: 14,
        ),

        _buildNumberField(
          controller:
          _earlyLeaveGraceController,
          label:
          'Early Leave Grace Period',
          suffix: 'minutes',
          helper:
          'Early leaving will be allowed within this period.',
        ),
      ],
    );
  }

  // =============================================================
  // ATTENDANCE PERMISSIONS
  // =============================================================

  Widget _buildAttendancePermissionCard() {
    return _buildCard(
      title:
      'Attendance Permissions',
      icon:
      Icons.verified_user_outlined,
      children: [
        _buildSwitchTile(
          title:
          'Late Attendance Allowed',
          subtitle:
          'Allow employees to check in after the scheduled start time.',
          value:
          lateAttendanceAllowed,
          onChanged: (value) {
            setState(() {
              lateAttendanceAllowed =
                  value;
            });
          },
        ),

        _buildSwitchTile(
          title:
          'Early Leave Allowed',
          subtitle:
          'Allow employees to leave before the scheduled end time.',
          value:
          earlyLeaveAllowed,
          onChanged: (value) {
            setState(() {
              earlyLeaveAllowed =
                  value;
            });
          },
        ),

        _buildSwitchTile(
          title:
          'Check-in Required',
          subtitle:
          'Employees must record their attendance check-in.',
          value:
          checkInRequired,
          onChanged: (value) {
            setState(() {
              checkInRequired =
                  value;
            });
          },
        ),

        _buildSwitchTile(
          title:
          'Check-out Required',
          subtitle:
          'Employees must record their attendance check-out.',
          value:
          checkOutRequired,
          onChanged: (value) {
            setState(() {
              checkOutRequired =
                  value;
            });
          },
        ),
      ],
    );
  }

  // =============================================================
  // WORKING HOURS
  // =============================================================

  Widget _buildWorkingHoursCard() {
    return _buildCard(
      title:
      'Working Hour Rules',
      icon:
      Icons.access_time_outlined,
      children: [
        _buildNumberField(
          controller:
          _halfDayController,
          label:
          'Half-Day Threshold',
          suffix: 'hours',
          helper:
          'Worked hours below this threshold may be treated as half-day.',
        ),

        const SizedBox(
          height: 14,
        ),

        _buildNumberField(
          controller:
          _minimumHoursController,
          label:
          'Minimum Working Hours',
          suffix: 'hours',
          helper:
          'Expected minimum working hours for a normal workday.',
        ),
      ],
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          Theme.of(context)
              .dividerColor
              .withOpacity(.5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: primary,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
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
            height: 8,
          ),

          ...children,
        ],
      ),
    );
  }

  // =============================================================
  // NUMBER FIELD
  // =============================================================

  Widget _buildNumberField({
    required TextEditingController
    controller,
    required String label,
    required String suffix,
    required String helper,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
      const TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter
            .allow(
          RegExp(r'[0-9.]'),
        ),
      ],
      decoration:
      InputDecoration(
        labelText: label,
        suffixText: suffix,
        helperText: helper,
        border:
        const OutlineInputBorder(),
      ),
    );
  }

  // =============================================================
  // SWITCH
  // =============================================================

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>
    onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding:
      EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight:
          FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(.60),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor:
      Theme.of(context)
          .colorScheme
          .primary,
    );
  }

  // =============================================================
  // ERROR CARD
  // =============================================================

  Widget _buildError() {
    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 16,
      ),
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
        Colors.red.withOpacity(.07),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          Colors.red.withOpacity(.20),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Text(
              errorMessage!,
              style:
              const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INFORMATION
  // =============================================================

  Widget _buildInformationCard() {
    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.40),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: primary,
            size: 20,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Text(
              'These rules are stored separately for each company and automatically use the logged-in user’s company.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}