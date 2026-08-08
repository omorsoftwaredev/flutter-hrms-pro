import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseErrorHelper {
  DatabaseErrorHelper._();

  static String getMessage(PostgrestException e) {
    switch (e.code) {
    // Unique constraint violation
      case '23505':
        return 'This record already exists. Please use a different value.';

    // Foreign key violation
      case '23503':
        return 'This record is linked to other data and cannot be processed.';

    // Not-null violation
      case '23502':
        return 'Please fill in all required fields.';

    // Check constraint violation
      case '23514':
        return 'The provided data is not valid.';

    // Invalid text representation
      case '22P02':
        return 'Invalid data format. Please check your input.';

    // Permission denied / RLS
      case '42501':
        return 'You do not have permission to perform this operation.';

    // Undefined table
      case '42P01':
        return 'The requested data table was not found.';

    // Undefined column
      case '42703':
        return 'A required database field was not found.';

    // Default
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}