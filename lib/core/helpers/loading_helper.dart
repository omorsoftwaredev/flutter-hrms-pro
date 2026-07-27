import 'package:flutter/material.dart';

class LoadingHelper {
  LoadingHelper._();

  static Future<T?> run<T>(
      BuildContext context,
      Future<T> Function() action,
      ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      return await action();
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}