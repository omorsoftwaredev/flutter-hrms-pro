import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/repositories/current_employee_repository.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../../auth/presentation/providers/current_employee_provider.dart';
import '../../../../core/services/attendance_checkin_service.dart';
import '../../../../core/services/location_service.dart';

class AttendanceMobilePage extends ConsumerStatefulWidget {
  const AttendanceMobilePage({
    super.key,
  });

  @override
  ConsumerState<AttendanceMobilePage> createState() =>
      _AttendanceMobilePageState();
}

class _AttendanceMobilePageState
    extends ConsumerState<AttendanceMobilePage> {
  final _locationService = const LocationService();

  final _attendanceService = AttendanceCheckInService();

  bool isLoading = false;

  String address = '';

  double latitude = 0;

  double longitude = 0;

  // =============================================================
  // LOAD LOCATION
  // =============================================================

  Future<void> _loadLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      final location = await _locationService.getLocation();

      setState(() {
        latitude = location.latitude;
        longitude = location.longitude;
        address = location.address;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // =============================================================
  // CHECK IN
  // =============================================================

  Future<void> _checkIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final location = await _locationService.getLocation();

      print("CHECKING CURRENT EMPLOYEE");

      final employee =
      await CurrentEmployeeRepository().currentEmployee();

      if (employee == null) {
        throw Exception(
          "Current employee not found.",
        );
      }

      final attendance = AttendanceEntity(
        companyId: employee.companyId,
        departmentId: employee.departmentId,
        designationId: employee.designationId,
        employeeId: employee.id,
        shiftId: employee.shiftId,
        attendanceNo:
        "ATT-${DateTime.now().millisecondsSinceEpoch}",
        attendanceDate: DateTime.now(),
        attendanceStatus: "PRESENT",
        checkInTime: DateTime.now(),
        checkInLatitude: location.latitude,
        checkInLongitude: location.longitude,
        remarks: location.address,
      );

      final ok = await _attendanceService.checkIn(
        attendance: attendance,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? "Check In Successful"
                : "Check In Failed",
          ),
          backgroundColor:
          ok ? Colors.green : Colors.red,
        ),
      );

      if (ok) {
        await _loadLocation();
      }
    } catch (e, stackTrace) {
      print('========== ATTENDANCE ERROR ==========');
      print('ERROR => $e');
      print('STACK TRACE => $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =============================================================
  // CHECK OUT
  // =============================================================

  Future<void> _checkOut() async {
    setState(() {
      isLoading = true;
    });

    try {
      final employee =
      await CurrentEmployeeRepository().currentEmployee();

      if (employee == null) {
        throw Exception(
          'Employee not found.',
        );
      }

      final ok =
      await _attendanceService.checkOut(
        employeeId: employee.id!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Check Out Successful'
                : 'Check Out Failed',
          ),
          backgroundColor:
          ok ? Colors.green : Colors.red,
        ),
      );
    } catch (e, stackTrace) {
      print('========== ATTENDANCE ERROR ==========');
      print('ERROR => $e');
      print('STACK TRACE => $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =============================================================
  // RESPONSIVE CONTENT WIDTH
  // =============================================================

  double _contentWidth(double width) {
    if (width >= 1400) {
      return 1050;
    }

    if (width >= 1000) {
      return 900;
    }

    if (width >= 700) {
      return 700;
    }

    return double.infinity;
  }

  // =============================================================
  // PAGE PADDING
  // =============================================================

  double _pagePadding(double width) {
    if (width >= 1200) {
      return 28;
    }

    if (width >= 700) {
      return 22;
    }

    return 16;
  }

  // =============================================================
  // EMPLOYEE CARD
  // =============================================================

  Widget _buildEmployeeCard(
      BuildContext context,
      AsyncValue employeeAsync,
      String now,
      String time,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDesktop = width >= 700;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isDesktop ? 24 : 20,
        ),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop ? 28 : 22,
        ),
        child: Column(
          children: [
            Container(
              width: isDesktop ? 82 : 72,
              height: isDesktop ? 82 : 72,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: isDesktop ? 42 : 36,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 16),

            employeeAsync.when(
              data: (employee) {
                return Text(
                  employee?.fullName ??
                      'Unknown Employee',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
              loading: () => SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.primary,
                ),
              ),
              error: (_, __) => Text(
                'Employee',
                style:
                theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  now,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 14),
                Icon(
                  Icons.access_time_outlined,
                  size: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  time,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // LOCATION CARD
  // =============================================================

  Widget _buildLocationCard(
      BuildContext context,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          width >= 700 ? 24 : 18,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: colorScheme.onErrorContainer,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your current GPS location',
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (isLoading)
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Getting current location...',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              _buildLocationInfoRow(
                context,
                icon: Icons.my_location_outlined,
                label: 'Latitude',
                value: latitude.toString(),
              ),

              const SizedBox(height: 12),

              _buildLocationInfoRow(
                context,
                icon: Icons.explore_outlined,
                label: 'Longitude',
                value: longitude.toString(),
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme
                      .surfaceContainerHighest,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        address.isEmpty
                            ? 'Address not available'
                            : address,
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =============================================================
  // LOCATION INFO ROW
  // =============================================================

  Widget _buildLocationInfoRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: colorScheme.primary,
          ),

          const SizedBox(width: 10),

          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style:
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ACTION BUTTON
  // =============================================================

  Widget _buildAttendanceButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback? onPressed,
        required bool isCheckout,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 54,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isCheckout
              ? colorScheme.error
              : colorScheme.primary,
          foregroundColor: isCheckout
              ? colorScheme.onError
              : colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: .3,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _loadLocation();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final employeeAsync =
    ref.watch(currentEmployeeProvider);

    final now =
    DateFormat('dd MMM yyyy').format(
      DateTime.now(),
    );

    final time =
    DateFormat('hh:mm a').format(
      DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mobile Attendance',
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _loadLocation,

        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width = constraints.maxWidth;

            final horizontalPadding =
            _pagePadding(width);

            return ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                30,
              ),

              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                      _contentWidth(width),
                    ),

                    child: Column(
                      children: [
                        // =================================================
                        // EMPLOYEE
                        // =================================================

                        _buildEmployeeCard(
                          context,
                          employeeAsync,
                          now,
                          time,
                          width,
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // LOCATION
                        // =================================================

                        _buildLocationCard(
                          context,
                          width,
                        ),

                        const SizedBox(height: 22),

                        // =================================================
                        // ATTENDANCE ACTIONS
                        // =================================================

                        if (width >= 800)
                          Row(
                            children: [
                              Expanded(
                                child:
                                _buildAttendanceButton(
                                  context,
                                  icon: Icons.login,
                                  label: 'CHECK IN',
                                  onPressed:
                                  _checkIn,
                                  isCheckout: false,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child:
                                _buildAttendanceButton(
                                  context,
                                  icon: Icons.logout,
                                  label: 'CHECK OUT',
                                  onPressed:
                                  _checkOut,
                                  isCheckout: true,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildAttendanceButton(
                                context,
                                icon: Icons.login,
                                label: 'CHECK IN',
                                onPressed: _checkIn,
                                isCheckout: false,
                              ),

                              const SizedBox(height: 12),

                              _buildAttendanceButton(
                                context,
                                icon: Icons.logout,
                                label: 'CHECK OUT',
                                onPressed: _checkOut,
                                isCheckout: true,
                              ),
                            ],
                          ),

                        const SizedBox(height: 14),

                        // =================================================
                        // REFRESH LOCATION
                        // =================================================

                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                            _loadLocation,
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            label: const Text(
                              'Refresh Location',
                            ),
                            style:
                            OutlinedButton.styleFrom(
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
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