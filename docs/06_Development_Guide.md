# Flutter HRMS Pro

# Development Guide

**Version:** `0.8.0`

---

# Development Philosophy

Flutter HRMS Pro is a professional, scalable and production-ready HRMS built using **Flutter** and **Supabase**.

## Core Principles

- Clean Architecture
- Feature-First Development
- Repository Pattern
- Riverpod State Management
- GoRouter Navigation
- Material 3 Design
- Documentation-Driven Development
- Responsive UI
- Reusable Widgets
- Production Ready Code
- CodeCanyon Quality

# Current Development Status

## Authentication

- Login
- Logout
- Auto Login
- Session Management
- Route Guard
- Forgot Password
- Update Password
- Developer Login
- Company Owner Login
- Employee Login
- Supervisor Login
- Role-based Dashboard Access

🟢 Completed

## Master Data

- Company CRUD
- Department CRUD
- Designation CRUD
- Shift CRUD
- Employee CRUD

🟢 Completed

## Role & Permission Management

- Role CRUD
- Role Permission CRUD
- Permission Management
- Role-based Access Support

🟢 Completed

## Employee Account Management

- Employee Account CRUD
- Employee Mapping
- Account Relationship Management

🟢 Completed

## Supervisor Management

- Supervisor CRUD
- Supervisor Department Creation
- Supervisor Department Management
- Supervisor Department Status Management
- Supervisor Department Assignment / Mapping
- Supervisor Dashboard
- Supervisor Attendance View

🟢 Completed

## Attendance Management

- Attendance CRUD
- Mobile Check In
- Mobile Check Out
- GPS Location Capture
- Address Detection
- Attendance Validation
- Attendance History
- Attendance Analytics
- Attendance Timeline
- Google Map Integration
- Attendance Summary
- Supervisor Attendance View

🟢 Completed Core Attendance

## Settings

### Theme Settings
- Light
- Dark
- System
- Theme Persistence
- Responsive UI

🟢 Completed

### Working Days
- Company Wise Working Days
- Persistent Settings
- Seven Day Configuration

🟢 Completed

### Basic Attendance Rules
- Late Grace Period
- Early Leave Grace Period
- Late Attendance Allowed
- Early Leave Allowed
- Half-Day Threshold
- Minimum Working Hours
- Check-in Required
- Check-out Required
- Company Wise Storage

🟢 Completed

### Weekend Settings

A separate weekend settings table/module was removed.

❌ Removed

# Next Development Priorities

## 1. Attendance Data Synchronization & Reports

- Sync attendance data with report layer
- Employee attendance summary
- Supervisor attendance summary
- Late calculation
- Early leave calculation
- Working hour calculation
- Company-wise reporting

⏭️ Next Priority

## 2. Leave Management

- Leave Types
- Apply Leave
- Leave Approval
- Holiday Management
- Official Movement

⏳ Planned

## 3. Dashboard & Analytics

- Company Statistics
- Employee Statistics
- Attendance Statistics
- Leave Statistics
- Charts
- Quick Actions
- Recent Activities

⏳ Planned

## 4. Reports

- Attendance Report
- Employee Report
- Leave Report
- Shift Report
- PDF Export
- Excel Export

⏳ Planned

## 5. Notifications

- In-App Notification
- Department Notification
- Company Announcement
- Push Notification

⏳ Planned

## 6. Employee Monitoring

- Background Location Tracking
- Google Maps
- Live Employee Monitoring
- Location History

⏳ Planned

# Development Workflow

```text
Requirement
      ↓
Planning
      ↓
Database Design
      ↓
Entity Design
      ↓
Model Development
      ↓
Repository
      ↓
Provider
      ↓
Business Logic
      ↓
UI Development
      ↓
Testing
      ↓
Bug Fix
      ↓
Documentation
      ↓
Git Commit
      ↓
Git Push
```

# Development Rule

The project should proceed **module-by-module**.

The current module should be completed and verified before starting an unrelated module.

Priority:

1. Stability
2. Data integrity
3. Multi-company isolation
4. Responsive UI
5. Reusable architecture
6. CodeCanyon quality
