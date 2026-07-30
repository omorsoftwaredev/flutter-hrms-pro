# Flutter HRMS Pro

# API Documentation

**Version:** `0.6.0`

---

# Overview

Flutter HRMS Pro uses **Supabase** as the backend platform.

Version **1.0** uses the official **Supabase Flutter SDK** with the **Repository Pattern**. No custom REST API server is required.

Architecture

```text
Flutter UI

↓

Riverpod

↓

Notifier

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
| Security | Row Level Security (RLS) |
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
final user =
    supabase.auth.currentUser;
```

Status

✅ Completed

---

## Current Session

```dart
final session =
    supabase.auth.currentSession;
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

🟡 Completed

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

# Repository Architecture

Every feature follows the same architecture.

```text
Page

↓

Riverpod Provider

↓

StateNotifier

↓

Repository

↓

Supabase

↓

Database
```

---

# Completed Repositories

## Authentication Repository

Operations

- Login
- Logout
- Current User
- Session
- Password Reset
- Update Password

Status

✅ Completed

---

## Company Repository

- Get All
- Get By Id
- Insert
- Update
- Delete

Status

✅ Completed

---

## Department Repository

- Get All
- Insert
- Update
- Delete

Status

✅ Completed

---

## Designation Repository

- Get All
- Insert
- Update
- Delete

Status

✅ Completed

---

## Shift Repository

- Get All
- Insert
- Update
- Delete

Status

✅ Completed

---

## Employee Repository

- Get All
- Insert
- Update
- Delete

Status

✅ Completed

---

## Attendance Repository

Implemented Operations

- Load Attendance
- Insert Attendance
- Update Attendance
- Delete Attendance
- Mobile Check In
- Mobile Check Out
- Today's Attendance
- Prevent Duplicate Check In
- Prevent Duplicate Check Out

Status

✅ Completed

---

# Attendance API

## Mobile Check In

```dart
await attendanceRepository.checkIn(
  attendance,
);
```

Status

✅ Completed

---

## Mobile Check Out

```dart
await attendanceRepository.checkOut(
  attendanceId: id,
  checkOutTime: DateTime.now(),
  latitude: latitude,
  longitude: longitude,
);
```

Status

✅ Completed

---

## Load Attendance

```dart
await attendanceRepository.getAll();
```

Status

✅ Completed

---

## Insert Attendance

```dart
await attendanceRepository.insert(
  attendance,
);
```

Status

✅ Completed

---

## Update Attendance

```dart
await attendanceRepository.update(
  attendance,
);
```

Status

✅ Completed

---

## Delete Attendance

```dart
await attendanceRepository.delete(
  attendance.id,
);
```

Status

✅ Completed

---

# Database Operations

## Select

```dart
await supabase
    .from('attendance')
    .select();
```

---

## Insert

```dart
await supabase
    .from('attendance')
    .insert(data);
```

---

## Update

```dart
await supabase
    .from('attendance')
    .update(data)
    .eq('id', id);
```

---

## Delete

```dart
await supabase
    .from('attendance')
    .delete()
    .eq('id', id);
```

---

# Query Examples

## Filter

```dart
.eq(
  'company_id',
  companyId,
)
```

---

## Employee

```dart
.eq(
  'employee_id',
  employeeId,
)
```

---

## Date

```dart
.eq(
  'attendance_date',
  today,
)
```

---

## Search

```dart
.ilike(
  'attendance_no',
  '%ATT%',
)
```

---

## Order

```dart
.order(
  'created_at',
  ascending: false,
)
```

---

# Storage API

Implemented

```dart
upload()

remove()

getPublicUrl()
```

Status

🟡 Ready

---

# Authentication Helper Functions

Implemented

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

} on PostgrestException catch (e) {

} catch (e) {

}
```

Rules

- Always use try-catch
- Friendly messages
- Never crash UI
- Debug logging only
- Return bool/result

---

# Security

Implemented

- Authentication
- Session Validation
- Route Guard
- Current Employee Mapping
- Row Level Security
- Attendance Validation

Upcoming

- Company Isolation
- Permission Middleware
- Role Permission Matrix

Status

🟡 In Progress

---

# Current API Status

| Module | Status |
|---------|--------|
| Authentication | ✅ |
| Company | ✅ |
| Department | ✅ |
| Designation | ✅ |
| Shift | ✅ |
| Employee | ✅ |
| Attendance CRUD | ✅ |
| Mobile Check In | ✅ |
| Mobile Check Out | ✅ |
| Leave | ⏳ |
| Dashboard | ⏳ |
| Reports | ⏳ |

---

# Upcoming APIs

Leave

- Leave Types
- Apply Leave
- Leave Approval

Dashboard

- Statistics
- Charts
- Summary Cards

Reports

- Attendance Report
- Employee Report
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
- Live GPS Tracking
- Face Attendance
- Push Notification
- Payroll APIs
- Public REST API
- Webhooks

---

# API Design Principles

- Clean Architecture
- Repository Pattern
- Feature First
- Riverpod
- Strong Typing
- Error Safe
- Reusable Code
- Lightweight Backend
- Flutter First
- Supabase Native

---

# API Status

✅ Stable Foundation

Completed Modules

- Authentication
- Company CRUD
- Department CRUD
- Designation CRUD
- Shift CRUD
- Employee CRUD
- Attendance CRUD
- Mobile Check In
- Mobile Check Out

Next Development

🚀 Leave Module

↓

🚀 Dashboard

↓

🚀 Reports

↓

🎯 Version 1.0