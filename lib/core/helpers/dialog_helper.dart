import 'package:flutter/material.dart';

class DialogHelper {
  DialogHelper._();

  static Future<void> showMessage(
      BuildContext context, {
        required String title,
        required String message,
      }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}