class AppValidator {
  AppValidator._();

  static String? required(
      String? value, {
        String field = "This field",
      }) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final regex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

    if (!regex.hasMatch(value)) {
      return "Invalid email";
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone is required";
    }

    if (value.length < 10) {
      return "Invalid phone";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return "Minimum 6 characters";
    }

    return null;
  }
}