# Flutter HRMS Pro

# Project Architecture

Version: 1.0

---

# Architecture Overview

Flutter HRMS Pro follows a **Feature-First Clean Architecture**. The project is designed to be scalable, maintainable, reusable, and production-ready.

The application is built using Flutter for the frontend and Supabase as the backend.

---

# Technology Stack

## Frontend

- Flutter
- Dart

## Backend

- Supabase

## State Management

- Riverpod

## Navigation

- GoRouter

## Database

- PostgreSQL (Supabase)

## Environment

- flutter_dotenv

---

# Project Structure

```
lib/

app/
core/
features/
shared/

main.dart
```

---

# Folder Structure

```
lib/

app/
│
├── app.dart
├── router.dart
└── theme.dart

core/
│
├── constants/
├── providers/
├── services/
├── utils/
└── widgets/

features/
│
├── auth/
├── dashboard/
├── employee/
├── attendance/
├── leave/
├── monitoring/
├── notification/
└── reports/

shared/

main.dart
```

---

# Feature Structure

Every feature follows the same structure.

```
feature_name/

data/
│
├── datasource/
├── models/
└── repositories/

domain/
│
├── entities/
├── repositories/
└── usecases/

presentation/
│
├── pages/
├── providers/
└── widgets/
```

---

# Routing Flow

```
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
   ├── Monitoring
   ├── Reports
   └── Notification
```

---

# Authentication Flow

```
Login

↓

Supabase Authentication

↓

Session Created

↓

Auto Login

↓

Dashboard

↓

Logout

↓

Session Removed
```

---

# Database Architecture

```
companies
      │
      ▼
departments
      │
      ▼
designations

employees
│
├── company_id
├── department_id
├── designation_id
└── shift_id

shifts
```

---

# State Management

Riverpod is used throughout the application.

Responsibilities:

- Authentication State
- User Session
- Employee State
- Attendance State
- Leave State
- Dashboard State

---

# Navigation

Navigation is managed using GoRouter.

Current Routes

```
/

/login

/dashboard

/dashboard/employees

/dashboard/attendance

/dashboard/leave
```

Future routes will be added module by module.

---

# Design Principles

- Clean Architecture
- Feature-First Development
- SOLID Principles
- Modular Design
- Reusable Components
- Error-Free Development
- Git Version Control
- Documentation Driven Development

---

# Development Workflow

```
Requirement

↓

Architecture

↓

Development

↓

Run

↓

Error Fix

↓

Testing

↓

Documentation Update

↓

Git Commit

↓

Git Push
```

---

# Supported Platforms

- Android
- iOS
- Web
- Windows
- macOS
- Linux

---

# Architecture Status

- Clean Architecture Implemented
- Feature-First Structure Ready
- Riverpod Configured
- GoRouter Configured
- Supabase Connected
- Environment Configured

Status: ✅ ACTIVE