import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';
import '../../../designation/presentation/providers/designation_provider.dart';
import '../../../shift/presentation/providers/shift_provider.dart';
import '../../../role/presentation/providers/role_provider.dart';

class EmployeeForm extends ConsumerStatefulWidget {
  const EmployeeForm({
    super.key,

    this.initialCompanyId,
    this.initialDepartmentId,
    this.initialDesignationId,
    this.initialShiftId,
    this.initialRoleId,

    this.initialEmployeeCode = '',
    this.initialCardNo = '',

    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialFullName = '',

    this.initialMobile = '',
    this.initialEmail = '',

    this.initialGender = 'Male',

    this.initialEmploymentType = 'Permanent',
    this.initialEmployeeStatus = 'Active',

    this.initialBasicSalary = 0,

    this.initialIsActive = true,

    this.isLoading = false,

    required this.onSubmit,
  });

  final String? initialCompanyId;
  final String? initialDepartmentId;
  final String? initialDesignationId;
  final String? initialShiftId;
  final String? initialRoleId;

  final String initialEmployeeCode;
  final String initialCardNo;

  final String initialFirstName;
  final String initialLastName;
  final String initialFullName;

  final String initialMobile;
  final String initialEmail;

  final String initialGender;

  final String initialEmploymentType;
  final String initialEmployeeStatus;

  final double initialBasicSalary;

  final bool initialIsActive;

  final bool isLoading;

  final Future<void> Function(
      String? companyId,
      String? departmentId,
      String? designationId,
      String? shiftId,
      String? roleId,

      String employeeCode,
      String cardNo,

      String firstName,
      String lastName,
      String fullName,

      String mobile,
      String email,

      String gender,

      String employmentType,
      String employeeStatus,

      double basicSalary,

      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<EmployeeForm> createState() =>
      _EmployeeFormState();
}

class _EmployeeFormState
    extends ConsumerState<EmployeeForm> {

final _formKey = GlobalKey<FormState>();

String? companyId;
String? departmentId;
String? designationId;
String? shiftId;
String? roleId;

late String gender;
late String employmentType;
late String employeeStatus;

late bool isActive;

late final TextEditingController employeeCode;
late final TextEditingController cardNo;

late final TextEditingController firstName;
late final TextEditingController lastName;
late final TextEditingController fullName;

late final TextEditingController mobile;
late final TextEditingController email;

late final TextEditingController salary;

@override
void initState() {
super.initState();

Future.microtask(() {
ref.read(companyProvider.notifier).loadCompanies();
ref.read(departmentProvider.notifier).loadDepartments();
ref.read(designationProvider.notifier).loadDesignations();
ref.read(shiftProvider.notifier).loadShifts();
ref.read(roleProvider.notifier).loadRoles();
});

companyId = widget.initialCompanyId;
departmentId = widget.initialDepartmentId;
designationId = widget.initialDesignationId;
shiftId = widget.initialShiftId;
roleId = widget.initialRoleId;

gender = widget.initialGender;
employmentType = widget.initialEmploymentType;
employeeStatus = widget.initialEmployeeStatus;

isActive = widget.initialIsActive;

employeeCode =
TextEditingController(text: widget.initialEmployeeCode);

cardNo =
TextEditingController(text: widget.initialCardNo);

firstName =
TextEditingController(text: widget.initialFirstName);

lastName =
TextEditingController(text: widget.initialLastName);

fullName =
TextEditingController(text: widget.initialFullName);

mobile =
TextEditingController(text: widget.initialMobile);

email =
TextEditingController(text: widget.initialEmail);

salary = TextEditingController(
text: widget.initialBasicSalary.toString(),
);
}

@override
void dispose() {
employeeCode.dispose();
cardNo.dispose();
firstName.dispose();
lastName.dispose();
fullName.dispose();
mobile.dispose();
email.dispose();
salary.dispose();
super.dispose();
}

Future<void> save() async {
if (!_formKey.currentState!.validate()) {
return;
}

await widget.onSubmit(
companyId,
departmentId,
designationId,
shiftId,
roleId,

employeeCode.text.trim(),
cardNo.text.trim(),

firstName.text.trim(),
lastName.text.trim(),
fullName.text.trim(),

mobile.text.trim(),
email.text.trim(),

gender,

employmentType,
employeeStatus,

double.tryParse(salary.text) ?? 0,

isActive,
);
}
@override
Widget build(BuildContext context) {

final companyState = ref.watch(companyProvider);
final departmentState = ref.watch(departmentProvider);
final designationState = ref.watch(designationProvider);
final shiftState = ref.watch(shiftProvider);
final roleState = ref.watch(roleProvider);

final companies = companyState.companies;

final departments = departmentState.departments
.where((e) => e.companyId == companyId)
.toList();

final designations = designationState.designations
.where((e) => e.companyId == companyId)
.toList();

final shifts = shiftState.shifts
.where((e) => e.companyId == companyId)
.toList();

final roles = roleState.filteredRoles
.where((e) => e.companyId == companyId)
.toList();

if (companyState.isLoading) {
return const Center(
child: CircularProgressIndicator(),
);
}

return Form(
key: _formKey,
child: ListView(
children: [

DropdownButtonFormField<String>(
value: companyId,
decoration: const InputDecoration(
labelText: 'Company',
),
items: companies
.map(
(e) => DropdownMenuItem(
value: e.id,
child: Text(e.name),
),
)
.toList(),
onChanged: (value) {
setState(() {
companyId = value;

departmentId = null;
designationId = null;
shiftId = null;
roleId = null;
});
},
validator: (v) =>
v == null ? 'Select Company' : null,
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
value: departmentId,
decoration: const InputDecoration(
labelText: 'Department',
),
items: departments
.map(
(e) => DropdownMenuItem(
value: e.id,
child: Text(e.name),
),
)
.toList(),
onChanged: (value) {
setState(() {
departmentId = value;
designationId = null;
});
},
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
value: designationId,
decoration: const InputDecoration(
labelText: 'Designation',
),
items: designations
.map(
(e) => DropdownMenuItem(
value: e.id,
child: Text(e.name),
),
)
.toList(),
onChanged: (value) {
setState(() {
designationId = value;
});
},
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
value: shiftId,
decoration: const InputDecoration(
labelText: 'Shift',
),
items: shifts
.map(
(e) => DropdownMenuItem(
value: e.id,
child: Text(e.name),
),
)
.toList(),
onChanged: (value) {
setState(() {
shiftId = value;
});
},
),

const SizedBox(height: 16),

/// NEW ROLE DROPDOWN
DropdownButtonFormField<String>(
value: roleId,
decoration: const InputDecoration(
labelText: 'Role',
),
items: roles
.map(
(e) => DropdownMenuItem(
value: e.id,
child: Text(e.roleName),
),
)
.toList(),
onChanged: (value) {
setState(() {
roleId = value;
});
},
),

const SizedBox(height: 16),

  TextFormField(
    controller: employeeCode,
    decoration: const InputDecoration(
      labelText: 'Employee Code',
    ),
    validator: (v) =>
    v == null || v.trim().isEmpty
        ? 'Employee Code is required'
        : null,
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: cardNo,
    decoration: const InputDecoration(
      labelText: 'Card No',
    ),
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: firstName,
    decoration: const InputDecoration(
      labelText: 'First Name',
    ),
    validator: (v) =>
    v == null || v.trim().isEmpty
        ? 'First Name is required'
        : null,
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: lastName,
    decoration: const InputDecoration(
      labelText: 'Last Name',
    ),
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: fullName,
    decoration: const InputDecoration(
      labelText: 'Full Name',
    ),
    validator: (v) =>
    v == null || v.trim().isEmpty
        ? 'Full Name is required'
        : null,
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: mobile,
    keyboardType: TextInputType.phone,
    decoration: const InputDecoration(
      labelText: 'Mobile',
    ),
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: email,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      labelText: 'Email',
    ),
  ),

  const SizedBox(height: 16),

  DropdownButtonFormField<String>(
    value: gender,
    decoration: const InputDecoration(
      labelText: 'Gender',
    ),
    items: const [
      DropdownMenuItem(
        value: 'Male',
        child: Text('Male'),
      ),
      DropdownMenuItem(
        value: 'Female',
        child: Text('Female'),
      ),
      DropdownMenuItem(
        value: 'Other',
        child: Text('Other'),
      ),
    ],
    onChanged: (value) {
      setState(() {
        gender = value!;
      });
    },
  ),

  const SizedBox(height: 16),

  DropdownButtonFormField<String>(
    value: employmentType,
    decoration: const InputDecoration(
      labelText: 'Employment Type',
    ),
    items: const [
      DropdownMenuItem(
        value: 'Permanent',
        child: Text('Permanent'),
      ),
      DropdownMenuItem(
        value: 'Contract',
        child: Text('Contract'),
      ),
      DropdownMenuItem(
        value: 'Intern',
        child: Text('Intern'),
      ),
    ],
    onChanged: (value) {
      setState(() {
        employmentType = value!;
      });
    },
  ),

  const SizedBox(height: 16),

  DropdownButtonFormField<String>(
    value: employeeStatus,
    decoration: const InputDecoration(
      labelText: 'Employee Status',
    ),
    items: const [
      DropdownMenuItem(
        value: 'Active',
        child: Text('Active'),
      ),
      DropdownMenuItem(
        value: 'Inactive',
        child: Text('Inactive'),
      ),
    ],
    onChanged: (value) {
      setState(() {
        employeeStatus = value!;
      });
    },
  ),

  const SizedBox(height: 16),

  TextFormField(
    controller: salary,
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
    ),
    decoration: const InputDecoration(
      labelText: 'Basic Salary',
    ),
  ),

  const SizedBox(height: 16),

  SwitchListTile(
    value: isActive,
    title: const Text('Active'),
    onChanged: (value) {
      setState(() {
        isActive = value;
      });
    },
  ),

  const SizedBox(height: 30),

  SizedBox(
    height: 50,
    child: FilledButton(
      onPressed: widget.isLoading
          ? null
          : save,
      child: widget.isLoading
          ? const SizedBox(
        height: 22,
        width: 22,
        child:
        CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
          : Text(
        companyId == null
            ? 'Save Employee'
            : 'Save Employee',
      ),
    ),
  ),

  const SizedBox(height: 24),
],
),
);
}
}
