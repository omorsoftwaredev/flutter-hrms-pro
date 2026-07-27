# Flutter HRMS Pro

# API Documentation

**Version:** `0.2.0`

---

# Overview

Flutter HRMS Pro uses **Supabase** as its backend platform.

Version **1.0** does **not** use custom REST APIs. All backend communication is performed through the official **Supabase Flutter SDK**.

The architecture follows:

```
Flutter
    ↓
Repository
    ↓
Supabase Service
    ↓
Supabase SDK
    ↓
PostgreSQL
```

---

# Backend

| Component | Technology |
|-----------|------------|
| Backend | Supabase |
| Database | PostgreSQL |
| Authentication | Supabase Auth |
| Storage | Supabase Storage |
| Security | Row Level Security (RLS) |
| Realtime | Optional (Future) |

---

# Authentication

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

🟡 In Progress

---

## Update Password

```dart
await supabase.auth.updateUser(
  UserAttributes(
    password: newPassword,
  ),
);
```

Status

🟡 In Progress

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

# Storage Operations

## Upload

```dart
await supabase.storage
    .from('employee-photos')
    .upload(path, file);
```

---

## Download URL

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

Available Database Functions

- hrms_current_employee()
- hrms_current_employee_id()
- hrms_current_company_id()
- hrms_current_role()
- hrms_is_super_admin()
- hrms_is_company_admin()

Status

✅ Completed

---

# Planned Repositories

## Authentication

- Login
- Logout
- Forgot Password
- Update Password
- User Profile

---

## Dashboard

- Dashboard Summary
- Statistics
- Recent Activities

---

## Employee

- Company CRUD
- Department CRUD
- Designation CRUD
- Shift CRUD
- Employee CRUD
- Employee Documents

---

## Attendance

- Check In
- Check Out
- Attendance History
- Attendance Reports

---

## Leave

- Leave Types
- Apply Leave
- Leave Approval
- Holiday Calendar

---

## Work Notes

- Create Note
- Update Note
- Delete Note

---

## Tasks

- Create Task
- Assign Task
- Update Progress
- Task Comments

---

## Notifications

- Notification List
- Mark as Read

---

# Response Pattern

Every repository should return a consistent result.

```dart
class ApiResult<T> {
  final bool success;
  final String message;
  final T? data;
}
```

---

# Error Handling

Rules

- Use try-catch
- Return readable error messages
- Log exceptions in debug mode
- Prevent application crashes

Example

```dart
try {
  final data = await supabase
      .from('employees')
      .select();
} on PostgrestException catch (e) {
  debugPrint(e.message);
} catch (e) {
  debugPrint(e.toString());
}
```

---

# Security

Implemented

- Supabase Authentication
- Row Level Security (RLS)
- Storage Policies
- Protected Routes
- Role-Based Access (Application Level)

Status

✅ Completed

---

# API Status

| Module | Status |
|---------|--------|
| Authentication | 🟡 |
| Dashboard | ⏳ |
| Employee | ⏳ |
| Attendance | ⏳ |
| Leave | ⏳ |
| Work Notes | ⏳ |
| Tasks | ⏳ |
| Notifications | ⏳ |

---

# Future (v2.x)

- Supabase Edge Functions
- Push Notifications
- Realtime Attendance
- Public REST API (Optional)

---

# Notes

- Uses the official Supabase Flutter SDK.
- No custom REST API is required for Version 1.0.
- Repository Pattern is used for all database operations.
- Business logic remains inside Flutter, keeping the backend lightweight.

---

**Status:** 🟡 Active Development