# Flutter HRMS Pro

A modern, scalable and production-ready **Human Resource Management System (HRMS)** built with **Flutter** and **Supabase**.

Designed for **Small, Medium and Enterprise Businesses** with a focus on:

- Clean Architecture
- Beautiful Material 3 UI
- High Performance
- Responsive Layout
- Cross Platform
- CodeCanyon Quality

---

# Version

**Current Version:** `0.8.0`

**Status:** 🟢 Active Development

---

# Technology Stack

## Frontend
- Flutter
- Dart
- Material 3

## Backend
- Supabase
- PostgreSQL

## State Management
- Flutter Riverpod

## Navigation
- GoRouter

## Environment
- flutter_dotenv

## Location
- Geolocator
- Geocoding
- Google Maps Flutter

---

# Project Goals

- Production Ready HRMS
- Clean Architecture
- Feature First Development
- Enterprise Ready
- Responsive Design
- CodeCanyon Ready
- Role Based Dashboard
- Permission Based Access Control
- Multi Company Support

---

# Features

## Authentication

- Login
- Logout
- Auto Login
- Forgot Password
- Update Password
- Route Guard
- Session Management
- Current Employee Mapping
- Developer Login
- Company Owner Login
- Employee Login
- Supervisor Login
- Role Based Dashboard Routing

### Login Sources

- `developers`
- `company_accounts`
- `employee_accounts`

### Dashboard Access

Completed:

- Developer Dashboard
- Company Owner Dashboard
- Employee Dashboard
- Supervisor Dashboard
- Role Based Access Foundation

✅ **Authentication & Dashboard Access Completed**

---

# Company Management

- Company CRUD
- Search
- Active / Inactive
- Multi Company Data Structure

✅ Completed

# Department Management

- Department CRUD
- Company Mapping
- Search

✅ Completed

# Designation Management

- Designation CRUD
- Company Mapping
- Search

✅ Completed

# Shift Management

- Shift CRUD
- Shift Time
- Grace Time
- Break Time
- Weekly Off
- Flexible Shift

✅ Completed

# Role Management

## Roles
- Role CRUD
- Role Management
- Role Based Access

## Role Permissions
- Permission Management
- Role Permission CRUD
- Permission Mapping

✅ Completed

# Employee Management

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

✅ Completed

# Employee Accounts

- Employee Account Management
- Employee Login Mapping
- Employee Account Management UI
- Employee Account CRUD

✅ Completed

# Supervisor Management

## Supervisor CRUD

- Create Supervisor
- Update Supervisor
- Delete Supervisor
- Supervisor Active / Inactive
- Supervisor Employee Mapping
- Supervisor Company Mapping
- Supervisor Department Mapping

✅ Completed

## Supervisor Department Assignment

Allows assigning multiple departments to a supervisor.

```text
Supervisor
    ↓
Departments
    ├── HR
    ├── IT
    ├── Accounts
    └── Sales
```

✅ Completed

# Supervisor Dashboard

- Supervisor Login
- Supervisor Dashboard
- Supervisor Department Overview
- Supervisor Employee Overview
- Supervisor Attendance Overview
- Supervisor Department Based Data
- Company Based Data Access

✅ Completed

# Attendance Management

## Employee Mobile Attendance

- Mobile Check In
- Mobile Check Out
- Current Employee Mapping
- GPS Location Capture
- Address Detection
- Attendance Validation
- Attendance Number Generation
- Duplicate Check In Prevention
- Duplicate Check Out Prevention
- Attendance Repository
- Attendance Provider
- Attendance Details
- Attendance History
- Attendance Analytics
- Attendance Timeline
- Google Map Integration
- Attendance Location Card
- Device Information
- Company Information
- Employee Information
- Shift Information
- Attendance Summary
- Bottom Action Bar

## Supervisor Attendance

- Supervisor Attendance View
- Company Based Attendance Access
- Supervisor Department Based Attendance Access

✅ **Mobile Attendance Completed**

# Settings

## Theme Settings

- Light Theme
- Dark Theme
- System Theme
- Immediate Theme Change
- Theme Persistence
- Responsive Appearance UI

✅ Completed

## Attendance Settings

### Working Days

- Company Wise Working Days
- Seven Day Working-Day Configuration
- Company Based Settings
- Persistent Database Storage

✅ Completed

### Weekend Settings

Weekend Settings are intentionally **not maintained as a separate table/module**. Day-off configuration is handled through Working Days.

❌ Removed

### Basic Attendance Rules

- Late Grace Period
- Early Leave Grace Period
- Late Attendance Allowed
- Early Leave Allowed
- Half-Day Threshold
- Minimum Working Hours
- Check-in Required
- Check-out Required
- Company Wise Rules
- Logged-in Company Based Configuration

✅ Completed

# Database Architecture

```text
Logged-in User
      ↓
Company ID
      ↓
Company Data
      ↓
Employee / Supervisor / Attendance / Settings
```

Company-specific settings and attendance data must always be isolated by `company_id`.

# Upcoming Modules

## Attendance Reports

- Attendance Report
- Employee Attendance Summary
- Late Report
- Early Leave Report
- Working Hour Summary
- Company Wise Filtering
- Supervisor Accessible Reports
- PDF Export
- Excel Export

⏳ Planned / Next Phase

## Leave Management

- Leave Types
- Apply Leave
- Leave Approval
- Holiday Management
- Official Movement

⏳ Planned

## Dashboard & Analytics

- Company Statistics
- Employee Statistics
- Attendance Statistics
- Leave Statistics
- Charts
- Quick Actions
- Recent Activities

⏳ Planned

## Notifications

- In-App Notification
- Department Notification
- Company Announcement
- Push Notification

⏳ Planned

## Employee Monitoring

- Background Location Tracking
- Google Maps
- Live Employee Monitoring
- Location History

⏳ Planned

# Version 2.0 Roadmap

- Face Attendance
- Face Recognition
- Push Notification
- Payroll Management

# Development Status

### Completed Foundation

- Authentication
- Role Based Access
- Company Management
- Department Management
- Designation Management
- Shift Management
- Employee Management
- Employee Accounts
- Supervisor Management
- Supervisor Dashboard
- Mobile Attendance
- Supervisor Attendance View
- Theme Settings
- Working Days
- Basic Attendance Rules

### Next Priority

1. Attendance Data Synchronization & Reporting
2. Attendance Reports
3. Leave Management
4. Dashboard & Analytics
5. Notifications
6. Employee Monitoring

---

# Development Philosophy

Flutter HRMS Pro is being developed module-by-module with a strong focus on:

- Clean Code
- Reusable Components
- Responsive UI
- Multi Company Architecture
- Database Integrity
- Maintainability
- Commercial Quality
- CodeCanyon Readiness

No unnecessary module should be introduced before the current module is stable and verified.
