# Flutter HRMS Pro

# Project Architecture

**Version:** `0.6.0`

---

# Architecture Overview

Flutter HRMS Pro follows a **Feature-First Clean Architecture** using **Flutter**, **Riverpod**, **GoRouter**, and **Supabase**.

The project is designed to be:

- Clean
- Modular
- Scalable
- Maintainable
- Responsive
- Production Ready
- CodeCanyon Ready

Every business module is isolated and follows the same folder structure, making the application easy to maintain and extend.

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

- Flutter Riverpod

## Navigation

- GoRouter

## Environment

- flutter_dotenv

## Packages

- flutter_riverpod
- supabase_flutter
- go_router
- geolocator
- geocoding
- intl
- flutter_background_service (Upcoming)
- flutter_local_notifications (Upcoming)

---

# High Level Architecture

```
Flutter UI
      │
      ▼
Presentation Layer
      │
      ▼
Riverpod Provider
      │
      ▼
Notifier
      │
      ▼
Repository
      │
      ▼
Supabase
      │
      ▼
PostgreSQL
```

---

# Project Structure

```
lib/

├── core/
│
├── features/
│
├── main.dart
```

---

# Core Layer

```
core/

constants/
extensions/
providers/
router/
services/
theme/
utils/
widgets/
```

Shared components live inside the **core** folder.

Examples

- Supabase Service
- Location Service
- Attendance CheckIn Service
- Validators
- Router
- Theme
- Shared Widgets

---

# Feature Structure

Every module follows the same architecture.

```
feature/

data/

domain/

presentation/
```

---

# Data Layer

```
data/

datasources/

models/

repositories/
```

Responsibilities

- Supabase Communication
- DTO / Model
- Repository Implementation

---

# Domain Layer

```
domain/

entities/

repositories/
```

Responsibilities

- Business Entity
- Repository Contract

---

# Presentation Layer

```
presentation/

pages/

providers/

widgets/
```

Contains

- Pages
- Widgets
- Riverpod State
- Notifier
- Provider

---

# Riverpod Flow

```
UI

↓

Provider

↓

Notifier

↓

Repository

↓

Supabase

↓

Database
```

Every module follows this same flow.

---

# Current Modules

## Authentication

Status

✅ Completed

Features

- Login
- Logout
- Auto Login
- Session Management
- Route Guard
- Forgot Password
- Update Password

---

## Company

Status

✅ Completed

---

## Department

Status

✅ Completed

---

## Designation

Status

✅ Completed

---

## Shift

Status

✅ Completed

---

## Employee

Status

✅ Completed

---

## Attendance

Status

🟡 In Progress

Completed

- Attendance CRUD
- Check In
- Check Out
- Duplicate Check In Prevention
- Duplicate Check Out Prevention
- GPS Location
- Employee Auto Detection
- Current Employee Repository
- Mobile Attendance Screen

Upcoming

- Attendance History
- Attendance Report
- Monthly Attendance
- Dashboard Statistics
- Office Geofence
- Background Tracking

---

## Leave

Status

⏳ Planned

---

## Dashboard

Status

🟡 In Progress

Completed

- Dashboard UI
- Quick Menu
- Navigation

Upcoming

- Statistics
- Charts
- Reports

---

# Authentication Flow

```
Login

↓

Supabase Auth

↓

Session

↓

Current User

↓

Current Employee

↓

Dashboard
```

---

# Attendance Flow

```
Employee Login

↓

Current Employee Repository

↓

Location Service

↓

GPS

↓

Attendance Entity

↓

Attendance Provider

↓

Attendance Repository

↓

Supabase

↓

attendance Table
```

---

# Mobile Attendance Flow

```
Login

↓

Get Current Employee

↓

Get GPS

↓

Create Attendance

↓

Insert Database

↓

Success
```

---

# Check Out Flow

```
Employee

↓

Today's Attendance

↓

Update Check Out Time

↓

Update GPS

↓

Completed
```

---

# Database Relationship

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
     ├── Notification
```

---

# Routing

```
/

login

forgot-password

update-password

dashboard

dashboard/companies

dashboard/departments

dashboard/designations

dashboard/shifts

dashboard/employees

dashboard/attendance

dashboard/mobile-attendance

dashboard/leave
```

---

# Responsive Architecture

### Mobile

Drawer Navigation

### Tablet

Navigation Rail

### Desktop

Permanent Sidebar

Same business logic is shared across every platform.

---

# Future Architecture

## Employee Monitoring

```
Background Service

↓

GPS

↓

Location History

↓

Google Maps

↓

Dashboard
```

---

## Face Attendance

```
Camera

↓

Face Detection

↓

Recognition

↓

Attendance

↓

Database
```

---

## Permission Architecture

```
Super Admin

↓

Company Admin

↓

HR

↓

Manager

↓

Employee
```

Permission Modules

- Company
- Department
- Designation
- Shift
- Employee
- Attendance
- Leave
- Dashboard
- Reports
- Settings

---

# Development Principles

- Clean Architecture
- Feature First
- SOLID
- Repository Pattern
- Riverpod
- GoRouter
- Material 3
- Responsive UI
- Reusable Widgets
- Documentation Driven Development
- Git Workflow

---

# Supported Platforms

- Android
- iOS
- Windows
- Linux
- macOS
- Web

Responsive

- Mobile
- Tablet
- Desktop

---

# Architecture Status

| Component | Status |
|-----------|--------|
| Clean Architecture | ✅ |
| Feature First | ✅ |
| Riverpod | ✅ |
| GoRouter | ✅ |
| Supabase | ✅ |
| PostgreSQL | ✅ |
| Authentication | ✅ |
| Company | ✅ |
| Department | ✅ |
| Designation | ✅ |
| Shift | ✅ |
| Employee | ✅ |
| Attendance CRUD | ✅ |
| Mobile Attendance | ✅ |
| Dashboard UI | 🟡 |
| Leave | ⏳ |
| Reports | ⏳ |
| Role Permission | ⏳ |
| Background Tracking | ⏳ |

---

# Current Milestone

✅ Authentication

✅ Master Data

✅ Attendance CRUD

✅ Mobile Check In

✅ Mobile Check Out

⬇

🚀 Attendance History

⬇

🚀 Dashboard Statistics

⬇

🚀 Leave Management

⬇

🎯 Version 1.0

---

# Version 1.0 Goals

- Secure Authentication
- Master Data
- Attendance Management
- Leave Management
- Dashboard
- Reports
- Role Permission
- Responsive UI
- Production Ready
- CodeCanyon Ready