# Flutter HRMS Pro

# Database Documentation

**Version:** `0.8.0`

---

# Database Overview

Flutter HRMS Pro uses **Supabase PostgreSQL** as its primary database engine.

The database follows a **multi-company HRMS architecture** designed for scalability, security, maintainability, and enterprise-grade performance.

## Objectives

- Multi Company Architecture
- UUID Based Design
- Clean Relational Database
- High Performance
- Secure Authentication
- Scalable Structure
- GPS Ready
- Mobile Attendance Ready
- Supervisor Management Ready
- Role & Permission Ready
- Company Wise Settings
- CodeCanyon Quality

# Database Modules

| Module | Status |
| --- | --- |
| Companies | ✅ Completed |
| Departments | ✅ Completed |
| Designations | ✅ Completed |
| Shifts | ✅ Completed |
| Roles | ✅ Completed |
| Role Permissions | ✅ Completed |
| Employees | ✅ Completed |
| Employee Accounts | ✅ Completed |
| Supervisors | ✅ Completed |
| Supervisor Department Assignments | ✅ Completed |
| Attendance | ✅ Completed |
| Working Days Settings | ✅ Completed |
| Attendance Rules Settings | ✅ Completed |
| Theme Settings | ✅ Completed |
| Weekend Settings Table | ❌ Removed |
| Attendance Reports | ⏳ Planned |
| Holidays | ⏳ Planned |
| Leave | ⏳ Planned |
| Notifications | ⏳ Planned |

# Current Database Structure

```text
Company
   │
   ├── Departments
   ├── Designations
   ├── Shifts
   ├── Roles
   ├── Employees
   │      ├── Employee Accounts
   │      └── Attendance
   ├── Supervisors
   │      └── Supervisor Department Assignments
   ├── Company Accounts
   ├── Working Days Settings
   └── Attendance Rules
```

# Attendance Rules Table

Current company-wise attendance rules are stored in:

```text
company_attendance_rules
```

Associated with:

```text
company_id
```

Important fields:

- `late_grace_minutes`
- `early_leave_grace_minutes`
- `late_attendance_allowed`
- `early_leave_allowed`
- `half_day_threshold_hours`
- `minimum_working_hours`
- `check_in_required`
- `check_out_required`

Each company has its own attendance rules.

# Working Days

Working days are configured company-wise.

No separate weekend settings table is maintained.

```text
Working Days
   ↓
7 Days
   ↓
Working / Day Off
```

# Attendance Data Principle

Raw attendance records should remain unchanged after creation.

```text
Actual Check-in
      ↓
Stored as raw attendance data
      ↓
Attendance Rules
      ↓
Calculated Result
      ↓
Report
```

# Multi Company Data Isolation

```text
Company A
   ├── Employees
   ├── Attendance
   ├── Working Days
   └── Attendance Rules

Company B
   ├── Employees
   ├── Attendance
   ├── Working Days
   └── Attendance Rules
```

Data from one company must never be mixed with another company's data.
