import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/repositories/current_employee_repository.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../../auth/presentation/providers/current_employee_provider.dart';
import '../../../../core/services/attendance_checkin_service.dart';
import '../../../../core/services/location_service.dart';

class AttendanceMobilePage extends ConsumerStatefulWidget {
  const AttendanceMobilePage({super.key});

  @override
  ConsumerState<AttendanceMobilePage> createState() =>
      _AttendanceMobilePageState();
}

class _AttendanceMobilePageState
    extends ConsumerState<AttendanceMobilePage> {
  final _locationService =
  const LocationService();

  final _attendanceService =
  AttendanceCheckInService();

  bool isLoading = false;

  String address = '';

  double latitude = 0;

  double longitude = 0;

  Future<void> _loadLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      final location =
      await _locationService.getLocation();

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
  Future<void> _checkIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final location = await _locationService.getLocation();

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
    } catch (e) {
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
  Future<void> _checkOut() async {
    setState(() {
      isLoading = true;
    });

    try {
      final employee =
      await CurrentEmployeeRepository()
          .currentEmployee();

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
    } catch (e) {
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

  @override
  void initState() {
    super.initState();

    _loadLocation();
  }

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
        child: ListView(
          padding:
          const EdgeInsets.all(16),
          children: [

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const CircleAvatar(
                      radius: 35,
                      child: Icon(
                        Icons.person,
                        size: 35,
                      ),
                    ),

                    const SizedBox(height: 15),

                    employeeAsync.when(
                      data: (employee) {
                        return Text(
                          employee?.fullName ?? 'Unknown Employee',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      loading: () =>
                      const CircularProgressIndicator(),
                      error: (_, __) =>
                      const Text('Employee'),
                    ),

                    const SizedBox(height: 5),

                    Text(now),

                    Text(time),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Row(
                      children: [

                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Center(
                        child:
                        CircularProgressIndicator(),
                      )
                    else ...[

                      Text(
                        "Latitude : $latitude",
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Longitude : $longitude",
                      ),

                      const SizedBox(height: 12),

                      Text(address),

                    ],

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: _checkIn,
                icon: const Icon(
                  Icons.login,
                ),
                label: const Text(
                  'CHECK IN',
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: _checkOut,
                style: FilledButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                ),
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'CHECK OUT',
                ),
              ),
            ),

            const SizedBox(height: 25),

            OutlinedButton.icon(
              onPressed: _loadLocation,
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Refresh Location',
              ),
            ),

          ],
        ),
      ),
    );
  }
}