from pathlib import Path

content = r'''# Flutter HRMS Pro

# Database Documentation

**Version:** `0.6.5`

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
| Supervisor Department Status | ✅ Completed |
| Attendance | ✅ Completed |
| Holidays | ⏳ Planned |
| Leave | ⏳ Planned |
| Dashboard | 🟡 In Progress |
| Reports | ⏳ Planned |
| Notifications | ⏳ Planned |

---

# Current Database Structure

```text
Company
   │
   ├── Departments
   ├── Designations
   ├── Shifts
   ├── Roles
   ├── Employees
   │      │
   │      ├── Employee Accounts
   │      └── Attendance
   │
   ├── Supervisors
   │      │
   │      └── Supervisor Department Assignments
   │
   └── Company Accounts