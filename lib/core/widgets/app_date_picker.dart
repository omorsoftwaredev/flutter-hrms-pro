import 'package:flutter/material.dart';

class AppDatePicker {
  AppDatePicker._();

  static Future<DateTime?> pick(
      BuildContext context, {
        DateTime? initialDate,
        DateTime? firstDate,
        DateTime? lastDate,
      }) {
    return showDatePicker(
      context: context,
      initialDate:
      initialDate ?? DateTime.now(),
      firstDate:
      firstDate ?? DateTime(2000),
      lastDate:
      lastDate ?? DateTime(2100),
    );
  }
}