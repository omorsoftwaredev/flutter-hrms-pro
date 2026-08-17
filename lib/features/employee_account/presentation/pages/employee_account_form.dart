//===============================================================
// Employee Account Form
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';
import '../../../employee/presentation/providers/employee_provider.dart';

class EmployeeAccountForm extends ConsumerStatefulWidget {
const EmployeeAccountForm({
super.key,

this.initialCompanyId,
this.initialDepartmentId,
this.initialEmployeeId,

this.initialUsername = '',
this.initialPassword = '',

this.initialCanLogin = true,
this.initialIsActive = true,
this.initialIsLocked = false,

this.isEdit = false,

required this.isLoading,
required this.onSubmit,
});

// =============================================================
// INITIAL DATA
// =============================================================

final String? initialCompanyId;
final String? initialDepartmentId;
final String? initialEmployeeId;

final String initialUsername;
final String initialPassword;

final bool initialCanLogin;
final bool initialIsActive;
final bool initialIsLocked;

// =============================================================
// MODE
// =============================================================

final bool isEdit;

// =============================================================
// STATE
// =============================================================

final bool isLoading;

// =============================================================
// SUBMIT
// =============================================================

final Future<void> Function(
String companyId,
String departmentId,
String employeeId,
String username,
String password,
bool canLogin,
bool isActive,
bool isLocked,
) onSubmit;

@override
ConsumerState<EmployeeAccountForm> createState() =>
_EmployeeAccountFormState();
}

class _EmployeeAccountFormState
extends ConsumerState<EmployeeAccountForm> {
final _formKey = GlobalKey<FormState>();

late final TextEditingController _usernameController;
late final TextEditingController _passwordController;

String? companyId;
String? departmentId;
String? employeeId;

bool canLogin = true;
bool isActive = true;
bool isLocked = false;

// =============================================================
// INIT
// =============================================================

@override
void initState() {
super.initState();

_usernameController = TextEditingController(
text: widget.initialUsername,
);

_passwordController = TextEditingController(
text: widget.initialPassword,
);

companyId = widget.initialCompanyId;
departmentId = widget.initialDepartmentId;
employeeId = widget.initialEmployeeId;

canLogin = widget.initialCanLogin;
isActive = widget.initialIsActive;
isLocked = widget.initialIsLocked;

Future.microtask(_loadData);
}

// =============================================================
// LOAD DATA
// =============================================================

Future<void> _loadData() async {
try {
final user = ref.read(currentUserProvider);

if (user == null) {
debugPrint(
'Employee Account Form => Current user unavailable.',
);
return;
}

final currentCompanyId = user.companyId.trim();

if (currentCompanyId.isEmpty) {
debugPrint(
'Employee Account Form => Company ID unavailable.',
);
return;
}

if (mounted) {
setState(() {
companyId = currentCompanyId;

if (departmentId != null &&
widget.initialCompanyId != currentCompanyId) {
departmentId = null;
employeeId = null;
}
});
}

await ref
    .read(departmentProvider.notifier)
    .loadDepartments();

await ref
    .read(employeeProvider.notifier)
    .loadEmployees();
} catch (e) {
debugPrint(
'Employee Account Form Load Error => $e',
);
}
}

// =============================================================
// DISPOSE
// =============================================================

@override
void dispose() {
_usernameController.dispose();
_passwordController.dispose();

super.dispose();
}

// =============================================================
// CONTENT WIDTH
// =============================================================

double _contentWidth(BuildContext context) {
final width = MediaQuery.sizeOf(context).width;

if (width >= 1400) {
return 900;
}

if (width >= 1000) {
return 820;
}

if (width >= 700) {
return 700;
}

return double.infinity;
}

// =============================================================
// HORIZONTAL PADDING
// =============================================================

double _horizontalPadding(BuildContext context) {
final width = MediaQuery.sizeOf(context).width;

if (width >= 1200) {
return 32;
}

if (width >= 700) {
return 24;
}

return 16;
}

// =============================================================
// SECTION CARD
// =============================================================

Widget _buildSettingsCard(
BuildContext context,
ThemeData theme,
) {
return Card(
elevation: 0,
clipBehavior: Clip.antiAlias,
child: Column(
children: [
//=======================================================
// SECTION HEADER
//=======================================================

Padding(
padding: const EdgeInsets.fromLTRB(
16,
16,
16,
8,
),
child: Row(
children: [
Icon(
Icons.settings_outlined,
color: theme.colorScheme.primary,
),
const SizedBox(width: 10),
Text(
'Account Settings',
style: theme.textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.w700,
),
),
],
),
),

//=======================================================
// ALLOW LOGIN
//=======================================================

SwitchListTile(
value: canLogin,
title: const Text(
'Allow Login',
),
subtitle: const Text(
'Employee can login to the system',
),
secondary: const Icon(
Icons.login_rounded,
),
onChanged: widget.isLoading
? null
    : (value) {
setState(() {
canLogin = value;
});
},
),

const Divider(
height: 1,
),

//=======================================================
// ACTIVE
//=======================================================

SwitchListTile(
value: isActive,
title: const Text(
'Active Account',
),
subtitle: const Text(
'Enable / Disable account',
),
secondary: const Icon(
Icons.verified_user_outlined,
),
onChanged: widget.isLoading
? null
    : (value) {
setState(() {
isActive = value;
});
},
),

const Divider(
height: 1,
),

//=======================================================
// LOCK
//=======================================================

SwitchListTile(
value: isLocked,
title: const Text(
'Lock Account',
),
subtitle: const Text(
'Prevent employee login',
),
secondary: const Icon(
Icons.lock_outline_rounded,
),
onChanged: widget.isLoading
? null
    : (value) {
setState(() {
isLocked = value;
});
},
),

const SizedBox(
height: 8,
),
],
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

final user = ref.watch(currentUserProvider);

final departmentState = ref.watch(
departmentProvider,
);

final employeeState = ref.watch(
employeeProvider,
);

final currentCompanyId =
user?.companyId.trim() ?? '';

// ===========================================================
// KEEP COMPANY IN SYNC
// ===========================================================

if (currentCompanyId.isNotEmpty &&
companyId != currentCompanyId) {
companyId = currentCompanyId;
}

// ===========================================================
// DATA
// ===========================================================

final departments =
departmentState.departments;

final employees =
employeeState.employees;

// ===========================================================
// FILTER DEPARTMENTS
// ===========================================================

final filteredDepartments = departments
    .where(
(department) =>
department.companyId == currentCompanyId,
)
    .toList();

// ===========================================================
// FILTER EMPLOYEES
// ===========================================================

final filteredEmployees = employees
    .where(
(employee) =>
employee.companyId == currentCompanyId &&
employee.departmentId == departmentId,
)
    .toList();

// ===========================================================
// INVALID USER
// ===========================================================

if (user == null) {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Text(
'Logged-in user information is not available.',
textAlign: TextAlign.center,
style: theme.textTheme.bodyMedium,
),
),
);
}

// ===========================================================
// INVALID COMPANY
// ===========================================================

if (currentCompanyId.isEmpty) {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Text(
'Company information is not available for this account.',
textAlign: TextAlign.center,
style: theme.textTheme.bodyMedium,
),
),
);
}

// ===========================================================
// FORM
// ===========================================================

return Center(
child: SizedBox(
width: _contentWidth(context),
child: Form(
key: _formKey,
child: SingleChildScrollView(
padding: EdgeInsets.fromLTRB(
_horizontalPadding(context),
16,
_horizontalPadding(context),
24,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
//=================================================
// FORM HEADER
//=================================================

Text(
widget.isEdit
? 'Update Employee Account'
    : 'Create Employee Account',
style: theme.textTheme.headlineSmall?.copyWith(
fontWeight: FontWeight.w700,
),
),

const SizedBox(
height: 6,
),

Text(
widget.isEdit
? 'Update login and account settings for this employee.'
    : 'Create a login account for an employee.',
style: theme.textTheme.bodyMedium?.copyWith(
color: colorScheme.onSurfaceVariant,
),
),

const SizedBox(
height: 24,
),

//=================================================
// DEPARTMENT
//=================================================

DropdownButtonFormField<String>(
value: filteredDepartments.any(
(department) =>
department.id == departmentId,
)
? departmentId
    : null,
decoration: const InputDecoration(
labelText: 'Department',
border: OutlineInputBorder(),
prefixIcon: Icon(
Icons.account_tree_outlined,
),
),
items: filteredDepartments.map(
(department) {
return DropdownMenuItem<String>(
value: department.id,
child: Text(
department.name,
overflow: TextOverflow.ellipsis,
),
);
},
).toList(),
onChanged: widget.isLoading
? null
    : (value) {
setState(() {
departmentId = value;
employeeId = null;
});
},
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'Select department';
}

return null;
},
),

const SizedBox(
height: 16,
),

//=================================================
// EMPLOYEE
//=================================================

DropdownButtonFormField<String>(
value: filteredEmployees.any(
(employee) =>
employee.id == employeeId,
)
? employeeId
    : null,
decoration: const InputDecoration(
labelText: 'Employee',
border: OutlineInputBorder(),
prefixIcon: Icon(
Icons.person_outline_rounded,
),
),
items: filteredEmployees.map(
(employee) {
return DropdownMenuItem<String>(
value: employee.id,
child: Text(
employee.fullName,
overflow: TextOverflow.ellipsis,
),
);
},
).toList(),
onChanged:
departmentId == null ||
widget.isLoading
? null
    : (value) {
setState(() {
employeeId = value;
});
},
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'Select employee';
}

return null;
},
),

const SizedBox(
height: 20,
),

//=================================================
// USERNAME
//=================================================

TextFormField(
controller: _usernameController,
enabled: !widget.isLoading,
decoration: const InputDecoration(
labelText: 'Username',
hintText: 'Enter username',
border: OutlineInputBorder(),
prefixIcon: Icon(
Icons.person_outline_rounded,
),
),
textInputAction:
TextInputAction.next,
validator: (value) {
final username =
value?.trim() ?? '';

if (username.isEmpty) {
return 'Username is required';
}

if (username.length < 4) {
return 'Minimum 4 characters';
}

return null;
},
),

const SizedBox(
height: 16,
),

//=================================================
// PASSWORD
//=================================================

TextFormField(
controller: _passwordController,
enabled: !widget.isLoading,
obscureText: true,
decoration: InputDecoration(
labelText: widget.isEdit
? 'New Password'
    : 'Password',
hintText: widget.isEdit
? 'Leave empty to keep current password'
    : 'Enter password',
border:
const OutlineInputBorder(),
prefixIcon: const Icon(
Icons.lock_outline_rounded,
),
),
validator: (value) {
final password =
value ?? '';

// CREATE

if (!widget.isEdit &&
password.isEmpty) {
return 'Password is required';
}

// EDIT

if (widget.isEdit &&
password.isEmpty) {
return null;
}

if (password.length < 6) {
return 'Password must be at least 6 characters';
}

return null;
},
),

const SizedBox(
height: 24,
),

//=================================================
// ACCOUNT SETTINGS
//=================================================

_buildSettingsCard(
context,
theme,
),

const SizedBox(
height: 24,
),

//=================================================
// SAVE BUTTON
//=================================================

SizedBox(
width: double.infinity,
height: 52,
child: FilledButton.icon(
onPressed: widget.isLoading
? null
    : () async {
//=====================================
// VALIDATE FORM
//=====================================

if (!_formKey
    .currentState!
    .validate()) {
return;
}

//=====================================
// COMPANY
//=====================================

final finalCompanyId =
currentCompanyId;

//=====================================
// REQUIRED IDs
//=====================================

if (finalCompanyId
    .isEmpty ||
departmentId == null ||
employeeId == null) {
ScaffoldMessenger
    .of(context)
    .showSnackBar(
SnackBar(
backgroundColor:
colorScheme.error,
content: Text(
'Please complete all required fields.',
style: TextStyle(
color: colorScheme
    .onError,
),
),
),
);

return;
}

//=====================================
// DEBUG
//=====================================

debugPrint(
'==============================================',
);

debugPrint(
'EMPLOYEE ACCOUNT SAVE',
);

debugPrint(
'Mode         => '
'${widget.isEdit ? 'UPDATE' : 'CREATE'}',
);

debugPrint(
'Company ID   => '
'$finalCompanyId',
);

debugPrint(
'Department   => '
'$departmentId',
);

debugPrint(
'Employee     => '
'$employeeId',
);

debugPrint(
'Username     => '
'${_usernameController.text.trim()}',
);

debugPrint(
'Can Login    => '
'$canLogin',
);

debugPrint(
'Active       => '
'$isActive',
);

debugPrint(
'Locked       => '
'$isLocked',
);

debugPrint(
'==============================================',
);

//=====================================
// SUBMIT
//=====================================

try {
await widget.onSubmit(
finalCompanyId,
departmentId!,
employeeId!,
_usernameController
    .text
    .trim(),
_passwordController
    .text
    .trim(),
canLogin,
isActive,
isLocked,
);
} catch (e) {
if (!context.mounted) {
return;
}

ScaffoldMessenger
    .of(context)
    .showSnackBar(
SnackBar(
backgroundColor:
colorScheme.error,
content: Text(
e.toString(),
style: TextStyle(
color: colorScheme
    .onError,
),
),
),
);
}
},
icon: widget.isLoading
? SizedBox(
width: 20,
height: 20,
child:
CircularProgressIndicator(
strokeWidth: 2,
color:
colorScheme.onPrimary,
),
)
    : const Icon(
Icons.save_rounded,
),
label: Text(
widget.isLoading
? 'Saving...'
    : widget.isEdit
? 'Update Account'
    : 'Save Account',
),
),
),

const SizedBox(
height: 8,
),
],
),
),
),
),
);
}
}
