import 'package:flutter/material.dart';

import '../../domain/entities/employee_entity.dart';

class EmployeeViewPage extends StatelessWidget {
  const EmployeeViewPage({
    super.key,
    required this.employee,
  });

  final EmployeeEntity employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 45,
                  backgroundImage:
                  employee.photoUrl != null &&
                      employee.photoUrl!.isNotEmpty
                      ? NetworkImage(
                    employee.photoUrl!,
                  )
                      : null,
                  child:
                  employee.photoUrl == null ||
                      employee.photoUrl!.isEmpty
                      ? Text(
                    employee.fullName
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  employee.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 4),

                Text(
                  employee.employeeCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const Divider(height: 32),

                _buildTile(
                  'Card No',
                  employee.cardNo,
                ),

                _buildTile(
                  'Company',
                  employee.companyId,
                ),

                _buildTile(
                  'Department',
                  employee.departmentId,
                ),

                _buildTile(
                  'Designation',
                  employee.designationId,
                ),

                _buildTile(
                  'Shift',
                  employee.shiftId,
                ),

                _buildTile(
                  'Role',
                  employee.roleId,
                ),

                _buildTile(
                  'Gender',
                  employee.gender,
                ),

                _buildTile(
                  'Mobile',
                  employee.mobile,
                ),

                _buildTile(
                  'Email',
                  employee.email,
                ),

                _buildTile(
                  'Blood Group',
                  employee.bloodGroup,
                ),

                _buildTile(
                  'Religion',
                  employee.religion,
                ),

                _buildTile(
                  'Nationality',
                  employee.nationality,
                ),

                _buildTile(
                  'Marital Status',
                  employee.maritalStatus,
                ),

                _buildTile(
                  'Employment Type',
                  employee.employmentType,
                ),

                _buildTile(
                  'Employee Status',
                  employee.employeeStatus,
                ),

                _buildTile(
                  'Basic Salary',
                  employee.basicSalary.toString(),
                ),

                _buildTile(
                  'Joining Date',
                  employee.joiningDate
                      ?.toString()
                      .split(' ')
                      .first,
                ),

                _buildTile(
                  'Confirmation Date',
                  employee.confirmationDate
                      ?.toString()
                      .split(' ')
                      .first,
                ),

                _buildTile(
                  'NID',
                  employee.nidNo,
                ),

                _buildTile(
                  'Passport',
                  employee.passportNo,
                ),

                _buildTile(
                  'Emergency Contact',
                  employee.emergencyContactName,
                ),

                _buildTile(
                  'Emergency Mobile',
                  employee.emergencyContactMobile,
                ),

                _buildTile(
                  'Present Address',
                  employee.presentAddress,
                ),

                _buildTile(
                  'Permanent Address',
                  employee.permanentAddress,
                ),

                _buildTile(
                  'Active',
                  employee.isActive
                      ? 'Yes'
                      : 'No',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      String title,
      String? value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value == null || value.isEmpty
                  ? '-'
                  : value,
            ),
          ),
        ],
      ),
    );
  }
}