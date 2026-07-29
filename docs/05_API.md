# Flutter HRMS Pro

# API Documentation

**Version:** `0.5.0`

---

# Overview

Flutter HRMS Pro uses **Supabase** as the backend platform.

Version **1.0** does **not** use custom REST APIs.

All backend communication is performed through the official **Supabase Flutter SDK** using the Repository Pattern.

Architecture

```text
Flutter UI

↓

Riverpod

↓

Repository

↓

Supabase Service

↓

Supabase Flutter SDK

↓

PostgreSQL
```

---

# Backend Stack

| Component | Technology |
|-----------|------------|
| Backend | Supabase |
| Database | PostgreSQL |
| Authentication | Supabase Auth |
| Storage | Supabase Storage |
| Security | Row Level Security |
| Realtime | Planned |

---

# Authentication API

## Login

```dart
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

Status

✅ Completed

---

## Logout

```dart
await supabase.auth.signOut();
```

Status

✅ Completed

---

## Current User

```dart
final user = supabase.auth.currentUser;
```

Status

✅ Completed

---

## Current Session

```dart
final session = supabase.auth.currentSession;
```

Status

✅ Completed

---

## Forgot Password

```dart
await supabase.auth.resetPasswordForEmail(
  email,
);
```

Status

🟡 Completed (Reset Flow Remaining)

---

## Update Password

```dart
await supabase.auth.updateUser(
  UserAttributes(
    password: password,
  ),
);
```

Status

🟡 Completed

---

# Repository Pattern

Every feature follows the same architecture.

```text
Presentation

↓

Provider

↓

Repository

↓

Supabase Service

↓

Supabase SDK
```

---

# Completed Repositories

## Company Repository

Operations

- Get Companies
- Get Company
- Add Company
- Update Company
- Delete Company

Status

✅ Completed

---

## Department Repository

Operations

- Get Departments
- Add Department
- Update Department
- Delete Department

Status

✅ Completed

---

## Designation Repository

Operations

- Get Designations
- Add Designation
- Update Designation
- Delete Designation

Status

✅ Completed

---

## Shift Repository

Operations

- Get Shifts
- Add Shift
- Update Shift
- Delete Shift

Status

✅ Completed

---

## Employee Repository

Operations

- Get Employees
- Add Employee
- Update Employee
- Delete Employee

Status

✅ Completed

---

# Database Operations

## Select

```dart
await supabase
    .from('employees')
    .select();
```

---

## Insert

```dart
await supabase
    .from('employees')
    .insert(data);
```

---

## Update

```dart
await supabase
    .from('employees')
    .update(data)
    .eq('id', id);
```

---

## Delete

```dart
await supabase
    .from('employees')
    .delete()
    .eq('id', id);
```

---

# Query Examples

## Filter

```dart
.from('employees')
.select()
.eq('company_id', companyId);
```

---

## Order

```dart
.order(
  'created_at',
  ascending: false,
);
```

---

## Search

```dart
.ilike(
  'full_name',
  '%john%',
);
```

---

## Limit

```dart
.limit(20);
```

---

# Storage API

## Upload

```dart
await supabase.storage
    .from('employee-photos')
    .upload(path, file);
```

---

## Public URL

```dart
supabase.storage
    .from('employee-photos')
    .getPublicUrl(path);
```

---

## Delete

```dart
await supabase.storage
    .from('employee-photos')
    .remove([path]);
```

---

# Authentication Helper Functions

Database Functions

- hrms_current_employee()
- hrms_current_employee_id()
- hrms_current_company_id()
- hrms_current_role()
- hrms_is_super_admin()
- hrms_is_company_admin()

Status

✅ Completed

---

# API Response Standard

Every repository should return a consistent response.

```dart
class ApiResult<T> {

  final bool success;

  final String message;

  final T? data;

  final Object? error;

}
```

---

# Error Handling

Pattern

```dart
try {

  final response = await repository.getAll();

  return ApiResult(
    success: true,
    message: 'Success',
    data: response,
  );

} on PostgrestException catch (e) {

  return ApiResult(
    success: false,
    message: e.message,
  );

} catch (e) {

  return ApiResult(
    success: false,
    message: e.toString(),
  );

}
```

Rules

- Always use try-catch
- Return friendly messages
- Log only in debug mode
- Never crash the application

---

# Security

Implemented

- Supabase Authentication
- Protected Routes
- Session Validation
- Route Guard
- Row Level Security
- Storage Policies

Future

- Permission Middleware
- Company Isolation
- Role Permission Matrix

Status

🟡 In Progress

---

# Current API Status

| Module | Status |
|---------|--------|
| Authentication | 🟡 95% |
| Company | ✅ |
| Department | ✅ |
| Designation | ✅ |
| Shift | ✅ |
| Employee | ✅ |
| Attendance | ⏳ |
| Leave | ⏳ |
| Dashboard | ⏳ |
| Reports | ⏳ |

---

# Upcoming APIs

Attendance

- Check In
- Check Out
- Attendance History
- Attendance Report

Leave

- Leave Types
- Apply Leave
- Leave Approval

Dashboard

- Statistics
- Charts
- Recent Activities

Reports

- Employee Report
- Attendance Report
- Leave Report

Settings

- User Profile
- Theme
- Permissions

---

# Version 2.x

Future Backend Features

- Edge Functions
- Realtime Attendance
- Push Notifications
- Email Notifications
- Payroll APIs
- Public REST API
- Webhooks

---

# API Design Principles

- Repository Pattern
- Feature Isolation
- Strong Typing
- Consistent Responses
- Error Safe
- Reusable Code
- Lightweight Backend
- Flutter First
- Supabase Native

---

# API Status

✅ Stable Foundation

Current implementation fully supports

- Authentication
- Company CRUD
- Department CRUD
- Designation CRUD
- Shift CRUD
- Employee CRUD

The next phase will introduce Attendance APIs while preserving the existing Repository architecture.