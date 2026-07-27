# Flutter HRMS Pro

# Project Architecture

**Version:** `0.2.0`

---

# Architecture Overview

Flutter HRMS Pro follows a **Feature-First Clean Architecture** using Flutter and Supabase.

The project is designed to be:

- Lightweight
- Modular
- Maintainable
- Scalable
- Production Ready

The primary target is **small and medium businesses (5–30 employees)**.

---

# Technology Stack

## Frontend

- Flutter
- Dart
- Material 3

## Backend

- Supabase

## Database

- PostgreSQL

## State Management

- Riverpod

## Navigation

- GoRouter

## Environment

- flutter_dotenv

---

# Project Structure

```text
lib/

├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

---

# Folder Structure

```text
lib/

app/
│
├── app.dart
├── router/
├── theme/
└── bootstrap.dart

core/
│
├── config/
├── constants/
├── extensions/
├── providers/
├── services/
├── utils/
└── widgets/

shared/
│
├── models/
├── widgets/
├── dialogs/
└── extensions/

features/
│
├── auth/
├── dashboard/
├── employee/
├── attendance/
├── leave/
├── work_note/
├── task/
├── notification/
└── profile/

main.dart
```

---

# Feature Architecture

Every feature follows the same structure.

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

# Application Flow

```text
Splash
    │
    ▼
Login
    │
    ▼
Authentication
    │
    ▼
Dashboard
    │
    ├── Employee
    ├── Attendance
    ├── Leave
    ├── Work Notes
    ├── Tasks
    ├── Notifications
    └── Profile
```

---

# Authentication Flow

```text
User Login
      │
      ▼
Supabase Auth
      │
      ▼
Session Created
      │
      ▼
Employee Loaded
      │
      ▼
Dashboard
      │
      ▼
Logout
```

---

# Database Architecture

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
    └── documents
```

---

# State Management

Riverpod manages application state.

Providers include:

- Authentication
- Session
- Company
- Employee
- Attendance
- Leave
- Work Notes
- Tasks
- Notifications
- Dashboard

---

# Navigation

Navigation is handled using GoRouter.

```text
/

├── splash
├── login
├── dashboard
│
├── employees
├── attendance
├── leave
├── work-notes
├── tasks
├── notifications
├── profile
└── settings
```

---

# Backend Architecture

Flutter

↓

Repository

↓

Supabase Service

↓

Supabase API

↓

PostgreSQL

---

# Design Principles

- Clean Architecture
- Feature-First Structure
- SOLID Principles
- Material 3 Design
- Reusable Widgets
- Responsive UI
- Lightweight Database
- Simple Business Logic
- Documentation Driven Development

---

# Development Workflow

```text
Requirement
      ↓
Planning
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

# Supported Platforms

## Current

- Android
- iOS

## Future

- Web
- Windows
- macOS
- Linux

---

# Architecture Status

| Component | Status |
|-----------|--------|
| Clean Architecture | ✅ |
| Feature-First Structure | ✅ |
| Riverpod | ✅ |
| GoRouter | ✅ |
| Supabase | ✅ |
| Database | ✅ |
| Authentication | 🟡 |
| UI Development | ⏳ |

---

# Architecture Goals

- Simple to Understand
- Easy to Maintain
- Fast Development
- Reusable Components
- Minimal Boilerplate
- Production Ready
- CodeCanyon Ready