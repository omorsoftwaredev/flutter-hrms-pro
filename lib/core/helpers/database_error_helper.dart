import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseErrorHelper {
  static String getMessage(PostgrestException e) {
    switch (e.code) {
      case '23505':
        return 'This record already exists. Please use a different value.';

      case '23503':
        return 'Related data was not found.';

      case '23502':
        return 'Please fill in all required fields.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}