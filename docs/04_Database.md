# Flutter HRMS Pro

# Database Documentation

**Version:** `0.6.0`

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
- CodeCanyon Quality

---

# Database Technology

- PostgreSQL
- Supabase
- UUID Primary Keys
- Foreign Keys
- Constraints
- Composite Indexes
- Trigger Functions
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
| Attendance | ✅ Completed |
| Holidays | ⏳ Planned |
| Leave | ⏳ Planned |
| Dashboard | ⏳ Planned |
| Reports | ⏳ Planned |
| Notifications | ⏳ Planned |

---

# Current Database Structure

```
Company
   │
   ├──────────────┐
   ▼              │

Department        │

Designation       │

Shift             │

Employee──────────┘
      │
      ├── Attendance
      ├── Leave
      ├── Holiday
      ├── Reports
      ├── Notifications
      └── Documents
```

---

# Database Tables

## companies

**Status**

✅ Completed

**Purpose**

Stores company master information.

---

## departments

**Status**

✅ Completed

**Purpose**

Stores department information.

---

## designations

**Status**

✅ Completed

**Purpose**

Stores designation information.

---

## shifts

**Status**

✅ Completed

**Purpose**

Stores office shift configuration.

---

## employees

**Status**

✅ Completed

**Purpose**

Stores employee master information.

### Important Fields

- company_id
- department_id
- designation_id
- shift_id
- user_id
- employee_code
- full_name
- mobile
- email
- role
- is_active

---

## attendance

**Status**

✅ Completed

**Purpose**

Stores daily employee attendance records.

### Main Fields

- id
- company_id
- employee_id
- department_id
- designation_id
- shift_id
- holiday_id
- leave_request_id

- attendance_no
- attendance_date

- shift_name
- shift_start
- shift_end

- check_in_time
- check_out_time

- work_minutes
- overtime_minutes
- late_minutes
- early_exit_minutes

- attendance_status

- is_leave
- is_holiday
- is_weekend

- check_in_latitude
- check_in_longitude

- check_out_latitude
- check_out_longitude

- check_in_address
- check_out_address

- device_name
- device_id
- ip_address

- remarks

- is_active

- created_by
- updated_by
- created_at
- updated_at

### Implemented Features

- Mobile Check In
- Mobile Check Out
- GPS Coordinates
- Address Detection
- Attendance Number Generation
- Employee Mapping
- Shift Mapping
- Duplicate Check In Prevention
- Duplicate Check Out Prevention
- Device Information
- Attendance Analytics Ready

---

# Database Relationships

```
Company
   │
   ├── Department
   ├── Designation
   ├── Shift
   └── Employee
          │
          ├── Attendance
          ├── Leave
          ├── Holiday
          └── Auth User
```

---

# Authentication Mapping

```
Supabase Auth

↓

auth.users

↓

employees.user_id

↓

Current Employee

↓

Attendance
```

---

# Foreign Keys

## Company

Referenced by

- Departments
- Designations
- Shifts
- Employees
- Attendance

---

## Department

Referenced by

- Employees
- Attendance

---

## Designation

Referenced by

- Employees
- Attendance

---

## Shift

Referenced by

- Employees
- Attendance

---

## Employee

Referenced by

- Attendance

---

# Database Features

### Implemented

- UUID Primary Keys
- Foreign Keys
- Check Constraints
- Unique Constraints
- Composite Indexes
- Updated_at Trigger
- Validation
- Authentication Mapping
- Employee Mapping
- Attendance Mapping
- GPS Ready
- Address Ready

**Status**

✅ Completed

---

# Trigger Functions

### Implemented

```
fn_set_updated_at()

protect_employee_sensitive_fields()
```

### Attendance Trigger

```
trg_attendance_updated_at
```

**Status**

✅ Completed

---

# Index Strategy

Optimized Indexes

- Companies
- Departments
- Designations
- Shifts
- Employees
- Attendance
- Attendance (Employee + Date)
- Attendance Date
- Authentication
- Role

**Status**

✅ Optimized

---

# Row Level Security (RLS)

### Development

- SELECT
- INSERT
- UPDATE
- DELETE

### Production (Upcoming)

- Company Isolation
- Employee Isolation
- Department Isolation
- Role Based Permission

**Status**

🟡 Development

---

# Storage Buckets

| Bucket | Status |
|---------|--------|
| employee-photo | ⏳ Planned |
| employee-signature | ⏳ Planned |
| company-logo | ⏳ Planned |
| documents | ⏳ Planned |

---

# Naming Convention

### Tables

snake_case

### Columns

snake_case

### Primary Key

id

### Foreign Keys

- company_id
- department_id
- designation_id
- shift_id
- employee_id
- holiday_id
- leave_request_id
- user_id

### Timestamps

- created_at
- updated_at

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
| Authentication | ✅ |
| Employees | ✅ |
| Attendance | ✅ |
| Mobile Attendance | ✅ |

---

# Upcoming Tables

- leave_types
- leave_requests
- holidays
- attendance_logs
- attendance_locations
- notifications
- reports

**Status**

⏳ Planned

---

# Version 2.x Database

Future Modules

- Face Recognition
- Face Attendance
- Employee Monitoring
- Background GPS Tracking
- Payroll
- Assets
- Recruitment
- Performance
- Visitor Management

---

# Database Goals

- Production Ready
- Enterprise Ready
- High Performance
- Secure
- Scalable
- Multi Company
- GPS Ready
- Mobile Attendance Ready
- Analytics Ready
- CodeCanyon Ready

---

# Current Milestone

✅ Authentication

✅ Master Data

✅ Employee Mapping

✅ Attendance Table

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