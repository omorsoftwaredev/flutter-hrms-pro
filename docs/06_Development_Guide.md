# Flutter HRMS Pro

# Development Guide

**Version:** `0.2.0`

---

# Development Philosophy

Flutter HRMS Pro is developed with one simple principle:

> **Build a beautiful, lightweight, production-ready HRMS for small and medium businesses using Flutter and Supabase.**

The project prioritizes:

- Simple Architecture
- Clean Code
- Beautiful UI
- Reusable Components
- Stable Database
- Fast Development

---

# Development Workflow

Every feature follows the same workflow.

```text
Requirement
      ↓
Planning
      ↓
UI Design
      ↓
Development
      ↓
Run
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

Each Sprint must follow these steps.

1. Plan
2. Design
3. Develop
4. Test
5. Fix
6. Update Documentation
7. Git Commit
8. Git Push
9. Next Sprint

A Sprint is not complete until all steps are finished.

---

# Development Rules

## Rule 01

Develop **one screen at a time**.

Example

```text
Splash

↓

Login

↓

Dashboard

↓

Employee
```

---

## Rule 02

Finish one feature before starting another.

Do not leave partially completed modules.

---

## Rule 03

Keep the project buildable at all times.

Every commit should compile successfully.

---

## Rule 04

Use reusable widgets.

Examples

- AppButton
- AppTextField
- AppCard
- StatCard
- EmployeeTile
- EmptyWidget
- LoadingWidget

---

## Rule 05

Keep business logic outside UI.

Use:

- Repository
- Service
- Provider

UI should only display data.

---

## Rule 06

Keep widgets small.

If a widget exceeds ~250 lines, consider splitting it into smaller widgets.

---

## Rule 07

Avoid duplicate code.

If the same code appears multiple times, move it into a reusable widget or utility.

---

# Documentation Rules

Maintain only these documents.

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

Keep documentation synchronized with the implementation.

---

# Git Workflow

After every completed feature:

```bash
git add .

git commit -m "Meaningful message"

git push
```

Examples

```text
feat(auth): complete login module

feat(employee): add employee repository

fix(router): protect dashboard routes

docs: update project documentation
```

---

# Flutter Coding Standards

- Clean Architecture
- Feature-First Structure
- Riverpod
- GoRouter
- Material 3
- Responsive Layout
- Reusable Widgets
- Null Safety
- Meaningful Naming

---

# Folder Structure

Every feature follows:

```text
feature/

data/
│
├── datasources/
├── models/
└── repositories/

domain/
│
├── entities/
├── repositories/
└── usecases/

presentation/
│
├── controllers/
├── pages/
├── providers/
└── widgets/
```

---

# Database Guidelines

- UUID Primary Keys
- Foreign Keys
- snake_case Naming
- created_at
- updated_at
- Soft Delete where appropriate
- Company isolation using RLS

---

# API Guidelines

Use only the official Supabase Flutter SDK.

Repositories should:

- Catch exceptions
- Return consistent results
- Avoid SQL inside UI
- Keep business logic centralized

---

# Error Handling

Always

- Use try-catch
- Show friendly messages
- Log debug errors
- Never crash the application

---

# UI Guidelines

Every screen should:

- Follow Material 3
- Support different screen sizes
- Show loading indicators
- Handle empty states
- Display proper error states
- Use consistent spacing and typography

---

# Code Review Checklist

Before marking a feature complete:

- [ ] Builds successfully
- [ ] No analyzer errors
- [ ] No critical warnings
- [ ] UI matches design
- [ ] Repository implemented
- [ ] Database connected
- [ ] Documentation updated
- [ ] Git committed
- [ ] Git pushed

---

# Version 1.0 Development Order

1. Authentication
2. Dashboard
3. Employee Management
4. Attendance
5. Leave
6. Work Notes
7. Tasks
8. Notifications
9. Profile
10. Settings
11. Testing
12. Release

---

# Version 1.0 Success Criteria

Version 1.0 is complete when:

- Authentication is stable
- Dashboard is complete
- Employee module is complete
- Attendance module is complete
- Leave module is complete
- Work Notes and Tasks are complete
- Notifications work correctly
- Documentation is up to date
- Application is production-ready
- Android release build is successful

---

# Project Principles

- Flutter First
- Database Second
- Simple over Complex
- Reusable over Duplicate
- Lightweight over Enterprise
- Quality over Quantity
- Complete Features over Half-Finished Features

---

**Status:** ✅ Active Development