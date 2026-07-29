# Flutter HRMS Pro

# Project Architecture

**Version:** `0.5.0`

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

The architecture is built around independent feature modules so every module follows the same structure and coding standards.

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

---

# Project Structure

```text
lib/

├── core/
├── features/
├── main.dart
```

---

# Core Structure

```text
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

Core contains shared resources used throughout the application.

---

# Feature Structure

Every module follows exactly the same architecture.

```text
feature/

data/

domain/

presentation/
```

---

# Data Layer

Responsible for communication with Supabase.

```text
data/

datasources/

models/

repositories/
```

Contains

- Supabase datasource
- DTO / Models
- Repository implementation

---

# Domain Layer

Contains business logic.

```text
domain/

entities/

repositories/
```

Contains

- Entity
- Repository Contract

---

# Presentation Layer

Contains UI and State Management.

```text
presentation/

pages/

providers/

widgets/
```

Contains

- Pages
- Riverpod Provider
- State
- Notifier
- Reusable Widgets

---

# Current Feature Modules

```text
features/

auth/

company/

department/

designation/

shift/

employee/

dashboard/

attendance/

leave/
```

Completed

- Authentication
- Company
- Department
- Designation
- Shift
- Employee

Upcoming

- Attendance
- Leave
- Dashboard
- Reports
- Settings

---

# Application Flow

```text
Application

↓

Authentication

↓

Dashboard

↓

Master Data

↓

Attendance

↓

Leave

↓

Reports

↓

Settings
```

---

# Authentication Flow

```text
User

↓

Login

↓

Supabase Authentication

↓

Session

↓

Route Guard

↓

Dashboard

↓

Logout
```

---

# CRUD Flow

Every CRUD module follows exactly the same workflow.

```text
UI

↓

Provider

↓

Repository

↓

Supabase

↓

Database
```

This architecture is used for

- Company
- Department
- Designation
- Shift
- Employee

and will be reused for every future module.

---

# Database Architecture

```text
Company

│

├──────────────┐

▼              │

Department     │

               │

Designation    │

               │

Shift          │

               │

Employee───────┘

      │

      ├── Attendance

      ├── Leave

      ├── Documents

      ├── Notifications

      ├── Reports
```

---

# Riverpod Architecture

Each feature contains its own provider.

```text
Feature

↓

State

↓

Notifier

↓

Repository

↓

Supabase
```

Advantages

- Independent
- Testable
- Reusable
- Easy Maintenance

---

# Routing Architecture

GoRouter handles navigation.

```text
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

dashboard/leave
```

---

# Responsive Architecture

The application is designed for every Flutter platform.

### Mobile

- Navigation Drawer

### Tablet

- Navigation Rail

### Desktop

- Permanent Sidebar

Same business logic is reused on every platform.

---

# Theme Architecture

Future implementation

```text
Theme

↓

Light

Dark

System

↓

Accent Color

↓

Material 3
```

---

# Permission Architecture

Future implementation

```text
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

Permission Service

```text
Permission

↓

Company

Department

Designation

Shift

Employee

Attendance

Leave

Reports

Settings
```

---

# Backend Architecture

```text
Flutter UI

↓

Riverpod

↓

Repository

↓

Supabase Service

↓

Supabase API

↓

PostgreSQL
```

---

# Folder Naming Convention

Each feature follows identical naming.

```text
feature/

entity.dart

model.dart

repository.dart

repository_impl.dart

provider.dart

state.dart

notifier.dart

card.dart

form.dart

list_page.dart

form_page.dart
```

This keeps every module consistent and easy to maintain.

---

# Development Principles

- Clean Architecture
- Feature First Development
- SOLID Principles
- Repository Pattern
- Riverpod
- GoRouter
- Material 3
- Responsive UI
- Reusable Widgets
- Documentation Driven Development
- Git Version Control

---

# Development Workflow

```text
Requirement

↓

Database Design

↓

Architecture

↓

Flutter Development

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
| Feature First Structure | ✅ |
| Riverpod | ✅ |
| GoRouter | ✅ |
| Supabase | ✅ |
| Database | ✅ |
| Authentication | 🟡 95% |
| Company Module | ✅ |
| Department Module | ✅ |
| Designation Module | ✅ |
| Shift Module | ✅ |
| Employee Module | ✅ |
| Responsive Foundation | 🟡 |
| Attendance Module | ⏳ |

---

# Architecture Goals

- Modular Development
- Feature Isolation
- Reusable Components
- Scalable Codebase
- Minimal Boilerplate
- Responsive Design
- Easy Maintenance
- Enterprise Ready
- Production Ready
- CodeCanyon Ready