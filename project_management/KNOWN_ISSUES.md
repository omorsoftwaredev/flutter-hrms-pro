# Flutter HRMS Pro

# Known Issues

**Version:** `0.2.0`

This document tracks known issues, limitations, and temporary workarounds.

---

# Authentication

## Reset Password Deep Link

**Status:** 🟡 In Progress

### Issue

After clicking the password reset link, the application does not always navigate directly to the Update Password screen.

### Temporary Workaround

Restart the application and reopen the reset link.

### Planned Fix

Improve Deep Link handling using GoRouter.

---

# User Mapping

**Status:** 🟡 Temporary Limitation

### Issue

A newly created Supabase Auth user is not automatically linked to an employee record.

### Current Solution

Update the `employees.user_id` field after successful registration or by an administrator.

### Planned Improvement

Automatically link the authenticated user to the employee record during onboarding.

---

# Storage Upload

**Status:** 🟡 Under Testing

### Issue

Large file uploads may take longer on slow internet connections.

### Current Solution

Display a loading indicator while uploading.

---

# Responsive Layout

**Status:** 🟡 Planned Improvement

### Issue

The application is currently optimized for Android phones.

### Planned Improvement

Improve layouts for tablets in future updates.

---

# Known Limitations

Current Version (0.2.x)

- Android is the primary supported platform.
- Web/Desktop support is not yet optimized.
- Push notifications are not implemented.
- Offline mode is not available.
- Background location tracking is not included.
- Face attendance is not available.

---

# Database

## Soft Delete

**Status:** ✅ Implemented

Most important tables support soft delete where required.

---

## Row Level Security

**Status:** ✅ Implemented

Basic RLS policies are enabled for production use.

---

# Future Improvements

- Better Deep Link handling
- Automatic employee-user linking
- Offline data synchronization
- Improved tablet layouts
- Better image upload experience

---

# Reporting Issues

If a new issue is discovered:

1. Describe the problem.
2. Add reproduction steps.
3. Add a temporary workaround (if available).
4. Mark the issue as resolved after fixing it.

---

# Issue Status Legend

- 🔴 Critical
- 🟠 High
- 🟡 Medium
- 🟢 Resolved

---

**Status:** 🟡 Active