from pathlib import Path

content = r'''# Flutter HRMS Pro

# API Documentation

**Version:** `0.6.5`

---

# API Overview

Flutter HRMS Pro uses **Supabase** as its backend platform.

The application communicates directly with the **Supabase Flutter SDK** using the **Repository Pattern** and **Clean Architecture**. No custom REST API server is required.

Architecture

```text
Flutter UI
      │
      ▼
Riverpod Provider
      │
      ▼
StateNotifier
      │
      ▼
Repository / Remote DataSource
      │
      ▼
Supabase Service
      │
      ▼
Supabase Flutter SDK
      │
      ▼
PostgreSQL