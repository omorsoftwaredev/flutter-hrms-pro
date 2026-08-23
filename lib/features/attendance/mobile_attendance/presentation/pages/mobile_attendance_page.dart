import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../auth/presentation/providers/current_employee_provider.dart';
import '../../../../../core/services/location_service.dart';
import '../../domain/entities/mobile_attendance_entity.dart';
import '../providers/mobile_attendance_provider.dart';

class MobileAttendancePage
    extends ConsumerStatefulWidget {
  const MobileAttendancePage({
    super.key,
  });

  @override
  ConsumerState<
      MobileAttendancePage> createState() =>
      _MobileAttendancePageState();
}

class _MobileAttendancePageState
    extends ConsumerState<
        MobileAttendancePage> {
  final LocationService
  _locationService =
  const LocationService();

  bool _pageLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      _initialize,
    );
  }

  //==============================================================
  // INITIALIZE
  //==============================================================

  Future<void> _initialize() async {
    await ref
        .read(
      mobileAttendanceProvider,
    )
        .initialize();
  }

  //==============================================================
  // REFRESH
  //==============================================================

  Future<void> _refresh() async {
    await ref
        .read(
      mobileAttendanceProvider,
    )
        .refresh();
  }

  //==============================================================
  // CHECK IN
  //==============================================================

  Future<void> _checkIn() async {
    final provider =
    ref.read(
      mobileAttendanceProvider,
    );

    if (!provider.canCheckIn ||
        provider.isBusy) {
      return;
    }

    setState(() {
      _pageLoading = true;
    });

    try {
      final employee =
      await ref.read(
        currentEmployeeProvider.future,
      );

      if (employee == null) {
        throw Exception(
          'Current employee not found.',
        );
      }

      final location =
      await _locationService
          .getLocation();

      final now =
      DateTime.now();

      final attendance =
      MobileAttendanceEntity(
        companyId:
        employee.companyId,
        departmentId:
        employee.departmentId,
        designationId:
        employee.designationId,
        employeeId:
        employee.id,
        shiftId:
        employee.shiftId,
        attendanceNo:
        'ATT-${now.millisecondsSinceEpoch}',
        attendanceDate:
        now,
        attendanceStatus:
        'PRESENT',
        remarks: null,
        checkInLatitude:
        location.latitude,
        checkInLongitude:
        location.longitude,
        checkInAddress:
        location.address,
        checkInAccuracy:
        location.accuracy,
      );

      final success =
      await provider.checkIn(
        attendance: attendance,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        _showMessage(
          'Check-in successful.',
        );
      } else {
        _showMessage(
          provider.error ??
              'Check-in failed.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _cleanError(e),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _pageLoading = false;
        });
      }
    }
  }

  //==============================================================
  // CHECK OUT
  //==============================================================

  Future<void> _checkOut() async {
    final provider =
    ref.read(
      mobileAttendanceProvider,
    );

    if (!provider.canCheckOut ||
        provider.isBusy) {
      return;
    }

    setState(() {
      _pageLoading = true;
    });

    try {
      final success =
      await provider.checkOut();

      if (!mounted) {
        return;
      }

      if (success) {
        _showMessage(
          'Check-out successful.',
        );
      } else {
        _showMessage(
          provider.error ??
              'Check-out failed.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _cleanError(e),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _pageLoading = false;
        });
      }
    }
  }

  //==============================================================
  // MESSAGE
  //==============================================================

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
        Text(message),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  String _cleanError(
      Object error,
      ) {
    final message =
    error.toString().trim();

    if (message.startsWith(
      'Exception: ',
    )) {
      return message.substring(
        'Exception: '.length,
      );
    }

    return message.isEmpty
        ? 'Something went wrong.'
        : message;
  }

  //==============================================================
  // TIME
  //==============================================================

  String _formatTime(
      DateTime? value,
      ) {
    if (value == null) {
      return '--:--';
    }

    return DateFormat(
      'hh:mm a',
    ).format(value);
  }

  //==============================================================
  // SHIFT TIME
  //==============================================================

  String _formatShiftTime(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return '--:--';
    }

    final raw =
    value.trim();

    try {
      final parts =
      raw.split(':');

      if (parts.length >= 2) {
        final hour =
        int.parse(parts[0]);

        final minute =
        int.parse(parts[1]);

        final date =
        DateTime(
          2000,
          1,
          1,
          hour,
          minute,
        );

        return DateFormat(
          'hh:mm a',
        ).format(date);
      }
    } catch (_) {
      // Fall through.
    }

    return raw;
  }

  //==============================================================
  // FORMAT LOCATION
  //==============================================================

  String _locationText(
      String? address,
      ) {
    if (address == null ||
        address.trim().isEmpty) {
      return 'Location unavailable';
    }

    return address.trim();
  }

  //==============================================================
  // STATUS COLOR
  //==============================================================

  Color _statusColor(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    if (provider.isCompleted) {
      return colors.tertiary;
    }

    if (provider.isCheckedIn) {
      return colors.primary;
    }

    return colors.outline;
  }

  //==============================================================
  // EMPLOYEE / STATUS HEADER
  //==============================================================

  Widget _buildEmployeeHeader(
      BuildContext context,
      AsyncValue employeeAsync,
      MobileAttendanceProvider provider,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    String employeeName =
        'Employee';

    employeeAsync.whenData(
          (employee) {
        employeeName =
            employee?.fullName ??
                'Employee';
      },
    );

    final statusColor =
    _statusColor(
      context,
      provider,
    );

    final statusText =
    provider.isCompleted
        ? 'Attendance Completed'
        : provider.isCheckedIn
        ? 'Checked In'
        : 'Not Checked In';

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          22,
        ),
        side: BorderSide(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
              colors.primaryContainer,
              child: Icon(
                Icons
                    .person_outline,
                color: colors
                    .onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(
              width: 13,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    employeeName,
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style: theme
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormat(
                      'dd MMM yyyy',
                    ).format(
                      DateTime.now(),
                    ),
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: colors
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration:
              BoxDecoration(
                color: statusColor
                    .withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                BorderRadius
                    .circular(
                  20,
                ),
                border: Border.all(
                  color: statusColor
                      .withValues(
                    alpha: 0.25,
                  ),
                ),
              ),
              child: Text(
                statusText,
                style: theme
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color:
                  statusColor,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==============================================================
  // SECTION HEADER
  //==============================================================

  Widget _buildSectionHeader(
      BuildContext context, {
        required IconData icon,
        required String title,
      }) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration:
          BoxDecoration(
            color:
            colors.primaryContainer,
            borderRadius:
            BorderRadius.circular(
              15,
            ),
          ),
          child: Icon(
            icon,
            size: 28,
            color: colors
                .onPrimaryContainer,
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Text(
          title,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w800,
          ),
        ),
      ],
    );
  }

  //==============================================================
  // SHIFT CARD
  //==============================================================

  Widget _buildShiftCard(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final shift =
        provider.shift;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        side: BorderSide(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            _buildSectionHeader(
              context,
              icon:
              Icons.schedule_outlined,
              title: 'Shift',
            ),
            const SizedBox(
              height: 20,
            ),
            if (shift == null)
              Container(
                width:
                double.infinity,
                padding:
                const EdgeInsets
                    .all(
                  16,
                ),
                decoration:
                BoxDecoration(
                  color: colors
                      .surfaceContainerLowest,
                  borderRadius:
                  BorderRadius
                      .circular(
                    16,
                  ),
                  border:
                  Border.all(
                    color: colors
                        .outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons
                          .info_outline,
                      color: colors
                          .onSurfaceVariant,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        'No shift assigned.',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colors
                              .onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              _buildShiftNameBox(
                context,
                provider,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .login_outlined,
                      label: 'Start Time',
                      value:
                      _formatShiftTime(
                        provider
                            .shiftStartTime,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .logout_outlined,
                      label: 'End Time',
                      value:
                      _formatShiftTime(
                        provider
                            .shiftEndTime,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .schedule_outlined,
                      label: 'Late Grace',
                      value:
                      '${provider.lateGraceMinutes} min',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .timer_outlined,
                      label: 'Early Leave',
                      value:
                      '${provider.earlyLeaveGraceMinutes} min',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .hourglass_bottom_outlined,
                      label: 'Half Day',
                      value:
                      '${provider.halfDayMinutes} min',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    _buildShiftInfoBox(
                      context,
                      icon: Icons
                          .nightlight_outlined,
                      label: 'Shift Type',
                      value:
                      provider.isNightShift
                          ? 'Night'
                          : 'Day',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  //==============================================================
  // SHIFT NAME BOX
  //==============================================================

  Widget _buildShiftNameBox(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(16),
      decoration:
      BoxDecoration(
        color: colors
            .surfaceContainerLowest,
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons
                .badge_outlined,
            color:
            colors.primary,
            size: 25,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  'Shift Name',
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colors
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  provider.shiftName ??
                      'Shift',
                  maxLines: 2,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // SHIFT INFO BOX
  //==============================================================

  Widget _buildShiftInfoBox(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Container(
      padding:
      const EdgeInsets.all(13),
      decoration:
      BoxDecoration(
        color: colors
            .surfaceContainerLowest,
        borderRadius:
        BorderRadius.circular(
          15,
        ),
        border: Border.all(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color:
            colors.primary,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colors
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // WORK SUMMARY
  //==============================================================

  Widget _buildWorkSummary(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        side: BorderSide(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            _buildSectionHeader(
              context,
              icon:
              Icons.analytics_outlined,
              title:
              'Work Summary',
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child:
                  _buildWorkSummaryItem(
                    context,
                    icon:
                    Icons.timer_outlined,
                    title:
                    'Actual Work',
                    value: provider
                        .actualWorkDurationText,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child:
                  _buildWorkSummaryItem(
                    context,
                    icon:
                    Icons
                        .more_time_outlined,
                    title:
                    'Overtime',
                    value: provider
                        .overtimeDurationText,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width:
              double.infinity,
              padding:
              const EdgeInsets
                  .all(
                14,
              ),
              decoration:
              BoxDecoration(
                color: colors
                    .surfaceContainerLowest,
                borderRadius:
                BorderRadius.circular(
                  15,
                ),
                border: Border.all(
                  color: colors
                      .outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    provider.isCheckedIn
                        ? Icons
                        .play_circle_outline
                        : provider.isCompleted
                        ? Icons
                        .check_circle_outline
                        : Icons
                        .pause_circle_outline,
                    color:
                    colors.primary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      provider.isCheckedIn
                          ? 'Working time is updating automatically.'
                          : provider.isCompleted
                          ? 'Actual work calculated from check-in to check-out.'
                          : 'Actual work will start after check-in.',
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colors
                            .onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==============================================================
  // WORK SUMMARY ITEM
  //==============================================================

  Widget _buildWorkSummaryItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Container(
      padding:
      const EdgeInsets.all(15),
      decoration:
      BoxDecoration(
        color: colors
            .surfaceContainerLowest,
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
          colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 23,
            color:
            colors.primary,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colors
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  value,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // CHECK IN CARD
  //==============================================================

  Widget _buildCheckInCard(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final attendance =
        provider.todayAttendance;

    final checkedIn =
        provider.hasCheckedIn;

    return _buildAttendanceActionCard(
      context,
      title: 'Check In',
      time: checkedIn
          ? _formatTime(
        attendance?.checkInTime,
      )
          : '--:--',
      location: checkedIn
          ? _locationText(
        attendance
            ?.checkInAddress,
      )
          : 'Start today\'s attendance',
      icon: checkedIn
          ? Icons
          .check_circle_outline
          : Icons.login,
      completed: checkedIn,
      active:
      provider.canCheckIn &&
          !provider.isBusy,
      onPressed:
      provider.canCheckIn &&
          !provider.isBusy
          ? _checkIn
          : null,
    );
  }

  //==============================================================
  // CHECK OUT CARD
  //==============================================================

  Widget _buildCheckOutCard(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    final attendance =
        provider.todayAttendance;

    final checkedOut =
        provider.hasCheckedOut;

    return _buildAttendanceActionCard(
      context,
      title: 'Check Out',
      time: checkedOut
          ? _formatTime(
        attendance?.checkOutTime,
      )
          : '--:--',
      location: checkedOut
          ? _locationText(
        attendance
            ?.checkOutAddress,
      )
          : provider.canCheckOut
          ? 'Complete today\'s attendance'
          : 'Available after check-in',
      icon: checkedOut
          ? Icons
          .check_circle_outline
          : Icons.logout,
      completed: checkedOut,
      active:
      provider.canCheckOut &&
          !provider.isBusy,
      danger: true,
      onPressed:
      provider.canCheckOut &&
          !provider.isBusy
          ? _checkOut
          : null,
    );
  }

  //==============================================================
  // ACTION CARD
  //==============================================================

  Widget _buildAttendanceActionCard(
      BuildContext context, {
        required String title,
        required String time,
        required String location,
        required IconData icon,
        required bool completed,
        required bool active,
        required VoidCallback? onPressed,
        bool danger = false,
      }) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final Color accent;

    if (completed) {
      accent =
          colors.tertiary;
    } else if (danger) {
      accent =
          colors.primary;
    } else {
      accent =
          colors.primary;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          22,
        ),
        side: BorderSide(
          color: active
              ? accent
              : colors
              .outlineVariant,
          width:
          active ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          22,
        ),
        onTap:
        onPressed,
        child: Padding(
          padding:
          const EdgeInsets.all(
            18,
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration:
                BoxDecoration(
                  color: accent
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(
                    16,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accent,
                  size: 28,
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      time,
                      style: theme
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Icon(
                          Icons
                              .location_on_outlined,
                          size: 16,
                          color: colors
                              .onSurfaceVariant,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: colors
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                completed
                    ? Icons
                    .check_circle
                    : Icons
                    .arrow_forward_ios,
                size:
                completed ? 25 : 16,
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==============================================================
  // ERROR CARD
  //==============================================================

  Widget _buildErrorCard(
      BuildContext context,
      MobileAttendanceProvider provider,
      ) {
    if (provider.error == null ||
        provider.error!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(14),
      decoration:
      BoxDecoration(
        color:
        colors.errorContainer,
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: colors.error
              .withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,
        children: [
          Icon(
            Icons
                .error_outline,
            color:
            colors.error,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              provider.error!,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colors
                    .onErrorContainer,
              ),
            ),
          ),
          IconButton(
            visualDensity:
            VisualDensity
                .compact,
            onPressed:
            provider.clearError,
            icon:
            const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // BUILD
  //==============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final employeeAsync =
    ref.watch(
      currentEmployeeProvider,
    );

    final provider =
    ref.watch(
      mobileAttendanceProvider,
    );

    final theme =
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          'Mobile Attendance',
        ),
        actions: [
          IconButton(
            tooltip:
            'Refresh',
            onPressed:
            provider.isBusy
                ? null
                : _refresh,
            icon:
            const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body:
      RefreshIndicator(
        onRefresh:
        _refresh,
        child:
        LayoutBuilder(
          builder:
              (
              context,
              constraints,
              ) {
            final width =
                constraints.maxWidth;

            final contentWidth =
            width >= 1100
                ? 850.0
                : width >= 700
                ? 700.0
                : double.infinity;

            return ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding:
              const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                30,
              ),
              children: [
                Center(
                  child:
                  ConstrainedBox(
                    constraints:
                    BoxConstraints(
                      maxWidth:
                      contentWidth,
                    ),
                    child:
                    Column(
                      children: [
                        // ------------------------------------------------
                        // EMPLOYEE + ONE STATUS
                        // ------------------------------------------------

                        _buildEmployeeHeader(
                          context,
                          employeeAsync,
                          provider,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // ------------------------------------------------
                        // SHIFT
                        // ------------------------------------------------

                        _buildShiftCard(
                          context,
                          provider,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // ------------------------------------------------
                        // WORK SUMMARY
                        // ------------------------------------------------

                        _buildWorkSummary(
                          context,
                          provider,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // ------------------------------------------------
                        // CHECK IN
                        // ------------------------------------------------

                        _buildCheckInCard(
                          context,
                          provider,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // ------------------------------------------------
                        // CHECK OUT
                        // ------------------------------------------------

                        _buildCheckOutCard(
                          context,
                          provider,
                        ),

                        if (provider.error !=
                            null &&
                            provider.error!
                                .isNotEmpty) ...[
                          const SizedBox(
                            height: 16,
                          ),
                          _buildErrorCard(
                            context,
                            provider,
                          ),
                        ],

                        if (_pageLoading ||
                            provider.isBusy) ...[
                          const SizedBox(
                            height: 18,
                          ),
                          const LinearProgressIndicator(),
                        ],

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Location is captured securely for attendance verification.',
                          textAlign:
                          TextAlign.center,
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}