from pathlib import Path

content = r"""# Flutter HRMS Pro

# Project Architecture

**Version:** `0.6.5`

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

Each business module is isolated and follows the same folder structure, making the application easier to extend, maintain, test, and document.

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

```text
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
Repository / Data Source
      │
      ▼
Supabase
      │
      ▼
PostgreSQL