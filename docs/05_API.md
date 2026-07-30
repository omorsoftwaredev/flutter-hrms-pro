# Flutter HRMS Pro

# API Documentation

**Version:** `0.6.0`

---

# API Overview

Flutter HRMS Pro uses **Supabase** as its backend platform.

Version **0.6.0** communicates directly with **Supabase Flutter SDK** using the **Repository Pattern** and **Clean Architecture**. No custom REST API server is required.

Architecture

```text
Flutter UI
      │
      ▼
Riverpod Provider
      │
      ▼
StateNotifier
      │
      ▼
Repository
      │
      ▼
Supabase Service
      │
      ▼
Supabase Flutter SDK
      │
      ▼
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
| Edge Functions | Planned |

---

# Authentication API

## Login

```dart
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

✅ Completed

---

## Logout

```dart
await supabase.auth.signOut();
```

✅ Completed

---

## Current User

```dart
final user = supabase.auth.currentUser;
```

✅ Completed

---

## Current Session

```dart
final session = supabase.auth.currentSession;
```

✅ Completed

---

## Forgot Password

```dart
await supabase.auth.resetPasswordForEmail(
  email,
);
```

✅ Completed

---

## Update Password

```dart
await supabase.auth.updateUser(
  UserAttributes(
    password: password,
  ),
);
```

✅ Completed

---

# Repository Architecture

Every module follows the same architecture.

```text
Presentation

↓

Riverpod Provider

↓

StateNotifier

↓

Repository

↓

Supabase Service

↓

Supabase

↓

PostgreSQL
```

---

# Completed Repositories

## Authentication Repository

Implemented

- Login
- Logout
- Current User
- Session
- Forgot Password
- Update Password

✅ Completed

---

## Company Repository

- Get All
- Get By Id
- Insert
- Update
- Delete

✅ Completed

---

## Department Repository

- Get All
- Insert
- Update
- Delete

✅ Completed

---

## Designation Repository

- Get All
- Insert
- Update
- Delete

✅ Completed

---

## Shift Repository

- Get All
- Insert
- Update
- Delete

✅ Completed

---

## Employee Repository

- Get All
- Insert
- Update
- Delete
- Current Employee

✅ Completed

---

## Attendance Repository

Implemented

- Get All Attendance
- Get Attendance By Id
- Insert Attendance
- Update Attendance
- Delete Attendance
- Mobile Check In
- Mobile Check Out
- Today's Attendance
- Employee Attendance
- Duplicate Check In Prevention
- Duplicate Check Out Prevention

✅ Completed

---

# Attendance APIs

## Mobile Check In

```dart
await attendanceRepository.checkIn(
  attendance,
);
```

Features

- Current Employee Mapping
- GPS Coordinates
- Address Detection
- Device Information
- Attendance Number Generation

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

Features

- GPS Update
- Address Update
- Working Minutes
- Duplicate Protection

✅ Completed

---

## Get Attendance List

```dart
await attendanceRepository.getAll();
```

✅ Completed

---

## Create Attendance

```dart
await attendanceRepository.insert(
  attendance,
);
```

✅ Completed

---

## Update Attendance

```dart
await attendanceRepository.update(
  attendance,
);
```

✅ Completed

---

## Delete Attendance

```dart
await attendanceRepository.delete(
  attendance.id,
);
```

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

## Company Filter

```dart
.eq(
  'company_id',
  companyId,
)
```

---

## Employee Filter

```dart
.eq(
  'employee_id',
  employeeId,
)
```

---

## Date Filter

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

✅ Completed

---

# Standard API Result

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
- Friendly error messages
- Never crash UI
- Debug logging only
- Return typed results

---

# Security

Implemented

- Authentication
- Session Validation
- Route Guard
- Current Employee Mapping
- Attendance Validation
- Row Level Security (Development)

Upcoming

- Company Isolation
- Department Isolation
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
| Dashboard | ⏳ |
| Leave | ⏳ |
| Reports | ⏳ |

---

# Upcoming APIs

## Dashboard

- Today Attendance
- Attendance Statistics
- Summary Cards
- Charts

---

## Leave

- Leave Types
- Apply Leave
- Leave Approval

---

## Reports

- Attendance Report
- Employee Report
- Leave Report

---

## Settings

- User Profile
- Theme
- Permission Settings

---

# Version 2.x

Future Backend Features

- Edge Functions
- Realtime Attendance
- Live GPS Tracking
- Employee Monitoring
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

# Current Milestone

✅ Authentication

✅ Company CRUD

✅ Department CRUD

✅ Designation CRUD

✅ Shift CRUD

✅ Employee CRUD

✅ Attendance CRUD

✅ Mobile Check In

✅ Mobile Check Out

⬇

🚀 Attendance Dashboard

⬇

🚀 Attendance History

⬇

🚀 Leave Module

⬇

🎯 Version 1.0