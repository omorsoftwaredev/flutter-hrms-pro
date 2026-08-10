# Flutter HRMS Pro

# Project Roadmap

**Version:** 0.6.5

---

# Project Vision

Flutter HRMS Pro is a modern, scalable, responsive, and production-ready Human Resource Management System (HRMS) built with Flutter and Supabase.

The goal is to build a commercial-grade, CodeCanyon-quality HRMS supporting Android, iOS, Windows, macOS, Linux, and Web from a single Flutter codebase.

## Architecture Principles

- Clean Architecture
- Feature-First Development
- Repository Pattern
- Riverpod State Management
- Supabase Backend
- GoRouter Navigation
- Documentation-Driven Development
- Responsive Material 3 UI

---

# Current Progress

## Overall Progress

🟢 Approximately 70%

## Current Version

`0.6.5`

## Current Development Status

🟢 Core HRMS Foundation Completed

🟢 Authentication Completed

🟢 Master Data Completed

🟢 Employee Accounts Completed

🟢 Role & Permission Management Completed

🟢 Supervisor Management Completed

🟢 Supervisor Department Management Completed

🟢 Supervisor Department Status Completed

🟢 Attendance Module 95% Completed

🚀 Next Major Task: Supervisor Dashboard + Attendance Dashboard

---

# Module 01 — Authentication

## Status

✅ 100% Completed

## Completed Features

- Login
- Logout
- Auto Login
- Route Guard
- Session Management
- Forgot Password
- Update Password
- Current Employee Mapping
- Role Based Login
- Company Based Login

## Login Types

### Developer

✅ Developer Login

✅ Developer Dashboard

### Company Owner

✅ Company Owner Login

✅ Company Owner Dashboard

### Employee

✅ Employee Login

✅ Employee Dashboard

### Supervisor

🟡 Supervisor Login Logic Pending

🟡 Supervisor Dashboard Pending

---

# Module 02 — Company Management

## Status

✅ 100% Completed

## Features

- Company CRUD
- Company Search
- Active / Inactive
- Company Relationship
- Company Account Mapping

---

# Module 03 — Department Management

## Status

✅ 100% Completed

## Features

- Department CRUD
- Company Dropdown
- Department Search
- Company Relationship
- Active / Inactive

---

# Module 04 — Designation Management

## Status

✅ 100% Completed

## Features

- Designation CRUD
- Company Dropdown
- Designation Search
- Department Relationship
- Active / Inactive

---

# Module 05 — Shift Management

## Status

✅ 100% Completed

## Features

- Shift CRUD
- Shift Time
- Grace Time
- Break Time
- Weekly Off
- Flexible Shift
- Employee Shift Mapping

---

# Module 06 — Employee Management

## Status

✅ 100% Completed

## Features

- Employee CRUD
- Company
- Department
- Designation
- Shift
- Salary
- Personal Information
- Employment Information
- User Mapping
- Employee Role
- Employee Status

---

# Module 07 — Employee Accounts

## Status

✅ 100% Completed

## Features

- Employee Account Management
- Employee Login Account
- Account Mapping
- Employee Authentication Mapping
- Account Status

---

# Module 08 — Role Management

## Status

✅ 100% Completed

## Features

- Role CRUD
- Role Management
- Active / Inactive
- Role Assignment
- Role Based Access Structure

---

# Module 09 — Role Permission Management

## Status

✅ 100% Completed

## Features

- Permission Management
- Role Permission Management
- Permission Assignment
- Permission Mapping
- Permission Based Access Structure

## Permission Areas

- Company
- Department
- Designation
- Shift
- Employee
- Employee Accounts
- Supervisor
- Attendance
- Leave
- Reports
- Dashboard
- Settings

---

# Module 10 — Supervisor Management

## Status

✅ 100% Completed

## Features

- Supervisor CRUD
- Create Supervisor
- Update Supervisor
- Delete Supervisor
- Supervisor Status Toggle
- Employee to Supervisor Mapping
- Company Mapping
- Department Mapping
- Supervisor Search / Management

---

# Module 11 — Supervisor Department Assignment

## Status

✅ 100% Completed

## Features

### Create Supervisor Departments

- Company Selection
- Supervisor Selection
- Department Selection
- Select All Departments
- Clear All Departments
- Assign Multiple Departments
- Database Synchronization

### Manage Supervisor Departments

- Company Selection
- Supervisor Selection
- Existing Assignment Loading
- Add Department
- Remove Department
- Select All
- Clear All
- Assignment Update
- Final State Synchronization
- Database Insert
- Database Delete

---

# Module 12 — Supervisor Department Status

## Status

✅ 100% Completed

## Features

- Supervisor Name
- Assigned Department List
- Department Assignment Status
- Assigned Departments
- Unassigned Departments
- Department Status View
- Supervisor Based Department View

## Status Tabs

### Tab 01 — Departments Without Supervisor

Shows departments where no supervisor has been assigned.

### Tab 02 — Supervisor Departments

Shows:

- Supervisor Name
- Assigned Department Name
- Department Assignment Information

---

# Module 13 — Attendance Management

## Status

🟢 95% Completed

## Attendance CRUD

- Create
- Update
- Delete
- Search

## Mobile Attendance

- Check In
- Check Out
- GPS Capture
- Reverse Geocoding
- Employee Mapping
- Duplicate Check-In Protection
- Duplicate Check-Out Protection

## Attendance History

- History Page
- Search
- Refresh
- Detail Navigation

## Attendance Details

- Employee Summary
- Employee Avatar
- Attendance Summary
- Attendance Analytics
- Attendance Timeline
- Shift Information
- Company Information
- Device Information
- Google Map Preview
- Open in Google Maps
- Location Card
- Remarks Card
- Basic Information Card
- Bottom Action Bar

## Remaining

- PDF Export
- Print
- Share
- Calendar View

---

# Module 14 — Attendance Dashboard

## Status

🚀 Next Sprint

## Planned Features

- Dashboard Statistics
- My Attendance
- Today's Attendance
- Monthly Attendance
- Recent Activities
- Attendance Overview Cards
- Attendance Charts
- Working Hours
- Late Statistics
- Overtime Statistics

---

# Module 15 — Leave Management

## Status

⏳ Planned

## Features

- Leave Types
- Leave Application
- Leave Approval
- Holidays
- Official Movement

---

# Module 16 — Main Dashboard

## Status

🟡 Partially Completed

## Completed

- Developer Dashboard
- Company Owner Dashboard
- Employee Dashboard
- Role Based Dashboard Structure

## Remaining

- Supervisor Dashboard
- Dashboard Statistics
- Employee Summary
- Attendance Summary
- Leave Summary
- Company Statistics
- Charts
- Quick Actions

---

# Module 17 — Reports

## Status

⏳ Planned

## Features

- Attendance Report
- Employee Report
- Leave Report
- Shift Report
- Supervisor Report
- Department Report
- PDF Export
- Excel Export
- Print
- Share

---

# Module 18 — Notifications

## Status

⏳ Planned

## Features

- Company Announcement
- Department Notification
- In-App Notification
- Push Notification

---

# Module 19 — Settings

## Status

⏳ Planned

## Features

- Company Settings
- Attendance Settings
- Leave Settings
- Notification Settings
- Theme Settings
- System Settings

---

# Module 20 — Profile

## Status

⏳ Planned

## Features

- My Profile
- Profile Photo
- Signature
- Login History
- Password Change
- Account Information

---

# Database Status

## Completed Tables

- Companies
- Departments
- Designations
- Shifts
- Employees
- Attendance
- Roles
- Role Permissions
- Employee Accounts
- Supervisors
- Supervisor Department Assignments

## Database Features

- Relationships
- Foreign Keys
- Indexes
- Triggers
- RLS Policies
- Authentication
- Storage
- Assignment Synchronization

## Status

✅ Completed

---

# Flutter Development Phases

## Phase 01 — Authentication

✅ Completed

- Login
- Logout
- Auto Login
- Route Guard
- Session Management
- Role Based Login
- Current User Mapping

---

## Phase 02 — Master Data

✅ Completed

- Company
- Department
- Designation
- Shift
- Employee

---

## Phase 03 — Employee Accounts

✅ Completed

- Employee Accounts
- Account Mapping
- Employee Authentication

---

## Phase 04 — Role & Permission

✅ Completed

- Roles
- Role Permissions
- Permission Mapping
- Role Based Access

---

## Phase 05 — Supervisor Management

✅ Completed

- Supervisor CRUD
- Supervisor Status
- Supervisor Mapping

---

## Phase 06 — Supervisor Department Management

✅ Completed

- Create Supervisor Departments
- Manage Supervisor Departments
- Department Assignment
- Department Removal
- Assignment Synchronization
- Supervisor Department Status

---

## Phase 07 — Attendance Module

🟢 95% Completed

- Attendance CRUD
- Mobile Attendance
- GPS
- Reverse Geocoding
- Attendance History
- Attendance Details
- Analytics
- Timeline
- Google Maps

---

## Phase 08 — Attendance Dashboard

🚀 Next

---

## Phase 09 — Supervisor Dashboard

🚀 Next

Planned Features:

- Supervisor Dashboard
- My Departments
- Assigned Employees
- Department Attendance
- Department Summary
- Employee Attendance
- Leave Summary
- Department Statistics

---

## Phase 10 — Leave Module

⏳ Planned

---

## Phase 11 — Main Dashboard

⏳ Planned

---

## Phase 12 — Reports

⏳ Planned

---

## Phase 13 — Notifications

⏳ Planned

---

## Phase 14 — Settings

⏳ Planned

---

## Phase 15 — Testing & Optimization

⏳ Planned

---

# Version Roadmap

## Version 0.6.5

### Completed

✅ Authentication

✅ Company Management

✅ Department Management

✅ Designation Management

✅ Shift Management

✅ Employee Management

✅ Employee Accounts

✅ Roles

✅ Role Permissions

✅ Supervisor CRUD

✅ Supervisor Status

✅ Create Supervisor Departments

✅ Manage Supervisor Departments

✅ Supervisor Department Status

🟢 Attendance Module — 95%

---

# Version 0.7.0

## Attendance Dashboard

Planned:

- Attendance Dashboard
- Attendance Statistics
- Attendance Calendar
- Attendance Charts
- Working Hours
- Late Statistics
- Overtime Statistics

---

# Version 0.8.0

## Supervisor Dashboard + Leave Module

Planned:

- Supervisor Dashboard
- Supervisor Departments
- Department Employees
- Department Attendance
- Leave Types
- Leave Application
- Leave Approval
- Holidays
- Official Movement

---

# Version 0.9.0

## Reports & Notifications

Planned:

- Attendance Reports
- Employee Reports
- Leave Reports
- Supervisor Reports
- PDF Export
- Excel Export
- Company Announcement
- Department Notification
- In-App Notification

---

# Version 1.0.0

## Production Stable Release

Target:

- Production Ready
- Stable Database
- Complete Authentication
- Complete Role & Permission
- Complete Supervisor Management
- Attendance
- Leave
- Dashboard
- Reports
- Notifications
- Settings
- Testing
- Performance Optimization

---

# Future Version 2.x

## Advanced HRMS Features

- Face Attendance
- Face Recognition
- QR Attendance
- NFC Attendance
- Live GPS Tracking
- Employee Monitoring
- Payroll
- Recruitment
- Performance Management
- Asset Management
- Training Management
- Loan Management
- Push Notification

---

# Responsive Support

## Platforms

- Android
- iOS
- Windows
- macOS
- Linux
- Web

## Layouts

- Mobile
- Tablet
- Desktop

---

# Development Principles

- Clean Architecture
- SOLID Principles
- Repository Pattern
- Feature First
- Riverpod
- GoRouter
- Supabase
- Material 3
- Responsive Design
- Documentation Driven Development
- Reusable Widgets
- Maintainable Code
- Scalable Architecture

---

# Current Project Status

## Completed

✅ Login System

✅ Developer Dashboard

✅ Company Owner Dashboard

✅ Employee Dashboard

✅ Company Module

✅ Department Module

✅ Designation Module

✅ Shift Module

✅ Employee Module

✅ Employee Accounts

✅ Roles

✅ Role Permissions

✅ Supervisor CRUD

✅ Supervisor Status

✅ Create Supervisor Departments

✅ Manage Supervisor Departments

✅ Supervisor Department Status

🟢 Attendance Module — 95%

---

# Current Milestone

```text
Authentication
      ↓
Company
      ↓
Department
      ↓
Designation
      ↓
Shift
      ↓
Employee
      ↓
Employee Accounts
      ↓
Roles
      ↓
Role Permissions
      ↓
Supervisor
      ↓
Supervisor Department Assignment
      ↓
Supervisor Department Management
      ↓
Supervisor Department Status
      ↓
Attendance
      ↓
🚀 Attendance Dashboard
      ↓
🚀 Supervisor Dashboard
      ↓
Leave
      ↓
Reports
      ↓
Notifications
      ↓
Settings
      ↓
🎯 Version 1.0.0