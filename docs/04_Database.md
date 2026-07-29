# Flutter HRMS Pro

# Database Documentation

**Version:** `0.5.0`

---

# Database Overview

Flutter HRMS Pro uses **Supabase PostgreSQL** as its primary database engine.

The database is designed using a **multi-company HRMS architecture** that is lightweight, scalable and production-ready.

Primary Objectives

- Clean Schema
- High Performance
- Multi Company Support
- Secure Authentication
- Easy Maintenance
- CodeCanyon Ready

---

# Database Technology

- PostgreSQL
- Supabase
- UUID Primary Keys
- Foreign Keys
- Indexes
- Constraints
- Triggers
- Views
- Row Level Security (RLS)
- Storage Buckets

---

# Database Modules

| Module | Status |
|---------|--------|
| Companies | ✅ Completed |
| Departments | ✅ Completed |
| Designations | ✅ Completed |
| Shifts | ✅ Completed |
| Employees | ✅ Completed |
| Attendance | ⏳ Planned |
| Leave | ⏳ Planned |
| Dashboard | ⏳ Planned |
| Reports | ⏳ Planned |
| Notifications | ⏳ Planned |

---

# Current Database Structure

```text
Company

│

├──────────────┐

▼              │

Department     │

               │

Designation    │

               │

Shift          │

               │

Employee───────┘

      │

      ├── Attendance

      ├── Leave

      ├── Reports

      ├── Notifications

      └── Documents
```

---

# Current Tables

## companies

Purpose

Stores company information.

Main Fields

- id
- code
- name
- email
- phone
- website
- address
- is_active
- created_at
- updated_at

Status

✅ Completed

---

## departments

Purpose

Stores department information.

Main Fields

- id
- company_id
- code
- name
- description
- display_order
- is_active

Status

✅ Completed

---

## designations

Purpose

Stores designation information.

Main Fields

- id
- company_id
- code
- name
- description
- grade
- base_salary
- display_order
- is_active

Status

✅ Completed

---

## shifts

Purpose

Stores office shift information.

Main Fields

- id
- company_id
- code
- name
- start_time
- end_time
- break_minutes
- grace_in_minutes
- grace_out_minutes
- weekly_off_day
- is_night_shift
- is_flexible
- is_active

Status

✅ Completed

---

## employees

Purpose

Stores employee master information.

Main Fields

- id
- company_id
- department_id
- designation_id
- shift_id
- user_id
- employee_code
- card_no
- full_name
- mobile
- email
- joining_date
- employment_type
- employee_status
- role
- basic_salary
- is_super_admin
- is_company_admin
- created_by
- updated_by
- created_at
- updated_at

Status

✅ Completed

---

# Database Relationships

```text
Company

│

├──── Department

│

├──── Designation

│

├──── Shift

│

└──── Employee

        │

        ├── Department

        ├── Designation

        ├── Shift

        └── Auth User
```

---

# Foreign Keys

## Company

Referenced by

- Departments
- Designations
- Shifts
- Employees

---

## Department

Referenced by

- Employees

---

## Designation

Referenced by

- Employees

---

## Shift

Referenced by

- Employees

---

## Authentication

```text
auth.users

      │

      ▼

employees.user_id
```

---

# Database Features

Implemented

- UUID Primary Keys
- Foreign Keys
- Unique Constraints
- Check Constraints
- Indexes
- Triggers
- Updated_at Trigger
- Validation
- RLS
- Authentication Mapping

Status

✅ Completed

---

# Trigger Functions

Implemented

```text
fn_set_updated_at()

protect_employee_sensitive_fields()
```

Status

✅ Completed

---

# Row Level Security

Development Policy

CRUD Enabled

- SELECT
- INSERT
- UPDATE
- DELETE

Production

Future implementation

- Company Isolation
- Role Based Access
- Permission Based Security

Status

🟡 Development Mode

---

# Storage

Buckets

| Bucket | Status |
|----------|--------|
| employee-photos | Planned |
| company-logo | Planned |
| employee-documents | Planned |

---

# Index Strategy

Indexes Added

- Company
- Department
- Designation
- Shift
- Employee Code
- Card Number
- Mobile
- Email
- Full Name
- Role

Status

✅ Optimized

---

# Naming Convention

Tables

snake_case

Columns

snake_case

Primary Key

id

Foreign Key

company_id

department_id

designation_id

shift_id

user_id

Timestamps

created_at

updated_at

---

# Authentication Mapping

```text
Supabase Auth

↓

auth.users

↓

employees.user_id

↓

Application User
```

---

# Database Standards

- UUID Primary Keys
- Foreign Keys
- Proper Constraints
- Indexed Search Columns
- Trigger Based Timestamp
- Clean Naming Convention
- Multi Company Ready
- Flutter Friendly

---

# Current Database Status

| Component | Status |
|-----------|--------|
| Schema Design | ✅ |
| Relationships | ✅ |
| Foreign Keys | ✅ |
| Constraints | ✅ |
| Indexes | ✅ |
| Triggers | ✅ |
| RLS | ✅ |
| Authentication | ✅ |
| CRUD Foundation | ✅ |

---

# Upcoming Tables

- attendance
- leave_types
- leave_requests
- holidays
- attendance_logs
- notifications
- reports

Status

⏳ Planned

---

# Version 2.x Database

Future Modules

- Face Attendance
- GPS Tracking
- Payroll
- Assets
- Recruitment
- Performance
- Visitor Management

---

# Database Goals

- Lightweight
- Clean
- High Performance
- Secure
- Scalable
- Easy Maintenance
- Production Ready
- CodeCanyon Ready

---

# Database Status

✅ Stable Foundation

The current database foundation supports:

- Authentication
- Company Management
- Department Management
- Designation Management
- Shift Management
- Employee Management

The next phase is **Attendance Management**, which will extend the existing schema while preserving the current architecture.