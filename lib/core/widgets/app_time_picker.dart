import 'package:flutter/material.dart';

class AppTimePicker {
  AppTimePicker._();

  static Future<TimeOfDay?> pick(
      BuildContext context, {
        TimeOfDay? initialTime,
      }) {
    return showTimePicker(
      context: context,
      initialTime:
      initialTime ?? TimeOfDay.now(),
    );
  }
}