# Flutter HRMS Pro

# Development Guide

Version: 1.0

---

# Project Goal

Develop a production-ready Human Resource Management System (HRMS) using Flutter and Supabase.

The project must be:

- Clean
- Modular
- Scalable
- Error-Free
- CodeCanyon Ready

---

# Development Workflow

Every feature must follow the same workflow.

```
Planning
    │
    ▼
Documentation
    │
    ▼
Development
    │
    ▼
Run
    │
    ▼
Error Fix
    │
    ▼
Testing
    │
    ▼
README Update
    │
    ▼
Docs Update
    │
    ▼
Git Commit
    │
    ▼
Git Push
```

---

# Sprint Workflow

Every Sprint follows the same process.

1. Plan the feature
2. Write the code
3. Run the project
4. Fix all errors
5. Test successfully
6. Update documentation
7. Commit to Git
8. Push to GitHub
9. Start the next Sprint

No Sprint is considered complete until all steps are finished.

---

# Development Rules

## Rule 01

Work on **one feature at a time**.

---

## Rule 02

Never develop multiple dependent modules together.

Finish one module before starting the next.

---

## Rule 03

Every step must compile successfully before continuing.

---

## Rule 04

Keep commits small and meaningful.

Example:

```
feat(auth): login completed
fix(router): route guard fixed
docs: update authentication status
```

---

## Rule 05

Every completed feature must be documented.

---

## Rule 06

Keep the project always in a runnable state.

---

# Documentation Rules

Project documentation consists of only six files.

```
README.md

docs/

01_Project_Roadmap.md
02_Project_Status.md
03_Architecture.md
04_Database.md
05_API.md
06_Development_Guide.md
```

Do not create additional documentation files unless absolutely necessary.

---

# Git Workflow

Every completed task follows:

```
git add .

git commit -m "Meaningful message"

git push
```

Commit after every successful feature.

Do not accumulate multiple unfinished changes.

---

# Coding Standards

- Use Clean Architecture
- Use Feature-First Structure
- Keep widgets small and reusable
- Avoid duplicate code
- Follow consistent naming conventions
- Write readable code
- Prefer composition over duplication

---

# Folder Rules

Every new module must follow the same structure.

```
feature/

data/
domain/
presentation/
```

Do not mix code between modules.

---

# Error Handling

Always:

- Run before committing
- Fix errors immediately
- Never ignore warnings without reason
- Keep the project stable

---

# README Update Rules

Update README only when:

- Sprint completed
- Major feature completed
- Project progress changes
- Version changes

---

# Database Rules

- Use UUID as Primary Key
- Use Foreign Keys
- Keep naming consistent
- Document every schema change

---

# API Rules

- Use Supabase SDK
- Handle exceptions with try-catch
- Show user-friendly error messages
- Keep services reusable

---

# Code Review Checklist

Before marking a feature complete:

- Code compiles successfully
- No build errors
- Navigation works
- Database works
- Authentication works
- Documentation updated
- Git committed
- Git pushed

---

# Project Principles

- Minimal Documentation
- Maximum Development
- Small Incremental Changes
- Error-Free Progress
- Production-Ready Code
- CodeCanyon Standard

---

# Current Development Order

1. Authentication
2. Employee Management
3. Attendance Management
4. Leave Management
5. Employee Monitoring
6. Dashboard & Reports
7. Notification System
8. CodeCanyon Release

---

# Success Criteria

Version 1.0 will be considered complete when:

- All planned modules are implemented.
- The application runs without critical errors.
- Documentation is complete.
- GitHub repository is fully updated.
- The project is ready for CodeCanyon submission.

---

Status: ✅ ACTIVE