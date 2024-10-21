import 'package:flutter/material.dart';

void showMessage(String msg, BuildContext context) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully!')),
    );
  }
}
