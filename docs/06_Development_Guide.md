# Flutter HRMS Pro

# Development Guide

**Version:** `0.5.0`

---

# Development Philosophy

Flutter HRMS Pro is built with one clear goal:

> **Develop a modern, lightweight, responsive, production-ready Human Resource Management System using Flutter and Supabase.**

The project focuses on:

- Clean Architecture
- Feature-First Development
- Responsive UI
- Reusable Components
- Production Quality
- CodeCanyon Ready

---

# Development Goals

- Lightweight Application
- Beautiful Material 3 UI
- Multi-Company Support
- Responsive Layout
- High Performance
- Clean Database
- Easy Maintenance
- Scalable Architecture

---

# Current Development Progress

Completed

- Authentication
- Company CRUD
- Department CRUD
- Designation CRUD
- Shift CRUD
- Employee CRUD

In Progress

- Authentication Finalization
- Dashboard

Upcoming

- Attendance
- Leave
- Reports
- Settings

---

# Development Workflow

Every feature follows the same workflow.

```text
Requirement

↓

Planning

↓

Database Design

↓

UI Design

↓

Development

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

---

# Sprint Workflow

Each Sprint follows:

```text
Plan

↓

Database

↓

Model

↓

Repository

↓

Provider

↓

UI

↓

CRUD

↓

Testing

↓

Documentation

↓

Git Commit
```

A Sprint is complete only after every step is finished.

---

# Module Development Order

## Phase 1

✅ Authentication

✅ Company

✅ Department

✅ Designation

✅ Shift

✅ Employee

---

## Phase 2

Dashboard

Attendance

Leave

Reports

---

## Phase 3

Notifications

Profile

Settings

Role Permission

Theme

Responsive Layout

---

## Phase 4

Testing

Optimization

Release

CodeCanyon Package

---

# Flutter Architecture

Every feature follows the same structure.

```text
feature/

data/

domain/

presentation/
```

Detailed structure

```text
feature/

data/

├── datasources/

├── models/

└── repositories/

domain/

├── entities/

├── repositories/

└── usecases/

presentation/

├── pages/

├── providers/

├── widgets/

└── controllers/
```

---

# Coding Standards

## Naming

Classes

```text
EmployeeRepository
```

Variables

```dart
employeeName
```

Files

```text
employee_repository.dart
```

Database

```text
employee_code
created_at
updated_at
```

---

# Widget Rules

Create reusable widgets.

Examples

- AppButton
- AppCard
- AppDialog
- AppDropdown
- AppTextField
- AppSearchBar
- AppLoading
- AppEmpty
- AppError
- AppPagination

---

# UI Rules

Every page should

- Use Material 3
- Be Responsive
- Support Mobile
- Support Tablet
- Support Desktop
- Handle Loading
- Handle Empty State
- Handle Error State

---

# Responsive Design

Target Platforms

✅ Android

✅ iOS

🟡 Web

🟡 Windows

🟡 macOS

🟡 Linux

Guidelines

- Avoid fixed widths
- Use LayoutBuilder
- Use MediaQuery only when necessary
- Support different resolutions
- Support landscape mode

---

# Theme Guidelines

Support

- Light Theme
- Dark Theme
- System Theme

Future

- Custom Theme Colors
- Company Branding

---

# State Management

Riverpod

Providers should only

- Load Data
- Update State
- Notify UI

Business logic belongs inside repositories.

---

# Repository Rules

Repositories

Must

- Catch Exceptions
- Return Typed Results
- Never Access UI
- Never Show Snackbars
- Never Use BuildContext

---

# Service Rules

Services should

- Communicate with Supabase
- Upload Files
- Authentication
- Storage
- Helper Methods

---

# Database Rules

- UUID Primary Keys
- Foreign Keys
- Indexes
- Constraints
- Triggers
- snake_case
- created_at
- updated_at

Never execute SQL directly inside Flutter UI.

---

# API Rules

Use only

- Supabase SDK

Never

- Write SQL in UI
- Duplicate Queries
- Mix UI and Business Logic

---

# Error Handling

Always

```dart
try {

} on PostgrestException catch (e) {

} catch (e) {

}
```

Rules

- Friendly Messages
- Debug Logging
- No Application Crash

---

# Documentation Rules

Always update

```text
README.md

docs/

01_Project_Roadmap.md

02_Project_Status.md

03_Architecture.md

04_Database.md

05_API.md

06_Development_Guide.md
```

Documentation must always match the latest implementation.

---

# Git Workflow

After every completed feature

```bash
git add .

git commit -m "Meaningful Commit"

git push
```

Examples

```text
feat(company): complete company crud

feat(employee): complete employee crud

feat(shift): complete shift management

feat(auth): complete authentication

docs: update documentation
```

---

# Code Review Checklist

Before merging

- [ ] Flutter Analyze Passed
- [ ] Flutter Test Passed
- [ ] No Analyzer Errors
- [ ] No Runtime Errors
- [ ] Responsive UI
- [ ] CRUD Working
- [ ] Repository Tested
- [ ] Database Connected
- [ ] Documentation Updated
- [ ] Git Commit Complete

---

# Current Version Progress

| Module | Status |
|---------|--------|
| Authentication | 🟡 95% |
| Company | ✅ |
| Department | ✅ |
| Designation | ✅ |
| Shift | ✅ |
| Employee | ✅ |
| Dashboard | ⏳ |
| Attendance | ⏳ |
| Leave | ⏳ |
| Reports | ⏳ |
| Notifications | ⏳ |
| Settings | ⏳ |

---

# Version 1.0 Roadmap

Remaining Development

1. Authentication Finish
2. Dashboard
3. Attendance
4. Leave
5. Reports
6. Notifications
7. Settings
8. Theme System
9. Role Permission
10. Responsive Layout Finalization
11. Testing
12. Release Build

---

# Version 2.x Ideas

- Face Attendance
- QR Attendance
- GPS Tracking
- Live Location
- Payroll
- Assets
- Recruitment
- Performance Review
- Visitor Management
- Flutter Web Admin Panel

---

# Project Principles

- Flutter First
- Supabase Native
- Clean Architecture
- Feature-First Development
- Responsive Design
- Reusable Components
- SOLID Principles
- Documentation Driven Development
- Production Ready
- CodeCanyon Ready

---

# Success Criteria

Version 1.0 will be considered complete when:

- Authentication is fully complete
- Company Management is stable
- Department Management is stable
- Designation Management is stable
- Shift Management is stable
- Employee Management is stable
- Attendance is complete
- Leave is complete
- Dashboard is production ready
- Responsive Layout works on all supported platforms
- Theme Switching is implemented
- Role Permission is implemented
- Documentation is fully synchronized
- Android Release Build succeeds
- Project is ready for CodeCanyon submission

---

# Development Status

✅ Active Development

The project currently has a stable foundation with complete CRUD functionality for Company, Department, Designation, Shift, and Employee modules.

The next major milestone is **Dashboard**, followed by **Attendance**, **Leave**, **Role & Permission**, **Theme System**, and a fully responsive UI across all supported platforms.