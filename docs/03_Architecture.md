# Flutter HRMS Pro

# Project Architecture

**Version:** `0.8.0`

---

# Architecture Overview

Flutter HRMS Pro follows a **Feature-First Clean Architecture** built with **Flutter**, **Riverpod**, **GoRouter**, and **Supabase**.

The architecture is designed to be:

- Clean
- Modular
- Scalable
- Maintainable
- Testable
- Responsive
- Production Ready
- CodeCanyon Ready

Each business module is isolated and follows the same folder structure.

---

# Technology Stack

- Flutter / Dart / Material 3
- Supabase
- PostgreSQL
- Flutter Riverpod
- GoRouter
- flutter_dotenv

---

# High Level Architecture

```text
Flutter UI
      ↓
Presentation Layer
      ↓
Riverpod Provider
      ↓
Notifier / State
      ↓
Repository / Data Source
      ↓
Supabase Service
      ↓
Supabase
      ↓
PostgreSQL
```

# Feature Structure

```text
features/
├── authentication/
├── company/
├── department/
├── designation/
├── shift/
├── role/
├── employee/
├── employee_account/
├── supervisor/
├── attendance/
└── settings/
```

# Multi Company Architecture

```text
Authenticated User
        ↓
     company_id
        ↓
        ├── Employees
        ├── Supervisors
        ├── Attendance
        ├── Working Days
        └── Attendance Rules
```

Normal company-owner settings do not require a company dropdown when the logged-in account already maps to a company.

# Settings Architecture

```text
Settings
│
├── Theme Settings
│   ├── Light
│   ├── Dark
│   └── System
│
└── Attendance Settings
    ├── Working Days
    └── Basic Attendance Rules
```

Weekend Settings are not maintained as a separate module/table.

# Attendance Architecture

```text
Employee
   ↓
Mobile Check In / Check Out
   ↓
Attendance Database
   ├── Employee Attendance
   └── Supervisor Attendance View
   ↓
Attendance Processing
   ├── Working Days
   └── Attendance Rules
   ↓
Reports
```

Raw attendance records remain preserved. Settings are used for calculations and reporting.

# Responsive UI

Major pages should use:

- `LayoutBuilder`
- `ConstrainedBox`
- `SingleChildScrollView`
- Adaptive spacing
- Mobile / tablet / desktop breakpoints
- Theme-aware colors

# Architectural Principles

1. Keep business logic outside widgets where practical.
2. Reuse providers and repositories.
3. Keep company-specific data scoped by `company_id`.
4. Preserve raw attendance records.
5. Avoid duplicate settings tables.
6. Complete and verify the current module before unrelated modules.
