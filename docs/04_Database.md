# Flutter HRMS Pro

# Database Documentation

Version: 1.0

---

# Database Overview

Flutter HRMS Pro uses **Supabase PostgreSQL** as the primary database.

The database is designed to support a scalable Human Resource Management System (HRMS) with multi-company support, modular architecture, and future enterprise features.

---

# Database Technology

- Database : PostgreSQL
- Platform : Supabase
- UUID Primary Keys
- Foreign Key Constraints
- Timestamp Support
- Row Level Security (Future)

---

# Database Tables

## Master Tables

| Table | Status |
|--------|--------|
| companies | ✅ Created |
| departments | ✅ Created |
| designations | ✅ Created |
| shifts | ✅ Created |
| employees | ✅ Created |

---

# Relationship Diagram

```
companies
     │
     ▼
departments
     │
     ▼
designations

employees
├── company_id
├── department_id
├── designation_id
└── shift_id

shifts
```

---

# Table Details

## companies

Purpose

Stores company information.

Main Fields

- id
- company_name
- company_code
- address
- phone
- email
- status
- created_at

Status

✅ Completed

---

## departments

Purpose

Stores department information for each company.

Main Fields

- id
- company_id
- department_name
- department_code
- status
- created_at

Relationship

departments.company_id → companies.id

Status

✅ Completed

---

## designations

Purpose

Stores employee designation information.

Main Fields

- id
- department_id
- designation_name
- designation_code
- status
- created_at

Relationship

designations.department_id → departments.id

Status

✅ Completed

---

## shifts

Purpose

Stores office shift schedules.

Main Fields

- id
- shift_name
- check_in_time
- check_out_time
- late_allow_minutes
- status
- created_at

Status

✅ Completed

---

## employees

Purpose

Stores employee profile information.

Main Fields

- id
- employee_id
- company_id
- department_id
- designation_id
- shift_id
- full_name
- email
- phone
- joining_date
- status
- created_at

Relationships

employees.company_id → companies.id

employees.department_id → departments.id

employees.designation_id → designations.id

employees.shift_id → shifts.id

Status

✅ Completed

---

# Current Foreign Keys

- Department → Company
- Designation → Department
- Employee → Company
- Employee → Department
- Employee → Designation
- Employee → Shift

Status

✅ Completed

---

# Upcoming Tables

## Authentication

- users
- user_profiles
- user_roles

---

## Attendance Module

- attendance
- attendance_logs
- attendance_locations

---

## Leave Module

- leave_types
- leave_requests
- leave_approvals
- holidays
- official_movements

---

## Employee Monitoring

- live_locations
- location_history

---

## Notes Module

- notes
- note_comments
- attachments

---

## Notification Module

- notifications
- notification_logs

---

# Database Rules

- Use UUID as Primary Key
- Use Foreign Keys for Relationships
- Avoid Duplicate Data
- Use created_at and updated_at
- Use status field for Active/Inactive records
- Follow Naming Convention (snake_case)

---

# Migration History

## Sprint 03

Created

- companies
- departments
- designations
- shifts
- employees

Status

✅ Completed

---

# Current Database Status

| Module | Status |
|---------|--------|
| Database Setup | ✅ Completed |
| Master Tables | ✅ Completed |
| Relationships | ✅ Completed |
| Authentication Tables | ⏳ Pending |
| Attendance Tables | ⏳ Pending |
| Leave Tables | ⏳ Pending |
| Monitoring Tables | ⏳ Pending |
| Notification Tables | ⏳ Pending |

---

# Notes

- All SQL scripts are executed directly in Supabase SQL Editor.
- Database changes should be version-controlled through Git documentation.
- Every new table or relationship must be documented in this file before implementation.

---

Status: 🟡 ACTIVE