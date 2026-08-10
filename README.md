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

**Current Version:** `0.6.1`

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
- Supervisor Login Architecture
- Role Based Dashboard Routing

### Login Sources

The authentication system supports account mapping from:

- `developers`
- `company_accounts`
- `employee_accounts`

### Dashboard Access

Different users can access different dashboards based on their account and role.

Completed:

- Developer Dashboard
- Company Owner Dashboard
- Employee Dashboard
- Role Based Access Foundation

Pending:

- Supervisor Dashboard

✅ **Authentication Core Completed**

🟡 **Supervisor Dashboard Pending**

---

# Company Management

- Company CRUD
- Search
- Active / Inactive

✅ Completed

---

# Department Management

- Department CRUD
- Company Dropdown
- Search

✅ Completed

---

# Designation Management

- Designation CRUD
- Company Dropdown
- Search

✅ Completed

---

# Shift Management

- Shift CRUD
- Shift Time
- Grace Time
- Break Time
- Weekly Off
- Flexible Shift

✅ Completed

---

# Role Management

## Roles

- Role CRUD
- Role Management
- Role Based Access

✅ Completed

## Role Permissions

- Permission Management
- Role Permission CRUD
- Permission Mapping

✅ Completed

---

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

---

# Employee Accounts

- Employee Account Management
- Employee Login Mapping
- Employee Account Management UI
- Employee Account CRUD

✅ Completed

---

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

---

## Supervisor Department Assignment

### Create Supervisor Departments

Allows assigning multiple departments to a supervisor.

Example:

```text
Supervisor
    ↓
Departments
    ├── HR
    ├── IT
    ├── Accounts
    └── Sales