// ===============================================================
// Flutter HRMS Pro
//
// Attendance Rules Settings Page
//
// Version : 2.0.0
//
// Updated:
// - Fully Theme Aware
// - Light / Dark Theme Support
// - Material 3 ColorScheme
// - Responsive UI
// - Company-wise attendance rules
// - Logged-in company automatically detected
// - No company dropdown
// - No hardcoded UI colors
// - FontWeight kept within standard Flutter values
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/services/supabase_service.dart';

class AttendanceRulesSettingsPage extends ConsumerStatefulWidget {
  const AttendanceRulesSettingsPage({
    super.key,
  });

  @override
  ConsumerState<AttendanceRulesSettingsPage> createState() =>
      _AttendanceRulesSettingsPageState();
}

class _AttendanceRulesSettingsPageState
    extends ConsumerState<AttendanceRulesSettingsPage> {
  // =============================================================
  // CONTROLLERS
  // =============================================================

  final TextEditingController _lateGraceController =
  TextEditingController();

  final TextEditingController _earlyLeaveGraceController =
  TextEditingController();

  final TextEditingController _halfDayController =
  TextEditingController();

  final TextEditingController _minimumHoursController =
  TextEditingController();

  // =============================================================
  // STATE
  // =============================================================

  bool isLoading = true;
  bool isSaving = false;

  bool lateAttendanceAllowed = true;
  bool earlyLeaveAllowed = true;
  bool checkInRequired = true;
  bool checkOutRequired = true;

  String? errorMessage;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRules();
    });
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _lateGraceController.dispose();
    _earlyLeaveGraceController.dispose();
    _halfDayController.dispose();
    _minimumHoursController.dispose();

    super.dispose();
  }

  // =============================================================
  // LOAD RULES
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

      final response = await SupabaseService.client
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

  // =============================================================
  // DEFAULT VALUES
  // =============================================================

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
  // SAVE RULES
  // =============================================================

  Future<void> _saveRules() async {
    if (isSaving) return;

    try {
      final lateGrace = int.tryParse(
        _lateGraceController.text.trim(),
      );

      final earlyGrace = int.tryParse(
        _earlyLeaveGraceController.text.trim(),
      );

      final halfDay = double.tryParse(
        _halfDayController.text.trim(),
      );

      final minimumHours = double.tryParse(
        _minimumHoursController.text.trim(),
      );

      // ---------------------------------------------------------
      // VALIDATION
      // ---------------------------------------------------------

      if (lateGrace == null || lateGrace < 0) {
        _showError(
          'Please enter a valid late grace period.',
        );
        return;
      }

      if (earlyGrace == null || earlyGrace < 0) {
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

      if (minimumHours == null || minimumHours < 0) {
        _showError(
          'Please enter valid minimum working hours.',
        );
        return;
      }

      // ---------------------------------------------------------
      // CURRENT USER
      // ---------------------------------------------------------

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

      if (!mounted) return;

      setState(() {
        isSaving = true;
        errorMessage = null;
      });

      // ---------------------------------------------------------
      // UPSERT
      // ---------------------------------------------------------

      await SupabaseService.client
          .from('company_attendance_rules')
          .upsert(
        {
          'company_id': companyId,

          'late_grace_minutes':
          lateGrace,

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

      _showSuccess(
        'Attendance rules saved successfully.',
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
  // SUCCESS MESSAGE
  // =============================================================

  void _showSuccess(String message) {
    if (!mounted) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.inverseSurface,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color:
              colorScheme.onInverseSurface,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                  colorScheme.onInverseSurface,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // ERROR MESSAGE
  // =============================================================

  void _showError(String message) {
    if (!mounted) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.errorContainer,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color:
              colorScheme.onErrorContainer,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow:
                TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                  colorScheme.onErrorContainer,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor:
        colorScheme.surface,

        foregroundColor:
        colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Attendance Rules',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight:
            FontWeight.w600,
            color:
            colorScheme.onSurface,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: isLoading
            ? Center(
          child:
          CircularProgressIndicator(
            color:
            colorScheme.primary,
          ),
        )
            : _buildBody(),
      ),

      // =========================================================
      // SAVE BUTTON
      // =========================================================

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
            height: 52,
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
              isSaving
                  ? null
                  : _saveRules,

              icon: isSaving
                  ? SizedBox(
                width: 19,
                height: 19,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                  colorScheme
                      .onPrimary,
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
              FilledButton.styleFrom(
                backgroundColor:
                colorScheme.primary,

                foregroundColor:
                colorScheme.onPrimary,

                disabledBackgroundColor:
                colorScheme
                    .surfaceContainerHighest,

                disabledForegroundColor:
                colorScheme
                    .onSurfaceVariant,

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                textStyle:
                theme.textTheme
                    .labelLarge
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w600,
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
        final bool isWide =
            constraints.maxWidth >= 700;

        return SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

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

                  const SizedBox(
                    height: 12,
                  ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
        colorScheme.primaryContainer,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration:
            BoxDecoration(
              color:
              colorScheme.primary,

              borderRadius:
              BorderRadius.circular(14),
            ),

            child: Icon(
              Icons.rule_outlined,

              color:
              colorScheme.onPrimary,

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

                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,

                    color:
                    colorScheme
                        .onPrimaryContainer,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Configure the basic attendance behavior for your company.',

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colorScheme
                        .onPrimaryContainer
                        .withValues(
                      alpha: .72,
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
      icon: Icons.timer_outlined,
      children: [
        _buildNumberField(
          controller:
          _lateGraceController,

          label:
          'Late Grace Period',

          suffix:
          'minutes',

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

          suffix:
          'minutes',

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

          suffix:
          'hours',

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

          suffix:
          'hours',

          helper:
          'Expected minimum working hours for a normal workday.',
        ),
      ],
    );
  }

  // =============================================================
  // COMMON CARD
  // =============================================================

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
        colorScheme.surfaceContainerLow,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration:
                BoxDecoration(
                  color:
                  colorScheme
                      .secondaryContainer,

                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,

                  size: 20,

                  color:
                  colorScheme
                      .onSecondaryContainer,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Text(
                  title,

                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,

                    color:
                    colorScheme
                        .onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          Divider(
            height: 1,

            color:
            colorScheme
                .outlineVariant,
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
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return TextField(
      controller:
      controller,

      keyboardType:
      const TextInputType.numberWithOptions(
        decimal: true,
      ),

      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9.]'),
        ),
      ],

      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight:
        FontWeight.w600,

        color:
        colorScheme.onSurface,
      ),

      decoration:
      InputDecoration(
        labelText:
        label,

        suffixText:
        suffix,

        helperText:
        helper,

        filled: true,

        fillColor:
        colorScheme.surface,

        labelStyle:
        TextStyle(
          color:
          colorScheme
              .onSurfaceVariant,
        ),

        suffixStyle:
        TextStyle(
          color:
          colorScheme
              .onSurfaceVariant,

          fontWeight:
          FontWeight.w600,
        ),

        helperStyle:
        theme.textTheme.bodySmall?.copyWith(
          color:
          colorScheme
              .onSurfaceVariant,
        ),

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide:
          BorderSide(
            color:
            colorScheme
                .outlineVariant,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide:
          BorderSide(
            color:
            colorScheme
                .outlineVariant,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide:
          BorderSide(
            color:
            colorScheme.primary,

            width: 1.5,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide:
          BorderSide(
            color:
            colorScheme.error,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide:
          BorderSide(
            color:
            colorScheme.error,

            width: 1.5,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SWITCH TILE
  // =============================================================

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>
    onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return SwitchListTile.adaptive(
      contentPadding:
      EdgeInsets.zero,

      title: Text(
        title,

        style: theme
            .textTheme
            .bodyLarge
            ?.copyWith(
          fontWeight:
          FontWeight.w600,

          color:
          colorScheme.onSurface,
        ),
      ),

      subtitle: Padding(
        padding:
        const EdgeInsets.only(
          top: 3,
        ),

        child: Text(
          subtitle,

          style: theme
              .textTheme
              .bodySmall
              ?.copyWith(
            color:
            colorScheme
                .onSurfaceVariant,
          ),
        ),
      ),

      value:
      value,

      onChanged:
      onChanged,

      activeColor:
      colorScheme.primary,

      activeTrackColor:
      colorScheme
          .primaryContainer,

      inactiveThumbColor:
      colorScheme
          .onSurfaceVariant,

      inactiveTrackColor:
      colorScheme
          .surfaceContainerHighest,

      trackOutlineColor:
      WidgetStateProperty
          .resolveWith(
            (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return colorScheme
                .primary;
          }

          return colorScheme
              .outline;
        },
      ),
    );
  }

  // =============================================================
  // ERROR CARD
  // =============================================================

  Widget _buildError() {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

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
        colorScheme.errorContainer,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color:
          colorScheme.error
              .withValues(
            alpha: .25,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.error_outline_rounded,

            color:
            colorScheme
                .onErrorContainer,

            size: 21,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              errorMessage ?? '',

              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                colorScheme
                    .onErrorContainer,

                fontWeight:
                FontWeight.w600,

                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INFORMATION CARD
  // =============================================================

  Widget _buildInformationCard() {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color:
        colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: .45,
        ),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color:
          colorScheme
              .outlineVariant,
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Container(
            width: 34,
            height: 34,

            decoration:
            BoxDecoration(
              color:
              colorScheme
                  .primaryContainer,

              borderRadius:
              BorderRadius.circular(10),
            ),

            child: Icon(
              Icons.info_outline_rounded,

              color:
              colorScheme
                  .onPrimaryContainer,

              size: 19,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              'These rules are stored separately for each company and automatically use the logged-in user’s company.',

              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                colorScheme
                    .onSurfaceVariant,

                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}