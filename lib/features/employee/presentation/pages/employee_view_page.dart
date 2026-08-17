import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeViewPage extends StatelessWidget {
  const EmployeeViewPage({
    super.key,
    required this.employee,
  });

  final EmployeeEntity employee;

  // ===========================================================
  // FORMAT DATE
  // ===========================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return date.toString().split(' ').first;
  }

  // ===========================================================
  // FORMAT VALUE
  // ===========================================================

  String _value(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    return value;
  }

  // ===========================================================
  // RESPONSIVE CONTENT WIDTH
  // ===========================================================

  double _contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1200) {
      return 1000;
    }

    if (width >= 800) {
      return 760;
    }

    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final employeeName =
    employee.fullName.trim().isNotEmpty
        ? employee.fullName
        : employee.firstName;

    final firstLetter =
    employeeName.trim().isNotEmpty
        ? employeeName.trim().substring(0, 1).toUpperCase()
        : '?';

    return Scaffold(
      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        title: const Text(
          'Employee Details',
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal:
            MediaQuery.sizeOf(context).width < 600
                ? 16
                : 24,
            vertical: 20,
          ),
          child: Center(
            child: SizedBox(
              width: _contentWidth(context),
              child: Column(
                children: [
                  // =================================================
                  // EMPLOYEE HEADER
                  // =================================================

                  AppCard(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                        MediaQuery.sizeOf(context).width < 600
                            ? 4
                            : 12,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          // =========================================
                          // PHOTO
                          // =========================================

                          CircleAvatar(
                            radius:
                            MediaQuery.sizeOf(context).width < 600
                                ? 42
                                : 48,
                            backgroundColor:
                            colorScheme.primaryContainer,
                            backgroundImage:
                            employee.photoUrl != null &&
                                employee.photoUrl!
                                    .trim()
                                    .isNotEmpty
                                ? NetworkImage(
                              employee.photoUrl!,
                            )
                                : null,
                            child:
                            employee.photoUrl == null ||
                                employee.photoUrl!
                                    .trim()
                                    .isEmpty
                                ? Text(
                              firstLetter,
                              style: theme
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                color:
                                colorScheme
                                    .onPrimaryContainer,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            )
                                : null,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =========================================
                          // NAME
                          // =========================================

                          Text(
                            employeeName,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          // =========================================
                          // EMPLOYEE CODE
                          // =========================================

                          if (employee.employeeCode != null &&
                              employee.employeeCode!
                                  .trim()
                                  .isNotEmpty)
                            Text(
                              employee.employeeCode!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),

                          const SizedBox(
                            height: 14,
                          ),

                          // =========================================
                          // STATUS
                          // =========================================

                          AppStatusChip(
                            isActive: employee.isActive,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =================================================
                  // EMPLOYEE INFORMATION
                  // =================================================

                  AppCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // ===========================================
                        // BASIC INFORMATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Basic Information',
                          Icons.badge_outlined,
                        ),

                        AppDetailTile(
                          icon: Icons.badge,
                          title: 'Employee Code',
                          value: _value(
                            employee.employeeCode,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.credit_card,
                          title: 'Card No',
                          value: _value(
                            employee.cardNo,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.person,
                          title: 'First Name',
                          value: _value(
                            employee.firstName,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.person_outline,
                          title: 'Last Name',
                          value: _value(
                            employee.lastName,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.person,
                          title: 'Full Name',
                          value: _value(
                            employee.fullName,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.business,
                          title: 'Company',
                          value: _value(
                            employee.companyId,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.apartment,
                          title: 'Department',
                          value: _value(
                            employee.departmentId,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.work,
                          title: 'Designation',
                          value: _value(
                            employee.designationId,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.access_time,
                          title: 'Shift',
                          value: _value(
                            employee.shiftId,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.admin_panel_settings,
                          title: 'Role',
                          value: _value(
                            employee.roleId,
                          ),
                        ),

                        // ===========================================
                        // PERSONAL INFORMATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Personal Information',
                          Icons.person_outline,
                        ),

                        AppDetailTile(
                          icon: Icons.wc,
                          title: 'Gender',
                          value: _value(
                            employee.gender,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.cake,
                          title: 'Date of Birth',
                          value: _formatDate(
                            employee.dateOfBirth,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.bloodtype,
                          title: 'Blood Group',
                          value: _value(
                            employee.bloodGroup,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.church,
                          title: 'Religion',
                          value: _value(
                            employee.religion,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.flag,
                          title: 'Nationality',
                          value: _value(
                            employee.nationality,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.family_restroom,
                          title: 'Marital Status',
                          value: _value(
                            employee.maritalStatus,
                          ),
                        ),

                        // ===========================================
                        // CONTACT INFORMATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Contact Information',
                          Icons.contact_phone_outlined,
                        ),

                        AppDetailTile(
                          icon: Icons.phone,
                          title: 'Mobile',
                          value: _value(
                            employee.mobile,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.email,
                          title: 'Email',
                          value: _value(
                            employee.email,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.contact_emergency,
                          title: 'Emergency Contact',
                          value: _value(
                            employee.emergencyContactName,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.phone_in_talk,
                          title: 'Emergency Mobile',
                          value: _value(
                            employee.emergencyContactMobile,
                          ),
                        ),

                        // ===========================================
                        // ADDRESS
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Address',
                          Icons.location_on_outlined,
                        ),

                        AppDetailTile(
                          icon: Icons.location_on,
                          title: 'Present Address',
                          value: _value(
                            employee.presentAddress,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.home,
                          title: 'Permanent Address',
                          value: _value(
                            employee.permanentAddress,
                          ),
                        ),

                        // ===========================================
                        // EMPLOYMENT INFORMATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Employment Information',
                          Icons.work_history_outlined,
                        ),

                        AppDetailTile(
                          icon: Icons.work_history,
                          title: 'Employment Type',
                          value: _value(
                            employee.employmentType,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.verified_user,
                          title: 'Employee Status',
                          value: _value(
                            employee.employeeStatus,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.calendar_today,
                          title: 'Joining Date',
                          value: _formatDate(
                            employee.joiningDate,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.event_available,
                          title: 'Confirmation Date',
                          value: _formatDate(
                            employee.confirmationDate,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.payments,
                          title: 'Basic Salary',
                          value: employee.basicSalary.toString(),
                        ),

                        // ===========================================
                        // IDENTIFICATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Identification',
                          Icons.fingerprint,
                        ),

                        AppDetailTile(
                          icon: Icons.credit_card,
                          title: 'NID',
                          value: _value(
                            employee.nidNo,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.travel_explore,
                          title: 'Passport',
                          value: _value(
                            employee.passportNo,
                          ),
                        ),

                        // ===========================================
                        // ACCOUNT INFORMATION
                        // ===========================================

                        _sectionTitle(
                          context,
                          'Account & Audit Information',
                          Icons.manage_accounts_outlined,
                        ),

                        AppDetailTile(
                          icon: Icons.account_circle,
                          title: 'User ID',
                          value: _value(
                            employee.userId,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.person_add,
                          title: 'Created By',
                          value: _value(
                            employee.createdBy,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.edit,
                          title: 'Updated By',
                          value: _value(
                            employee.updatedBy,
                          ),
                        ),

                        AppDetailTile(
                          icon: Icons.login,
                          title: 'Last Login',
                          value:
                          employee.lastLoginAt?.toString() ??
                              '-',
                        ),

                        AppDetailTile(
                          icon: Icons.access_time,
                          title: 'Created At',
                          value:
                          employee.createdAt?.toString() ??
                              '-',
                        ),

                        AppDetailTile(
                          icon: Icons.update,
                          title: 'Updated At',
                          value:
                          employee.updatedAt?.toString() ??
                              '-',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // SECTION TITLE
  // ===========================================================

  Widget _sectionTitle(
      BuildContext context,
      String title,
      IconData icon,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        4,
        20,
        4,
        8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}