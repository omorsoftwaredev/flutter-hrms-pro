# Flutter HRMS Pro

# API Documentation

Version: 1.0

---

# Overview

Flutter HRMS Pro uses **Supabase** as the backend platform.

Currently, all data operations are performed through the Supabase Flutter SDK. No custom REST API is used in Version 1.0.

Future versions may expose REST APIs for third-party integrations.

---

# Backend

- Platform : Supabase
- Database : PostgreSQL
- Authentication : Supabase Auth
- Storage : Supabase Storage (Future)
- Realtime : Supabase Realtime (Future)

---

# Authentication API

## Login

Method

Supabase Authentication

Example

```dart
await Supabase.instance.client.auth.signInWithPassword(
  email: email,
  password: password,
);
```

Status

✅ Completed

---

## Logout

Example

```dart
await Supabase.instance.client.auth.signOut();
```

Status

✅ Completed

---

## Current User

Example

```dart
final user = Supabase.instance.client.auth.currentUser;
```

Status

✅ Completed

---

## Session

Example

```dart
final session = Supabase.instance.client.auth.currentSession;
```

Status

✅ Completed

---

## Auto Login

Supabase automatically restores the previous session.

Status

✅ Completed

---

## Forgot Password

Example

```dart
await Supabase.instance.client.auth.resetPasswordForEmail(
  email,
);
```

Status

⏳ Pending

---

# Database Operations

## Select

```dart
await Supabase.instance.client
    .from('employees')
    .select();
```

---

## Insert

```dart
await Supabase.instance.client
    .from('employees')
    .insert(data);
```

---

## Update

```dart
await Supabase.instance.client
    .from('employees')
    .update(data)
    .eq('id', id);
```

---

## Delete

```dart
await Supabase.instance.client
    .from('employees')
    .delete()
    .eq('id', id);
```

---

# Current Database APIs

## Companies

- Create
- Read
- Update
- Delete

Status

⏳ Pending

---

## Departments

- Create
- Read
- Update
- Delete

Status

⏳ Pending

---

## Designations

- Create
- Read
- Update
- Delete

Status

⏳ Pending

---

## Shifts

- Create
- Read
- Update
- Delete

Status

⏳ Pending

---

## Employees

- Create
- Read
- Update
- Delete

Status

⏳ Pending

---

# Upcoming APIs

## Attendance

- Check In
- Check Out
- Attendance History
- Attendance Report

---

## Leave

- Leave Apply
- Leave Approval
- Leave History

---

## Monitoring

- Upload Live Location
- Location History
- Route History

---

## Notification

- Send Notification
- Read Notification
- Mark as Read

---

## Dashboard

- Dashboard Summary
- Employee Statistics
- Attendance Statistics

---

# Response Handling

Every API call should return:

- Success
- Error
- Message
- Data (if available)

Example

```dart
try {
  final response = await Supabase.instance.client
      .from('employees')
      .select();
} catch (e) {
  debugPrint(e.toString());
}
```

---

# Error Handling

Rules

- Use try-catch
- Show user-friendly messages
- Log errors in debug mode
- Prevent application crash

---

# Security

- Supabase Authentication
- Protected Routes
- User Roles (Upcoming)
- Row Level Security (Future)

---

# API Status

| API | Status |
|------|--------|
| Authentication | 🟡 In Progress |
| Companies | ⏳ Pending |
| Departments | ⏳ Pending |
| Designations | ⏳ Pending |
| Shifts | ⏳ Pending |
| Employees | ⏳ Pending |
| Attendance | ⏳ Pending |
| Leave | ⏳ Pending |
| Monitoring | ⏳ Pending |
| Notification | ⏳ Pending |
| Dashboard | ⏳ Pending |

---

# Notes

- All backend communication uses the official Supabase Flutter SDK.
- REST API is not required for Version 1.0.
- Every new service or repository should be documented here before implementation.

---

Status: 🟡 ACTIVE