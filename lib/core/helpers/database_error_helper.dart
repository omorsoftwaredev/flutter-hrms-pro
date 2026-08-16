import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseErrorHelper {
  DatabaseErrorHelper._();

  static String getMessage(PostgrestException e) {
    // DEBUG
    debugPrint('========================================');
    debugPrint('SUPABASE DATABASE ERROR');
    debugPrint('Code     : ${e.code}');
    debugPrint('Message  : ${e.message}');
    debugPrint('Details  : ${e.details}');
    debugPrint('Hint     : ${e.hint}');
    debugPrint('========================================');

    switch (e.code) {
      case '23505':
        return 'This record already exists. Please use a different value.';

      case '23503':
        return 'This record is linked to other data and cannot be processed.';

      case '23502':
        return 'Please fill in all required fields.';

      case '23514':
        return 'The provided data is not valid.';

      case '22P02':
        return 'Invalid data format. Please check your input.';

      case '42501':
        return 'You do not have permission to perform this operation.';

      case '42P01':
        return 'The requested data table was not found.';

      case '42703':
        return 'A required database field was not found.';

      default:
        return 'Database error [${e.code}]: ${e.message}';
    }
  }
}