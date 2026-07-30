# Flutter HRMS Pro

# Project Architecture

**Version:** `0.6.0`

---

# Architecture Overview

Flutter HRMS Pro follows a **Feature-First Clean Architecture** built with **Flutter**, **Riverpod**, **GoRouter**, and **Supabase**.

The architecture is designed to be:

- Clean
- Modular
- Scalable
- Maintainable
- Testable
- Responsive
- Production Ready
- CodeCanyon Ready

Each business module is completely isolated and follows the same folder structure, making the application easy to extend and maintain.

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
- google_maps_flutter
- url_launcher
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

Shared reusable components live inside the **core** layer.

Examples

- Supabase Service
- Location Service
- Authentication Service
- Validators
- Router
- Theme
- Shared Widgets

---

# Feature Structure

Every feature follows the same architecture.

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
- CRUD Operations

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
- Business Rules

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
- Riverpod Providers
- Notifiers
- UI Components

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

Every business module follows the same flow.

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
- Current Employee Mapping

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

🟢 95% Completed

Completed

- Attendance CRUD
- Attendance Repository
- Attendance Provider
- Attendance Entity
- Attendance Model
- Mobile Check In
- Mobile Check Out
- Duplicate Check In Prevention
- Duplicate Check Out Prevention
- GPS Location
- Address Detection
- Current Employee Mapping
- Attendance Summary Card
- Attendance Details Page
- Attendance Timeline Card
- Attendance Analytics Card
- Employee Info Card
- Company Info Card
- Shift Info Card
- Device Info Card
- Attendance Location Card
- Google Map Preview
- Open Google Map Button
- Bottom Action Bar

Upcoming

- Attendance History
- Attendance Calendar
- Dashboard Statistics
- Monthly Attendance
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

- Dashboard Navigation
- Dashboard UI
- Quick Menu

Upcoming

- Attendance Dashboard
- Attendance Statistics
- Charts
- Reports

---

# Authentication Flow

```
Login

↓

Supabase Authentication

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
        │
        ▼
Current Employee
        │
        ▼
Location Service
        │
        ▼
GPS + Address
        │
        ▼
Attendance Entity
        │
        ▼
Attendance Repository
        │
        ▼
Supabase
        │
        ▼
Attendance Database
        │
        ▼
Attendance Details UI
```

---

# Mobile Attendance Flow

```
Employee Login

↓

Current Employee

↓

Get GPS

↓

Get Address

↓

Create Attendance

↓

Supabase

↓

Attendance Details
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

Update Address

↓

Completed
```

---

# Database Relationship

```
Company
      │
      ├────────────┐
      ▼            │

Department         │

Designation        │

Shift              │

Employee───────────┘
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

dashboard/attendance/details

dashboard/mobile-attendance

dashboard/leave
```

---

# Responsive Architecture

## Mobile

Drawer Navigation

## Tablet

Navigation Rail

## Desktop

Permanent Sidebar

Business logic is shared across every platform.

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

# Permission Architecture

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
- SOLID Principles
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

Responsive Layout

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
| Attendance Details UI | ✅ |
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

✅ Mobile Attendance

✅ Attendance Details UI

✅ Google Map Integration

⬇

🚀 Attendance History

⬇

🚀 Attendance Dashboard

⬇

🚀 Leave Management

⬇

🎯 Version 1.0

---

# Version 1.0 Goals

- Secure Authentication
- Master Data
- Attendance Management
- Attendance Dashboard
- Leave Management
- Reports
- Role Permission
- Responsive UI
- Production Ready
- CodeCanyon Ready