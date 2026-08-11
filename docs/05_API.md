# Flutter HRMS Pro

# API Documentation

**Version:** `0.8.0`

---

# API Overview

Flutter HRMS Pro uses **Supabase** as its backend platform.

The application communicates directly with the **Supabase Flutter SDK** using the **Repository Pattern** and **Clean Architecture**. No custom REST API server is required.

# Architecture

```text
Flutter UI
      ↓
Riverpod Provider
      ↓
Notifier / State
      ↓
Repository / Remote DataSource
      ↓
Supabase Service
      ↓
Supabase Flutter SDK
      ↓
PostgreSQL
```

# Current Data Modules

## Authentication
- Login
- Logout
- Session Management
- Auto Login
- Route Guard
- Current User Mapping

## Company
- Company CRUD
- Company Based Data Access

## Employee
- Employee CRUD
- Employee Account Mapping

## Supervisor
- Supervisor CRUD
- Supervisor Department Assignment
- Supervisor Dashboard Data
- Supervisor Attendance Data

## Attendance
- Employee Check In
- Employee Check Out
- Attendance History
- Attendance Details
- Attendance Analytics
- Supervisor Attendance View

## Settings
- Theme Settings
- Working Days Settings
- Basic Attendance Rules

# Company Context

```text
Authenticated User
      ↓
Current User
      ↓
company_id
      ↓
Supabase Query
```

Normal company-owner settings do not require a company dropdown when the account already maps to a company.

# Attendance Rules

Attendance rules are stored per company.

```text
company_id
late_grace_minutes
early_leave_grace_minutes
late_attendance_allowed
early_leave_allowed
half_day_threshold_hours
minimum_working_hours
check_in_required
check_out_required
```

# Attendance Reporting Principle

The reporting layer should use:

1. Raw attendance records
2. Employee information
3. Company information
4. Shift information
5. Working days
6. Attendance rules

Original check-in/check-out values should remain available for audit and historical reporting.

# Future Data Work

- Attendance Report
- Monthly Attendance
- Working Hour Summary
- PDF Export
- Excel Export
- Leave
- Notifications
- Employee Monitoring
