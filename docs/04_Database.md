# Flutter HRMS Pro

# Database Documentation

**Version:** `0.2.0`

---

# Database Overview

Flutter HRMS Pro uses **Supabase PostgreSQL** as the primary database.

The database is designed for a **lightweight multi-company HRMS** targeting **small and medium businesses (5–30 employees)**.

Key goals:

- Lightweight
- Secure
- Scalable
- Easy to Maintain
- Flutter Friendly

---

# Database Technology

- PostgreSQL
- Supabase
- UUID Primary Keys
- Foreign Keys
- Indexes
- Views
- Triggers
- Seed Data
- Row Level Security (RLS)
- Storage Policies

---

# Database Modules

| Module | Status |
|---------|--------|
| Companies | ✅ |
| Departments | ✅ |
| Designations | ✅ |
| Shifts | ✅ |
| Employees | ✅ |
| Attendance | ✅ |
| Leave | ✅ |
| Work Notes | ✅ |
| Tasks | ✅ |
| Notifications | ✅ |
| Documents | ✅ |
| Attachments | ✅ |
| Activity Logs | ✅ |

---

# Database Relationships

```text
companies
    │
    ├──────────────┐
    ▼              │
departments        │
    │              │
    ▼              │
designations       │
                   │
employees──────────┘
    │
    ├── shift
    ├── attendance
    ├── leave_requests
    ├── work_notes
    ├── tasks
    ├── notifications
    └── employee_documents
```

---

# Core Tables

## companies

Purpose

Stores company information.

Important Columns

- id
- code
- name
- phone
- email
- website
- address
- contact_person
- owner_employee_id
- created_by
- updated_by
- is_deleted
- deleted_at
- created_at
- updated_at

Status

✅ Completed

---

## departments

Purpose

Stores department information.

Important Columns

- id
- company_id
- code
- name
- manager_name
- phone
- email

Status

✅ Completed

---

## designations

Purpose

Stores designation information.

Important Columns

- id
- company_id
- department_id
- code
- name
- grade
- base_salary

Status

✅ Completed

---

## shifts

Purpose

Stores employee shift information.

Important Columns

- id
- company_id
- code
- name
- start_time
- end_time
- break_minutes

Status

✅ Completed

---

## employees

Purpose

Stores employee profile and authentication mapping.

Important Columns

- id
- user_id
- company_id
- department_id
- designation_id
- shift_id
- employee_code
- full_name
- mobile
- email
- role
- is_super_admin
- is_company_admin
- last_login_at
- created_by
- updated_by
- created_at
- updated_at

Status

✅ Completed

---

# Security

Implemented

- UUID Primary Keys
- Foreign Keys
- Indexes
- RLS Policies
- Storage Policies
- Auth Helper Functions

Status

✅ Completed

---

# Storage Buckets

| Bucket | Access |
|---------|--------|
| employee-photos | Public |
| company-logos | Public |
| employee-documents | Authenticated |
| attachments | Authenticated |

---

# Authentication

Authentication is handled by Supabase Auth.

Employees are linked using:

```text
auth.users.id
        │
        ▼
employees.user_id
```

Helper Functions

- hrms_current_employee()
- hrms_current_employee_id()
- hrms_current_company_id()
- hrms_current_role()
- hrms_is_super_admin()
- hrms_is_company_admin()

---

# Database Standards

- UUID Primary Keys
- snake_case Naming
- Foreign Keys
- created_at
- updated_at
- Soft Delete (where required)
- Company Isolation using RLS

---

# Migration Summary

Completed

- Schema Creation
- Foreign Keys
- Indexes
- Views
- Triggers
- Seed Data
- Validation Scripts
- Verification Scripts
- RLS
- Storage Policies
- Authentication Helpers

Status

✅ Completed

---

# Current Database Status

| Component | Status |
|-----------|--------|
| Schema | ✅ |
| Relationships | ✅ |
| Indexes | ✅ |
| Views | ✅ |
| Triggers | ✅ |
| Seed Data | ✅ |
| Validation | ✅ |
| RLS | ✅ |
| Storage | ✅ |
| Authentication | ✅ |

---

# Future Improvements (v2.x)

- Face Attendance
- QR Attendance
- Live Location Tracking
- Advanced Reporting

---

# Notes

- Database is optimized for Flutter + Supabase.
- Designed for small and medium businesses.
- Avoid unnecessary ERP complexity.
- Keep schema lightweight and maintainable.

---

**Status:** ✅ Stable Foundation